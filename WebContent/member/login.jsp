<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
		<table border="1" align="center" >
			<form method="post" action="loginOk.jsp">
			<tr height="30">
				<td width="100" align="center" >사용자 ID</td>
				<td width="100"><input type="text" name="mem_id"></td>
			</tr>
			<tr height="30">
				<td width="100" align="center" >비밀번호</td>
				<td width="100"><input type="password" name="mem_pwd"></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
<!-- 				<a href="loginOk.jsp"><button type="submit">로 그 인</button></a>  -->
<!-- 				<a href="register.jsp"><button type="submit">회원가입</button></a>  -->
					<input type="submit" value="로 그 인">
					<input type="button" value="회원가입" onclick="javascript:window.location='register.jsp'">
				</td>
			</tr>
		</form>
	</table>
</body>
</html>