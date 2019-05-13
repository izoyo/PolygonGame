import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "LoginServlet", urlPatterns = {"/Login"} )
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        response.setContentType("text/html; charset=UTF-8");
//        response.setCharacterEncoding("utf-8");
//        request.setCharacterEncoding("utf-8");

        String un = request.getParameter("username");
        String up = request.getParameter("password");

        System.out.println("Login:" + un + " , " + up);

        if("admin".equals(un) && "123".equals(up))
        {
            Cookie cname=new Cookie("username",un);
            Cookie cpwd=new Cookie("password",up);
            cname.setMaxAge(24*3600);
            cpwd.setMaxAge(24*3600);
            response.addCookie(cname);
            response.addCookie(cpwd);

            response.sendRedirect("index.jsp");

        }else{
            response.sendRedirect("signup.jsp");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
