package magic.board;

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

import magic.member.MemberDBBean;

public class BoardDBBean {
	// jsp 소스에서 빈객체 생성을 위한 참조 변수
	private static BoardDBBean instance = new BoardDBBean();

	// 1)MemberDBBean 객체 레퍼런스를 리턴하는 메소드
	public static BoardDBBean getInstance() {
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
	private static BoardBean board = null;

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

	/* ==== 게시글 정보 삽입 메소드[ 성공시 1 반환, 실패시 -1 반환 ] ==== */
	public int insertBoard(BoardBean board) {

		int id = board.getB_id();
		int ref = board.getB_ref();
		int step = board.getB_step();
		int level = board.getB_level();
		int number;
		int re = -1;

		try {
			conn = getConnection();

			// 글 번호 가져오기
			sql = "SELECT MAX(B_ID) FROM boardT";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			// 글이 하나라도 있으면 글 번호 최댓값+1, 글이 없으면 글 번호는 1부터 시작.
			if (rs.next()) {
				number = rs.getInt(1) + 1;
			} else {
				number = 1;
			}

			// 답글이라면 B_STEP의 값을 1 증가시킴.
			if (id != 0) {
				sql = "UPDATE BOARDT SET B_STEP = B_STEP + 1 WHERE B_REF = ? AND B_STEP > ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, ref);
				pstmt.setInt(2, step);
				pstmt.executeUpdate();

				step = step + 1;
				level = level + 1;
			} else {
				ref = number;
				step = 0;
				level = 0;
			}

			// 테이블에 데이터 INSERT
			sql = "INSERT INTO boardT(b_id, b_uid, b_title, b_content"
					+ ", b_date, b_ip, b_ref, b_step, b_level, b_fname, b_fsize, b_rfname) "
					+ "VALUES((SELECT NVL(MAX(b_id),0)+1 FROM boardT)," + "?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, board.getB_uid());
			pstmt.setString(2, board.getB_title());
			pstmt.setString(3, board.getB_content());
			pstmt.setTimestamp(4, new Timestamp(System.currentTimeMillis())); // 현재 시간 저장
			pstmt.setString(5, InetAddress.getLocalHost().getHostAddress()); // 작성자 IP를 받아옴
			pstmt.setInt(6, ref);
			pstmt.setInt(7, step);
			pstmt.setInt(8, level);
			pstmt.setString(9, board.getB_fname());
			pstmt.setInt(10, board.getB_fsize());
			pstmt.setString(11, board.getB_rfname());

			re = pstmt.executeUpdate();

			System.out.println("게시글 추가 성공");
		} catch (Exception e) {
			System.out.println("게시글 추가 실패");
			e.printStackTrace();
		} finally {
			closeObject();
		}

		return re;
	}

	/* ==== 게시글 정보를 반환하는 메소드 [ 게시글 객체 board 반환 ] ==== */
	public BoardBean getBoard(int id, boolean hitadd) {
		try {
			conn = getConnection();

			// hitadd 값이 true면 조회수 +1
			if (hitadd == true) {
				sql = "UPDATE BOARDT SET B_HIT=B_HIT + 1 WHERE B_ID=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, id);
				pstmt.executeUpdate();
			}

			// B_ID에 해당하는 게시글 전체 정보 SELECT
			sql = "SELECT * FROM BOARDT WHERE B_ID = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				board = new BoardBean();
				board.setB_id(rs.getInt(1));
				board.setB_uid(rs.getInt(2));
				board.setB_title(rs.getString(3));
				board.setB_content(rs.getString(4));
				board.setB_date(rs.getTimestamp(5));
				board.setB_hit(rs.getInt(6));
				board.setB_ip(rs.getString(7));
				board.setB_ref(rs.getInt(8));
				board.setB_step(rs.getInt(9));
				board.setB_level(rs.getInt(10));
				board.setB_fname(rs.getString(11));
				board.setB_fsize(rs.getInt(12));
				board.setB_rfname(rs.getString(13));
			}

			System.out.println("글 불러오기 완료");
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("글 불러오기 실패");
		} finally {
			closeObject();
		}

		return board;
	}

	/* ==== 게시글 목록을 반환하는 메소드 [ 게시글 ArrayList 반환 ] ==== */
	public ArrayList<BoardBean> listBoard(String pageNumber) {
		ResultSet pageSet = null; // 페이지에 관련된 결과값을 받기 위한 참조변수
		int dbCount = 0; // 게시글 총 갯수
		int absolutePage = 1;
		ArrayList<BoardBean> boardList = new ArrayList<>();

		// 게시글 선택
		sql = "SELECT b_id,b_uid, b_title, b_content"
				+ ", TO_CHAR(b_date,'YYYY-MM-DD HH24:MI'), b_hit, b_ip"
				+ ", b_ref, b_step, b_level, b_fname, b_fsize, b_rfname FROM boardT "
				// ORDER BY b_ref desc, b_step asc => 최신글 순이고, 답글 순
				+ "ORDER BY b_ref desc, b_step asc";

		try {
			conn = getConnection();
			stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);

			String countB_idSQL = "SELECT count(b_id) FROM boardT";
			pageSet = stmt.executeQuery(countB_idSQL);

			// 게시글 총 갯수 존재 여부 확인 후 게시글 총 갯수 가져오기
			if (pageSet.next()) {
				dbCount = pageSet.getInt(1);
				pageSet.close();
			}

			// ex) 84건인 경우: (84 % 10 = 4)
			if (dbCount % BoardBean.pageSize == 0) {
				// 80 / 10 : 8페이지 까지
				BoardBean.pageCount = dbCount / BoardBean.pageSize;
			} else {
				// 84/10 +1 = 9페이지
				BoardBean.pageCount = dbCount / BoardBean.pageSize + 1;
			}

			// 넘겨오는 페이지 번호가 있는 경우
			if (pageNumber != null) {
				BoardBean.pageNum = Integer.parseInt(pageNumber);
				// ex)1: 0*10 +1=1 2: 1*10 +1 = 11 = > 1페이지는 1, 2페이지는 11
				// (페이지 기준 게시글)
				absolutePage = (BoardBean.pageNum - 1) * BoardBean.pageSize + 1;
			}

			rs = stmt.executeQuery(sql);
			if (rs.next()) {// 게시글이 있으면 참
				rs.absolute(absolutePage); // 페이지의 기준 게시글 셋팅
				int count = 0;
				while (count < BoardBean.pageSize) { // 게시글 갯수만큼 반복
					board = new BoardBean();
					board.setB_id(rs.getInt(1));
					board.setB_uid(rs.getInt(2));
					board.setB_title(rs.getString(3));
					board.setB_content(rs.getString(4));
					board.setB_date2(rs.getString(5));
					board.setB_hit(rs.getInt(6));
					board.setB_ip(rs.getString(7));
					board.setB_ref(rs.getInt(8));
					board.setB_step(rs.getInt(9));
					board.setB_level(rs.getInt(10));
					board.setB_fname(rs.getString(11));
					board.setB_fsize(rs.getInt(12));
					board.setB_rfname(rs.getString(13));
					boardList.add(board);

//					페이지 변경 시 처리 위한 로직
					if (rs.isLast()) {
						break;
					} else {
						rs.next();
					}
					count++;
				}
			}

			System.out.println("글 목록 불러오기 성공");
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("글 목록 불러오기 실패");
		} finally {
			closeObject();
		}

		return boardList;
	}

	/* ==== 게시글 삭제 메소드[ 성공시 1 반환, 실패시 -1 반환 ] ==== */
	public int deleteBoard(int b_id,int uid) {
		int re = -1;
		int getb_uid;
		MemberDBBean mb =MemberDBBean.getInstance();
		try {
			conn = getConnection();

			// 해당 게시글의 B_PWD 값 가져오기
			sql = "SELECT B_UID FROM BOARDT WHERE B_ID=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, b_id);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				getb_uid = rs.getInt(1);

				if (getb_uid==uid) {
					sql = "DELETE FROM BOARDT WHERE B_ID=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, b_id);
					re = pstmt.executeUpdate();
					
					sql = "DELETE FROM COMMENTT WHERE C_BID=?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, b_id);
					re= pstmt.executeUpdate();

					System.out.println("게시글 삭제 성공");
					re = 1;
				} else {
					System.out.println("자신의 글만 삭제 가능합니다.");
					re = 0;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("게시글 삭제 실패");
		} finally {
			closeObject();
		}

		return re;
	}

	/* ==== 게시글 정보 수정 메소드[ 성공시 1 반환, 실패시 -1 반환 ] ==== */
	public int updateBoard(BoardBean board) {

		int re = -1;

		try {
			conn = getConnection();

			// 게시글 UPDATE 쿼리
			sql = "UPDATE boardT SET B_TITLE = ?, B_CONTENT = ? WHERE B_ID = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, board.getB_title());
			pstmt.setString(2, board.getB_content());
			pstmt.setInt(3, board.getB_id());
			re = pstmt.executeUpdate();

			System.out.println("게시글 수정 완료");
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("게시글 수정 실패");
		} finally {
			closeObject();
		}
		return re;
	}

	public BoardBean getFileName(int b_id) {
		sql = "SELECT B_FNAME, B_RFNAME FROM BOARDT WHERE B_ID = ?";
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, b_id);
			rs = pstmt.executeQuery();

			// 첨부파일이 있으면
			if (rs.next()) {
				board = new BoardBean();
				board.setB_fname(rs.getString(1));
				board.setB_rfname(rs.getString(2));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeObject();
		}
		return board;
	}
}