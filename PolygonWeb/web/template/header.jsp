<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
    final long serialVersionUID = 1L;
    // JDBC 驱动名及数据库 URL
    final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
    final String DB_URL = "jdbc:mysql://localhost:3306/polygongame?characterEncoding=utf-8&useSSL=false";

    final String USER = "root";
    final String PASS = "youyaang520";

    Cookie[] cookies = request.getCookies();
    String name = null, pwd = null;
    for (Cookie c : cookies) {
        if (c.getName().equals("username")) {
            name = c.getValue();
        }
        if (c.getName().equals("password")) {
            pwd = c.getValue();
        }
    }
    if (name == null || pwd == null) {
        response.sendRedirect("signup.jsp");
    }

    String user_name = name;
    int user_points = 0, user_room = 0;

    Connection conn;

    Class.forName(JDBC_DRIVER);
    conn = DriverManager.getConnection(DB_URL, USER, PASS);
    try {


        String sql = "SELECT * FROM dbuser WHERE user = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, name);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            user_name = rs.getString("name");
            user_points = rs.getInt("points");
            user_room = rs.getInt("room");
        }

        rs.close();
        ps.close();

//        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
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
    <div class="m-auto alert alert-info alert-dismissible fade show" style=" width: 60%;">
        <button type="button" class="close" data-dismiss="alert">&times;</button>
        <%=Headmsg%>
    </div>
    <% } %>
</div>

<main role="main" class="container" style="margin-top:80px">

    <div class="row">
        <div class="col-sm-2">

            <div class="row">
                <div class="col-sm-6">
                    <a href="pk.jsp" class="btn btn-outline-dark btn-lg" role="button">大厅</a>
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
                    <p>账号：<%=name%>
                    </p>
                    <p>用户名：<%=user_name%>
                    </p>
                    <p>积分：<%=user_points%>
                    </p>
                </div>

                <%
                    if (user_room > 0) {
                %>
                <div class="m-auto">
                    <a href="room.jsp" class="btn btn-outline-dark btn-lg" role="button">返回房间</a>
                </div>


                <%
                    try {

                        PreparedStatement ps = conn.prepareStatement("SELECT * FROM dbhistory WHERE user=? AND status=1");
                        ps.setString(1, name);
                        ResultSet rsHistory = ps.executeQuery();

                        // rsHistory | rsMatch
                        if (rsHistory.next()) {

                            ps = conn.prepareStatement("SELECT * FROM dbmatch WHERE id=?");
                            ps.setInt(1, rsHistory.getInt("matchid"));
                            ResultSet rsMatch = ps.executeQuery();
                            rsMatch.next();

                            if ((System.currentTimeMillis() / 1000) < rsHistory.getLong("time") + rsMatch.getInt("timelimit")) {
                %>
                <div class="m-auto">
                    <a href="game.jsp#gameFrame" class="btn btn-outline-dark btn-lg" role="button">继续游戏</a>
                </div>
                <%
                            } else {
                                ps = conn.prepareStatement("UPDATE dbhistory SET status=3 WHERE user=? AND matchid=?");
                                ps.setString(1, name);
                                ps.setInt(2, rsHistory.getInt("matchid"));
                                int flag = ps.executeUpdate();
                                System.out.println("设置超时," + flag + "," + name + "," + rsHistory.getInt("matchid"));
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                } else {
                %>
                <div class="m-auto">
                    <a href="newroom.jsp" class="btn btn-outline-dark btn-lg" role="button">新建房间</a>
                </div>
                <%}%>
            </div>


        </div>
        <div class="col-sm-10">


            <%--
            conn
            name //账号
            user_name //昵称
            user_points //积分
            user_room //所在房间号



            --%>
