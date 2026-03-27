<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<div class="search-bar" style="position: relative;">
    <input type="text" id="globalSearchInput" placeholder="${currentGameName} 글 검색..." autocomplete="off">
    <span style="cursor:pointer;">🔍</span>
    
    <div id="searchResults" class="search-dropdown" data-current-game="${currentGameCode}" style="display: none;">
        <c:forEach var="post" items="${searchPool}">
            <a href="/post/${post.id}" class="search-item" data-game="${post.gameCode}">
                [${post.boardName}] ${post.title}
            </a>
        </c:forEach>
    </div>
</div>