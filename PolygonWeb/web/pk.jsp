<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@include file="template/header.jsp" %>


<div class="card">

    <div class="card-header">
        大厅
    </div>
    <div class="card-body">
        <div class="row">
            <%
                try {
                    PreparedStatement ps = conn.prepareStatement("SELECT * FROM dbroom WHERE status <> 2");
                    ResultSet rs = ps.executeQuery();
                    while (rs.next()) {

                        int numPeo = 1;
                        ps = conn.prepareStatement("SELECT count(*) FROM dbuser WHERE room = ?");
                        ps.setInt(1, rs.getInt("id"));
                        ResultSet rsNum = ps.executeQuery();
                        rsNum.next();
                        numPeo = rsNum.getInt(1);

                        String hoster = "";
                        ps = conn.prepareStatement("SELECT name FROM dbuser WHERE user = ?");
                        ps.setString(1, rs.getString("user"));
                        ResultSet rsHost = ps.executeQuery();
                        rsHost.next();
                        hoster = rsHost.getString(1);

            %>

            <div class="col-md-3">
                <div class="card mb-4 box-shadow">
                    <h4 class="card-title mx-auto mt-3"><%=rs.getString("psw").compareTo("") > 0 ? "\uD83D\uDD12" : ""%> <%=rs.getInt("id")%>
                        号</h4>
                    <hr>

                    <div class="card-body">
                        <b><%=rs.getString("name")%>
                        </b>
                        <p class="card-text">房主：<%=hoster%> <br> 人数：<%=numPeo%>
                        </p>
                        <span class="badge badge-info"><%=rs.getInt("type") == 0 ? "固定局" : "随机局"%></span>
                        <%=rs.getInt("canBack") == 1 ? "<span class=\"badge badge-info\">可悔步</span>" : ""%>
                        <%=rs.getInt("showAns") == 1 ? "<span class=\"badge badge-info\">最优解</span>" : ""%>

                        <div class="d-flex justify-content-between align-items-center mt-3">
                            <div class="btn-group">
                                <%
                                    if (rs.getString("psw").compareTo("") > 0) {
                                        out.println("<a href=\"joinroom.jsp?id=" + rs.getInt("id") + "\">");
                                    }else {
                                        out.println("<a href=\"Room?ac=join&id=" + rs.getInt("id") + "\">");
                                    }
                                %>

                                <button type="button" class="btn btn-sm btn-outline-secondary">加入</button>
                                </a>
                            </div>
                            <small class="text-muted"><%=rs.getInt("status") == 1 ? "游戏中" : "准备中"%>
                            </small>
                        </div>
                    </div>
                </div>
            </div>
            <%
                    }


                } catch (Exception e) {
                    System.out.println(e.toString());
                }

            %>


        </div>
    </div>

</div>
<%@include file="template/footer.jsp" %>
