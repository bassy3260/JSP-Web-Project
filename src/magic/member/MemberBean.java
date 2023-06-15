package magic.member;

public class MemberBean {
	
	private int mem_uid;
	private String mem_id;
	private String mem_pwd;
	private String mem_name;
	private String mem_email;
	private String mem_addr;
	
	
	
	public int getMem_uid() {
		return mem_uid;
	}
	public void setMem_uid(int mem_uid) {
		this.mem_uid = mem_uid;
	}
	public String getMem_id() {
		return mem_id;
	}
	public void setMem_id(String mem_id) {
		this.mem_id = mem_id;
	}
	public String getMem_pwd() {
		return mem_pwd;
	}
	public String getMem_name() {
		return mem_name;
	}
	public String getMem_email() {
		return mem_email;
	}
	public String getMem_addr() {
		return mem_addr;
	}
	public void setMem_pwd(String mem_pwd) {
		this.mem_pwd = mem_pwd;
	}
	public void setMem_name(String mem_name) {
		this.mem_name = mem_name;
	}
	public void setMem_email(String mem_email) {
		this.mem_email = mem_email;
	}
	public void setMem_addr(String mem_addr) {
		this.mem_addr = mem_addr;
	}

}
