<%@page import="Models.Account"%>
<%@page import="DAOs.AccountDAO"%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đăng nhập</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f4;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                position: relative;
            }
            .close-button {
                position: absolute;
                top: 10px;
                left: 10px;
                font-size: 24px;
                font-weight: bold;
                background: none;
                border: none;
                cursor: pointer;
                color: #4CAF50;
            }
            .login-container {
                background-color: #fff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                width: 300px;
                text-align: center;
            }
            .login-container h1 {
                margin-bottom: 20px;
                color: #4CAF50;
            }
            .login-container form div {
                margin-bottom: 15px;
            }
            .login-container label {
                display: block;
                text-align: left;
                margin-bottom: 5px;
                font-weight: bold;
                color: #333;
            }
            .login-container input[type="text"],
            .login-container input[type="password"] {
                width: calc(100% - 20px);
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 5px;
                box-sizing: border-box;
            }
            .login-container button {
                background-color: #4CAF50;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
                width: 100%;
            }
            .login-container button:hover {
                background-color: #45a049;
            }
            .login-container a {
                color: #4CAF50;
                text-decoration: none;
                display: block;
                margin-top: 10px;
            }
            .login-container a:hover {
                text-decoration: underline;
            }
            .notification {
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 20px;
                background-color: white;
                border-left: 5px solid #4CAF50;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                z-index: 1000;
                display: none;
                animation: slide-in 0.5s forwards;
            }
            .notification.show {
                display: block;
            }
            .notification.success {
                border-color: #4CAF50;
            }
            .notification.error {
                border-color: red;
            }
            .notification .close-btn {
                background: none;
                border: none;
                font-size: 20px;
                cursor: pointer;
                position: absolute;
                top: 10px;
                right: 10px;
            }
            @keyframes slide-in {
                from {
                    opacity: 0;
                    transform: translateX(100%);
                }
                to {
                    opacity: 1;
                    transform: translateX(0);
                }
            }
            .progress-bar {
                position: absolute;
                bottom: 0;
                left: 0;
                height: 5px;
                background-color: #4CAF50;
                animation: progress 2s linear forwards;
            }
            .progress-bar.error {
                background-color: red;
                animation-duration: 3s;
            }
            @keyframes progress {
                from {
                    width: 0%;
                }
                to {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <button class="close-button" onclick="window.location.href = 'index.jsp'">×</button>
        <div class="login-container">
            <h1>Đăng nhập</h1>
            <form method="post">
                <div>
                    <label for="txtUS">Tên đăng nhập</label>
                    <input type="text" id="txtUS" name="txtUS" value="<%= request.getParameter("txtUS") != null ? request.getParameter("txtUS") : ""%>" placeholder="Nhập tên đăng nhập" required/>
                </div>
                <div>
                    <label for="txtPA">Mật khẩu</label>
                    <input type="password" id="txtPA" name="txtPA" placeholder="Nhập mật khẩu" required/>
                </div>
                <div>
                    <button type="submit" name="btnLogin">Đăng nhập</button>
                </div>
                <a href="forget.jsp">Quên mật khẩu?</a>
            </form>
            <p>Chưa có tài khoản? <a href="register.jsp">Đăng kí ngay</a></p>
            <div id="notification" class="notification success">
                <button class="close-btn" onclick="closeNotification()">×</button>
                <p>Đăng nhập thành công</p>
                <div class="progress-bar"></div>
            </div>
            <div id="errorNotification" class="notification error">
                <button class="close-btn" onclick="closeNotification()">×</button>
                <p>Tên đăng nhập hoặc mật khẩu không đúng!</p>
                <div class="progress-bar error"></div>
            </div>
        </div>

        <script>
            function showNotification() {
                var notification = document.getElementById("notification");
                notification.classList.add("show");
                setTimeout(function () {
                    notification.classList.remove("show");
                }, 2000); // Hiển thị thông báo thành công trong 2 giây
            }

            function showErrorNotification() {
                var notification = document.getElementById("errorNotification");
                notification.classList.add("show");
                setTimeout(function () {
                    notification.classList.remove("show");
                    window.location.href = 'login.jsp';
                }, 3000); // Hiển thị thông báo lỗi trong 3 giây và sau đó tải lại trang
            }

            function closeNotification() {
                var notifications = document.querySelectorAll('.notification');
                notifications.forEach(function (notification) {
                    notification.classList.remove("show");
                });
            }
        </script>
        <%
            if (request.getParameter("btnLogin") != null) {
                String user = request.getParameter("txtUS");
                String pass = request.getParameter("txtPA");

                AccountDAO dao = new AccountDAO();
                Account acc = new Account(user, pass);

                if (dao.login(acc)) {
                    session.setAttribute("userLogin", user);
                    out.print("<script>showNotification();</script>");
                    out.print("<meta http-equiv='refresh' content='2;URL=index.jsp'>"); // Chuyển trang sau 2 giây
                } else {
                    out.print("<script>showErrorNotification();</script>");
                }
            }
        %>
    </body>
</html>
