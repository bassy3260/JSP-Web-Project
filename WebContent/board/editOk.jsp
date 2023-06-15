<%@page import="magic.board.BoardBean"%>
<%@page import="magic.board.BoardDBBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<jsp:useBean class="magic.board.BoardBean" id="board"></jsp:useBean>
<%

	String b_content= request.getParameter("b_content");
	String b_title= request.getParameter("b_title");

	String pageNum = request.getParameter("pageNum");	
	int b_id = Integer.parseInt(request.getParameter("b_id"));
	int uid = Integer.parseInt(session.getAttribute("uid").toString());
	BoardDBBean db = BoardDBBean.getInstance();
	board = db.getBoard(b_id, false);
	board.setB_content(b_content);
	board.setB_title(b_title);
	int re = db.updateBoard(board);
	if(board.getB_uid()==uid){
		if(re==1){
%>
		<script>
			alert("게시글이 수정 되었습니다.");
		</script>
<% 
			response.sendRedirect("list.jsp?pageNum="+pageNum);
		}else{
%>
		<script>
			alert("게시글 수정에 실패하였습니다.");
			history.back();
		</script>
<%	
		}
	}else{
%>
		<script>
			alert("본인의 글만 수정할 수 있습니다.");
			history.back();
		</script>
<% 
	}
%>
