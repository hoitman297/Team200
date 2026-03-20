function handleEdit() {
            if(confirm("게시글을 수정하시겠습니까?")) {
                alert("수정 페이지로 이동합니다.");
            }
        }

        function handleDelete() {
            if(confirm("정말로 삭제하시겠습니까? 복구할 수 없습니다.")) {
                alert("게시글이 삭제되었습니다.");
            }
        }