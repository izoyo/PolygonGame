import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "talkServlet", urlPatterns = {"/Talk"})
public class talkServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    // JDBC 驱动名及数据库 URL
    static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://localhost:3306/polygongame?characterEncoding=utf-8&useSSL=false";

    static final String USER = "root";
    static final String PASS = "youyaang520";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            response.setContentType("text/html;charset=UTF-8");

            String action = request.getParameter("ac");
            String user;

            Class.forName(JDBC_DRIVER);
            Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
            PreparedStatement ps;

            switch (action) {
                case "send":
                    user = request.getParameter("user");
                    String msg = request.getParameter("msg");
                    int roomId = Integer.parseInt(request.getParameter("roomid"));
                    ps = conn.prepareStatement("INSERT INTO dbtalk VALUES (null, ?, ?, ?, ?);");
                    ps.setInt(1, roomId);
                    ps.setString(2, user);
                    ps.setString(3, msg);
                    ps.setLong(4,System.currentTimeMillis()/1000);
                    ps.executeUpdate();
                    break;
                default:
                    break;
            }
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
