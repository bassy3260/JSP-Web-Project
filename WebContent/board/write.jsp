<%@page import="magic.board.BoardBean"%>
<%@page import="magic.board.BoardDBBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String pageNum = request.getParameter("pageNum");	

	int b_id = 0;
	int b_ref = 0;
	int b_step = 0;
	int b_level = 0;
	String b_title = null;

	// show.jsp 에서 글 번호를 갖고왔다면
	if ( request.getParameter("b_id") != null ) {
		
		b_id = Integer.parseInt( request.getParameter("b_id") ); 
		BoardDBBean manager = BoardDBBean.getInstance();
		BoardBean board = manager.getBoard(b_id, false);
		b_ref = board.getB_ref();
		System.out.print(b_ref);
		b_step = board.getB_step(); 
		b_level = board.getB_level();
		b_title = board.getB_title();
	}		
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="board.js?ver=123" charset="utf-8"></script>
</head>
<body>
	<form name="board_form" method="post" action="writeOk.jsp" enctype="multipart/form-data">
		<table align ="center">
			<tr height="30">
				<td colspan="4" align="center">
				<h1>글 올리기</h1> <br>
				<input type="hidden" name="b_id" value="<%=b_id%>" />
				<input type="hidden" name="b_ref" value="<%=b_ref%>" />
				<input type="hidden" name="b_step" value="<%=b_step%>" />
				<input type="hidden" name="b_level" value="<%=b_level%>" />
				</td>
			</tr>		
			<tr height="30">
				<td width=60">글 제목</td>
				<% 
					if(b_id==0){		
				%>
				<td colspan=3><input type="text" size="82"  name="b_title">*</td>
				<% }else{
				%>
					<td colspan=3><input type="text" size="82" value="[답변]:<%=b_title %>" name="b_title">*</td>
				<% }%>
			</tr>
			<tr>
				<td width="80">파  일</td>
				<td colspan="30" width="140"><input type = "file" name="b_fname" size="40" maxlength="100"></td>
			</tr>
			<tr height="200">
				
				<td colspan=4><input type="text" size="100" name="b_content" style="width:580px;height:200px;"></td>
			</tr>
	
			<tr>
				<td colspan="4" align="center">
				<input type="button" value="글쓰기" onclick="check_ok()">
				<input type="reset" value="다시입력">
				<input type="button" value="글 목록" onclick="javascript:window.location='list.jsp?pageNum=<%=pageNum%>'">
				</td>
			</tr>
		</table>
	</form>
</body>
</html>