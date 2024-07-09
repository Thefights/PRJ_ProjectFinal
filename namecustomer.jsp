<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Danh Sách Khách Hàng</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f4;
                margin: 0;
                padding: 0;
            }
            .container {
                width: 80%;
                margin: 20px auto;
                background-color: white;
                padding: 20px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                border-radius: 10px;
            }
            h1 {
                text-align: center;
                color: #333;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            th, td {
                padding: 10px;
                border: 1px solid #ddd;
                text-align: left;
            }
            th {
                background-color: #f2f2f2;
            }
            tr:nth-child(even) {
                background-color: #f9f9f9;
            }
            tr:hover {
                background-color: #f1f1f1;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Danh Sách Khách Hàng</h1>

            <%-- SQL Query to fetch customer data --%>
            <sql:setDataSource var="conn" driver="com.microsoft.sqlserver.jdbc.SQLServerDriver" 
                               url="jdbc:sqlserver://QUACH_KHANG_LAP\\KHANG;databaseName=PRJ_ProjectFinal;encrypt=true;trustServerCertificate=true" 
                               user="sa" password="098098" />

            <sql:query var="customers" dataSource="${conn}">
                SELECT * FROM Accounts
            </sql:query>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên Khách Hàng</th>
                        <th>Email</th>
                        <th>Số Điện Thoại</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="customer" items="${customers.rows}">
                        <tr>
                            <td>${customer.acc_id}</td>
                            <td>${customer.name}</td>
                            <td>${customer.email}</td>
                            <td>${customer.phone}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </body>
</html>