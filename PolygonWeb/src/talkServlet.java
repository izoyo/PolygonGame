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
import java.util.*;
import java.text.SimpleDateFormat;

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
            String username;

            Class.forName(JDBC_DRIVER);
            Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
            PreparedStatement ps;

            switch (action) {
                case "send":
                    username = new String(request.getParameter("name").getBytes("ISO8859-1"), "UTF-8");
                    String msg = new String(request.getParameter("msg").getBytes("ISO8859-1"), "UTF-8");
                    int roomId = Integer.parseInt(request.getParameter("roomid"));
                    ps = conn.prepareStatement("INSERT INTO dbtalk VALUES (null, ?, ?, ?, ?);");
                    ps.setInt(1, roomId);
                    ps.setString(2, username);
                    ps.setString(3, msg);
                    ps.setLong(4, System.currentTimeMillis() / 1000);
                    ps.executeUpdate();
                    break;
                case "get":
                    roomId = Integer.parseInt(request.getParameter("roomid"));
                    int minId = Integer.parseInt(request.getParameter("min"));
                    int maxId = Integer.parseInt(request.getParameter("max"));
                    ps = conn.prepareStatement("SELECT * FROM dbtalk WHERE id>? AND id<=? AND roomid=?;");
                    ps.setInt(1, minId);
                    ps.setInt(2, maxId);
                    ps.setInt(3, roomId);
                    ResultSet rsMsg = ps.executeQuery();
                    while (rsMsg.next()) {
                        Long timeStamp = rsMsg.getLong("time")*1000;  //获取当前时间戳
                        SimpleDateFormat sdf=new SimpleDateFormat("HH:mm:ss"); //yyyy-MM-dd
                        String sd = sdf.format(new Date(timeStamp));      // 时间戳转换成时间
                        response.getWriter().print("<p>[" + sd + "]" + rsMsg.getString("name") + " ： " + rsMsg.getString("msg") + "</p>");
                    }
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
