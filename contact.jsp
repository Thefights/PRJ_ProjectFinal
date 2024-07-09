<%@ page import="java.util.Properties"%>
<%@ page import="javax.mail.*"%>
<%@ page import="javax.mail.internet.*"%>
<%@ page import="Models.Feedback"%>
<%@ page import="DAOs.FeedbackDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Contact Us</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/contact.css"/>
</head>
<body>
    <div class="title">
        <h1>Contact Us</h1>
    </div>
    <div>
        <form action="contact.jsp" method="post">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required/><br/>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required/><br/>

            <label for="subject">Subject:</label>
            <input type="text" id="subject" name="subject" required/><br/>

            <label for="message">Message:</label>
            <textarea id="message" name="message" rows="4" cols="50" required></textarea><br/>

            <button type="submit">Send</button>
        </form>
        <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String subject = request.getParameter("subject");
                String messageContent = request.getParameter("message");

                // Lưu phản hồi vào cơ sở dữ liệu
                Feedback feedback = new Feedback(name, email, subject, messageContent);
                FeedbackDAO feedbackDAO = new FeedbackDAO();
                feedbackDAO.saveFeedback(feedback);

                // Gửi email
                final String username = "khangqpce180023@fpt.edu.vn"; // Replace with your email
                final String password = "losk agvz rxlv tgps"; // Replace with your email password
                final String toEmail = "khangqpce180023@fpt.edu.vn";

                Properties prop = new Properties();
                prop.put("mail.smtp.host", "smtp.gmail.com");
                prop.put("mail.smtp.port", "587");
                prop.put("mail.smtp.auth", "true");
                prop.put("mail.smtp.starttls.enable", "true"); // TLS

                Session emailSession = Session.getInstance(prop, new javax.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(username, password);
                    }
                });

                try {
                    Message message = new MimeMessage(emailSession);
                    message.setFrom(new InternetAddress(username));
                    message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
                    message.setSubject(subject);
                    message.setText("Name: " + name + "\nEmail: " + email + "\n\n" + messageContent);

                    Transport.send(message);
                    out.println("<p style='color:green'>Your message has been sent successfully!</p>");
                } catch (MessagingException e) {
                    e.printStackTrace();
                    out.println("<p style='color:red'>There was an error sending your message. Please try again later.</p>");
                }
            }
        %>
    </div>
</body>
</html>