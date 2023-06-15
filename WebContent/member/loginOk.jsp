<%@page import="magic.member.MemberBean"%>
<%@page import="magic.member.MemberDBBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	String id= request.getParameter("mem_id");
	String pwd= request.getParameter("mem_pwd");
	
	MemberDBBean manager=MemberDBBean.getInstance();
	
 	int check=manager.userCheck(id, pwd);
 	MemberBean mb=manager.getMember(id);
 	if(mb==null){
%>
	<script>
		alert("존재하지 않는 회원");
		history.back();
	</script>
<% 
	}else{
 		int uid=mb.getMem_uid();
 		String name=mb.getMem_name();
 		String email=mb.getMem_email();
 		String addr=mb.getMem_addr();
 		if(check==1){ 
	 	//세션에 사용자 정보 추가후 main.jsp 로 이동
	 		session.setAttribute("uid", uid);
	 		session.setAttribute("id", id);
	 		session.setAttribute("pwd", pwd);
	 		session.setAttribute("name", name);
	 		session.setAttribute("email", email);
	 		session.setAttribute("addr", addr);
	 		session.setAttribute("Member", "yes");
	 		response.sendRedirect("../board/list.jsp");
		}else if(check==0){ 
%>
			<script>
				alert("비밀번호가 맞지 않습니다.");
 				history.back();
			</script>
<% 
 		}else{
%>
			<script>
 				alert("아이디가 맞지 않습니다.");
 				history.back();
			</script>
		
<%
 	} 
} 
%>
</body>
</html>