import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public SignupServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);// TODO Auto-generated method stub
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // TODO Auto-generated method stub
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("utf-8");
        request.setCharacterEncoding("utf-8");
        String un = request.getParameter("username");
        String up = request.getParameter("password");



        if("admin".equals (un)&&"123".equals(up))
        {
            Cookie cname=new Cookie("username",un);
            Cookie cpwd=new Cookie("password",up);
            cname.setMaxAge(24*3600);
            cpwd.setMaxAge(24*3600);
            response.addCookie(cname);
            response.addCookie(cpwd);
            HttpSession session=request.getSession();
            session.setAttribute("currentname",un);
            request.setAttribute("currname",un);
            request.getRequestDispatcher("index.jsp").forward(request, response);
//                response.sendRedirect("index.jsp");
           // ---------------------------------------------
//            这个地方的跳转有问题
//---------------------------------------------
        }else{
            response.sendRedirect("http://www.baidu.com");
//
        }
    }

}
