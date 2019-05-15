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
import java.sql.*;

@WebServlet(name = "GameServlet", urlPatterns = {"/Game"})
public class GameServlet extends HttpServlet {
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

//            System.out.println("Room:" + action);

            Class.forName(JDBC_DRIVER);
            Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
            PreparedStatement ps;

            switch (action) {
                case "star":
                    int roomId = Integer.parseInt(request.getParameter("room"));
                    ps = conn.prepareStatement("SELECT * FROM dbroom WHERE id=?");
                    ps.setInt(1, roomId);
                    ResultSet rsRoom = ps.executeQuery();
                    if (!rsRoom.next())
                        break;

                    // 非准备中
                    if (rsRoom.getInt("status") != 0)
                        break;

                    String[] temp;
                    int length = 0;
                    String data_number, data_boundary;
                    data_number = rsRoom.getString("data_number");
                    data_boundary = rsRoom.getString("data_boundary");

                    if (rsRoom.getInt("type") == 1) {//随机
                        temp = data_boundary.split(",");
                        if (temp.length != 2)
                            break;
                        int a, b;
                        a = Integer.parseInt(temp[0]);
                        b = Integer.parseInt(temp[1]);
                        length = a + (int) (Math.random() * (b - a));
                        data_boundary = "";
                        for (int i = 0; i < length; i++) {
                            String tchar = (Math.random() > 0.5 ? "+" : "*");
                            if (i == 0) {
                                data_boundary = tchar;
                            } else {
                                data_boundary = data_boundary + ',' + tchar;
                            }
                        }

                        temp = data_number.split(",");
                        if (temp.length != 2)
                            break;
                        a = Integer.parseInt(temp[0]);
                        b = Integer.parseInt(temp[1]);
                        data_number = "";
                        for (int i = 0; i < length; i++) {
                            int tnum = a + (int) (Math.random() * (b - a));
                            if (i == 0) {
                                data_number = String.valueOf(tnum);
                            } else {
                                data_number = data_number + ',' + tnum;
                            }
                        }

                    }
                    System.out.println("生成：" + data_boundary + "," + data_number);
                    String[] temp1 = data_boundary.split(",");
                    String[] temp2 = data_number.split(",");
                    if (temp1.length != temp2.length)
                        break;
                    length = temp1.length;
                    if (length < 3)
                        break;

                    ps = conn.prepareStatement("INSERT INTO dbmatch VALUES (null, ?, ?, ?, ?, ?, ?)");
                    ps.setInt(1, roomId);
                    ps.setInt(2, length);
                    ps.setString(3, data_number);
                    ps.setString(4, data_boundary);
                    ps.setLong(5, System.currentTimeMillis() / 1000 + 5);
                    ps.setInt(6, rsRoom.getInt("timeLimit"));
                    int flag = ps.executeUpdate();
                    System.out.println("加赛：" + flag);

                    ps = conn.prepareStatement("SELECT LAST_INSERT_ID();");
                    ResultSet rs = ps.executeQuery();
                    rs.next();
                    int matchId = rs.getInt(1);

                    ps = conn.prepareStatement("UPDATE dbroom SET nowMatch = ? , status = 1 WHERE id = ?");
                    ps.setInt(1, matchId);
                    ps.setInt(2, roomId);
                    flag = ps.executeUpdate();
                    System.out.println("改房：" + flag);

                    ps = conn.prepareStatement("SELECT * FROM dbuser WHERE room = ?");
                    ps.setInt(1, roomId);
                    rs = ps.executeQuery();
                    while (rs.next()) {
                        String tUser = rs.getString("user");
                        ps = conn.prepareStatement("INSERT INTO dbhistory VALUES (null, ?, ?, ?, 0, 1, 0);");
                        ps.setString(1, tUser);
                        ps.setLong(2, System.currentTimeMillis() / 1000 + 5);
                        ps.setInt(3, matchId);
                        ps.executeUpdate();
                        ps.close();
                    }

                    break;
                case "up":
                    int mactchId = Integer.parseInt(request.getParameter("matchid"));
                    String user = request.getParameter("user");
                    Long points = Long.parseLong(request.getParameter("socre"));
                    Double usetime = Double.parseDouble(request.getParameter("usetime"));
                    ps = conn.prepareStatement("UPDATE dbhistory SET score=?,status=2,usetime=? WHERE user=? AND matchid=?");
                    ps.setLong(1, points);
                    ps.setDouble(2, usetime);
                    ps.setString(3, user);
                    ps.setInt(4, mactchId);
                    flag = ps.executeUpdate();
                    System.out.println("战绩：" + flag);
                    break;
                case "getLatest":
                    Long rTime = 0L;
                    int rStatus = 0;
                    user = request.getParameter("user");
                    ps = conn.prepareStatement("SELECT * FROM dbhistory WHERE user = ? AND status = 1");
                    ps.setString(1, user);
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        if (rs.getInt("status") == 1) {
                            rTime = rs.getLong("time");
                        }
                    }

                    roomId = Integer.parseInt(request.getParameter("roomid"));
                    ps = conn.prepareStatement("SELECT * FROM dbroom WHERE id = ?");
                    ps.setInt(1, roomId);
                    rsRoom = ps.executeQuery();
                    if (rsRoom.next()) {
                        rStatus = rsRoom.getInt("status");
                    }

                    int gameEnd = 0;
                    if (rsRoom.getInt("status") == 1) {
                        ps = conn.prepareStatement("SELECT count(*) FROM dbhistory WHERE matchid = ? AND status=1 AND time >= ?;");
                        ps.setInt(1, rsRoom.getInt("nowMatch"));
                        ps.setLong(2, System.currentTimeMillis() / 1000 - rsRoom.getInt("timelimit"));
                        ResultSet rsHnum = ps.executeQuery();
                        rsHnum.next();
                        if (rsHnum.getInt(1) == 0) {
                            gameEnd = 1;
                        }
                    }

                    int msgId = 0;
                    ps = conn.prepareStatement("SELECT MAX(id) FROM dbtalk WHERE roomid=?");
                    ps.setInt(1, roomId);
                    rs = ps.executeQuery();
                    rs.next();
                    msgId = rs.getInt(1);

                    response.getWriter().println("{\"msg\":\"star\",\"starat\":\"" + rTime + "\", \"status\":\"" + rStatus + "\", \"end\":\"" + gameEnd + "\",\"msgid\":\"" + msgId + "\"}");
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
