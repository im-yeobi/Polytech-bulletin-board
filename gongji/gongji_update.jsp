<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

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
        <link rel="stylesheet" type="text/css" href="./css/gongji_insert.css" />

        <style>
            #delete-btn {
                width: 80px;
                height: 100%;
                display: block;
                float: left;
                background-color: #fff;
                border: 1px solid #ccc;
                border-radius: 5px;
                padding-top: 9px;
                text-align: center;
                font-size: 14px;
                margin-right: 20px;
            }
            #delete-btn:hover {
                background-color: #E6E6E6;
                border-color: darkgray;
            }
        </style>

        <%  
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date date = new Date();

            Connection conn = null;
            Statement stmt = null;
            ResultSet rset = null;

            int writeId = 0;
            String writeTitle = "";
            String writeDate = "";  // 글 작성일자
            String updateDate = ""; // 수정일자
            String writeContents = "";
        %>
    </head>

    <body>
        <%
            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost/jyk", "root", "1");
                stmt = conn.createStatement();

                String query = "SELECT id, title, DATE_FORMAT(date, '%Y-%c-%e %T'), content FROM gongji WHERE id=" + getParamId + ";";
                rset = stmt.executeQuery(query);
    
                rset.next();
                writeId = rset.getInt(1);           // 글 번호
                writeTitle = rset.getString(2);     // 글 제목
                writeDate = rset.getString(3);      // 글 쓴 시간
                updateDate = sdf.format(date);      // 글 수정 시간
                writeContents = rset.getString(4);  // 글 내용
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
                <h3>글 수정</h3>
            </header>
            <div class="write-container">
                <div class="write-user">
                    <img src="./img/admin.png" class="user-image" />
                    <span class="user-id">관리자</span>
                </div>
                <div class="write-panel">
                    <form name="write-form" id="write-form" action="gongji_write.jsp?key=update&id=<%= writeId %>" method="post" onSubmit="return checkInsert(this)">
                        <div class="write-number-field">
                            <span class="write-new">#<%= writeId %></span>
                        </div>
                        <div class="write-title-field">
                            <input type="text" name="title" class="form-title" placeholder="제목을 입력해주세요." value="<%= writeTitle %>" maxlength="55" required />
                        </div>
                        <div class="write-date-field">
                            <input type="text" name="date" class="form-date" value="<%= updateDate %>" readOnly />
                        </div>
                        <div class="write-content-field">
                            <textarea name="content" id="form-content" class="form-content"><%= writeContents %></textarea>
                        </div>
                        <div class="write-btn-field">
                            <div class="btn-field">
                                <a href="gongji_list.jsp" id="cancel-btn">취소</a>
                                <a href="gongji_delete.jsp?id=<%= writeId %>" id="delete-btn">삭제</a>
                                <input type="submit" id="form-btn" value="등록" />
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            (function() {
                var contents = document.getElementById('form-content').value;
                contents = contents.replace(/(<br>|<br\/>|<br \/>)/g, '\r\n');
                document.getElementById('form-content').value = contents;
            }());

            function checkInsert(form) {
                var title = form.title.value;
                var contents = form.content.value;
                title = title.replace(/(\s*)/g, "");    // s는 정규표현식에서 공백을 의미한다. 
                contents = contents.replace(/(\s*)/g, "");

                if (title == "") {  // 제목 공백 모두 제거하였을 때 비어있으면, 필수값 오류
                    alert("제목 오류");
                    form.title.value = title;
                    return false;
                } else if (contents == "") {    // 내용 공백 모두 제거하였을 때 비어있으면, 필수값 오류
                    alert("내용 오류");
                    form.content.value = contents;
                    return false;
                } else {
                    title = form.title.value;
                    contents = form.content.value;

                    title = title.replace(/(\s\s*)/g, " ");   // 띄어쓰기는 한 번만 허용한다.
                    title = title.replace(/&/g, "&amp;");
                    title = title.replace(/\"/g, "&quot;");
                    title = title.replace(/</g, "&lt;");
                    title = title.replace(/>/g, "&gt;");
                    title.trim();   // 앞 뒤 공백 제거
                    if (title.length >= 55)
                        return false;
                    form.title.value = title;
                    
                    contents = contents.replace(/&/g, "&amp;");
                    contents = contents.replace(/\"/g, "&quot;");
                    contents = contents.replace(/</g, "&lt;");
                    contents = contents.replace(/>/g, "&gt;");
                    contents = contents.replace(/(?:\r\n|\r|\n)/g, "<br />");    // 개행 적용하여 DB에 저장하기 위함.
                    //contents = contents.replace(/\s/g, '&nbsp;');
                    form.content.value = contents;
                    
                    return true;
                }
            }
        </script>
    </body>
</html>