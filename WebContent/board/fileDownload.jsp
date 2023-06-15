<%@page import="java.io.BufferedOutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="java.io.File"%>
<%@page import="magic.board.BoardBean"%>
<%@page import="magic.board.BoardDBBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int b_id = Integer.parseInt(request.getParameter("fileN"));
	BoardDBBean db = BoardDBBean.getInstance();
	BoardBean board = db.getFileName(b_id);
	
	String fileName="";
	String realFileName ="";
	
	// 첨부파일이 있으면
	if(board != null){
		fileName= board.getB_fname();
		realFileName = board.getB_rfname();
	}
	
	// 실제 업로드 되어 있는 경로
	String saveDirectory = application.getRealPath("/upload");
	// File.separator : 디렉토리 명과 파일명을 연결하는 구분자(운영체제마다 상이할 수 있음)
	// fileName : 넘버링 처리된 파일명
	String path = saveDirectory + File.separator + fileName;
	
	// file : 다운로드 대상 파일
	File file = new File(path);
	long length = file.length();
	// jsp 기본 한글 처리
	realFileName = new String(realFileName.getBytes("ms949"),"8859_1");
	
	// response 객체에 필요한 내용들을 담아서 전송
	// octet-stream : 기본 ContentType
	response.setContentType("application/octet-stream");
	response.setContentLength((int)length);
	// "Content-Dispostion" : 브라우저에 실제 파일명 컨텐츠가 있다고 알림
	response.setHeader("Content-Dispostion", "attachment;filename="+realFileName);
	
	// 파일 다운로드 할 때 임시 저장공간을 사용
	BufferedInputStream bis = new BufferedInputStream(new FileInputStream(file));
	// 기본 파일이 남아 있는 경우 초기화
	out.clear();
	// 다운로드 준비
	out = pageContext.pushBody();
	// 다운로드로 파일 내보낼 때 사용
	BufferedOutputStream bos = new BufferedOutputStream(response.getOutputStream());
	// bis로 읽어서 bos로 쓴다.
	
	// bis로 읽어서 bos에 쓰기
	int data;
	while((data=bis.read()) != -1){
		bos.write(data);
	}
	
	bis.close();
	bos.close();
%>