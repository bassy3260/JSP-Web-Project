<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.jspsmart.upload.File"%>
<%@page import="com.jspsmart.upload.SmartUpload"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="magic.board.BoardDBBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	int uid = Integer.parseInt(session.getAttribute("uid").toString());
	String name = session.getAttribute("name").toString();
%>
<jsp:useBean class="magic.board.BoardBean" id="board"></jsp:useBean>
<%
	BoardDBBean db=BoardDBBean.getInstance();
	
// 	파일 업로드 처리
	String path = request.getRealPath("upload");
	int size = 1024*1024;
	int fileSize= 0;
	String file="";
	String orifile="";
	
	// DefaultFileRenamePolicy: 파일명 넘버링 처리
	MultipartRequest multi= new MultipartRequest(request, path,size,"UTF-8", new DefaultFileRenamePolicy());
	// 파일명 가져오기
	Enumeration files= multi.getFileNames();
	String str = files.nextElement().toString();
	// file: 넘버링 처리된 파일 
	file = multi.getFilesystemName(str);
	
	if(file != null){
		//orifile : 실제 파일명
		orifile = multi.getOriginalFileName(str);
		fileSize = file.getBytes().length;
	}
	
	board.setB_ref(Integer.parseInt(multi.getParameter("b_ref")));
	board.setB_step(Integer.parseInt(multi.getParameter("b_step")));
	board.setB_level(Integer.parseInt(multi.getParameter("b_level")));
	board.setB_id(Integer.parseInt(multi.getParameter("b_id")));
	board.setB_uid(uid);
	board.setB_title(multi.getParameter("b_title"));
	board.setB_content(multi.getParameter("b_content"));

	if(file != null){
		board.setB_fname(file);
		board.setB_fsize(fileSize);
		board.setB_rfname(orifile);
	}
	
	if(db.insertBoard(board)==1){
		response.sendRedirect("list.jsp");
	}else{
		response.sendRedirect("write.jsp");
	}	
%>
