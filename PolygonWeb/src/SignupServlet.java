import java.io.IOException;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class SignupServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);// TODO Auto-generated method stub
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            response.getWriter().println("<h1>Sign!</h1>");
            response.getWriter().println(new Date());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
