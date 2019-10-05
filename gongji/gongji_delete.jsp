<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.io.*" %>

<%
    request.setCharacterEncoding("UTF-8");
    String getParamId;
    
    if (request.getParameter("id") == null) {   // 인자 넘어오지 않은 경우
        getParamId = "";
    }
    else {
        getParamId = request.getParameter("id");
    }
%>

<html>
    <head>
        <meta charset="utf-8" />

        <link rel="stylesheet" type="text/css" href="./css/reset.css" />
        <link rel="stylesheet" type="text/css" href="./css/gongji_list.css" />

        <%
            Connection conn = null;    // 커넥션 객체
            Statement stmt = null;
            ResultSet rset = null;

            Statement delStmt = null;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost/jyk", "root", "1");

                delStmt = conn.createStatement();
                String query = "DELETE FROM gongji WHERE id=" + getParamId + ";";
                delStmt.execute(query);
                delStmt.execute("COMMIT");
            } catch (SQLException sqle) {
                
            } catch (Exception e) {

            } finally {
                if (delStmt != null) delStmt.close();
            }
        %>
    </head>

    <body>
        <div class="whole-container">
            <header>
                <h3>공지사항 리스트</h3>
            </header>
            <article>
                <div id="gongjiContainer">
                    <ul id="gongjiList">
                        <%
                            try {
                                stmt = conn.createStatement();
                                
                                String query = "SELECT id, title, DATE_FORMAT(date, '%Y-%c-%e %T'), look_cnt FROM gongji ORDER BY id DESC;";
                                rset = stmt.executeQuery(query);
                                
                                while( rset.next() ) {
                        %>

                                    <li class="gongji">
                                        <div class="writing-number-name">
                                            <div class="writing-number"><span class="writing-id">#<%= rset.getInt(1) %></span><span class="writing-notice">공지사항</span></div>
                                            <div class="writing-name"><a href="gongji_view.jsp?id=<%= rset.getInt(1) %>" class="writing-name-show"><h5><%= rset.getString(2) %></h5></a></div>
                                        </div>
                                        <div class="writing-look-number">
                                            <img src="./img/look.png" class="look-image" /><span class="look-number"><%= rset.getInt(4) %></span>
                                        </div>
                                        <div class="writing-user">
                                            <img src="./img/admin.png" class="admin-image" />
                                            <div class="admin-user">
                                                <div class="admin-box"><span class="admin">관리자</span><div>
                                                <div class="date-box"><span class="writing-date"><%= rset.getString(3) %></span></div>
                                            </div>
                                        </div>
                                    </li>

                        <%
                                }
                            } catch (SQLException sqle) {   // sql 예외

                            } catch (Exception e) { // 이외 모든 예외

                            } finally {
                                if (rset != null) rset.close();
                                if (stmt != null) stmt.close();
                                if (conn != null) conn.close();
                            }
                        %>
                    </ul>
                    <div class="button-container"> 
                        <a href="gongji_insert.jsp" class="write-btn">새 글 쓰기</a>
                    </div>
                </div>
            </article>
         </div>
    </body>
</html>