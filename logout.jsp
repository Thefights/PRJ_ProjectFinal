<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.IOException" %>
<%
    // Hủy bỏ session
    session.invalidate();

    // Chuyển hướng người dùng về trang chủ (index.jsp)
    try {
        response.sendRedirect("index.jsp");
    } catch (IOException e) {
        e.printStackTrace();
    }
%>