<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Date"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@include file="adminPage.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Monthly Sales Report</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f4;
                margin: 20px;
            }

            h2, h3 {
                text-align: center;
                color: #333;
            }

            form {
                text-align: center;
                margin-bottom: 20px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                background-color: white;
            }

            table, th, td {
                border: 1px solid #ddd;
            }

            th, td {
                padding: 12px;
                text-align: center;
            }

            th {
                background-color: #333;
                color: white;
            }

            tbody tr:nth-child(odd) {
                background-color: #f9f9f9;
            }

            tbody tr:hover {
                background-color: #f1f1f1;
            }

            .total {
                text-align: right;
                margin-top: 20px;
            }

            .alert {
                padding: 10px;
                background-color: #f44336;
                color: white;
                border-radius: 5px;
                margin-bottom: 10px;
            }
        </style>
    </head>
    <body>
        <h2>Monthly Sales Report</h2>
        <form action="report.jsp" method="GET">
            Select month: 
            <select name="month">
                <option value="1">January</option>
                <option value="2">February</option>
                <option value="3">March</option>
                <option value="4">April</option>
                <option value="5">May</option>
                <option value="6">June</option>
                <option value="7">July</option>
                <option value="8">August</option>
                <option value="9">September</option>
                <option value="10">October</option>
                <option value="11">November</option>
                <option value="12">December</option>
            </select>
            <button type="submit">Show Sales</button>
        </form>
        <hr>
        <%-- Process form submission --%>
        <%
            String monthParam = request.getParameter("month");
            if (monthParam != null) {
                int selectedMonth = Integer.parseInt(monthParam);
                String startDate = "2024-" + selectedMonth + "-01";
                String endDate = "2024-" + selectedMonth + "-31";

                // Connect to database
                String url = "jdbc:sqlserver://DESKTOP-P79FH3I;databaseName=aa;encrypt=true;trustServerCertificate=true";
                String user = "sa";
                String password = "bao1234567890";

                try {
                    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                    Connection conn = DriverManager.getConnection(url, user, password);

                    // Query to get orders within selected month
                    String query = "SELECT * FROM Orders WHERE [date] BETWEEN ? AND ?";
                    PreparedStatement pstmt = conn.prepareStatement(query);
                    pstmt.setString(1, startDate);
                    pstmt.setString(2, endDate);

                    ResultSet rs = pstmt.executeQuery();

                    // Initialize total variables
                    double totalSales = 0;
                    int totalQuantity = 0;

                    if (!rs.isBeforeFirst()) {
        %>
        <div class="alert">No sales data available for the selected month.</div>
        <%
                    } else {
        %>
        <h3>Products Sold in <%= selectedMonth %> - Detailed Sales Report</h3>
        <table>
            <thead>
                <tr>
                    <th>Order ID</th>
                    <th>Date</th>
                    <th>Product ID</th>
                    <th>Product Name</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Total Price</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // Process each order
                    while (rs.next()) {
                        int orderId = rs.getInt("order_id");
                        Date orderDate = rs.getDate("date");
                        int productId = rs.getInt("pro_id");
                        int quantity = rs.getInt("quantity");
                        double totalPrice = rs.getDouble("total_price");

                        totalQuantity += quantity;
                        totalSales += totalPrice;

                        // Query product details
                        String productQuery = "SELECT pro_name, pro_price FROM Products WHERE pro_id = ?";
                        PreparedStatement productStmt = conn.prepareStatement(productQuery);
                        productStmt.setInt(1, productId);
                        ResultSet productRs = productStmt.executeQuery();

                        if (productRs.next()) {
                            String productName = productRs.getString("pro_name");
                            double productPrice = productRs.getDouble("pro_price");

                %>
                <tr>
                    <td><%= orderId %></td>
                    <td><%= orderDate %></td>
                    <td><%= productId %></td>
                    <td><%= productName %></td>
                    <td><%= productPrice %></td>
                    <td><%= quantity %></td>
                    <td><%= totalPrice %></td>
                </tr>
                <%
                        }

                        productRs.close();
                        productStmt.close();
                    }
                %>
            </tbody>
        </table>
        <p>Total Quantity Sold: <%= totalQuantity %></p>
        <p>Total Revenue: <%= totalSales %>Ð</p>
        <%
                    }

                    rs.close();
                    pstmt.close();
                    conn.close();

                } catch (SQLException | ClassNotFoundException ex) {
                    ex.printStackTrace();
                }
            }
        %>
    </body>
</html>
