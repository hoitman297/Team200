/**
 * LOG.GG 게시판 공통 스크립트
 */
$(document).ready(function() {
    
    // [1] 게시판 행(Row) 클릭 시 상세 페이지 이동 이벤트
    $(document).on("click", ".board-row-item td", function(e) {
        
        // 1. 번호(첫 번째 td)나 체크박스 등이 있는 칸은 클릭 이벤트에서 제외
        if ($(this).is(":first-child")) {
            return;
        }

        // 2. .data("href") 보다는 .attr("data-href")가 실시간 DOM 속성을 읽기에 더 확실합니다.
        const url = $(this).closest("tr").attr("data-href");

        // 3. 클릭한 요소가 <a> 태그 본인이거나 <a> 태그의 자식(아이콘 등)이라면 
        // 브라우저의 기본 이동 기능을 사용하도록 내버려 둡니다.
        if (url && !$(e.target).closest("a").length) {
            location.href = url;
        }
    });

});

/**
 * [2] 게시글 삭제 함수
 * @param boardNo 삭제할 게시글 번호
 */
function deleteBoard(boardNo) {
    if(confirm("정말로 이 게시글을 삭제하시겠습니까?")) {
        // JSP에서 <script> const contextPath = "${pageContext.request.contextPath}"; </script>
        // 라고 선언되어 있어야 정상 작동합니다. 
        // 만약 선언되어 있지 않다면 아래 코드로 자동 추출을 시도합니다.
        const cp = window.contextPath || window.location.pathname.substring(0, window.location.pathname.indexOf("/", 1));
        
        location.href = cp + "/board/delete?boardNo=" + boardNo;
    }
}