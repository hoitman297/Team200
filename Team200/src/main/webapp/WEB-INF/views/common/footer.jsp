<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%-- 
  include용 파일에는 html, head, body 태그를 절대 쓰지 마.
  부모 페이지의 </body> 바로 직전에 이 내용만 쏙 들어가는 거야.
--%>
<footer> © 2026 LOG.GG ${not empty footerTitle ? footerTitle : '커뮤니티 플랫폼'}.
	모든 권리 보유. </footer>