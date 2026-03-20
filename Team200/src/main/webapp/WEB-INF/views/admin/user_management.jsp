<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/admin/user_management/style.css">
    <script src="${pageContext.request.contextPath}/resources/admin/user_management/script.js"></script>
    
    <title>LOG.GG - 관리자 회원 관리</title>
</head>
<body>

    <div class="admin-header">
        <h2>전체 회원 목록 조회</h2>
        <button class="btn-back-home" onclick="history.back()">마이페이지로 돌아가기</button>
    </div>

    <div class="member-list-container">
        <div class="list-controls">
            <div class="search-box">
                <input type="text" placeholder="아이디, 이름, 이메일 검색">
                <button class="btn-action">검색</button>
            </div>
            <div class="filter-box">
                <select class="btn-action">
                    <option>가입일순</option>
                    <option>최근접속순</option>
                </select>
            </div>
        </div>

        <table class="member-table">
            <thead>
                <tr>
                    <th>번호</th>
                    <th>아이디</th>
                    <th>이름</th>
                    <th>이메일</th>
                    <th>상태</th>
                    <th>가입일</th>
                    <th>관리</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>001</td>
                    <td><strong>user01</strong></td>
                    <td>홍길동</td>
                    <td>user01@naver.com</td>
                    <td><span class="status-badge status-active">활성</span></td>
                    <td>2026-01-24</td>
                    <td>
                        <button class="btn-action">정지</button>
                        <button class="btn-action btn-delete">삭제</button>
                    </td>
                </tr>
                <tr>
                    <td>002</td>
                    <td><strong>user02</strong></td>
                    <td>강민서</td>
                    <td>user02@log.gg</td>
                    <td><span class="status-badge status-suspended">정지</span></td>
                    <td>2026-02-01</td>
                    <td>
                        <button class="btn-action">해제</button>
                        <button class="btn-action btn-delete">삭제</button>
                    </td>
                </tr>
                </tbody>
        </table>

        <div class="pagination">
            <span>&lt; 이전</span>
            <span class="active">1</span>
            <span>2</span>
            <span>3</span>
            <span>4</span>
            <span>5</span>
            <span>다음 &gt;</span>
        </div>
    </div>
</body>
</html>