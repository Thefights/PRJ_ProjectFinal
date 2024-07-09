<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.ArrayList"%>
<%@page import="DAOs.CartDAO"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="Models.Account"%>
<%@page import="DAOs.AccountDAO"%>
<%@page import="Models.Product"%>
<%@page import="Models.Order"%>
<%@page import="DAOs.ProductDAO"%>
<%@page import="DAOs.OrderDAO"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thanh toán</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f4;
                margin: 0;
                padding: 0;
            }
            .container {
                width: 50%;
                margin: 20px auto;
                background-color: white;
                padding: 20px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                border-radius: 10px;
            }
            h1, h3 {
                text-align: center;
            }
            .order-info, .customer-info, .total {
                margin-bottom: 20px;
            }
            .order-info div, .customer-info div, .total div {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
            }
            .order-info p, .customer-info p, .total p {
                margin: 0;
            }
            input[type="text"] {
                width: 100%;
                padding: 10px;
                margin: 5px 0;
                border: 1px solid #ccc;
                border-radius: 5px;
                box-sizing: border-box;
            }
            button {
                width: 100%;
                padding: 10px;
                background-color: #4CAF50;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
            }
            button:hover {
                background-color: #45a049;
            }
            hr {
                border: 1px solid #eee;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>THANH TOÁN</h1>
            <div class="customer-info">
                <h3>THÔNG TIN NGƯỜI NHẬN</h3>
                <%        
                    AccountDAO dao = new AccountDAO();
                    Account acc = dao.getAccountByUser((String) session.getAttribute("userLogin"));
                %>
                <div>
                    <p>Tên người nhận</p>
                    <input type="text" name="txtName" value="<%= acc.getName()%>" required/>
                </div>
                <div>
                    <p>Số điện thoại</p>
                    <input type="text" name="txtPhone" value="<%= acc.getPhone()%>" required/>
                </div>
                <div>
                    <p>Địa chỉ người nhận</p>
                    <input type="text" name="txtAddress" required/>
                </div>       
            </div>
            <div class="order-info">
                <h3>THÔNG TIN ĐƠN HÀNG</h3>
                <% 
                    if (session.getAttribute("cart") == null) {
                        OrderDAO ord = new OrderDAO();
                        ProductDAO pro = new ProductDAO();
                        Order order = (Order) session.getAttribute("order");
                        Product product = pro.getProductByID(order.getPro_id());
                %>
                <form method="post">
                    <div>
                        <p>Sản phẩm:</p>
                        <p><%= product.getName()%></p>
                    </div>
                    <div>
                        <p>Số lượng:</p>
                        <p><%= order.getQuantity()%>x</p>
                    </div>
                    <div class="total">
                        <p>Tổng tiền:</p>
                        <p><%= order.getTotalPrice()%>đ</p>
                    </div>
                    <hr>
                    <p>Bằng cách bấm nút "Đặt hàng", tôi đồng ý với chính sách của cửa hàng</p>
                    <button type="submit" name="btnOrd">Đặt hàng</button>
                </form>
                <% 
                    if (request.getParameter("btnOrd") != null) {
                        if (ord.addNewOrder(order)) {
                            out.print("Đặt hàng thành công");
                            session.removeAttribute("id");
                            session.removeAttribute("order");
                            response.sendRedirect("index.jsp");
                        }
                    }
                } else {
                    ArrayList<Order> orderList = new ArrayList<>();
                    CartDAO c = new CartDAO();
                    ResultSet rs = c.getAllCartByUserID(acc.getAccId());
                    int totalProduct = 0;
                    double totalPrice = 0;
                    out.print("<p> Đơn hàng</p>");
                    while (rs.next()) {
                        ProductDAO pro = new ProductDAO();
                        ResultSet result = pro.getProductByCartID(rs.getInt("cart_id"));
                        while (result.next()) {
                %>
                <div>
                    <p>Sản phẩm:</p>
                    <p><%= result.getString("pro_name")%></p>
                    <p>Số lượng:</p>
                    <p><%= rs.getInt("quantity")%>x</p>
                </div>
                <% 
                            totalPrice += result.getDouble("pro_price") * rs.getInt("quantity");
                            totalProduct += rs.getInt("quantity");
                            Timestamp date = new Timestamp(System.currentTimeMillis()); // Lấy ngày và giờ hiện tại
                            Order order = new Order(date, rs.getInt("quantity"), result.getDouble("pro_price") * rs.getInt("quantity"), "", acc.getAccId(), result.getInt("pro_id"));
                            orderList.add(order);
                        }
                    }
                %>
                <form method="post">
                    <div class="total">
                        <p>Tổng tiền:</p>
                        <p><%= totalProduct%> món</p>
                        <p><%= totalPrice%>đ</p>
                    </div>
                    <hr>
                    <p>Bằng cách bấm nút "Đặt hàng", tôi đồng ý với chính sách của cửa hàng</p>
                    <button type="submit" name="btnOrd">Đặt hàng</button>
                </form>
                <% 
                        if (request.getParameter("btnOrd") != null) {
                            for (Order order : orderList) {
                                OrderDAO o = new OrderDAO();
                                o.addNewOrder(order);
                            }
                            session.removeAttribute("cart");
                            CartDAO cart = new CartDAO();
                            cart.deleteCartByUser(acc.getAccId());
                            response.sendRedirect("index.jsp");
                        }
                    }
                %>
            </div>
        </div>
    </body>
</html>
