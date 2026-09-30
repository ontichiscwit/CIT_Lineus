/* [AX Lab] 신규 파일 (2026-07-29): A/S 목록 컬럼 정합성 정적 점검 스크립트
 *
 * 목적: list.jsp 의 aslist 테이블에서 아래 세 값이 반드시 같아야 한다.
 *        (1) colgroup 의 <col> 개수
 *        (2) thead 의 <th> 개수
 *        (3) setAsList() 가 한 행에 그리는 <td> 개수
 *      하나라도 어긋나면 컬럼이 밀려 엉뚱한 값이 다른 헤더 밑에 표시된다.
 *      브라우저는 이런 오류를 조용히 넘기므로(td 가 모자라면 그냥 빈칸) 눈으로는 발견하기 어렵다.
 *      추가로 빈 목록 안내행의 colspan 과 정렬키(data-sort)가 서버 화이트리스트에 있는지도 확인한다.
 *
 * 실행: node test/check-aslist-columns.js   (프로젝트 루트에서)
 */
'use strict';

const fs = require('fs');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const JSP = path.join(ROOT, 'jwcrm/src/main/webapp/WEB-INF/jsp/ad/as/list.jsp');
const CTRL = path.join(ROOT, 'jwcrm/src/main/java/egovframework/com/controller/AdAsController.java');

const jsp = fs.readFileSync(JSP, 'utf8');
const ctrl = fs.readFileSync(CTRL, 'utf8');

let failed = 0;
function check(label, actual, expected) {
	const ok = actual === expected;
	if (!ok) failed++;
	console.log(`${ok ? 'PASS' : 'FAIL'}  ${label}: ${actual}${ok ? '' : ' (기대값 ' + expected + ')'}`);
}

/* ---- aslist 테이블 영역만 잘라낸다 (다른 팝업 테이블과 섞이지 않게) ---- */
const tblStart = jsp.indexOf('<table class="aslist">');
const tblEnd = jsp.indexOf('</table>', tblStart);
if (tblStart < 0 || tblEnd < 0) {
	console.error('FAIL  list.jsp 에서 <table class="aslist"> 를 찾지 못했습니다.');
	process.exit(1);
}
const tbl = jsp.slice(tblStart, tblEnd);

const colCnt = (tbl.match(/<col\b/g) || []).length;
const thCnt = (tbl.match(/<th\b/g) || []).length;

/* ---- setAsList() 가 한 행에 그리는 td 개수 ----
   행 렌더 구간: '<tr data-asno=' 부터 "str += '</tr>';" 까지.
   대부분은 asws_cell(...) 호출로 만들고, 값 가공이 필요한 칸(체크박스·접수번호·거래처·문의내용·
   상태·담당자·신규답변)만 문자열 리터럴 <td ...> 로 만든다.
   ※ 리터럴 td 는 "한 칸당 정확히 1개" 여야 한다. 조건 분기로 <td 를 두 번 쓰면 실제 컬럼은 1개인데
     여기서는 2개로 세어 오탐이 난다. (그래서 list.jsp 는 내용만 변수로 만들고 td 는 한 번만 출력한다) */
const rowStart = jsp.indexOf("str += '<tr data-asno=");
const rowEnd = jsp.indexOf("str += '</tr>';", rowStart);
if (rowStart < 0 || rowEnd < 0) {
	console.error('FAIL  setAsList() 의 행 렌더 구간을 찾지 못했습니다.');
	process.exit(1);
}
const row = jsp.slice(rowStart, rowEnd);
const literalTd = (row.match(/<td\b/g) || []).length;
const cellTd = (row.match(/str \+= asws_cell\(/g) || []).length;
const tdCnt = literalTd + cellTd;

/* ---- 좌측 6컬럼 sticky 고정 해제 확인 (2026-07-30 요청사항) ----
   stk/stkN 클래스가 남아 있으면 CSS 규칙이 지워진 상태에서 의미 없는 클래스만 붙어 있는 것이므로
   (또는 CSS 를 되살렸을 때 의도치 않게 고정이 되살아나므로) 0 이어야 한다. */
const stkLeft = (tbl.match(/\bstk\d?\b/g) || []).length + (row.match(/\bstk\d?\b/g) || []).length;

console.log('--- A/S 목록 컬럼 정합성 ---');
console.log(`colgroup <col> : ${colCnt}`);
console.log(`thead <th>     : ${thCnt}`);
console.log(`row <td>       : ${tdCnt} (리터럴 ${literalTd} + asws_cell ${cellTd})`);
console.log('');

check('thead <th> 개수가 <col> 개수와 일치', thCnt, colCnt);
check('행 <td> 개수가 <col> 개수와 일치', tdCnt, colCnt);

/* ---- 빈 목록 안내행 colspan ---- */
const colspanM = jsp.match(/colspan="(\d+)"[^>]*>조회된 데이터가 없습니다/);
check('빈 목록 colspan', colspanM ? Number(colspanM[1]) : -1, colCnt);

/* ---- 좌측 컬럼 고정(sticky) 해제 상태 ---- */
check('sticky 고정 클래스(stk/stkN) 잔존 개수', stkLeft, 0);

/* ---- 헤더 순서 (2026-07-30 현업 요청 순서) ----
   체크박스 헤더는 내용이 <input> 이라 아래 정규식에서 빈 문자열로 걸러진다.
   순서가 바뀌면 어떤 컬럼이 어디로 갔는지 로그에 그대로 찍히므로 원인 파악이 쉽다. */
const EXPECTED_HEAD = [
	'접수번호', '거래처', '문의 내용 · 조치', '상태', '담당자',	/* 좌측 6컬럼 (체크박스 제외) */
	'연결AS', '처리예정일', '문의유형', '시스템유형', '신규답변',
	'접수일', '처리완료일자', '원인유형', '조치유형', '고객평가'	/* 우측 가로스크롤 10컬럼 */
];
const heads = [...tbl.matchAll(/<th[^>]*>([^<]*)</g)].map(m => m[1].trim()).filter(t => t !== '');
console.log('');
console.log(`헤더 순서 : ${heads.join(' | ')}`);
check('헤더 순서가 요청 순서와 일치', heads.join(' > '), EXPECTED_HEAD.join(' > '));

/* ---- 정렬키가 서버 화이트리스트(AS_SORT_COLS)에 모두 등록돼 있는지 ----
   등록되지 않은 키는 서버가 조용히 기본정렬로 폴백하므로, 클릭해도 아무 일이 없는 것처럼 보인다. */
const sortKeys = [...tbl.matchAll(/data-sort="([^"]+)"/g)].map(m => m[1]);
const wl = new Set([...ctrl.matchAll(/AS_SORT_COLS\.put\("([^"]+)"/g)].map(m => m[1]));
const missing = sortKeys.filter(k => !wl.has(k));
console.log('');
console.log(`정렬 가능 헤더 : ${sortKeys.length}개 / 서버 화이트리스트 : ${wl.size}개`);
if (missing.length) {
	failed++;
	console.log(`FAIL  화이트리스트에 없는 정렬키: ${missing.join(', ')}`);
} else {
	console.log('PASS  모든 data-sort 키가 AS_SORT_COLS 에 등록되어 있음');
}

/* ---- 우측 컬럼 폭 합계가 CSS 의 --w-right-sum 과 일치하는지 ----
   어긋나면 테이블 전체폭이 실제 컬럼 합과 달라져 가로스크롤 끝이 남거나 잘린다. */
const css = fs.readFileSync(path.join(ROOT, 'jwcrm/src/main/webapp/css/combine-as.css'), 'utf8');
const inlineWidths = [...tbl.matchAll(/<col style="width:(\d+)px"/g)].map(m => Number(m[1]));
const sum = inlineWidths.reduce((a, b) => a + b, 0);
const declM = css.match(/--w-right-sum:\s*(\d+)px/);
console.log('');
console.log(`우측 컬럼 ${inlineWidths.length}개 폭 합계 : ${sum}px`);
check('CSS --w-right-sum 이 실제 합계와 일치', declM ? Number(declM[1]) : -1, sum);
check('우측 컬럼 개수(= 전체 - 좌측고정 6)', inlineWidths.length, colCnt - 6);

console.log('');
console.log(failed === 0 ? '=> 전체 통과' : `=> 실패 ${failed}건`);
process.exit(failed === 0 ? 0 : 1);
