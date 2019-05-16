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
import java.util.*;

@WebServlet(name = "RoomServlet", urlPatterns = {"/Room"})
public class RoomServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    // JDBC 驱动名及数据库 URL
    static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://localhost:3306/polygongame?characterEncoding=utf-8&useSSL=false";

    static final String USER = "root";
    static final String PASS = "youyaang520";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();

            Cookie[] cookies = request.getCookies();
            Cookie cookie;

            String userName = "";
            for (Cookie c : cookies) {
                if (c.getName().equals("username")) {
                    userName = c.getValue();
                    break;
                }
            }

            String action = request.getParameter("ac");

//            String uname = new String(request.getParameter("name").getBytes("ISO8859-1"), "UTF-8");
            System.out.println("Room:" + action + "," + userName);

            Class.forName(JDBC_DRIVER);
            Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
            PreparedStatement ps;

            ps = conn.prepareStatement("SELECT * FROM dbuser WHERE user = ?");
            ps.setString(1, userName);
            ResultSet rsUser = ps.executeQuery();
            rsUser.next();

            // 可用：reUser、conn、ps、userName、
            switch (action) {
                case "new":
                    if( rsUser.getInt("room")>0 ){
                        cookie = new Cookie("msg", URLEncoder.encode("当前已在房间，不能新建", "utf-8"));
                        cookie.setMaxAge(60);
                        response.addCookie(cookie);
                        response.sendRedirect("room.jsp");
                        break;
                    }

                    int roomType = Integer.parseInt(0 + request.getParameter("c"));
                    int timelimit = Integer.parseInt(0 + request.getParameter("timelimit"));
                    if (timelimit <= 0) {
                        timelimit = 300;
                    }
                    String roomname = new String(request.getParameter("roomname").getBytes("ISO8859-1"), "UTF-8");
                    boolean usePsw = false; //使用密码
                    boolean canBack = false; //可以悔步
                    boolean showAns = false; //展示最优解
                    String psw = "";    //房间密码
                    if ("on".equals(request.getParameter("usePsw"))) {
                        usePsw = true;
                        psw = new String(request.getParameter("psw").getBytes("ISO8859-1"), "UTF-8");
                    }
                    if ("on".equals(request.getParameter("canBack"))) {
                        canBack = true;
                    }
                    if ("on".equals(request.getParameter("showAns"))) {
                        showAns = true;
                    }

                    String data_number = "", data_boundary = "";
                    if (roomType == 0) {//固定
                        data_number = request.getParameter("Number");
                        data_boundary = request.getParameter("Boundary");
                    } else {//随机
                        data_number = request.getParameter("rangeMinNum") + "," + request.getParameter("rangeMaxLength");
                        data_boundary = request.getParameter("rangeMinLength") + "," + request.getParameter("rangeMaxLength");
                    }
                    ps = conn.prepareStatement(
                            "INSERT INTO dbroom VALUES (null, ?, ?, 0, ?, ?, ?, ?, ?, ?, ?, ?, 0)"
                    );
                    ps.setString(1, userName);
                    ps.setLong(2, System.currentTimeMillis()/1000);
                    ps.setInt(3, canBack ? 1 : 0);
                    ps.setInt(4, timelimit);
                    ps.setString(5, psw);
                    ps.setInt(6, showAns ? 1 : 0);
                    ps.setInt(7, roomType);
                    ps.setString(8, data_number);
                    ps.setString(9, data_boundary);
                    ps.setString(10, roomname);

                    int flag = ps.executeUpdate();
                    System.out.println("建房：" + flag);

                    ps = conn.prepareStatement("UPDATE dbuser SET room = (SELECT LAST_INSERT_ID()) WHERE user = ?");
                    ps.setString(1, userName);
                    flag = ps.executeUpdate();
                    System.out.println("改房：" + flag);

                    cookie = new Cookie("msg", URLEncoder.encode("创建成功", "utf-8"));
                    cookie.setMaxAge(60);
                    response.addCookie(cookie);
                    response.sendRedirect("room.jsp");
                    break;

                case "join":
                    int roomId = Integer.parseInt(0 + request.getParameter("id"));
                    if(rsUser.getInt("room") == roomId){
                        response.sendRedirect("room.jsp");
                        break;
                    }
                    if(rsUser.getInt("room")>0){
                        cookie = new Cookie("msg", URLEncoder.encode("当前已在房间，不能加入别的", "utf-8"));
                        cookie.setMaxAge(60);
                        response.addCookie(cookie);
                        response.sendRedirect("room.jsp");
                        break;
                    }
                    ps = conn.prepareStatement("SELECT * FROM dbroom WHERE id = ?");
                    ps.setInt(1, roomId);
                    ResultSet reRoom = ps.executeQuery();
                    reRoom.next();

                    //检查密码
                    String roomPsw = reRoom.getString("psw");
                    System.out.println("psw:" + roomPsw + "," + request.getParameter("psw"));
                    if(!roomPsw.equals("")){
                        if(!roomPsw.equals(request.getParameter("psw"))){
                            cookie = new Cookie("msg", URLEncoder.encode("密码错误", "utf-8"));
                            cookie.setMaxAge(60);
                            response.addCookie(cookie);
                            response.sendRedirect("joinroom.jsp?id=" + roomId);
                            break;
                        }
                    }

                    ps = conn.prepareStatement("UPDATE dbuser SET room = ? WHERE user = ?");
                    ps.setInt(1, roomId);
                    ps.setString(2, userName);
                    flag = ps.executeUpdate();
                    System.out.println("进房：" + flag);
                    response.sendRedirect("room.jsp");

                    ps = conn.prepareStatement("INSERT INTO dbtalk VALUES (null, ?, ?, ?, ?);");
                    ps.setInt(1, roomId);
                    ps.setString(2, "<span class=\"text-danger\">系统</span>");
                    ps.setString(3, userName + "进入房间。");
                    ps.setLong(4, System.currentTimeMillis() / 1000);
                    ps.executeUpdate();

                    break;
                case "kick":
                    int kickId = Integer.parseInt(0 + request.getParameter("user"));
                    ps = conn.prepareStatement("UPDATE dbuser SET room = 0 WHERE id = ?");
                    ps.setInt(1, kickId);
                    flag = ps.executeUpdate();
                    System.out.println("踢人：" + flag);
                    response.sendRedirect("room.jsp");
                    break;

                case "exit":
                    roomId = rsUser.getInt("room");

                    ps = conn.prepareStatement("UPDATE dbuser SET room = 0 WHERE user = ?");
                    ps.setString(1, userName);
                    flag = ps.executeUpdate();
                    System.out.println("退房：" + flag);

                    ps = conn.prepareStatement("INSERT INTO dbtalk VALUES (null, ?, ?, ?, ?);");
                    ps.setInt(1, roomId);
                    ps.setString(2, "<span class=\"text-danger\">系统</span>");
                    ps.setString(3, userName + "退出房间。");
                    ps.setLong(4, System.currentTimeMillis() / 1000);
                    ps.executeUpdate();

                    //看看有没有建的房
                    ps = conn.prepareStatement("SELECT * FROM dbroom WHERE id = ? AND user = ? AND status<>2");
                    ps.setInt(1, roomId);
                    ps.setString(2, userName);
                    ResultSet rsRoom = ps.executeQuery();
                    if(rsRoom.next()){
                        //更改房间状态
                        ps = conn.prepareStatement("UPDATE dbroom SET status = 2 WHERE id = ?");
                        ps.setInt(1, roomId);
                        flag = ps.executeUpdate();
                        System.out.println("改房：" + flag);

                        ps = conn.prepareStatement("UPDATE dbuser SET room = 0 WHERE room = ?");
                        ps.setInt(1, roomId);
                        flag = ps.executeUpdate();
                        System.out.println("踢人：" + flag);
                    }

                    response.sendRedirect("pk.jsp");
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
