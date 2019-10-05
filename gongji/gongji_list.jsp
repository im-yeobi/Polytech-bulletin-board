<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<html>
    <head>
        <meta charset="utf-8" />

        <link rel="stylesheet" type="text/css" href="./css/reset.css" />
        <link rel="stylesheet" type="text/css" href="./css/gongji_list.css" />

        <%
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

            Connection conn = null;    // 커넥션 객체
            Statement stmt = null;
            ResultSet rset = null;
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
                        <!--<li class="gongji">
                            <div class="writing-number-name">
                                <div class="writing-number"><span class="writing-id">#2</span><span class="writing-notice">공지사항</span></div>
                                <div class="writing-name"><a href="" class="writing-name-show"><h5>엄청 길어버린다. 너무 길어서 문제이다.</h5></a></div>
                            </div>
                            <div class="writing-look-number">
                                <img src="./img/look.png" class="look-image" /><span class="look-number">10</span>
                            </div>
                            <div class="writing-user">
                                <img src="./img/admin.png" class="admin-image" />
                                <div class="admin-user">
                                    <div class="admin-box"><span class="admin">관리자</span><div>
                                    <div class="date-box"><span class="writing-date">2018-01-01</span></div>
                                </div>
                            </div>
                        </li>-->
                        
                        <%
                            try {
                                Class.forName("com.mysql.jdbc.Driver");
                                conn = DriverManager.getConnection("jdbc:mysql://localhost/jyk", "root", "1");
                                stmt = conn.createStatement();
                                
                                String query = "SELECT id, title, DATE_FORMAT(date, '%Y-%m-%d %T'), look_cnt FROM gongji ORDER BY id DESC;";
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

         <script>
            
         </script>
    </body>
</html>