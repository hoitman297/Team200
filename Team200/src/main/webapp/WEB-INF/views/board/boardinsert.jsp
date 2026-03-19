<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LOG.GG - 글쓰기</title>
    <style>
        @import url('https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css');
        
        :root {
            --primary-navy: #475569;
            --accent-blue: #3b82f6;
            --bg-soft: #f8fafc;
            --border-color: #e2e8f0;
            --card-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05);
        }

        body {
            margin: 0; padding: 0;
            font-family: 'Pretendard', sans-serif;
            background-color: var(--bg-soft);
            display: flex;
            justify-content: center;
            padding-top: 50px;
        }

        .write-container {
            width: 100%;
            max-width: 900px;
            background: white;
            border-radius: 24px;
            box-shadow: var(--card-shadow);
            padding: 40px;
            box-sizing: border-box;
        }

        /* 게임 카테고리 고정 안내 바 */
        .category-fixed-bar {
            background: #f1f5f9;
            padding: 12px 20px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 30px;
            border: 1px solid var(--border-color);
        }

        .category-tag {
            background: var(--primary-navy);
            color: white;
            padding: 4px 12px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 700;
        }

        .category-text {
            font-size: 15px;
            font-weight: 600;
            color: #64748b;
        }

        .write-header h2 {
            font-size: 28px;
            font-weight: 800;
            color: var(--primary-navy);
            margin: 0 0 30px 0;
        }

        /* 입력 폼 스타일 */
        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: 700;
            color: #334155;
            margin-bottom: 10px;
        }

        .form-group input[type="text"] {
            width: 100%;
            padding: 15px 20px;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            font-size: 16px;
            box-sizing: border-box;
            outline: none;
            transition: border-color 0.2s;
        }

        .form-group input:focus {
            border-color: var(--accent-blue);
        }

        /* 에디터 영역 (Textarea) */
        .editor-area {
            width: 100%;
            min-height: 400px;
            padding: 20px;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            font-size: 15px;
            line-height: 1.6;
            resize: vertical;
            outline: none;
            box-sizing: border-box;
            font-family: inherit;
        }

        .editor-area:focus {
            border-color: var(--accent-blue);
        }

        /* 하단 버튼 영역 */
        .write-footer {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #f1f5f9;
        }

        .btn {
            padding: 12px 30px;
            border-radius: 12px;
            font-weight: 700;
            font-size: 15px;
            cursor: pointer;
            border: none;
            transition: all 0.2s;
        }

        .btn-cancel {
            background: #f1f5f9;
            color: #64748b;
        }

        .btn-cancel:hover { background: #e2e8f0; }

        .btn-submit {
            background: var(--primary-navy);
            color: white;
        }

        .btn-submit:hover { background: #334155; transform: translateY(-1px); }

        /* 파일 첨부 영역 간소화 */
        .file-upload {
            font-size: 14px;
            color: #94a3b8;
            margin-top: 10px;
        }
    </style>
</head>
<body>

    <div class="write-container">
        <div class="category-fixed-bar">
            <span class="category-tag">작성 중</span>
            <span class="category-text" id="targetGame">배틀그라운드 > 자유 게시판</span>
        </div>

        <div class="write-header">
            <h2>새 글 작성하기</h2>
        </div>

        <form id="writeForm">
            <div class="form-group">
                <label>제목</label>
                <input type="text" placeholder="제목을 입력해 주세요" required>
            </div>

            <div class="form-group">
                <label>내용</label>
                <textarea class="editor-area" placeholder="커뮤니티 가이드라인을 준수하여 내용을 작성해 주세요."></textarea>
                <div class="file-upload">📎 사진이나 파일을 드래그하여 첨부할 수 있습니다.</div>
            </div>

            <div class="write-footer">
                <button type="button" class="btn btn-cancel" onclick="history.back()">취소</button>
                <button type="submit" class="btn btn-submit">등록하기</button>
            </div>
        </form>
    </div>

    <script>
        // 실제 구현 시에는 URL 파라미터나 상태값을 통해 게임 이름을 가져옵니다.
        // 예: write.html?game=PUBG
        window.onload = function() {
            // 현재는 예시로 '배틀그라운드' 고정
            console.log("글쓰기 페이지 로드 완료");
        };

        document.getElementById('writeForm').onsubmit = function(e) {
            e.preventDefault();
            alert('게시글이 성공적으로 등록되었습니다.');
            location.href = 'board.html'; // 등록 후 게시판 목록으로 이동
        };
    </script>

</body>
</html>