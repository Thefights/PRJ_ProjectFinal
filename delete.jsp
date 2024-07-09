<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Xóa sản phẩm</title>
    </head>
    <body>
        <%
            String proId = request.getParameter("id");
            if (proId != null) {
                Connection conn = null;
                PreparedStatement ps = null;
                try {
                    String jdbcURL = "jdbc:sqlserver://DESKTOP-P79FH3I;databaseName=aa;encrypt=true;trustServerCertificate=true";
                    String jdbcUsername = "sa";
                    String jdbcPassword = "bao1234567890";
                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                    conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
                    String sql = "DELETE FROM Products WHERE pro_id = ?";
                    ps = conn.prepareStatement(sql);
                    ps.setInt(1, Integer.parseInt(proId));
                    ps.executeUpdate();
                    response.sendRedirect("list.jsp");
                } catch (SQLException | ClassNotFoundException e) {
                    e.printStackTrace();
                } finally {
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                }
            } else {
                response.sendRedirect("list.jsp");
            }
        %>
    </body>
</html>
