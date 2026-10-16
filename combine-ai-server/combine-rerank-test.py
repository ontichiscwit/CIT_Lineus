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

from combine_recommend import (FALLBACK_MIN_SIM, RERANK_MIN_SCORE, RERANK_TOP, Recommender,
                               match_terms, product_match_detail)
import combine_morph


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

    def test_items_carry_match_fields(self):
        result = self._recommend(FakeIndex([1.0]), lambda _q, d: [1.0] * len(d), top_k=1)
        self.assertEqual("같은 업무분류", result["items"][0]["match_reason"])
        self.assertIn("match_terms", result["items"][0])


# [AX Lab] 2026-10-16 추천 근거(겹친 단어) 표시 — Kiwi 방식(기본)과 규칙 방식(폴백) 둘 다 같은 기대값을 만족해야 한다
class MatchTermsTest(unittest.TestCase):
    IDF = {"진단서": 4.9, "출력": 2.0, "문의": 0.8, "처방": 1.4, "처방전": 3.0, "산재조합": 8.4, "bixolon": 6.0, "it": 3.0}
    UNITS = None                                    # None: Kiwi (setUpClass 에서 적재) / False: 규칙 방식

    @classmethod
    def setUpClass(cls):
        if cls.UNITS is None and not combine_morph.warmup(wait=True):
            raise unittest.SkipTest("kiwipiepy 미설치")

    def _match(self, query, synonyms, doc, idf):
        return match_terms(query, synonyms, doc, idf, self.UNITS)

    def _terms(self, query, doc, synonyms=""):
        return [(m["term"], m["synonym"]) for m in self._match(query, synonyms, doc, self.IDF)]

    def test_strips_particles_and_endings(self):
        terms = self._terms("진단서를 출력하면 문의드립니다", "진단서 출력 문의 방법")
        self.assertEqual([("진단서", False), ("출력", False)], terms)

    def test_drops_common_words_and_predicates(self):
        self.assertEqual([], self._terms("문의 나옵니다", "문의 내용이 나옵니다"))

    def test_prefers_longer_contained_term(self):
        self.assertEqual([("처방전", False)], self._terms("처방 처방전", "처방전 발행"))

    def test_marks_synonym_terms(self):
        self.assertEqual([("산재조합", True)], self._terms("산재 지사 산재조합", "산재조합 등록", synonyms="산재조합"))

    def test_english_keeps_case_and_skips_fragments(self):
        self.assertEqual([("BIXOLON", False)], self._terms("it's BIXOLON bixolon", "it's bixolon driver"))

    def test_strips_gwa_si_but_keeps_department(self):
        idf = dict(self.IDF, 사진=3.0, 신규오더=5.0, 진료과=4.0, 같이=2.5, 첨부=2.5)
        terms = [m["term"] for m in self._match("첨부 사진과 같이 신규오더시 진료과",
                                                "", "첨부 사진과 같이 신규오더시 진료과 변경", idf)]
        self.assertEqual(["신규오더", "진료과", "사진"], terms)

    def test_product_match_detail_labels(self):
        self.assertEqual((1.0, "같은 업무분류"), product_match_detail({"service_cate": "원무"}, {"service_cate": "원무", "tier": 2}))
        self.assertEqual((0.0, None), product_match_detail({"service_cate": "원무"}, {"service_cate": "진료", "tier": 2}))
        self.assertEqual((1.0, "같은 프로그램·화면"), product_match_detail({"screen_nm": "외래수납"}, {"screen_nm": "외래수납"}))
        self.assertEqual((0.6, "같은 문의유형"), product_match_detail({"inquiry_type": "사용법"}, {"inquiry_type": "사용법"}))


class RuleMatchTermsTest(MatchTermsTest):
    UNITS = False


class KiwiMatchTermsTest(unittest.TestCase):
    """규칙 방식으로는 못 하던 것: 붙여 쓴 기능어 떼기 · 붙어 있던 명사 덩어리 유지."""
    IDF = {"신규": 3.0, "신규오더": 5.0, "시술확인서": 6.0, "시술": 3.0, "확인서": 3.5, "작성": 1.8,
           "d/c오더": 6.0, "마약류투약정보조회": 9.0, "환자": 1.6}

    @classmethod
    def setUpClass(cls):
        if not combine_morph.warmup(wait=True):
            raise unittest.SkipTest("kiwipiepy 미설치")

    def _terms(self, query, doc):
        return [m["term"] for m in match_terms(query, "", doc, self.IDF)]

    def test_splits_attached_function_word(self):
        self.assertEqual(["신규"], self._terms("신규및 대상자", "신규및 D/C 대상자 기준"))

    def test_keeps_compound_noun_together(self):
        self.assertEqual(["시술확인서", "작성"], self._terms("시술확인서 작성후 삭제했는지", "시술확인서 작성 방법"))

    def test_compound_matches_spaced_doc(self):
        self.assertEqual(["시술확인서"], self._terms("시술확인서가 안 나와요", "시술 확인서 출력"))

    def test_falls_back_to_longest_present_piece(self):
        self.assertEqual(["신규"], self._terms("신규오더시 명단", "신규 환자 등록"))

    def test_keeps_symbol_joined_terms(self):
        self.assertEqual(["D/C오더", "마약류투약정보조회"],
                         sorted(self._terms("D/C오더 마약류투약정보조회에서", "D/C오더 마약류투약정보조회 화면")))

    def test_trims_trailing_dependent_words(self):
        self.assertEqual(["환자"], self._terms("환자분 입원중", "환자 정보"))


if __name__ == "__main__":
    unittest.main()
