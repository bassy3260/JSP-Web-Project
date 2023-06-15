<%@page import="magic.member.MemberDBBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%  
	request.setCharacterEncoding("utf-8");
%>
<jsp:useBean id="mb" class = "magic.member.MemberBean"/>
<%-- 폼 양식에서 전달되는 파라미터 값 얻어와서 mb 객체의 프러퍼리 값으로 저장 --%>
<jsp:setProperty property="*" name="mb"/>
<!-- 오류 발생시 데이터 확인 -->
<!-- 1. db쪽에 로그를 추가해서 확인 -->
<!-- 오류 발생 시점에 더블클릭해서 표시를 하고 debug모드로 톰캣을 재시작해서 F8로 이동하면서 값을 확인 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%int uid= Integer.parseInt(session.getAttribute("uid").toString());
	String id= (String)session.getAttribute("id");
	mb.setMem_uid(uid);
	mb.setMem_id(id);
	MemberDBBean manager = MemberDBBean.getInstance();
	int re=manager.updateMember(mb);
	
	if(re==1){
	%>
		
		<script>
			alert("회원 정보 수정이 완료되었습니다.");
		</script>
	<%
		response.sendRedirect("../board/list.jsp?pageNum=1");
		
	}else{ //insert 정상적으로 실행 안됨
		%>
		<script>
		alert("회원 정보 수정에 실패했습니다.");
		history.back();
		</script>
		<%
	}
	
%>
</body>
</html>