package magic.member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

//회원정보 처리 빈 객체
public class MemberDBBean {
//jsp 소스에서 빈객체 생성을 위한 참조 변수
	private static MemberDBBean instance = new MemberDBBean();

//1)MemberDBBean 객체 레퍼런스를 리턴하는 메소드
	public static MemberDBBean getInstance() {
		return instance;
	}

	// 2)쿼리작업에 사용할 커넥션 객체를 리턴하는 메소드(dbcp 기법)
	public Connection getConnection() throws Exception {
		Context ctx = new InitialContext();
		DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}

	// 3)전달인자로 받은 member를 memberT 테이블에 삽입하는 메소드
	public int insertMember(MemberBean member) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		// 매개변수로 받은 member객체를 ? 인 쿼리 파라미터에 메핑
		String sql = "INSERT INTO MEMBERT VALUES((SELECT NVL(MAX(MEM_UID),0)+1 FROM MEMBERT),?,?,?,?,?)";
		int re = -1; // 초기값-1, insert 정상적으로 실행되면1

		try {
			// dbcp 기법의 연결 객체
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, member.getMem_id());
			pstmt.setString(2, member.getMem_pwd());
			pstmt.setString(3, member.getMem_name());
			pstmt.setString(4, member.getMem_email());
			pstmt.setString(5, member.getMem_addr());
			// insert문은 excuteUpdate 메소드 호출
			pstmt.executeUpdate();
			re = 1;

			pstmt.close();
			conn.close();
			System.out.println("추가 성공");
		} catch (Exception e) {
			System.out.println("추가 실패");
			e.printStackTrace();
		}
		return re;

	}

	// 4) 회원 가입시 아이디 중복 확인 할때 사용하는 메소드
	public int confirmID(String id) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		// 매개변수로 받은 member객체를 ? 인 쿼리 파라미터에 메핑
		String sql = "SELECT mem_id FROM MEMBERT WHERE mem_id=?";
		int re = -1; // 초기값-1, 아이디가 중복되면 1

		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id); // ?를 처리하기 위해서 id를 넣는다. 동일하다? (id =?)
			// SELECT 문은 executeQuery 메소드 호출
			rs = pstmt.executeQuery();

			if (rs.next()) {
				re = 1;
			} else {
				re = -1;
			}
			rs.close();
			pstmt.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return re;
	}

	
	public int userCheck(String id, String pwd) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		//매개변수로 받은 id를 ?인 쿼리 파라미터에 매핑
		String sql = "SELECT mem_pwd FROM MEMBERT WHERE mem_id=?";
		int re=-1; // 초기값이 -1, 비밀번호가 일치하면 1
		String db_mem_pw="";
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id); 
			rs = pstmt.executeQuery();
			if(rs.next()) { //아이디가 일치하는 로우 존재
				db_mem_pw= rs.getNString("mem_pwd");
				if(db_mem_pw.equals(pwd)) { //패스워드가 일치
					re=1;
					rs.close();
					pstmt.close();
					conn.close();
				}else { //패스워드 불일치
					re=0;
				}
			}else { //해당 아이디가 존재하지 않음
				re=-1;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return re;
	}
	
	public MemberBean getMember(String id) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql= "SELECT mem_uid, mem_id, mem_pwd, mem_name, mem_email, mem_addr FROM MEMBERT WHERE mem_id=?";
		MemberBean member = null;
//		member: 쿼리 겨과에 해당하는 회원 정보를 담는다	
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id); 
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				member= new MemberBean();
				member.setMem_uid(rs.getInt(1));
				member.setMem_id(rs.getString(2));
				member.setMem_pwd(rs.getString(3));
				member.setMem_name(rs.getString(4));
				member.setMem_email(rs.getString(5));
				member.setMem_addr(rs.getString(6));
			}
			rs.close();
			pstmt.close();
			conn.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		return member;
	}
	
	public MemberBean getMember(int uid) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql= "SELECT mem_uid, mem_id, mem_pwd, mem_name, mem_email, mem_addr FROM MEMBERT WHERE mem_uid=?";
		MemberBean member = null;
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, uid); 
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				member= new MemberBean();
				member.setMem_uid(rs.getInt(1));
				member.setMem_id(rs.getString(2));
				member.setMem_pwd(rs.getString(3));
				member.setMem_name(rs.getString(4));
				member.setMem_email(rs.getString(5));
				member.setMem_addr(rs.getString(6));
			}
			rs.close();
			pstmt.close();
			conn.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		return member;
	}
	public int updateMember(MemberBean member) throws Exception{
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql= "UPDATE MEMBERT SET mem_pwd=?, mem_name=?, mem_email=?, mem_addr=? WHERE mem_uid=?";
		int re = -1; // 초기값-1, insert 정상적으로 실행되면1
		try {
			// dbcp 기법의 연결 객체
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, member.getMem_pwd());
			pstmt.setString(2, member.getMem_name());
			pstmt.setString(3, member.getMem_email());
			pstmt.setString(4, member.getMem_addr());
			pstmt.setInt(5, member.getMem_uid());
			// insert문은 excuteUpdate 메소드 호출
			re = pstmt.executeUpdate();
			

			pstmt.close();
			conn.close();
			System.out.println("수정 성공");
		} catch (Exception e) {
			System.out.println("수정 실패");
			e.printStackTrace();
		}
		return re;

	}
}
