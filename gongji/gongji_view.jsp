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
        <link rel="stylesheet" type="text/css" href="./css/gongji_write.css" />

        <%  
            Connection conn = null;
            Statement stmt = null;
            ResultSet rset = null;

            Statement upStmt = null;

            int writeId = 0;
            String writeTitle = "";
            String writeDate = "";
            String writeModifyDate = "";
            String writeContents = "";
            int writeLookCnt = 0;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost/jyk", "root", "1");

                upStmt = conn.createStatement();
                String upQuery = "UPDATE gongji f, gongji e SET f.look_cnt=e.look_cnt+1 WHERE f.id=" + getParamId + " AND e.id= " + getParamId + ";";  // 조회수 +1
                upStmt.execute(upQuery);
                upStmt.execute("COMMIT");
            } catch(SQLException sqle) {

            } catch (Exception e) {

            } finally {
                if (upStmt != null) upStmt.close();
            }
        %>
    </head>

    <body>
        <%
        try {
                stmt = conn.createStatement();
                String query = "SELECT id, title, DATE_FORMAT(date, '%Y-%c-%e %T'), DATE_FORMAT(modify_date, '%Y-%c-%e %T'), content, look_cnt FROM gongji WHERE id=" + getParamId + ";";
                rset = stmt.executeQuery(query);
                
                rset.next();
                writeId = rset.getInt(1);               // 글 번호
                writeTitle = rset.getString(2);         //  글 제목
                writeDate = rset.getString(3);          // 글 쓴 시간
                writeModifyDate = rset.getString(4);    // 글 수정 시간
                writeContents = rset.getString(5);      // 글 내용
                writeLookCnt = rset.getInt(6);          // 글 조회수
            } catch (SQLException sqle) {

            } catch (Exception e) {

            } finally {
                if (rset != null) rset.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
        <div class="whole-container">
            <header>
                <h3>글 보기</h3>
            </header>
            <div class="container">
                <div class="write-container">
                    <div class="write-user">
                        <div class="image-field">
                            <img src="./img/admin.png" class="user-image" />
                        </div>
                        <div class="write-user-date">
                            <div class="user-date-field">
                                <span class="user-id">관리자</span>
                                <span class="write-date"><%= writeDate %><%= (writeModifyDate != null)? "&nbsp;&nbsp;(수정시간: " + writeModifyDate + ")" : "" %></span>
                            </div>
                            <div class="look-field">
                                <img src="./img/look.png" id="look-image" />
                                <span class="look-number"><%= writeLookCnt %></span>
                            </div>
                        </div>
                    </div>
                    <div class="write-panel">
                        <div class="write-header">
                            <div class="write-number-field">
                                <span id="write-number">#<%= writeId %></span>
                                <span class="writing-notice">공지사항</span>
                            </div>
                            <div class="write-title-field">
                                <h2 id="write-title"><%= writeTitle %></h2>
                            </div>
                        </div>
                        <hr>
                        <div class="write-body">
                            <textarea name="content" id="form-content" style="width:765px; height:250px; resize:none; font-size:15px;" readOnly><%= writeContents %></textarea>
                        </div>
                    </div>
                </div>
                <div class="write-btn-field">
                    <div class="btn-field">
                        <a href="gongji_list.jsp" id="view-list-btn" >목록</a>
                        <input type="button" id="form-btn" value="수정" onClick="clickUpdate()" />
                    </div>
                </div>
            </div>
        </div>

        <script>
            (function() {
                var contents = document.getElementById('form-content').value;
                contents = contents.replace(/(<br>|<br\/>|<br \/>)/g, '\r\n');
                document.getElementById('form-content').value = contents;
            }());
            function clickUpdate() {
                window.location = "gongji_update.jsp?id=<%= getParamId %>";
            }
        </script>
    </body>
</html>