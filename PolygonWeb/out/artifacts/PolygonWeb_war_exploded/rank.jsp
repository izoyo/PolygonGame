<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@include file="template/header.jsp" %>

<link href="src/rank.css" rel="stylesheet">

<%
    int myRank = 0;

    try {
        PreparedStatement ps = conn.prepareStatement("SELECT count(*) FROM dbuser WHERE points > ?");
        ps.setInt(1, user_points);

        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            myRank = rs.getInt(1) + 1;
        }


    } catch (Exception e) {
        System.out.println(e.toString());
    }

    String mybadge = "badge-secondary";
    switch (myRank) {
        case 1:
            mybadge = "badge-warning";
            break;
        case 2:
            mybadge = "badge-primary";
            break;
        case 3:
            mybadge = "badge-info";
            break;
        case 4:
            mybadge = "badge-success";
            break;
        default:
            mybadge = "badge-secondary";
            break;
    }

%>

<div class="card">

    <div class="card-header">
        天梯 / 排行榜
    </div>
    <div class="card-body">
        你的排名：<span class="badge <%=mybadge%>"><%=myRank%></span>
        <ul class="list-group mt-3">
            <li class="list-group-item">
                <div class="rankitem">
                    <div><h1><span class="badge badge-warning">1</span> 小仙 </h1></div>
                    <div class="points">1000分</div>
                </div>
            </li>
            <li class="list-group-item">
                <div class="rankitem">
                    <div><h2><span class="badge badge-primary">2</span> 撒旦法 </h2></div>
                    <div class="points">1000分</div>
                </div>
            </li>
            <li class="list-group-item">
                <div class="rankitem">
                    <div><h3><span class="badge badge-info">3</span> 王企鹅 </h3></div>
                    <div class="points">1000分</div>
                </div>
            </li>
            <li class="list-group-item">
                <div class="rankitem">
                    <div><h4><span class="badge badge-success">4</span> 热羊肉汤 </h4></div>
                    <div class="points">1000分</div>
                </div>
            </li>
            <li class="list-group-item">
                <div class="rankitem">
                    <div><h5><span class="badge badge-secondary">5</span> 风格和风格 </h5></div>
                    <div class="points">1000分</div>
                </div>
            </li>

        </ul>
    </div>

</div>
<%@include file="template/footer.jsp" %>
