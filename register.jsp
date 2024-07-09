<%@page import="Models.Account"%>
<%@page import="DAOs.AccountDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đăng kí</title>
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
            .register-container {
                background-color: #fff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                width: 300px;
                text-align: center;
            }
            .register-container h1 {
                margin-bottom: 20px;
                color: #4CAF50;
            }
            .register-container form div {
                margin-bottom: 15px;
            }
            .register-container label {
                display: block;
                text-align: left;
                margin-bottom: 5px;
                font-weight: bold;
                color: #333;
            }
            .register-container input[type="text"],
            .register-container input[type="password"],
            .register-container input[type="email"] {
                width: calc(100% - 20px);
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 5px;
                box-sizing: border-box;
            }
            .register-container button {
                background-color: #4CAF50;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
                width: 100%;
            }
            .register-container button:hover {
                background-color: #45a049;
            }
            .register-container a {
                color: #4CAF50;
                text-decoration: none;
                display: block;
                margin-top: 10px;
            }
            .register-container a:hover {
                text-decoration: underline;
            }
            #message {
                position: absolute;
                top: 20px;
                right: 20px;
                padding: 15px;
                border-radius: 5px;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                display: none;
            }
        </style>
    </head>
    <body>
        <button class="close-button" onclick="window.location.href = 'index.jsp'">×</button>
        <div class="register-container">
            <h1>Đăng kí tài khoản</h1>
            <form method="post">
                <div>
                    <label>Tên tài khoản</label>
                    <input type="text" name="txtNewUS" placeholder="Nhập tên tài khoản" value="<%= request.getParameter("txtNewUS") != null ? request.getParameter("txtNewUS") : ""%>" required/>
                </div>
                <div>
                    <label>Mật khẩu</label>
                    <input type="password" name="txtNewPA" placeholder="Nhập mật khẩu" required/>
                </div>
                <div>
                    <label>Nhập lại mật khẩu</label>
                    <input type="password" name="txtNewRePA" placeholder="Nhập lại mật khẩu" required/>
                </div>
                <div>
                    <label>Tên của bạn</label>
                    <input type="text" name="txtNewName" placeholder="Nhập họ tên của bạn" value="<%= request.getParameter("txtNewName") != null ? request.getParameter("txtNewName") : ""%>" required/>
                </div>
                <div>
                    <label>Số điện thoại</label>
                    <input type="text" name="txtNewPhone" placeholder="Nhập số điện thoại" value="<%= request.getParameter("txtNewPhone") != null ? request.getParameter("txtNewPhone") : ""%>" required/>
                </div>
                <div>
                    <label>Email</label>
                    <input type="email" name="txtNewEmail" placeholder="Nhập email của bạn" value="<%= request.getParameter("txtNewEmail") != null ? request.getParameter("txtNewEmail") : ""%>" required/>
                </div>    
                <div>
                    <p>Tôi đồng ý chính sách của cửa hàng</p>
                </div>
                <button type="submit" name="btnRegister">ĐĂNG KÍ</button>
                <p>Bạn đã có tài khoản? <a href="login.jsp">Đăng nhập ngay</a></p>
            </form>
        </div>
        <div id="message"></div>

        <%
            if (request.getParameter("btnRegister") != null) {
                String username = request.getParameter("txtNewUS");
                String password = request.getParameter("txtNewPA");
                String rePassword = request.getParameter("txtNewRePA");
                String realName = request.getParameter("txtNewName");
                String phone = request.getParameter("txtNewPhone");
                String email = request.getParameter("txtNewEmail");

                String errorMessage = null;

                if (password.equals(rePassword)) {
                    AccountDAO dao = new AccountDAO();
                    if (dao.existedAccByEmail(email)) {
                        errorMessage = "Email đã được sử dụng. Vui lòng nhập email khác!";
                    } else if (dao.existedAccPhone(phone)) {
                        errorMessage = "Số điện thoại đã được sử dụng. Vui lòng nhập số điện thoại khác!";
                    } else if (dao.existedAccByUsername(username)) {
                        errorMessage = "Tên đăng nhập đã tồn tại. Vui lòng nhập tên đăng nhập khác!";
                    } else {
                        Account acc = new Account(username, password, realName, phone, email);
                        if (dao.register(acc)) {
        %>
        <script>
            document.getElementById("message").style.color = "green";
            document.getElementById("message").style.display = "block";
            document.getElementById("message").innerHTML = "Đăng kí thành công!!! Đang quay lại trang đăng nhập.";
            setTimeout(function () {
                window.location.href = "login.jsp";
            }, 1500);
        </script>
        <%
                    } else {
                        errorMessage = "Đăng ký thất bại. Vui lòng thử lại.";
                    }
                }
            } else {
                errorMessage = "Mật khẩu không khớp. Vui lòng nhập lại.";
            }

            if (errorMessage != null) {
        %>
        <script>
            document.getElementById("message").style.display = "block";
            document.getElementById("message").innerHTML = "<%= errorMessage%>";
            setTimeout(function () {
                window.location.href = "register.jsp";
            }, 2000);
        </script>
        <%
                }
            }
        %>
    </body>
</html>
