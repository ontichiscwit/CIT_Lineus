# -*- coding: utf-8 -*-
"""[AX Lab] 원격 재정렬 결합 로직 회귀 테스트 — 모델/네트워크 없이 실행한다."""
import sys
import types
import unittest

try:
    import numpy as np
except ModuleNotFoundError:
    # 순위 결합 테스트는 수치 연산을 쓰지 않는다. 개발 PC에 운영 requirements를 설치하지 않아도 실행되게 한다.
    np = types.SimpleNamespace()
    sys.modules["numpy"] = np

from combine_recommend import FALLBACK_MIN_SIM, RERANK_MIN_SCORE, RERANK_TOP, Recommender


def _doc(doc_id, relevance, cos=0.65):
    return {
        "doc_id": doc_id,
        "tier": 2,
        "source_type": "case",
        "title": f"사례 {doc_id}",
        "embed_text": f"문의와 처리 내용 {doc_id}",
        "answer_text": "처리 답변",
        "answer_html": "",
        "internal_note": None,
        "topic": "테스트",
        "resolution": None,
        "service_cate": "원무",
        "program_nm": None,
        "screen_nm": None,
        "deep_link": None,
        "attached_file": [],
        "occurred_at": "2026-10",
        "quality_score": 0.5,
        "as_no": doc_id,
        "question_text": "테스트 문의",
        "public_link": None,
        "_candidate": (doc_id, cos, 1.0, relevance),
    }


class FakeIndex:
    def __init__(self, relevances, cosines=None):
        cosines = cosines or [0.65] * len(relevances)
        docs = [_doc(f"d{i}", rel, cos) for i, (rel, cos) in enumerate(zip(relevances, cosines))]
        self.meta = {doc["doc_id"]: doc for doc in docs}
        self.doc_ids = list(self.meta)
        self.model = "bge-m3"
        self.built_at = "test"

    def search_hybrid(self, _qvec, _q_lex, _tiers, _exclude, _k):
        return [self.meta[doc_id]["_candidate"] for doc_id in self.doc_ids]

    def get(self, doc_id):
        return self.meta[doc_id]


class RerankIntegrationTest(unittest.TestCase):
    @staticmethod
    def _recommend(index, rerank_fn, top_k=5):
        rec = Recommender(index, embed_fn=lambda _text: [0.0, 0.0],
                          rerank_fn=rerank_fn)
        return rec.recommend("수납 취소 문의", service_cate="원무", top_k=top_k)

    def test_reranker_changes_order_and_adds_score(self):
        index = FakeIndex([1.0, 0.8])
        result = self._recommend(index, lambda _query, _docs: [0.0, 10.0], top_k=2)
        self.assertEqual("d1", result["items"][0]["doc_id"])
        self.assertEqual(1.0, result["items"][0]["rerank_score"])
        self.assertIn("relevance", result["items"][0])
        self.assertIn("semantic_sim", result["items"][0])
        self.assertIn("confidence", result["items"][0])

    def test_failure_uses_original_formula(self):
        index = FakeIndex([1.0, 0.8])

        def fail(_query, _docs):
            raise TimeoutError("test")

        result = self._recommend(index, fail, top_k=2)
        self.assertEqual("d0", result["items"][0]["doc_id"])
        self.assertNotIn("rerank_score", result["items"][0])

    def test_only_configured_top_candidates_are_sent(self):
        captured = []
        index = FakeIndex([1.0 - i * 0.01 for i in range(RERANK_TOP + 5)])

        def capture(_query, docs):
            captured.extend(docs)
            return list(range(len(docs)))

        result = self._recommend(index, capture)
        self.assertEqual(RERANK_TOP, len(captured))
        self.assertEqual("000", result["result"])
        self.assertLessEqual(len(result["items"]), 5)

    # [AX Lab] 2026-10-16 관련 없는 후보 거르기
    def test_low_raw_rerank_score_is_excluded(self):
        index = FakeIndex([1.0, 0.8, 0.6])
        result = self._recommend(index, lambda _q, _d: [3.0, RERANK_MIN_SCORE - 0.01, RERANK_MIN_SCORE])
        self.assertEqual(["d0", "d2"], sorted(it["doc_id"] for it in result["items"]))
        self.assertEqual(3.0, result["items"][0]["rerank_raw"])

    def test_candidates_outside_rerank_top_are_excluded(self):
        index = FakeIndex([1.0 - i * 0.01 for i in range(RERANK_TOP + 5)])
        result = self._recommend(index, lambda _q, docs: [RERANK_MIN_SCORE - 3.0] * len(docs))
        self.assertEqual("000", result["result"])
        self.assertEqual([], result["items"])

    def test_fallback_excludes_low_cosine(self):
        index = FakeIndex([1.0, 0.8], cosines=[FALLBACK_MIN_SIM + 0.05, FALLBACK_MIN_SIM - 0.01])

        def fail(_query, _docs):
            raise TimeoutError("test")

        result = self._recommend(index, fail, top_k=2)
        self.assertEqual(["d0"], [it["doc_id"] for it in result["items"]])


if __name__ == "__main__":
    unittest.main()
