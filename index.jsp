<%@page import="Models.Account"%>
<%@page import="DAOs.AccountDAO"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Diep Gia Coffee</title>
        <%
            String username = (String) session.getAttribute("userLogin");
            if (username == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>
        <style>
            body {
                background-color: #ffffff; /* Light blue background color */
                margin: 0; /* Remove default margin */
                font-family: Arial, sans-serif; /* Specify a default font family */
            }

            .header {
                width: 100%;
                position: fixed;
                top: 0;
                left: 0;
                background-color: white;
                z-index: 1000;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            .full-width-image {
                padding-top: 20px;
                max-width: 100%;
            }
            .header-icons .user a:hover {
                color: #ff9966; /* Màu chữ khi hover */
            }
            .header-nav {
                display: flex;
                align-items: center;
                justify-content: space-around;
                padding: 10px 20px;
            }
            .header-nav .logo img {
                height: 100px;
            }
            .header-icons {
                display: flex;
                align-items: center;
            }
            .header-icons .user {
                position: relative;
                margin-right: 20px;
                padding-left: 40px;
            }
            .header-icons .user img {
                height: 30px;
                cursor: pointer;
            }
            .user-tabs {
                display: none;
                position: absolute;
                top: 30px;
                right: 0;
                background: white;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                padding: 10px;
            }
            .user-tabs a {
                display: block;
                width: 120px;
                padding: 5px 10px;
                text-decoration: none;
                color: black;
                font-family: Arial, sans-serif;
            }
            .header-icons .user:hover .user-tabs {
                display: block;
            }
            .header-icons button {
                background: none;
                border: none;
                cursor: pointer;
            }
            .header-icons button img {
                height: 30px;
            }
            .category {
                display: flex;
                justify-content: center;
                background-color: #f8f8f8;
                padding: 10px 0;
            }
            .category button {
                background: none;
                border: none;
                font-size: 16px;
                margin: 0 10px;
                cursor: pointer;
            }
            .header-icons a {
                text-decoration: none;
                color: black;
                display: flex;
                align-items: center;
                margin-left: 20px;
            }
            .header-icons a img {
                height: 30px;
                margin-right: 5px;
            }

            /* Wrapper for the entire content */
            #wrapper {
                width: 80%;
                margin: 0 auto;
                min-height: 100vh; /* Ensure full viewport height */
                display: flex;
                flex-direction: column; /* Stack children vertically */
            }

            /* Full-width image styling */
            .full-width-image {
                width: 100%;
                max-width: 100%;
                height: auto;
                margin-top: 180px; /* Add margin to push content below fixed header */
            }

            /* Navigation bar styling */
            nav {
                display: flex;
                justify-content: center; /* Center content horizontally */
                gap: 20px; /* Space between items */
                background-color: #ff9966; /* Optional: add background color */
                padding: 10px 0; /* Optional: add padding for spacing */
                width: 100%; /* Full width */
            }

            nav a {
                color: #333; /* Link text color */
                text-decoration: none; /* Remove underline */
                font-weight: bold; /* Make text bold */
                padding: 10px; /* Add padding for spacing */
                transition: color 0.3s; /* Smooth hover effect */
            }

            nav a:hover {
                color: #ff9966; /* Change text color on hover */
            }

            /* Menu title styling */
            .title {
                text-align: center; /* Center-align the title */
                margin: 20px 0; /* Add margin above and below */
            }

            /* Wrapper for the entire content */
            .products-container {
                display: grid;
                grid-template-columns: repeat(4, 1fr); /* 4 columns */
                gap: 20px; /* Space between items */
                padding: 20px; /* Space around grid */
            }

            .product {
                display: flex;
                flex-direction: column;
                align-items: center;
                background-color: #f9f9f9; /* Background color for product */
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 10px;
                transition: transform 0.3s; /* Smooth hover effect */
            }

            .product:hover {
                transform: scale(1.05); /* Slight zoom effect on hover */
            }

            .product img {
                width: 100%;
                height: auto;
                margin: auto; /* Center the image */
            }

            .product .name {
                font-weight: bold;
                margin-top: 5px;
                text-align: center;
            }

            .product .price {
                color: #f57224; /* Price color */
                font-size: 16px;
                text-align: center;
            }

            .product a {
                padding: 10px; /* Button padding */
                width: 50%;
                background-color: #333; /* Button background color */
                color: #ffffff; /* Button text color */
                text-decoration: none; /* Remove underline */
                border-radius: 10px; /* Rounded corners */
                transition: background-color 0.3s; /* Smooth hover effect */
                text-align: center; /* Center-align the button */
            }
        </style>
        <%
            AccountDAO dao = new AccountDAO();
            Account acc = dao.getAccountByUser((String) session.getAttribute("userLogin"));
        %>
    </head>
    <body>
        <div class="header">
            <div class="header-nav">
                <a href="index.jsp" class="logo">
                    <img src="images/logo_1.png" alt="Logo">
                </a>
                <div class="header-icons">
                    <div class="user">

                        <p><img src="images/user.png" alt="Người dùng"><%= acc.getName()%></p>
                    </div>
                    <div>
                    </div>
                    <div>
                        <a href="cart.jsp">
                            <img src="images/shopping-cart.png" alt="Giỏ hàng"/>
                            Giỏ hàng
                        </a>
                    </div>
                </div>
            </div>
            <nav class="category">
                <form action="index.jsp" method="GET">
                    <button type="submit" name="category" value="all">Tất cả</button>
                    <button type="submit" name="category" value="1">Trà</button>
                    <button type="submit" name="category" value="2">Bánh</button>
                    <button type="submit" name="category" value="3">Khác</button>
                </form>
            </nav>
        </div>
        <img src="images/thum.jpg" alt="Ảnh chính" class="full-width-image">
        <div id="wrapper">
            <h2 style="text-align: center">Menu</h2>

            <%-- SQL Query to fetch products based on category --%>
            <sql:setDataSource var="conn"
                               driver="com.microsoft.sqlserver.jdbc.SQLServerDriver"
                               url="jdbc:sqlserver://DESKTOP-P79FH3I;databaseName=aa;encrypt=true;trustServerCertificate=true"
                               user="sa"
                               password="bao1234567890" />

            <%-- Default to fetch all products if no category selected --%>
            <c:choose>
                <c:when test="${empty param.category or param.category == 'all'}">
                    <sql:query var="products" dataSource="${conn}">
                        SELECT * FROM Products
                    </sql:query>
                </c:when>
                <c:otherwise>
                    <sql:query var="products" dataSource="${conn}">
                        SELECT * FROM Products WHERE cate_id = ${param.category}
                    </sql:query>
                </c:otherwise>
            </c:choose>

            <div class="products-container">
                <c:forEach var="row" items="${products.rows}" varStatus="loop">
                    <div class="product">
                        <img src="${row.image_url}" alt="${row.pro_name}">
                        <div class="name">${row.pro_name}</div>
                        <div class="price">${row.pro_price}đ</div>
                        <a href="order.jsp?id=${row.pro_id}">Đặt món</a>
                    </div>
                </c:forEach>
            </div>
        </div>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                let userIcon = document.querySelector(".header-icons .user");
                let userTabs = document.querySelector(".header-icons .user-tabs");

                // Hiển thị userTabs khi di chuột vào userIcon
                userIcon.addEventListener("mouseenter", function () {
                    userTabs.style.display = "block";
                });

                // Ẩn userTabs khi di chuột ra khỏi userIcon
                userIcon.addEventListener("mouseleave", function () {
                    userTabs.style.display = "none";
                });
            });
        </script>
    </body>
</html>