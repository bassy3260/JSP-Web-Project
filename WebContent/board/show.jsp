<%@page import="magic.member.MemberDBBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="magic.comment.CommentDBBean"%>
<%@page import="magic.comment.CommentBean"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="magic.board.BoardDBBean"%>
<%@page import="magic.board.BoardBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	MemberDBBean mb = MemberDBBean.getInstance();

	String pageNum = request.getParameter("pageNum");

	int b_id, b_hit, uid = 0;
	b_id = Integer.parseInt(request.getParameter("b_id"));
	if (session.getAttribute("Member") != null) {
		uid = Integer.parseInt(session.getAttribute("uid").toString());
	}
	BoardBean board = new BoardBean();
	BoardDBBean db = BoardDBBean.getInstance();

	board = db.getBoard(b_id, true);

	String b_title = board.getB_title();
	int b_uid = board.getB_uid();
	b_hit = board.getB_hit();
	String b_content = board.getB_content();
	Timestamp b_date = board.getB_date();
	SimpleDateFormat sd = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	String date = sd.format(b_date);
	String fname = board.getB_fname();
	int fsize = board.getB_fsize();

	CommentDBBean cb = CommentDBBean.getInstance();
	ArrayList<CommentBean> commentList = cb.listComment(b_id);
	String c_date, c_content = "";
	int c_uid;
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div width="600" align="center">
		<h1>글 내용 보기</h1>
		<table width="600" border="1" cellspacing="0">
			<tr>
				<td align="center">글 번호</td>
				<td align="center"><%=b_id%></td>
				<td align="center">조회수</td>
				<td align="center"><%=b_hit%></td>
			</tr>
			<tr>
				<td width="100" align="center">작성자</td>
				<td width="200" align="center"><%=mb.getMember(b_uid).getMem_name()%></td>
				<td width="100" align="center">작성일</td>
				<td width="200" align="center"><%=date%></td>
			</tr>
			<tr>
				<td width="110" align="center">파 일</td>
				<td colspan="3">&nbsp; <%
 	if (board.getB_rfname() != null) {
 	out.print("<p>첨부파일" + "<a href= 'fileDownload.jsp?fileN=" + board.getB_id() + "'>" + board.getB_rfname() + "</a>"
 	+ "</p>");
 }
 %>

				</td>
			</tr>
			<tr>
				<td align="center">글 제목</td>
				<td colspan=3><%=b_title%></td>

			</tr>
			<tr height="300">
				<td align="center">글 내용</td>
				<td colspan=3><%=b_content%></td>
			</tr>
			</tr>
			<tr height="30">
				<td colspan=4 align="right">
					<form>
						<%
							if (session.getAttribute("Member") != null) {
						%>

						<input type="button" value="답변 글"
							onclick="javascript:window.location='write.jsp?b_id=<%=b_id%>&pageNum=<%=pageNum%>'">
						<%
							}
						%>
						<%
							if (b_uid == uid) {
						%>
						<input type="button" value="글 수정"
							onclick="javascript:window.location='edit.jsp?b_id=<%=b_id%>&pageNum=<%=pageNum%>'">
						<input type="button" value="글 삭제"
							onclick="javascript:window.location='deleteOk.jsp?b_id=<%=b_id%>&pageNum=<%=pageNum%>'">
						<%
							}
						%>

						<input type="button" value="글 목록"
							onclick="javascript:window.location='list.jsp?pageNum=<%=pageNum%>'">
					</form>
				</td>

			</tr>
		</table>
		<form method="post" action="commentOk.jsp?b_id=<%=b_id%>">
			<table>
				<tr colspan="4">
					<td><h3>댓글</h3></td>
				</tr>
				<tr>
					<td colspan="4" align="right">
						<%
							if (session.getAttribute("Member") != null) {
						%> <input type="text" size="100" name="c_content"
						style="width: 580px; height: 200px;"><br> <input
						type="submit" value="댓글 등록" align="right"> <%
 	}
 %>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<table border="1" width="600">
							<%
								for (int i = 0; i < commentList.size(); i++) {
								CommentBean comment = commentList.get(i);
								c_uid = comment.getC_uid();
								c_content = comment.getC_content();
								c_date = comment.getC_date2();
							%>
							<tr height="25" border="1">
								<td width="150" align="center">작성자</td>
								<td width="150" align="center"><%=mb.getMember(c_uid).getMem_name()%></td>
								<td width="150" align="center">작성일</td>
								<td width="130" align="center"><%=c_date%></td>
							</tr>
							<tr>
								<td colspan="4" width="600"><%=c_content%></td>
							</tr>
							<%
								}
							%>

						</table>

						</form>
					</td>
				</tr>
			</table>
	</div>
</body>
</html>