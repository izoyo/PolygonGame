<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Polygon</title>
</head>
<body>
<%="Hello!!"%>
<%
    Cookie[] cookies=request.getCookies();
    String name=null, pwd=null;
    for (Cookie c:cookies){
        if(c.getName().equals("username")){
            name = c.getValue();
        }if(c.getName().equals("password")){
            pwd = c.getValue();
        }
    }
    System.out.println(name+" , "+pwd);
    if(name != null && pwd != null){
        out.println("欢迎回来" + name);
    }else{
        response.sendRedirect("signup.jsp");
    }
%>
<input type="button" value="登陆与注册" onclick="window.location.href='signup.jsp'">

</body>
</html>
