<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Page</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f4;
                margin: 0;
                padding: 0;
            }
            .header {
                background-color: #333;
                color: white;
                padding: 10px;
                text-align: center;
            }
            .header a {
                color: white;
                text-decoration: none;
                padding: 10px 20px;
                display: inline-block;
            }
            .header a:hover {
                background-color: #555;
            }
            .container {
                width: 80%;
                margin: 20px auto;
                background-color: white;
                padding: 20px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }
            h1 {
                text-align: center;
                color: #333;
            }
            .content {
                margin-top: 20px;
            }
        </style>
    </head>
    <body>
        <h1>ADMIN PAGE</h1>
        <div class="header">
            <a href="namecustomer.jsp">Tên các khách hàng</a>
            <a href="list.jsp">Các sản phẩm</a>
            <a href="report.jsp">Doanh thu theo tháng</a>
        </div>
    </body>
</html>