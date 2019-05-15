import java.io.*;
import java.util.Date;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    // JDBC 驱动名及数据库 URL
    static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://localhost:3306/polygongame?characterEncoding=utf-8&useSSL=false";

    static final String USER = "root";
    static final String PASS = "youyaang520";


    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);// TODO Auto-generated method stub
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();

            String un = request.getParameter("username");
            String up = request.getParameter("password");
            String uname = new String(request.getParameter("name").getBytes("ISO8859-1"), "UTF-8");
            System.out.println("注册:" + un + "," + up + "," + uname);

            Class.forName(JDBC_DRIVER);
            Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);

            String sql = "SELECT id FROM DBuser WHERE user = ? OR name = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, un);
            ps.setString(2, uname);

            ResultSet rs = ps.executeQuery();

            int flag = 0;

            if (!rs.next()) {//用户名冲突
                String sql2 = "INSERT INTO dbuser VALUES(null, ?, ?, ?, 0, ?, 0);";
                ps = conn.prepareStatement(sql2);
                ps.setString(1, un);
                ps.setString(2, up);
                ps.setString(3, uname);
                ps.setLong(4, System.currentTimeMillis() / 1000);

                flag = ps.executeUpdate();
                System.out.println("注册结果:" + flag);
            }
            // 完成后关闭
            rs.close();
            ps.close();
            conn.close();

            if (flag > 0) {
                response.sendRedirect("Login?username=" + un + "&password=" + up);
            } else {
                response.sendRedirect("signup.jsp?err=2");
            }


        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
