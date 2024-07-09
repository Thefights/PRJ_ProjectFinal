<%@page import="Models.Account"%>
<%@page import="DAOs.AccountDAO"%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Reset Password</title>
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
        .container {
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            width: 300px;
            text-align: center;
        }
        .container h1 {
            margin-bottom: 20px;
            color: #4CAF50;
        }
        .container form div {
            margin-bottom: 15px;
        }
        .container label {
            display: block;
            text-align: left;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        .container input[type="text"],
        .container input[type="password"],
        .container input[type="email"] {
            width: calc(100% - 20px);
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }
        .container button {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
        }
        .container button:hover {
            background-color: #45a049;
        }
        #message {
            margin-top: 10px;
        }
        .error-message {
            color: red;
        }
        .success-message {
            color: green;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Đổi mật khẩu</h1>
        <form method="post">
            <div>
                <label>Tên đăng nhập</label>
                <%
                    AccountDAO dao = new AccountDAO();
                    String otpEmail = (String) session.getAttribute("otpEmail");
                    Account account = null;
                    if (otpEmail != null) {
                        account = dao.getAccountByEmail(otpEmail);
                    }
                %>
                <input type="text" value="<%= account != null ? account.getUsername() : ""%>" readonly/>
            </div>
            <div>
                <label>Nhập mật khẩu mới</label>
                <input type="password" name="txtRePass" required/>
            </div>
            <div>
                <label>Xác nhận mật khẩu mới</label>
                <input type="password" name="txtReRePass" required/>
            </div>
            <div>
                <button type="submit" name="btnRePass">Đổi mật khẩu</button>
            </div>
        </form>
        <div id="message"></div>
        <%
            if (request.getParameter("btnRePass") != null) {
                String newPassword = request.getParameter("txtRePass");
                String confirmPassword = request.getParameter("txtReRePass");

                if (newPassword.equals(confirmPassword)) {
                    if (account != null) {
                        account.setPassword(newPassword);
                        boolean updateSuccess = dao.updatePassword(account);
                        if (updateSuccess) {
                            // Hiển thị thông báo thành công bằng JavaScript
        %>
        <script>
            document.getElementById("message").innerHTML = "Mật khẩu đã được thay đổi thành công.";
            // Delay 1.5 giây trước khi chuyển hướng
            setTimeout(function () {
                window.location.href = "login.jsp"; // Chuyển hướng về trang login
            }, 1500); // 1500 milliseconds = 1.5 giây
        </script>
        <%
                            // Xóa OTP và email khỏi session
                            session.removeAttribute("otp");
                            session.removeAttribute("otpEmail");
                        } else {
                            out.println("<p class='error-message'>Đổi mật khẩu thất bại. Vui lòng thử lại.</p>");
                        }
                    } else {
                        out.println("<p class='error-message'>Tài khoản không tồn tại.</p>");
                    }
                } else {
                    out.println("<p class='error-message'>Mật khẩu không khớp. Vui lòng nhập lại.</p>");
                }
            }
        %>
    </div>
</body>
</html>
