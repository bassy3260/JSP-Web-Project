package magic.comment;

import java.sql.Timestamp;

public class CommentBean {
	private int c_id;
	private int c_uid;
	private int c_bid;
	private String c_content;
	private Timestamp c_date;
	private String c_date2;

	
	public Timestamp getC_date() {
		return c_date;
	}
	public void setC_date(Timestamp c_date) {
		this.c_date = c_date;
	}
	public String getC_date2() {
		return c_date2;
	}
	public void setC_date2(String c_date2) {
		this.c_date2 = c_date2;
	}
	public int getC_id() {
		return c_id;
	}
	public void setC_id(int c_id) {
		this.c_id = c_id;
	}
	public int getC_bid() {
		return c_bid;
	}
	public void setC_bid(int c_bid) {
		this.c_bid = c_bid;
	}
	
	public int getC_uid() {
		return c_uid;
	}
	public void setC_uid(int c_uid) {
		this.c_uid = c_uid;
	}
	public String getC_content() {
		return c_content;
	}
	public void setC_content(String c_content) {
		this.c_content = c_content;
	}


	
	
}
