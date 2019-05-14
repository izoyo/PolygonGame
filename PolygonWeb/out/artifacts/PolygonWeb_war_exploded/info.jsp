<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="template/header.jsp"%>
<%--<%--%>
<%--    String msg = "你查看了信息";--%>
<%--    Cookie cookie = new Cookie("msg",URLEncoder.encode(msg, "utf-8"));--%>
<%--    cookie.setMaxAge(60*60*24);--%>
<%--    response.addCookie(cookie);--%>
<%--%>--%>

<%

    List<String> words = new ArrayList<String>();
    words.add("today");
    words.add("is");
    words.add("a");
    words.add("great");
    words.add("day");
%>

<table width="200px" align="center" border="1" cellspacing="0">
    <%for (String word : words) {%>
    <tr>
        <td><%=word%></td>
    </tr>
    <%}%>
</table>

<%@include file="template/footer.jsp"%>