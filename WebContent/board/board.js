function check_ok(){
	if(board_form.b_title.value==""){
		alert("글 제목을 작성해주세요.")
		board_form.b_title.focus();
		return;
	}
	if(board_form.b_content.value==""){
		alert("글 내용을 작성해주세요.")
		board_form.b_content.focus();
		return;
	}
	
	document.board_form.submit();
}
function comment_ok(){
	
}

function update_ok(){
	if(update_form.b_title.value==""){
		alert("글 제목을 작성해주세요.")
		update_form.b_title.focus();
		return;
	}
	if(update_form.b_content.value==""){
		alert("글 내용을 작성해주세요.")
		update_form.b_content.focus();
		return;
	}
	document.update_form.submit();
}

function delete_ok(){
	document.delete_form.submit();
}