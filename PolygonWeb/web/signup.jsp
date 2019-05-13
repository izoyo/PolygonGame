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
    <link rel="stylesheet" href="src/signup.css" type="text/css" media="all">
</head>

<body>
<h1>登录与注册</h1>
<div class="container">
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
            <input type="text" Name="username" placeholder="用户名" required>
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
