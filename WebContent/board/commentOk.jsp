<%@page import="magic.comment.CommentDBBean"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.jspsmart.upload.File"%>
<%@page import="com.jspsmart.upload.SmartUpload"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="magic.board.BoardDBBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<%

	int c_bid = Integer.parseInt(request.getParameter("b_id"));
	int uid = Integer.parseInt(session.getAttribute("uid").toString());
	String name = session.getAttribute("name").toString();
	
	String id = (String) session.getAttribute("id");
%>
<jsp:useBean class="magic.comment.CommentBean" id="comment"></jsp:useBean>
<jsp:setProperty property="c_content" name="comment" />
<%
	CommentDBBean cb = CommentDBBean.getInstance();
	comment.setC_uid(uid);
	comment.setC_bid(c_bid);
	int re = cb.insertComment(comment);

	if (re == 1) {
%>
<script>
	alert("댓글 입력이 완료되었습니다.");
</script>
<%
	response.sendRedirect("show.jsp?b_id="+c_bid);
} else { //insert 정상적으로 실행 안됨
%>
<script>
	alert("댓글 입력에 실패했습니다.");
	history.back();
</script>
<%
}
%>
