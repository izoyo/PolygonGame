<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*"%>
<%
    Cookie[] cookies = request.getCookies();
    String name=null, pwd=null;
    for (Cookie c:cookies){
        if(c.getName().equals("username")){
            name = c.getValue();
        }if(c.getName().equals("password")){
            pwd = c.getValue();
        }
    }
    if(name == null || pwd == null){
        response.sendRedirect("signup.jsp");
    }
%>
<html>
<head>
    <title>Polygon</title>
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.1.0/css/bootstrap.min.css">
    <script src="https://cdn.bootcss.com/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://cdn.bootcss.com/popper.js/1.12.5/umd/popper.min.js"></script>
    <script src="https://cdn.bootcss.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>
    <link href="./src/main.css" rel="stylesheet">
</head>
<body>
<div class="jumbotron" id="j-head">
    <div class="container">
        <h2>🖇️多边形游戏</h2>
        <p> - 算法设计与分析项目</p>
    </div>
</div>
<hr>

<%--<nav class="navbar navbar-expand-sm bg-light navbar-light fixed-top" id="n-head">--%>
<%--    <a class="navbar-brand" href="index.jsp">多边形游戏</a>--%>
<%--    <ul class="navbar-nav mr-auto">--%>
<%--        <li class="nav-item">--%>
<%--            <a class="nav-link" href="pk.jsp">匹配</a>--%>
<%--        </li>--%>
<%--        <li class="nav-item">--%>
<%--            <a class="nav-link" href="rank.jsp">天梯</a>--%>
<%--        </li>--%>

<%--    </ul>--%>
<%--    <ul class="navbar-nav">--%>
<%--        <li class="nav-item dropdown">--%>
<%--            <a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#">用户名</a>--%>
<%--            <div class="dropdown-menu">--%>
<%--                <a class="dropdown-item" href="info.jsp">信息</a>--%>
<%--                <a class="dropdown-item" href="signup.jsp">注销</a>--%>
<%--            </div>--%>
<%--        </li>--%>
<%--    </ul>--%>
<%--</nav>--%>

<%
    String Headmsg = null;
    for (Cookie c:cookies){
        if(c.getName().equals("msg")){
            Headmsg = URLDecoder.decode(c.getValue(), "utf-8");
            c.setMaxAge(0);
            response.addCookie(c);
        }
    }
%>
<div style="margin-top:80px; margin-bottom: 20px">
<% if (Headmsg != null) { %>
    <div class="m-auto alert alert-info alert-dismissible fade show" style=" width: 60%;"><button type="button" class="close" data-dismiss="alert">&times;</button>
        <%=Headmsg%>
    </div>
<% } %>
</div>

<main role="main" class="container" style="margin-top:80px">

    <div class="row">
        <div class="col-sm-2">

            <div class="row">
                <div class="col-sm-6">
                    <a href="pk.jsp" class="btn btn-outline-dark btn-lg" role="button">匹配</a>
                </div>
                <div class="col-sm-6">
                    <a href="rank.jsp" class="btn btn-outline-dark btn-lg" role="button">天梯</a>
                </div>
            </div>
            <hr>
            <div class="row">
                <div class="col-sm-6">
                    <a href="index.jsp" class="btn btn-outline-dark btn-lg" role="button">主页</a>
                </div>
                <div class="col-sm-6">
                    <a href="signup.jsp" class="btn btn-outline-dark btn-lg" role="button">注销</a>
                </div>
            </div>
            <hr>
            <div class="row">
                <div class="col-sm-12 m-3 " style="font-size: 20px;">
                    <p>账号：12333</p>
                    <p>用户名：小仙</p>
                    <p>积分：123</p>
                </div>
            </div>
        </div>
        <div class="col-sm-10">





