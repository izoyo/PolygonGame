<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@include file="template/header.jsp" %>
<%
    String chooseRoom = request.getParameter("c");
    int cRoom = 0;
%>
<div class="card">

    <ul class="breadcrumb">
        <li class="breadcrumb-item"><a href="pk.jsp">大厅</a></li>
        <%
            if (chooseRoom == null) {
                cRoom = 0;
            } else {
                cRoom = Integer.parseInt(chooseRoom);
            }

            if (cRoom == 0) {
                out.println("<li class=\"breadcrumb-item active\">新建固定房间</li>");
            } else {
                out.println("<li class=\"breadcrumb-item active\">新建随机房间</li>");

            }
        %>

    </ul>
    <div class="card-body">

        <a href="./newroom.jsp?c=0#roomname" role="button" class="m-3 btn btn-lg btn-primary <%=cRoom==0?"disabled":""%>">固定</a>
        <a href="./newroom.jsp?c=1#roomname" role="button" class="m-3 btn btn-lg btn-primary <%=cRoom==1?"disabled":""%>">随机</a>

        <form class="mx-auto row" action="Room?ac=new&c=<%=cRoom%>" method="post">


            <div class="col-sm-4">
                <input type="text" id="roomname" name="roomname" class="my-2 form-control" placeholder="名称" required autofocus>
            </div>
            <div class="col-sm-5" style="display: flex;">
                <div class="custom-control custom-checkbox m-3">
                    <input type="checkbox" id="SI0" name="usePsw" class="custom-control-input">
                    <label class="custom-control-label" for="SI0">🔒</label>
                </div>
                <input type="text" name="psw" class="my-2 form-control" placeholder="密码">

            </div>
            <div class="col-sm-3">
                <input type="text" name="timelimit" class="my-2 form-control" placeholder="时间限制(S 不填300)">
            </div>



            <%
                if(cRoom == 0){
            %>
            <div class="col-sm-6">
                各边：<input type="text" name="Boundary" class="my-2 form-control" placeholder="各边(+,*,+,+)" required>
            </div>
            <div class="col-sm-6">
                各点：<input type="text" name="Number" class="my-2 form-control" placeholder="各点(1,2,3,4)" required>
            </div>

            <%
                }else{
            %>
            <div class="col-sm-6">
                最小边数：<input type="text" name="rangeMinLength" class="my-2 form-control" placeholder="最小边长" required>
            </div>
            <div class="col-sm-6">
                最大边数：<input type="text" name="rangeMaxLength" class="my-2 form-control" placeholder="最大边长" required>
            </div>
            <div class="col-sm-6">
                最小节点：<input type="text" name="rangeMinNum" class="my-2 form-control" placeholder="最小节点" required>
            </div>
            <div class="col-sm-6">
                最大节点：<input type="text" name="rangeMaxNum" class="my-2 form-control" placeholder="最大节点" required>
            </div>

            <%
                }
            %>
            <div class="col-sm-3">
                <div class="custom-control custom-checkbox m-3">
                    <input type="checkbox" id="SI1" name="canBack" class="custom-control-input">
                    <label class="custom-control-label" for="SI1">可以悔步</label>
                </div>
            </div>
            <div class="col-sm-3">
                <div class="custom-control custom-checkbox m-3">
                    <input type="checkbox" id="SI2" name="showAns" class="custom-control-input">
                    <label class="custom-control-label" for="SI2">训练模式</label>
                </div>
            </div>
            <button class="m-3 btn btn-lg btn-primary btn-block" type="submit">新建</button>

        </form>
    </div>

</div>

<%@include file="template/footer.jsp" %>
