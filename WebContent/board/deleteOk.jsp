<%@page import="java.io.File"%>
<%@page import="magic.board.BoardBean"%>
<%@page import="magic.board.BoardDBBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    		<%
request.setCharacterEncoding("utf-8");
%>

<%
	request.setCharacterEncoding("utf-8");
	int uid = Integer.parseInt(session.getAttribute("uid").toString());
	String pageNum = request.getParameter("pageNum");	
	int b_id = Integer.parseInt(request.getParameter("b_id"));
	String b_pwd = request.getParameter("b_pwd");
	BoardDBBean db = BoardDBBean.getInstance();
	BoardBean board = db.getBoard(b_id,false);
	String fname = board.getB_fname();
	int b_uid = board.getB_uid();
	int re = db.deleteBoard(b_id, uid);
	String up = "D:\\dev\\work_jsp\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\jspwork_230217\\upload\\";
	if(re==1){
		%>
		<script>
			alert("게시글이 삭제 되었습니다.");
		</script>
		<% 
		response.sendRedirect("list.jsp?pageNum="+pageNum);
		if(fname != null ){
			File file = new File(up+fname);
			file.delete();
		}
	}else if(re==0){
	%>
		<script>
			alert("자신의 글만 삭제 가능합니다.");
			history.back();
		</script>
	<% 
		
	}else{
	%>
		<script>
		alert("게시글 삭제가 실패하였습니다.");
		history.back();
		</script>
	<%
	}
%>
   