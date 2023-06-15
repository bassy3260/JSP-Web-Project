<%@page import="magic.member.MemberDBBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<jsp:useBean id="mb" class = "magic.member.MemberBean"/>
<%-- 폼 양식에서 전달되는 파라미터 값 얻어와서 mb 객체의 프러퍼리 값으로 저장 --%>
<jsp:setProperty property="*" name="mb"/>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	MemberDBBean manager = MemberDBBean.getInstance();

	if(mb.getMem_id()==null){
	%>
		<script>
		alert("회원가입에 실패했습니다.");
		history.back();
		</script>
	<% 
	}
	if(manager.confirmID(mb.getMem_id())==1){ //아이디가 중복
		
		%>
		<script>
		alert("중복되는 아이디가 존재합니다.");
		history.back();
		</script>
		<%
	}else{ //아이디가 중복아님
		int re = manager.insertMember(mb); 
		if(re==1){
			%>
			<script>
			alert("회원가입을 축하드립니다.\n회원으로 로그인 해주세요.");
			</script>
			<%
			response.sendRedirect("../board/list.jsp");
		}else{ //insert 정상적으로 실행 안됨
			%>
			<script>
			alert("회원가입에 실패했습니다.");
			history.back();
			</script>
			<%
		}
	}
%>
</body>
</html>