function deleteBoard(boardNo) {
    if(confirm("정말로 이 게시글을 삭제하시겠습니까?")) {
        // 삭제를 처리하는 컨트롤러 주소로 보냅니다.
        location.href = "${pageContext.request.contextPath}/board/delete?boardNo=" + boardNo;
    }
}