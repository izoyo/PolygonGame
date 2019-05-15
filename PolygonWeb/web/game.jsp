<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@include file="template/header.jsp" %>
<%
    try {

        PreparedStatement ps = conn.prepareStatement("SELECT * FROM dbroom WHERE id=?");
        ps.setInt(1, user_room);
        ResultSet rsRoom = ps.executeQuery();
        rsRoom.next();

%>

<div class="card" id="gameFrame">
    <ul class="breadcrumb">
        <li class="breadcrumb-item"><a href="pk.jsp">大厅</a></li>
        <li class="breadcrumb-item"><a href="room.jsp"><%=user_room%>号房间</a></li>
        <li class="breadcrumb-item active">游戏中</li>
    </ul>

    <iframe src="game/play.jsp?user=<%=name%>&roomid=<%=user_room%>&matchid=<%=rsRoom.getString("nowMatch")%>&canBack=<%=rsRoom.getString("canBack")%>&showAns=<%=rsRoom.getString("showAns")%>"
            width=100% height=600>
    </iframe>
</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<%@include file="template/footer.jsp" %>
