<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@include file="template/header.jsp" %>

<script>
    function confirmChange() {
        var msg = "您真的确定要修改吗？\n不修改请取消。";
        if (confirm(msg) == true) {
            return true;
        } else {
            return false;
        }
    }
</script>
<div class="card">

    <div class="card-header">
        公告
    </div>
    <div class="card-body">
        多边形游戏 V1
    </div>
    <hr>

    <div class="container">
        <form action="ChangeName?user=<%=name%>" method="post">

            <div class="input-group my-4">
                <input type="text" class="form-control" name="name" placeholder="自定义昵称" required>
                <div class="input-group-append">
                    <input type="submit" class="btn btn-outline-secondary" onclick="javascript:return confirmChange()"
                           value="修改昵称"></input>
                </div>
            </div>

        </form>
        <hr>
        <table class="table">
            <caption>历史记录</caption>
            <thead>
            <tr>
                <th>时间</th>
                <th>长度</th>
                <th>点</th>
                <th>边</th>
                <th>得分</th>
                <th>耗时</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <%
                try {
                    PreparedStatement ps = conn.prepareStatement("SELECT * FROM dbhistory WHERE user=? AND status<>1 ORDER BY id DESC;");
                    ps.setString(1, name);
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {
                        Long timeStamp = rs.getLong("time") * 1000;  //获取当前时间戳
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); //
                        String sd = sdf.format(new Date(timeStamp));      // 时间戳转换成时间

                        ps = conn.prepareStatement("SELECT * FROM dbmatch WHERE id = ?;");
                        ps.setInt(1, rs.getInt("matchid"));
                        ResultSet rsMatch = ps.executeQuery();
                        rsMatch.next();
            %>
            <tr>
                <td><%=sd%>
                </td>
                <td><%=rsMatch.getInt("length")%>
                </td>
                <td><%=rsMatch.getString("data_number")%>
                </td>
                <td><%=rsMatch.getString("data_border")%>
                </td>
                <td><%=rs.getInt("score")%>
                </td>
                <td><%=rs.getDouble("usetime")%>秒</td>
                <td><a class="btn btn-primary btn-sm" href="game.jsp?isTrain=1&matchid=<%=rs.getInt("matchid")%>">重玩</a></td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
            </tbody>
        </table>
    </div>

</div>
<%@include file="template/footer.jsp" %>
