import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.net.*;

@WebServlet(name = "LoginServlet", urlPatterns = {"/Login"})
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    // JDBC 驱动名及数据库 URL
    static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://localhost:3306/polygongame?characterEncoding=utf-8&useSSL=false";

    static final String USER = "root";
    static final String PASS = "youyaang520";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        response.setContentType("text/html; charset=UTF-8");
//        response.setCharacterEncoding("utf-8");
//        request.setCharacterEncoding("utf-8");

        try {
            response.setContentType("text/html;charset=UTF-8");

            String un = request.getParameter("username");
            String up = request.getParameter("password");

            System.out.println("Login:" + un + " , " + up);

            Class.forName(JDBC_DRIVER);
            Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);

            System.out.println("coon:"+conn);

            String sql = "SELECT id FROM dbuser WHERE user = ? AND psw = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, un);
            ps.setString(2, up);

            ResultSet rs = ps.executeQuery();

            String msg;
            if (rs.next()) {
                int id = rs.getInt("id");
                // 完成后关闭
                rs.close();
                ps.close();
                conn.close();


                Cookie cname = new Cookie("username", un);
                Cookie cpwd = new Cookie("password", up);
                cname.setMaxAge(24 * 3600);
                cpwd.setMaxAge(24 * 3600);
                response.addCookie(cname);
                response.addCookie(cpwd);

                msg = "登陆成功！";
                System.out.println(un + msg);
                Cookie cookie = new Cookie("msg", URLEncoder.encode(msg, "utf-8"));
                cookie.setMaxAge(60 * 60 * 24);
                response.addCookie(cookie);
                response.sendRedirect("index.jsp");

            } else {
                rs.close();
                ps.close();
                conn.close();
                System.out.println(un + "登陆失败！");
                response.sendRedirect("signup.jsp?err=1");
            }


        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
