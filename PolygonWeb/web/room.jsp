<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@include file="template/header.jsp" %>

<%

    try {

        if (user_room <= 0) {
            response.sendRedirect("pk.jsp");
        }

        String hostUser = ""; // 房主账号
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM dbroom WHERE id = ?;");
        ps.setInt(1, user_room);
        ResultSet rsRoom = ps.executeQuery();
        if (rsRoom.next()) {
            hostUser = rsRoom.getString("user");
        }

        int hostPoint = 0;
        String hostName = ""; // 房主昵称
        ps = conn.prepareStatement("SELECT * FROM dbuser WHERE user = ?;");
        ps.setString(1, hostUser);
        ResultSet rsHost = ps.executeQuery();
        if (rsHost.next()) {
            hostPoint = rsHost.getInt("points");
            hostName = rsHost.getString("name");
        }

%>
<script>
    var xmlhttp;
    var xmlhttpMsg;
    var starAtTime; // 游戏开始时间
    var roomStatus; // 房间状态 0 准备中 1 游戏中 2 被删除

    if (window.XMLHttpRequest) {
        xmlhttp = new XMLHttpRequest();//  IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
        xmlhttpMsg = new XMLHttpRequest();//  IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
    } else {
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");// IE6, IE5 浏览器执行代码
        xmlhttpMsg = new ActiveXObject("Microsoft.XMLHTTP");// IE6, IE5 浏览器执行代码
    }

    function sendMsg() {
        var msg = document.getElementById("msgInput").value;
        if(msg == "")
            return;
        xmlhttpMsg.open("POST", "Talk", true);
        xmlhttpMsg.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlhttpMsg.send("ac=send&roomid=<%=user_room%>&user=<%=name%>&msg=" + msg);
        console.log("send", msg);
        document.getElementById("msgInput").value = "";
    }
    function starGame(rid) {
        xmlhttp.open("POST", "Game", true);
        xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlhttp.send("ac=star&room=" + rid);
        console.log("开始游戏");
    }

    function heartBeat() {
        if (starAtTime != null && starAtTime > 0) {
            var d = new Date();
            var lestTime = parseInt(starAtTime - d.getTime() / 1000);
            if (lestTime <= 0) {
                document.getElementById("starTip").style.display = "block";
                document.getElementById("countdownTip").style.display = "none";
                window.location.href = 'game.jsp#gameFrame';
            } else {
                document.getElementById("countdownTip").style.display = "block";
                document.getElementById("countdownNum").innerText = lestTime;
            }
        }
        switch (roomStatus) {
            case 0:
                var b = document.getElementById("nohostStarButton");
                if (b != null) {
                    b.innerText = "准备中";
                }
                break;
            case 1:
                var b = document.getElementById("nohostStarButton");
                if (b != null) {
                    b.innerText = "游戏中";
                }
                break;
            case 2:
                document.getElementById("offTip").style.display = "block";
                break;
            default:
                break;
        }

        xmlhttp.open("POST", "Game", true);
        xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200 && xmlhttp.responseText != "") {
                json = JSON.parse(xmlhttp.responseText);
                if (starAtTime != parseInt(json.starat)) {
                    starAtTime = parseInt(json.starat);
                    console.log("star", starAtTime);
                }
                var oldStatus = roomStatus;
                if (roomStatus != parseInt(json.status)) {
                    roomStatus = parseInt(json.status);
                    console.log("room", roomStatus);
                    if(roomStatus == 0 && oldStatus == 1){
                        location.reload();
                    }
                }
                if (parseInt(json.end)==1 && document.getElementById("hostStarButton") != null) {
                    location.reload();
                }
            }
        }
        xmlhttp.send("ac=getLatest&user=<%=name%>&roomid=<%=user_room%>");

    }

    intHB = self.setInterval("heartBeat()", 1000);

</script>

<div class="card">
    <div class="alert alert-danger" id="offTip" style="display: none;">
        <strong>本房间已被删除!</strong> 请退出。
    </div>
    <div class="alert alert-info" id="countdownTip" style="display: none;">
        <strong>游戏即将开始!</strong> 倒计时：<span id="countdownNum">4</span>S
    </div>
    <div class="alert alert-info" id="starTip" style="display: none;">
        <strong>游戏已经开始啦!</strong> 马上跳转
    </div>

    <ul class="breadcrumb">
        <li class="breadcrumb-item"><a href="pk.jsp">大厅</a></li>
        <li class="breadcrumb-item active"><%=user_room%>号房间</li>
    </ul>

    <div class="card-body row">


        <div class="col-sm-5" style="border-right-style: solid; border-bottom-style: solid; border-color: gray;">
            <%
                //rsRoom | rsHost
                int roomStatus = rsRoom.getInt("status");
                if (hostUser.equals(name)) {

                    if (rsRoom.getInt("status") == 1) {
                        //结算
                        ps = conn.prepareStatement("SELECT count(*) FROM dbhistory WHERE matchid = ? AND status=1 AND time >= ?;");
                        ps.setInt(1, rsRoom.getInt("nowMatch"));
                        ps.setLong(2, System.currentTimeMillis() / 1000 - rsRoom.getInt("timelimit"));
                        ResultSet rsHnum = ps.executeQuery();
                        rsHnum.next();
                        if (rsHnum.getInt(1) == 0) {
                            roomStatus = 0;
                            System.out.println("清算," + user_room);
                            // 修改玩家超时
                            ps = conn.prepareStatement("UPDATE dbhistory SET status=3 WHERE matchid = ? AND status=1");
                            ps.setInt(1, rsRoom.getInt("nowMatch"));
                            ps.executeUpdate();


                            ps = conn.prepareStatement("SELECT count(*) FROM dbhistory WHERE matchid = ?;");
                            ps.setInt(1, rsRoom.getInt("nowMatch"));
                            ResultSet sNum = ps.executeQuery();
                            sNum.next();
                            int peoNum = sNum.getInt(1);
                            System.out.println("比赛人数：" + peoNum);
                            String content = "<p>参加人数：" + peoNum + "</p>";

                            int[] reword = {0, 0, 0};
                            if (peoNum > 5) {
                                reword[0] = 3;
                                reword[1] = 2;
                                reword[2] = 1;
                            } else if (peoNum > 3) {
                                reword[0] = 2;
                                reword[1] = 1;
                            } else if (peoNum > 1) {
                                reword[0] = 1;
                            }

                            ps = conn.prepareStatement("SELECT * FROM dbhistory WHERE matchid = ? AND status=2 ORDER BY score desc;");
                            ps.setInt(1, rsRoom.getInt("nowMatch"));
                            ResultSet sPeo = ps.executeQuery();
                            int i;
                            for (i = 0; sPeo.next() && i < 3; i++) {
                                // 加分
                                ps = conn.prepareStatement("UPDATE dbuser SET points =  points+? WHERE user = ?");
                                ps.setInt(1, reword[i]);
                                ps.setString(2, sPeo.getString("user"));
                                ps.executeUpdate();
                                System.out.println("奖励:" + reword[i] + "," + sPeo.getString("user"));
                                content = content + "<p>第" + (i + 1) + "名：" + sPeo.getString("user") + "（" + sPeo.getLong("score") + "） +" + reword[i] + "</p>";
                            }
                            content = content + "<p>有效成绩：" + i + "</p>";

                            // 修改房间准备
                            System.out.println(content);
                            ps = conn.prepareStatement("INSERT INTO dbroomhistory VALUES (null, ?, ?, ?);");
                            ps.setInt(1, user_room);
                            ps.setInt(2, rsRoom.getInt("nowMatch"));
                            ps.setString(3, content);
                            ps.executeUpdate();

                            ps = conn.prepareStatement("UPDATE dbroom SET status=0,nowMatch=0 WHERE id=?");
                            ps.setInt(1, user_room);
                            ps.executeUpdate();
                        }

                    }
                    out.print("<button onclick=\"starGame(" + user_room + ")\" type=\"button\" class=\"btn btn-primary\" id=\"hostStarButton\" " + (roomStatus == 0 ? "" : "disabled") + ">" + (roomStatus == 0 ? "开始游戏" : "游戏中") + "</button>");

                } else {
                    //不是房主
                    out.print("<button type=\"button\" class=\"btn btn-primary\" disabled id=\"nohostStarButton\">" + (roomStatus == 0 ? "准备中" : "游戏中") + "</button>");
                }
            %>

            <ul class="list-group mt-3">


                <li class="list-group-item"><span class="badge badge-primary">房主</span> <span
                        class="badge badge-info"><%=hostPoint%></span> <%=hostName%>
                </li>

                <%
                    ps = conn.prepareStatement("SELECT * FROM dbuser WHERE user <> ? AND room = ?;");
                    ps.setString(1, hostUser);
                    ps.setInt(2, user_room);
                    ResultSet rsJoinPeo = ps.executeQuery();
                    while (rsJoinPeo.next()) {
                %>
                <li class="list-group-item">
                    <%
                        if (hostUser.equals(name)) {
                    %>
                    <a href="Room?ac=kick&user=<%=rsJoinPeo.getInt("id")%>">❌</a>
                    <%
                        }
                    %>

                    <span class="badge badge-info"><%=rsJoinPeo.getInt("points")%></span> <%=rsJoinPeo.getString("name")%>
                </li>
                <%
                    }
                %>
            </ul>


        </div>

        <div class="col-sm-4" style="border-right-style: solid; border-bottom-style: solid; border-color: gray;">

            <%
                if (hostUser.equals(name)) {
            %>
            <a href="Room?ac=exit" role="button" class="btn btn-danger">删除房间</a>

            <%
            } else {
            %>
            <a href="Room?ac=exit" role="button" class="btn btn-danger">退出房间</a>
            <%
                }
            %>
            <ul class="list-group mt-3">
                <li class="list-group-item">房间名：<%=rsRoom.getString("name")%>
                </li>
                <li class="list-group-item">
                    <%=rsRoom.getInt("type") == 0 ? "[固定局]" : "[随机局]"%>
                    <%=rsRoom.getInt("canBack") == 1 ? " [可以悔步] " : ""%>
                    <%=rsRoom.getInt("showAns") == 1 ? " [训练模式] " : ""%>
                    [<%=rsRoom.getString("timeLimit")%>S]
                </li>
                <li class="list-group-item">边：<%=rsRoom.getString("data_boundary")%>
                </li>
                <li class="list-group-item">数：<%=rsRoom.getString("data_number")%>
                </li>
            </ul>

        </div>
        <div class="col-sm-3" style="border-bottom-style: solid; border-color: gray;">
            <h3>上一把</h3>
            <%
                ps = conn.prepareStatement("SELECT * FROM dbroomhistory WHERE roomid=? order by id desc ");
                ps.setInt(1, user_room);
                ResultSet rRH = ps.executeQuery();
                if (rRH.next()) {
                    out.print(rRH.getString("content"));
                }
            %>
        </div>

        <div class="col-sm-12 p-2" style="height:300px;overflow:auto;">
            聊天记录
        </div>

        <div class="input-group m-3">
            <input type="text" class="form-control" Name="msg" placeholder="" id="msgInput" required>
            <div class="input-group-append">
                <button class="btn btn-outline-secondary" type="button" onclick="sendMsg()">发送</button>
            </div>
        </div>

    </div>

</div>
<%

    } catch (Exception e) {
        System.out.println(e.toString());
    }
%>
<%@include file="template/footer.jsp" %>
