<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<html>
    <head>
        <meta charset="utf-8" />

        <link rel="stylesheet" type="text/css" href="./css/reset.css" />
        <link rel="stylesheet" type="text/css" href="./css/gongji_insert.css" />

        <%  
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            Date date = new Date();
        %>
    </head>

    <body>
        <div class="whole-container">
            <header>
                <h3>새 글 입력</h3>
            </header>
            <div class="write-container">
                <div class="write-user">
                    <img src="./img/admin.png" class="user-image" />
                    <span class="user-id">관리자</span>
                </div>
                <div class="write-panel">
                    <form name="write-form" id="write-form" action="gongji_write.jsp?key=insert" method="post" onSubmit="return checkInsert(this)">
                        <div class="write-number-field">
                            <span class="write-new">신규</span>
                        </div>
                        <div class="write-title-field">
                            <input type="text" name="title" class="form-title" placeholder="제목을 입력해주세요." maxlength="55" required />
                        </div>
                        <div class="write-date-field">
                            <input type="text" name="date" class="form-date" value="<%= sdf.format(date) %>" readOnly />
                        </div>
                        <div class="write-content-field">
                            <textarea name="content" class="form-content"></textarea>
                        </div>
                        <div class="write-btn-field">
                            <div class="btn-field">
                                <a href="gongji_list.jsp" id="cancel-btn" >취소</a>
                                <input type="submit" id="form-btn" value="등록" />
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
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

                    title = title.replace(/&/g, "&amp;");
                    title = title.replace(/\"/g, "&quot;");
                    title = title.replace(/(\s\s*)/g, " ");   // 띄어쓰기는 한 번만 허용한다.
                    title = title.replace(/</g, "&lt;");
                    title = title.replace(/>/g, "&gt;");
                    title.trim();   // 앞 뒤 공백 제거
                    if (title.length >= 55) {
                        alert("제목의 길이는 55자 이하여야 합니다!");
                        return false;
                    }
                    form.title.value = title;

                    contents = contents.replace(/&/g, "&amp;");
                    contents = contents.replace(/\"/g, "&quot;");
                    contents = contents.replace(/</g, "&lt;");
                    contents = contents.replace(/>/g, "&gt;");
                    contents = contents.replace(/(?:\r\n|\r|\n)/g, "<br />");    // 개행 적용하여 DB에 저장하기 위함.
                    // contents = contents.replace(/(?:\r\n|\r|\n)/g, "<br />");    // 개행 적용하여 DB에 저장하기 위함.
                    //contents = contents.replace(/\s/g, '&nbsp;');
                    //contents = contents.replace(/(\r\n|\r|\n)/g, "<br />");    // 개행 적용하여 DB에 저장하기 위함.
                    form.content.value = contents;
                    
                    return true;
                }
            }
        </script>
    </body>
</html>