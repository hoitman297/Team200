// 전체 선택 기능
    document.getElementById('checkAll').addEventListener('change', function() {
        const checkboxes = document.querySelectorAll('.chk');
        checkboxes.forEach(chk => chk.checked = this.checked);
    });

    // 수정 모드 토글
    function toggleEdit(id) {
        const row = document.getElementById(`row-${id}`);
        const textView = row.querySelector('.text-view');
        const editInput = row.querySelector('.edit-input');
        const actionBtn = row.querySelector('.action-link');

        if (editInput.style.display === 'none' || editInput.style.display === '') {
            editInput.style.display = 'block';
            textView.style.display = 'none';
            actionBtn.innerText = '저장';
            actionBtn.style.color = 'blue';
        } else {
            // 저장 로직
            textView.innerText = editInput.value;
            editInput.style.display = 'none';
            textView.style.display = 'block';
            actionBtn.innerText = '수정';
            actionBtn.style.color = '';
            alert('댓글이 수정되었습니다.');
        }
    }

    // 개별 삭제
    function deleteRow(id) {
        if(confirm('이 댓글을 정말 삭제하시겠습니까?')) {
            document.getElementById(`row-${id}`).remove();
        }
    }

    // 선택 삭제
    function deleteSelected() {
        const selected = document.querySelectorAll('.chk:checked');
        if (selected.length === 0) {
            alert('삭제할 댓글을 선택해주세요.');
            return;
        }
        if (confirm(`${selected.length}개의 댓글을 일괄 삭제하시겠습니까?`)) {
            selected.forEach(chk => chk.closest('tr').remove());
        }
    }