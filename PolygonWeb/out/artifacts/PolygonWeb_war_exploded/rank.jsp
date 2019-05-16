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

            <%
                try {
                    PreparedStatement ps = conn.prepareStatement("SELECT * FROM dbuser ORDER BY points desc");
                    ResultSet rs = ps.executeQuery();
                    myRank = 1;
                    while (rs.next()) {
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

            <li class="list-group-item">
                <div class="rankitem">
                    <div><h<%=myRank>5?5:myRank%>><span class="badge <%=mybadge%>"><%=myRank%></span> <%=rs.getString("name")%> </<%=myRank>5?5:myRank%>></div>
                    <div class="points"><%=rs.getString("points")%> 分</div>
                </div>
            </li>

            <%
                        myRank++;
                    }


                } catch (Exception e) {
                    System.out.println(e.toString());
                }
            %>

        </ul>
    </div>

</div>
<%@include file="template/footer.jsp" %>
