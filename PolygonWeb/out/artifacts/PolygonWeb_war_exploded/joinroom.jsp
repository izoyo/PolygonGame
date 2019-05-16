<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@include file="template/header.jsp" %>


<div class="card">

    <%
        if( user_room == Integer.parseInt(0+request.getParameter("id"))){
            response.sendRedirect("room.jsp");

        }else if( user_room > 0 ){
            Cookie cookie = new Cookie("msg", URLEncoder.encode("当前已在房间，不能加入别的", "utf-8"));
            cookie.setMaxAge(60);
            response.addCookie(cookie);
            response.sendRedirect("room.jsp");
        }
    %>
    <ul class="breadcrumb">
        <li class="breadcrumb-item"><a href="pk.jsp">大厅</a></li>
        <li class="breadcrumb-item active">输入密码</li>
    </ul>
    <div class="card-body">

        <form action="Room?ac=join&id=<%=request.getParameter("id")%>" method="post">

            <div class="input-group">
                <input type="text" class="form-control" Name="psw" placeholder="请输入密码" required >
                <div class="input-group-append">
                    <button class="btn btn-outline-secondary" type="submit">进入<%=request.getParameter("id")%>号房间</button>
                </div>
            </div>

        </form>

    </div>

</div>
<%@include file="template/footer.jsp" %>