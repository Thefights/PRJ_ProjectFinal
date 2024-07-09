<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@include file="adminPage.jsp" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Danh sách sản phẩm</title>
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
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            table, th, td {
                border: 1px solid #ddd;
            }
            th, td {
                padding: 8px;
                text-align: left;
            }
            .actions a {
                margin-right: 10px;
                color: blue;
                text-decoration: none;
            }
            .actions a.delete {
                color: red;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <sql:setDataSource var="conn"
                               driver="com.microsoft.sqlserver.jdbc.SQLServerDriver"
                               url="jdbc:sqlserver://DESKTOP-P79FH3I;databaseName=aa;encrypt=true;trustServerCertificate=true"
                               user="sa"
                               password="bao1234567890" />

            <sql:query var="product" dataSource="${conn}">
                SELECT * FROM Products
            </sql:query>
            <a href="addNew.jsp">Add New</a>
            <table>
                <thead>
                    <tr>
                        <th>Pro_id</th>
                        <th>Pic</th>
                        <th>Name</th>
                        <th>Price</th>
                        <th>Des</th>
                        <th>Cate_id</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="row" items="${product.rows}" varStatus="loop">
                        <tr>
                            <td>${row.pro_id}</td>
                            <td><img src="${row.image_url}" alt="${row.pro_name}" width="50" height="50"></td>
                            <td>${row.pro_name}</td>
                            <td>${row.pro_price}</td>
                            <td>${row.description}</td>
                            <td>${row.cate_id}</td>
                            <td>
                                <div class="actions">
                                    <a href="edit.jsp?id=${row.pro_id}" class="edit">Edit</a>
                                    <a onclick="return confirm('Do you want to delete?');" href="delete.jsp?id=${row.pro_id}">Delete</a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </body>
</html>
