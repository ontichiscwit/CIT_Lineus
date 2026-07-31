/* [AX Lab] 신규 파일 (2026-07-31): 접수 등록 모달 정합성 정적 검사
   ─────────────────────────────────────────────────────────────────────────────
   combine-as-form.js 가 참조하는 화면 요소 id 가 combine-as-modal.jsp 에 실제로
   존재하는지 검사한다. (id 오타는 브라우저에서 조용히 무시되어 눈으로 찾기 어렵다)
   추가로 다음 두 가지 안전규칙도 함께 검사한다.
   ① 모달 마크업(#cawsRegist)의 입력요소에 name 속성이 없어야 한다.
      (listFrm.serialize() → getAsList.do 목록조회 파라미터 오염 방지)
   ② list.jsp 에 combine-as-form.js include 와 버튼 연결(cafm_open*)이 있어야 한다.

   실행: node test/check-cafm-modal-ids.js  (프로젝트 루트에서)
   ───────────────────────────────────────────────────────────────────────────── */
var fs = require('fs');
var path = require('path');

var ROOT = path.join(__dirname, '..');
var JS_PATH = path.join(ROOT, 'jwcrm/src/main/webapp/js/combine-as-form.js');
var JSP_PATH = path.join(ROOT, 'jwcrm/src/main/webapp/WEB-INF/jsp/ad/as/combine-as-modal.jsp');
var LIST_PATH = path.join(ROOT, 'jwcrm/src/main/webapp/WEB-INF/jsp/ad/as/list.jsp');

var js = fs.readFileSync(JS_PATH, 'utf8');
var jsp = fs.readFileSync(JSP_PATH, 'utf8');
var list = fs.readFileSync(LIST_PATH, 'utf8');

var fail = 0;
function ng(msg){ fail++; console.log('  [NG] ' + msg); }
function ok(msg){ console.log('  [OK] ' + msg); }

/* ── 1) JS 가 참조하는 id 가 JSP 에 존재하는가 ─────────────────────────────── */
console.log('1) combine-as-form.js 참조 id ↔ combine-as-modal.jsp 존재 여부');
var refIds = {};
/* cafm_el('id') / cafm_v('id') / cafm_sv('id', ...) / caws_html('id', ...) 의 첫번째 인자 수집 */
var re = /(?:cafm_el|cafm_v|cafm_sv|caws_html)\(\s*'([A-Za-z0-9_]+)'/g;
var m;
while((m = re.exec(js)) !== null) refIds[m[1]] = true;

/* JS 가 동적으로 만드는 요소(body 직속 폼/iframe)와 모달 밖 요소는 JSP 검사에서 제외 */
var dynamicIds = { cafmForm:1, cafmFileSlots:1, cafmParams:1, cafmFrame:1 };

var missing = [];
Object.keys(refIds).forEach(function(id){
	if(dynamicIds[id]) return;
	if(jsp.indexOf('id="' + id + '"') < 0) missing.push(id);
});
if(missing.length) ng('JSP 에 없는 id: ' + missing.join(', '));
else ok('참조 id ' + Object.keys(refIds).filter(function(id){ return !dynamicIds[id]; }).length + '개 모두 존재');

/* ── 2) 모달 입력요소 name 금지 (listFrm 오염 방지) ────────────────────────── */
console.log('2) #cawsRegist 안 입력요소 name 속성 금지');
var start = jsp.indexOf('id="cawsRegist"');
if(start < 0){
	ng('combine-as-modal.jsp 에 #cawsRegist 마크업이 없습니다');
}else{
	var seg = jsp.substring(start);
	var bad = [];
	var re2 = /<(?:input|select|textarea|button)\b[^>]*\bname\s*=/g;
	var m2;
	while((m2 = re2.exec(seg)) !== null) bad.push(m2[0]);
	if(bad.length) ng('name 속성이 있는 입력요소 ' + bad.length + '건:\n       ' + bad.join('\n       '));
	else ok('모달 내 입력요소에 name 속성 없음');
}

/* ── 3) list.jsp 연결 확인 ─────────────────────────────────────────────────── */
console.log('3) list.jsp 연결(스크립트 include + 버튼 3개)');
if(list.indexOf('/js/combine-as-form.js') < 0) ng('list.jsp 에 combine-as-form.js include 가 없습니다');
else ok('combine-as-form.js include 존재');
['cafm_openCopy', 'cafm_openInsert', 'cafm_openSub'].forEach(function(fn){
	if(list.indexOf(fn) < 0) ng('list.jsp 버튼에 ' + fn + ' 연결이 없습니다');
	else ok(fn + ' 버튼 연결 존재');
});

/* ── 4) 첨부 input 이름 규칙 (서버 insertAsInfo 는 uploadFile_숫자 만 접수첨부로 저장) ── */
console.log('4) 첨부 슬롯 이름 규칙 (uploadFile_숫자)');
if(js.indexOf("'uploadFile_' + (cafm.fileSeq++)") < 0) ng("첨부 슬롯 이름이 'uploadFile_' + 숫자 규칙이 아닙니다");
else ok("uploadFile_숫자 규칙 준수");

console.log('');
if(fail){ console.log('결과: 실패 ' + fail + '건'); process.exit(1); }
console.log('결과: 모든 검사 통과');
