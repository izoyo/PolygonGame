<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%--
//autoStar 自动开始

showAns 展示答案
canBack 可悔步
match 比赛ID
--%>
<%
    final long serialVersionUID = 1L;
    // JDBC 驱动名及数据库 URL
    final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
    final String DB_URL = "jdbc:mysql://localhost:3306/polygongame?characterEncoding=utf-8&useSSL=false";

    final String USER = "root";
    final String PASS = "youyaang520";
    Connection conn;

//    System.out.println(request.getParameter("canBack") + "," + request.getParameter("showAns"));
    String canBackstr = request.getParameter("canBack");
    String showAnsstr = request.getParameter("showAns");
    String user = request.getParameter("user");
    int roomId = Integer.parseInt(request.getParameter("roomid"));
    int matchId = Integer.parseInt(request.getParameter("matchid"));

    boolean isTrain = false;
    if(request.getParameter("isTrain")!=null){
        isTrain = true;
        canBackstr = "1";
        showAnsstr = "1";
    }


    ResultSet rsMatch;
    try {
        Class.forName(JDBC_DRIVER);
        conn = DriverManager.getConnection(DB_URL, USER, PASS);

        PreparedStatement ps = conn.prepareStatement("SELECT * FROM dbmatch WHERE id = ?");
        ps.setInt(1, matchId);
        rsMatch = ps.executeQuery();
        rsMatch.next();

        String dataBoundary = rsMatch.getString("data_border");
        String[] temp = dataBoundary.split(",");
        for (int i = 0; i < temp.length; i++) {
            if(i==0){
                dataBoundary = "\"" + temp[0] + "\"";
            }else{
                dataBoundary = dataBoundary + ",\"" + temp[i] + "\"";
            }
        }

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Polygon Game</title>
    <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/4.1.0/css/bootstrap.min.css">
    <script src="https://cdn.bootcss.com/jquery/3.3.1/jquery.min.js"></script>
    <script src="https://cdn.bootcss.com/popper.js/1.12.5/umd/popper.min.js"></script>
    <script src="https://cdn.bootcss.com/bootstrap/4.1.0/js/bootstrap.min.js"></script>
</head>

<body>
<div id="tipEnd" style="display: none;">
    <p>游戏结束！</p>
    得分：<span id="tipScore"></span>， 耗时<span id="useTime"></span>秒
</div>
<div id="playBoard">
    <button type="button" class="btn btn-primary" onclick="start(data_Length, data_Num, data_Bor, data_Show, data_Back)" <%=(showAnsstr.equals("0") ? "hidden" : "")%>>重新开始</button>

    <div id="parttwo" style="display: none">
        <!-- 玩家画布 -->
        <canvas id="demo-canvas2" width="600" height="500"></canvas>
        <!-- 按钮：显示最佳操作，会清空玩家的画布 -->
        <button  type="button" class="fa fa-play-circle fa-3x btn btn-primary" aria-hidden="true" id="showBestButton"
                onclick="showBest()" <%=(showAnsstr.equals("0") ? "hidden" : "")%>>
            展示最佳
        </button>


        <!-- 悔步按钮 -->
        <button  type="button" class="btn btn-primary" id="goBackButton"
                onclick="history_back()" <%=(canBackstr.equals("0") ? "hidden" : "")%>>
            退一步
        </button>

    </div>

    <!-- 显示最佳操作的div -->
    <div id="showBest" style="display: none">
        <canvas id="demo-canvas3" width="600" height="500"></canvas>
    </div>
    <!-- 测试按钮：用于测试是否已经结束，结果显示在console -->
    <button id="isEnd" onclick="isEnd()" hidden>isEnd</button>
    <!-- 测试按钮：用于测试获取最终结果，结果显示在console -->
    <button id="getScore" onclick="getScore()" hidden>getScore</button>
    <!-- 测试按钮：用于测试获取最佳操作的得分，结果显示在console -->
    <button id="getBestScore" onclick="getBestScore()" hidden>getBestScore</button>
</div>


<script src="js/index.js"></script>
<script type="text/javascript" src="js/draw.js"></script>
<script src="js/algorithm.js"></script>
<script src="js/check.js"></script>

<script type="text/javascript">

    isTrain = <%=isTrain%>;

    matchId = <%=matchId%>;
    user = "<%=user%>";
    starTime = <%=rsMatch.getLong("time")%>;
    timeLimit = <%=rsMatch.getLong("timelimit")%>;
    data_Num = [0, <%=rsMatch.getString("data_number")%>];
    data_Bor = ["+", <%=dataBoundary%>];
    data_Length = <%=rsMatch.getInt("length")%>;
    data_Show = <%=(showAnsstr.equals("0") ? "false" : "true")%>;
    data_Back = <%=(canBackstr.equals("0") ? "false" : "true")%>;
    // console.log(data_Length, data_Num, data_Bor, data_Show, data_Back);
    gameCheaker();

    start(data_Length, data_Num, data_Bor, data_Show, data_Back);
    intCheck = self.setInterval("gameCheaker()", 1000);
</script>
</body>
</html>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>