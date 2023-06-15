function check_ok(){

	if(reg_frm.mem_id.value==""){
	   alert("아이디를 써주세요.");
	   reg_frm.mem_uid.focus();
	   return;
	}else if(reg_frm.mem_id.value.length < 4){
	   alert("아이디는 4글자이상이어야 합니다.");
	   reg_frm.mem_uid.focus();
	   return;
	}
	if(reg_frm.mem_pwd.value==""){
	   alert("패스워드는 반드시 입력해야 합니다.");
	   reg_frm.mem_pwd.focus();
	   return;
	}
	if(reg_frm.mem_pwd.value != reg_frm.mem_check.value){
	   alert("패스워드가 일치하지 않습니다.");
	   reg_frm.mem_check.focus();
	   return;
	}
	if(reg_frm.mem_name.value==""){
	   alert("이름을 써주세요");
	   reg_frm.mem_name.focus();
	   return;
	}
	if(reg_frm.mem_email.value==""){
	   alert("Email을 써주세요.");
	   reg_frm.mem_email.focus();
	   return;
	}
	document.reg_frm.submit();
}

function update_check_ok(){
	if (document.update_frm.mem_pwd.value.length == 0){
		alert("패스워드는 반드시 입력해야 합니다.");
		update_frm.mem_pwd.focus();
		return;
	}
	if(document.update_frm.mem_pwd.value != document.update_frm.mem_check.value){
		alert("패스워드가 일치하지 않습니다.");
		update_frm.mem_check.focus();
		return;
	}
	if(document.update_frm.mem_email.value.length == 0){
		alert("Email을 써주세요.");
		update_frm.mem_email.focus();
		return;
	}
	document.update_frm.submit();
}