<%@page import="magic.member.MemberBean"%>
<%@page import="magic.member.MemberDBBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%	
	request.setCharacterEncoding("utf-8");
	int uid = Integer.parseInt(session.getAttribute("uid").toString());
	MemberDBBean manager = MemberDBBean.getInstance();
	MemberBean member = manager.getMember(uid);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="script.js" charset="utf-8"></script>
</head>

<body>
	<table border="1" align ="center">
		<form name="update_frm" method="post" action="memberUpdateOk.jsp">
			<tr height="50">
				<td colspan="2" align="center">
				<h1>회원 정보 수정</h1> <br>
				'*' 표시 항목은 필수 입력 항목입니다.
				</td>
			</tr>
			<tr height="30">
				<td width="80">User ID</td>
				<td><%= member.getMem_id() %>*</td>
			</tr>
			<tr height="30">
				<td width="80">암호</td>
				<td><input type="password" size="20"  name="mem_pwd">*</td>
			</tr>
			<tr height="30">
				<td width="80">암호 확인</td>
				<td><input type="password" size="20"  name="mem_check">*</td>
			</tr>
			<tr height="30">
				<td width="80">이름</td>
				<td><input type="text" size="20"  name="mem_name" value="<%= member.getMem_name() %>">*</td>
			</tr>
			<tr height="30">
				<td width="80">E-mail</td>
				<td><input type="text" size="30"  name="mem_email" value="<%= member.getMem_email() %>">>*</td>
			</tr>
			<tr height="30">
				<td width="80">주 소</td>
				<td><input type="text" size="40" name="mem_addr"  value="<%= member.getMem_addr() %>"></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
				<input type="button" onclick="update_check_ok()" value="수정 완료">
				<input type="reset" value="다시입력">
				<input type="button" value="수정 안함" onclick="javascript:window.location='../board/list.jsp'">
				</td>
			</tr>
		</form>
	</table>
</body>
</html>