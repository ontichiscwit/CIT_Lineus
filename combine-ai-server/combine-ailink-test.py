# -*- coding: utf-8 -*-
"""
[AX Lab] 신규 파일 (2026-10-21 AX Lab): AI PC 연결 감시(combine_ailink) 회귀 테스트 — 네트워크·메일 서버 없이 실행

  python combine-ailink-test.py
"""
import sys
import time
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import combine_ailink as al  # noqa: E402


class AiLinkTest(unittest.TestCase):
    def setUp(self):
        al._T.clear()
        self.mails = []
        self.logs = []
        al._CFG.update(log=self.logs.append, mailer=lambda s, b: self.mails.append((s, b)))
        self.ok = {"v": True}
        al.register("ollama", lambda: (self.ok["v"], None if self.ok["v"] else "URLError: refused"), "http://x:11434")

    def _wait_mail(self, n):
        for _ in range(50):
            if len(self.mails) >= n:
                return
            time.sleep(0.02)

    def test_single_failure_is_not_down(self):
        al.report("ollama", True)
        al.report("ollama", False, "timeout")
        self.assertFalse(al.is_down("ollama"))
        self.assertEqual(al.snapshot()["ollama"], "ok")
        self.assertEqual(self.mails, [])

    def test_consecutive_failures_mark_down_and_mail(self):
        al.report("ollama", True)
        for _ in range(al.DOWN_AFTER):
            al.report("ollama", False, "refused")
        self.assertTrue(al.is_down("ollama"))
        self.assertIn("down_since", al.snapshot())
        self._wait_mail(1)
        self.assertEqual(len(self.mails), 1)
        self.assertIn("끊김", self.mails[0][0])
        with self.assertRaises(al.AiPcDown):
            al.ensure_up("ollama")

    def test_recovery_mails_only_after_down_mail(self):
        for _ in range(al.DOWN_AFTER):
            al.report("ollama", False, "refused")
        al.report("ollama", True)
        self._wait_mail(2)
        self.assertFalse(al.is_down("ollama"))
        self.assertEqual(len(self.mails), 2)
        self.assertIn("복구", self.mails[1][0])
        self.assertTrue(any("복구" in m for m in self.logs))

    def test_check_now_counts_exceptions_as_failure(self):
        al.register("rerank", lambda: (_ for _ in ()).throw(ConnectionRefusedError("no")), "http://x:8766/health")
        for _ in range(al.DOWN_AFTER):
            al.check_now("rerank")
        self.assertTrue(al.is_down("rerank"))

    def test_disabled_target_is_off_and_never_down(self):
        al.register("rerank", lambda: (False, "x"), "u", enabled=False)
        for _ in range(5):
            al.report("rerank", False, "x")
        self.assertEqual(al.snapshot()["rerank"], "off")
        self.assertFalse(al.is_down("rerank"))

    def test_unregistered_target_is_noop(self):
        al.report("nothing", False, "x")
        al.suspect("nothing")
        self.assertFalse(al.is_down("nothing"))


if __name__ == "__main__":
    unittest.main(verbosity=2)
