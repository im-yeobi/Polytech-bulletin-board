<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    request.setCharacterEncoding("UTF-8");
    String getParamKey;

    // 신규
    String getParamTitle = "";
    String getParamDate = "";
    String getParamContent = "";

    // 수정
    int getParamId = 0;
    
    if (request.getParameter("key") == null) {
        getParamKey = "";
    } else {
        getParamKey = request.getParameter("key");

        if ( getParamKey.equals("update") )  {  // 수정
            if ( request.getParameter("id") == null ) {
                getParamId = 0;
            } else {
                getParamId = Integer.parseInt(request.getParameter("id"));
            }
        }

        if (request.getParameter("title") == null || request.getParameter("date") == null || request.getParameter("content") == null) {   // 인자 넘어오지 않은 경우
            getParamTitle = "제목 없음";
            getParamDate = "2018-01-01 00:00:00";
            getParamContent = "내용 없음";
        } else {
            getParamTitle = request.getParameter("title");
            getParamDate = request.getParameter("date");
            getParamContent = request.getParameter("content");
        }
    }
%>

<html>
    <head>
        <meta charset="utf-8" />

        <link rel="stylesheet" type="text/css" href="./css/reset.css" />
        <link rel="stylesheet" type="text/css" href="./css/gongji_write.css" />

        <%  
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date date = new Date();

            Connection conn = null;
            Statement stmt = null;
            ResultSet rset = null;

            Statement selStmt = null;

            String writeModifyDate = "";
            int writeLookCnt = 0;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost/jyk", "root", "1");
                stmt = conn.createStatement();
                selStmt = conn.createStatement();

                if( getParamKey.equals("insert") ) {    // 신규
                    String query = String.format("INSERT INTO gongji (title, date, content, look_cnt) VALUES ('%s', '%s', '%s', %d);",
                                                        getParamTitle, getParamDate, getParamContent, 0);
                    stmt.execute(query);

                    String selQuery = "SELECT LAST_INSERT_ID();";
                    rset = selStmt.executeQuery(selQuery);
                    rset.next();
                    getParamId = rset.getInt(1);

                    stmt.execute("COMMIT");
                } else {    // 수정
                    String query = String.format("UPDATE gongji SET title='%s', content='%s', modify_date='%s' WHERE id=%d;",
                                                        getParamTitle, getParamContent, getParamDate, getParamId);
                    stmt.execute(query);

                    String selQuery = "SELECT DATE_FORMAT(date, '%Y-%c-%e %T'), look_cnt FROM gongji WHERE id=" + getParamId + ";";
                    rset = selStmt.executeQuery(selQuery);
                    writeModifyDate = getParamDate;
                    getParamDate = rset.getString(1);
                    writeLookCnt = rset.getInt(2);

                    stmt.execute("COMMIT");
                }
            } catch (SQLException sqle) {

            } catch (Exception e) {

            } finally {
                if (rset != null) rset.close();
                if (stmt != null) stmt.close();
                if (selStmt != null) selStmt.close();
                if (conn != null) conn.close();
            }
        %>
    </head>

    <body>
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
                                <span class="write-date"><%= getParamDate %><%= (getParamKey.equals("update"))? "&nbsp;&nbsp;(수정시간: " + writeModifyDate + ")" : "" %></span>
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
                                <span id="write-number">#<%= getParamId %></span>
                                <span class="writing-notice">공지사항</span>
                            </div>
                            <div class="write-title-field">
                                <h2 id="write-title"><%= getParamTitle %></h2>
                            </div>
                        </div>
                        <hr>
                        <div class="write-body">
                            <textarea name="content" id="form-content" style="width:765px; height:250px; resize:none; font-size:15px;" readOnly><%= getParamContent %></textarea>
                        </div>
                    </div>
                </div>
                <div class="write-btn-field">
                    <div class="btn-field">
                        <a href="gongji_list.jsp" id="view-list-btn" >목록</a>
                        <input type="submit" id="form-btn" value="수정"  onClick="clickUpdate()" />
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