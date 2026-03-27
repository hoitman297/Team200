<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/admin/admin_inquiry/style.css">
    <script src="${pageContext.request.contextPath}/resources/admin/admin_inquiry/script.js"></script>
    
    <title>LOG.GG - 관리자 문의 관리</title>
</head>
<body>

    <div class="container">
        <div class="header-section">
            <h2>고객지원 (Admin)</h2>
            <button class="select-box" onclick="history.back()">뒤로가기</button>
        </div>

        <div class="filter-group">
            <select class="select-box">
                <option>전체 게임</option>
                <option>배틀그라운드</option>
                <option>오버워치</option>
                <option>리그 오브 레전드</option>
            </select>
            <select class="select-box">
                <option>상태 전체</option>
                <option>답변대기</option>
                <option>답변완료</option>
            </select>
        </div>

        <div class="content-card">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th width="80">번호</th>
                        <th width="120">분류</th>
                        <th>제목</th>
                        <th width="120">작성자</th>
                        <th width="120">날짜</th>
                        <th width="120">상태</th>
                    </tr>
                </thead>
                <tbody>
                    <tr class="clickable-row" onclick="toggleReply(3)">
                        <td>003</td>
                        <td>오버워치</td>
                        <td style="text-align:left;">로그인 오류가 계속 발생합니다.</td>
                        <td>USER01</td>
                        <td>25-03-09</td>
                        <td><span class="status-badge status-waiting">답변대기</span></td>
                    </tr>
                    <tr id="reply-3" style="display:none;">
                        <td colspan="6">
                            <div class="reply-section">
                                <div class="inquiry-content">
                                    <strong>[문의 내용]</strong><br>
                                    집에서 접속하는데 계속 500 에러가 뜹니다. 어제 패치 이후로 계속 이러는데 확인 좀 부탁드려요.
                                </div>
                                <textarea placeholder="사용자에게 전달할 답변 내용을 입력하세요."></textarea>
                                <button class="btn-submit" onclick="alert('답변이 등록되었습니다.')">답변 등록</button>
                            </div>
                        </td>
                    </tr>

                    <tr class="clickable-row" onclick="toggleReply(2)">
                        <td>002</td>
                        <td>배틀그라운드</td>
                        <td style="text-align:left;"><span class="secret-icon">🔒</span> 아이템 복구 관련 문의 드립니다.</td>
                        <td>user***</td>
                        <td>25-03-08</td>
                        <td><span class="status-badge status-done">답변완료</span></td>
                    </tr>
                    <tr id="reply-2" style="display:none;">
                        <td colspan="6">
                            <div class="reply-section">
                                <div class="inquiry-content">
                                    <strong>[문의 내용]</strong><br>
                                    실수로 스킨을 분해했는데 복구가 가능할까요? 어제 오후 3시쯤 발생한 일입니다.
                                </div>
                                <div class="inquiry-content" style="background-color: #f1f5f9; border-style: solid;">
                                    <strong>[기존 답변]</strong><br>
                                    안녕하세요. LOG.GG입니다. 요청하신 아이템 복구는 운영 정책상 7일 이내 1회에 한해 도와드리고 있습니다. 현재 복구 처리가 완료되었습니다.
                                </div>
                                <textarea placeholder="추가 답변이 필요한 경우 입력하세요."></textarea>
                                <button class="btn-submit">수정 및 재등록</button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>