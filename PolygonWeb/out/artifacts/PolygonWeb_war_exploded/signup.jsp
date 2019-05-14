<%--
  Created by IntelliJ IDEA.
  User: YPC
  Date: 2019/5/12
  Time: 14:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>登录与注册</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">

    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.1.0/css/bootstrap.min.css">
    <script src="https://cdn.bootcss.com/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://cdn.bootcss.com/popper.js/1.12.5/umd/popper.min.js"></script>
    <script src="https://cdn.bootcss.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="src/signup.css" type="text/css" media="all">
</head>
<%
    // 解决中文乱码的问题
    int err = 0;
    try {
        Cookie c = new Cookie("username","");
        c.setMaxAge(0);
        response.addCookie(c);

        err = Integer.parseInt(request.getParameter("err"));
    }catch (Exception e){
        System.out.println(e.toString());
    }

%>
<body>
<h1>登录与注册</h1>
<div class="container">
    <%if (err >0) {%>

    <div class="alert alert-danger alert-dismissible fade show m-auto" style=" width: 60%;">
        <button type="button" class="close" data-dismiss="alert">&times;</button>
        <%if (err == 1) {%>
            登陆失败！
        <%}else{%>
            注册失败！
        <%}%>
    </div>

    <%}%>

    <div class="login">
        <h2>登 录</h2>
        <form action="Login" method="post">
            <input type="text" Name="username" placeholder="用户名" required>
            <input type="password" Name="password" placeholder="密码" required>

            <div class="send-button">
                <form>
                    <input type="submit" value="登 录">
                </form>
            </div>
        </form>
    </div>


    <div class="register">
        <h2>注 册</h2>
        <form action="Signup" method="post">
            <input type="text" Name="username" placeholder="账号" required>
            <input type="text" Name="name" placeholder="用户名" required>
            <input type="password" Name="password" placeholder="密码" required>

            <div class="send-button">
                <form>
                    <input type="submit" value="注册">
                </form>
            </div>
        </form>
        <div class="clear"></div>
</div>
<div class="clear"></div>

</div>
</body>
</html>
