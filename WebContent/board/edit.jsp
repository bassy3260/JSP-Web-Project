<%@page import="magic.board.BoardDBBean"%>
<%@page import="magic.board.BoardBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<%
	String pageNum = request.getParameter("pageNum");	
	int b_id = Integer.parseInt(request.getParameter("b_id"));
	BoardBean board = new BoardBean();
	BoardDBBean db = BoardDBBean.getInstance();
	board = db.getBoard(b_id, false);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="board.js?ver=123" charset="utf-8"></script>
</head>
<body>
	<form name="update_form" method="post" action="editOk.jsp?b_id=<%=b_id%>&pageNum=<%=pageNum %>">
		<table align ="center">
			<tr height="30">
				<td colspan="4" align="center">
				<h1>글 수정하기</h1> <br>
				</td>
			</tr>
			
			<tr height="30">
				<td width=60">글 제목</td>
				<td colspan=3><input type="text" size="82" value=<%=board.getB_title()%>  name="b_title"></td>
			</tr>
			<tr height="200">
				
				<td colspan=4><input type="text" size="100" name="b_content" value=<%=board.getB_content() %> style="width:580px;height:200px;"></td>
			</tr>
			<tr>
				<td colspan="4" align="center">
				<input type="button" value="글 수정" onclick="update_ok()">
				<input type="reset" value="다시입력">
				<input type="button" value="글 목록" onclick="javascript:window.location='list.jsp?pageNum=<%=pageNum %>'">
				</td>
			</tr>
		</table>
	</form>
</body>
</html>