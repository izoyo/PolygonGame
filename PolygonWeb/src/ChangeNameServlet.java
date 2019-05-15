import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "ChangeNameServlet", urlPatterns = {"/ChangeName"})
public class ChangeNameServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    // JDBC 驱动名及数据库 URL
    static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://localhost:3306/polygongame?characterEncoding=utf-8&useSSL=false";

    static final String USER = "root";
    static final String PASS = "youyaang520";
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try{
            Class.forName(JDBC_DRIVER);
            Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
            String vname = new String(request.getParameter("name").getBytes("ISO8859-1"), "UTF-8");
            String vuser = request.getParameter("user");
            int flag;

            PreparedStatement ps = conn.prepareStatement("SELECT * FROM dbuser WHERE name = ?;");
            ps.setString(1, vname);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                flag = 0;
            }else {
                ps = conn.prepareStatement("UPDATE dbuser SET NAME = ? WHERE user = ?;");
                ps.setString(1, vname);
                ps.setString(2, vuser);
                flag = ps.executeUpdate();
            }

            String msg;
            if (flag > 0){
                msg = "修改成功";
            }else{
                msg = "修改失败";
            }
            Cookie cookie = new Cookie("msg", URLEncoder.encode(msg, "utf-8"));
            cookie.setMaxAge(60);
            response.addCookie(cookie);
            response.sendRedirect("index.jsp");
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
