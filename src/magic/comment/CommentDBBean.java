package magic.comment;

import java.net.InetAddress;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import magic.board.BoardBean;
import magic.board.BoardDBBean;
import magic.member.MemberBean;

public class CommentDBBean {
	// jsp 소스에서 빈객체 생성을 위한 참조 변수
	private static CommentDBBean instance = new CommentDBBean();

	// 1)MemberDBBean 객체 레퍼런스를 리턴하는 메소드
	public static CommentDBBean getInstance() {
		return instance;
	}

	// 2)쿼리작업에 사용할 커넥션 객체를 리턴하는 메소드(dbcp 기법)
	public Connection getConnection() throws Exception {
		Context ctx = new InitialContext();
		DataSource ds = (DataSource) ctx.lookup("java:comp/env/jdbc/oracle");
		return ds.getConnection();
	}

	// 데이터 연동 작업, 쿼리 실행 시 필요한 객체
	private static Connection conn = null;
	private static PreparedStatement pstmt = null;
	private static String sql = null;
	private static ResultSet rs = null;
	private static Statement stmt = null;
	private static CommentBean comment = null;

	/* ==== 자원 반납 메소드 ==== */
	public static void closeObject() {
		try {
			if (rs != null)
				rs.close();
			if (pstmt != null)
				pstmt.close();
			if (conn != null)
				conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// 3)전달인자로 받은 member를 memberT 테이블에 삽입하는 메소드
	public int insertComment(CommentBean comment) {

		int id = comment.getC_id();
		int number;
		int re = -1;
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			conn = getConnection();
			// 답글이라면 B_STEP의 값을 1 증가시킴.

			// 테이블에 데이터 INSERT
			sql = "INSERT INTO COMMENTT(C_id, C_UID, C_BID, C_content, C_DATE)"
					+ " VALUES((SELECT NVL(MAX(C_ID),0)+1 FROM COMMENTT)," + "?,?,?,?)";

			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, comment.getC_uid());
			pstmt.setInt(2, comment.getC_bid());
			pstmt.setString(3, comment.getC_content());
			pstmt.setTimestamp(4, new Timestamp(System.currentTimeMillis())); // 현재 시간 저장

			re = pstmt.executeUpdate();

			System.out.println("댓글 추가 성공");
		} catch (Exception e) {
			System.out.println("댓글 추가 실패");
			e.printStackTrace();
		} finally {
			closeObject();
		}

		return re;
	}

	/* ==== 게시글 목록을 반환하는 메소드 [ 게시글 ArrayList 반환 ] ==== */
	public ArrayList<CommentBean> listComment(int c_bid) {

		ArrayList<CommentBean> commentList = new ArrayList<>();

		// 게시글 선택
		sql = "SELECT C_ID, C_UID, C_BID, C_CONTENT, TO_CHAR(C_DATE,'YYYY-MM-DD HH24:MI')" + " FROM COMMENTT"
				+ " WHERE C_BID = ?"
				+" ORDER BY C_ID ASC";

		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, c_bid);
			rs = pstmt.executeQuery();
			while (rs.next()) {// 게시글이 있으면 참
				comment = new CommentBean();
				comment.setC_id(rs.getInt(1));
				comment.setC_uid(rs.getInt(2));
				comment.setC_bid(rs.getInt(3));
				comment.setC_content(rs.getString(4));
				comment.setC_date2(rs.getString(5));
				commentList.add(comment);
				System.out.println("댓글 목록 불러오기 성공");
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("댓글 목록 불러오기 실패");
		} finally {
			closeObject();
		}

		return commentList;

	}
}
