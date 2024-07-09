<%@page import="DAOs.AccountDAO"%>
<%@page import="java.util.Properties"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.Session"%>
<%@page import="javax.mail.Transport"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="java.util.Random"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Lấy lại mật khẩu</title>
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
            margin-bottom: 10px; /* Separate inputs a bit more */
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
            margin-top: 10px; /* Add some space above the buttons */
        }
        .container button:hover {
            background-color: #45a049;
        }
        .container a {
            color: #4CAF50;
            text-decoration: none;
            display: block;
            margin-top: 10px;
        }
        .container a:hover {
            text-decoration: underline;
        }
        .error-message {
            color: red;
            margin-top: 10px;
        }
        .success-message {
            color: green;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Lấy lại mật khẩu</h1>
        <form method="post">
            <div>
                <label>Nhập email</label>
                <input type="text" name="txtOTP" placeholder="Nhập email của bạn" value="<%= request.getParameter("txtOTP") != null ? request.getParameter("txtOTP") : ""%>" required/>
                <button type="submit" name="btnOTP">Gửi mã OTP</button>
            </div>

            <div>
                <input type="text" name="txtConfirm" placeholder="Xác nhận mã OTP"/>
                <button type="submit" name="btnConfirm">Xác nhận</button>
            </div>

            <p>Bạn chưa nhận được mã? <button type="submit" name="btnResendOTP">Nhận lại</button></p>
        </form>

        <hr>
        <h3>HOẶC</h3>
        <a href="register.jsp">Đăng kí ngay!</a>

        <%-- Handling messages --%>
        <% if (request.getParameter("btnOTP") != null || request.getParameter("btnResendOTP") != null) {
            String address = request.getParameter("txtOTP");
            AccountDAO dao = new AccountDAO();
            if (dao.existedAcc(address)) {
                // Tạo OTP
                Random rd = new Random();
                int otp = 100000 + rd.nextInt(899999);

                // Lưu OTP vào session
                session.setAttribute("otp", otp);
                session.setAttribute("otpEmail", address);

                // Gửi qua email từ email của admin
                final String adminUser = "khangqpce180023@fpt.edu.vn";
                final String adminPass = "losk agvz rxlv tgps";

                Properties props = new Properties();
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");
                props.put("mail.smtp.host", "smtp.gmail.com");
                props.put("mail.smtp.port", "587");

                Session ss = Session.getInstance(props, new javax.mail.Authenticator() {
                    protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
                        return new javax.mail.PasswordAuthentication(adminUser, adminPass);
                    }
                });

                try {
                    Message mess = new MimeMessage(ss);
                    mess.setFrom(new InternetAddress(adminUser));
                    mess.setRecipients(Message.RecipientType.TO, InternetAddress.parse(address));
                    mess.setSubject("Your OTP Code");
                    mess.setText("Your OTP code is: " + otp);

                    Transport.send(mess);

                    out.println("<p class='success-message'>Mã OTP đã được gửi tới email của bạn!</p>");
                } catch (Exception e) {
                    out.println("<p class='error-message'>Gửi mã OTP thất bại. Vui lòng thử lại.</p>");
                    e.printStackTrace();
                }
            } else {
                out.println("<p class='error-message'>Email không tồn tại!</p>");
            }
        }

        if (request.getParameter("btnConfirm") != null) {
            String inputOTP = request.getParameter("txtConfirm");
            Integer sessionOTP = (Integer) session.getAttribute("otp");

            if (sessionOTP != null && inputOTP != null && sessionOTP.equals(Integer.parseInt(inputOTP))) {
                response.sendRedirect("resetPass.jsp");
            } else {
                out.println("<p class='error-message'>Mã OTP không đúng. Vui lòng thử lại.</p>");
            }
        }
        %>
    </div>
</body>
</html>
