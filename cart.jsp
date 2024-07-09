<%@page import="Models.Cart"%>
<%@page import="java.util.ArrayList"%>
<%@page import="DAOs.AccountDAO"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Models.Product"%>
<%@page import="DAOs.ProductDAO"%>
<%@page import="DAOs.CartDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Giỏ hàng</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f2f2f2;
                margin: 0;
                padding: 0;
            }
            .cart-container {
                width: 80%;
                margin: 20px auto;
                border: 1px solid #ddd;
                padding: 20px;
                border-radius: 5px;
                background-color: #fff;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }
            .cart-item {
                border-bottom: 1px solid #eee;
                padding: 10px 0;
                margin-bottom: 10px;
            }
            .cart-item:last-child {
                border-bottom: none;
            }
            .product-info {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .product-name {
                font-weight: bold;
                margin-bottom: 5px;
            }
            .product-price {
                font-size: 18px;
                color: #007bff;
            }
            .product-note {
                font-size: 14px;
                color: #888;
                margin-top: 5px;
            }

            .product-info button {
                background-color: #dc3545;
                color: white;
                border: none;
                padding: 8px 12px;
                cursor: pointer;
                transition: background-color 0.3s ease;
                margin-left: 10px;
            }
            .product-info button:hover {
                background-color: #c82333;
            }
            .checkout-button {
                background-color: #28a745;
                color: white;
                border: none;
                padding: 12px 20px;
                font-size: 16px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }
            .checkout-button:hover {
                background-color: #218838;
            }
        </style>
    </head>
    <body>
        <%
            AccountDAO acc = new AccountDAO();
            ProductDAO pro = new ProductDAO();
            CartDAO dao = new CartDAO();

            int acc_id = acc.getIDByUser((String) session.getAttribute("userLogin"));
            ResultSet rs = dao.getAllCartByUserID(acc_id);
        %>
        <form class="cart-container" method="post">
            <h2>Giỏ hàng</h2>
            <hr>
            <%
                if (rs == null) {
                    out.print("Chưa có sản phẩm trong giỏ hàng.");
                } else {
                    double totalPrice = 0;
                    while (rs.next()) {
                        int id = rs.getInt("cart_id");
                        String note = rs.getString("note");
                        int quantity = rs.getInt("quantity");
                        ResultSet result = pro.getProductByCartID(id);
                        while (result.next()) {
                            String pro_name = result.getString("pro_name");
                            double price = result.getDouble("pro_price");
            %>
            <div class="cart-item">
                <div>
                    <div class="product-info">
                        <p class="product-name"><%= pro_name%></p>
                        <p class="product-price"><%= price%> đ</p>          
                    </div>
                    <p class="product-note"><i><%= note == null ? "Không có ghi chú" : note%></i></p>
                    <div class="product-info">
                        <p>Số lượng: <%= quantity%></p>
                        <button type="submit" name="btnDelete" value="<%= id%>">Xóa</button>
                    </div>
                </div>
            </div>
            <%
                        totalPrice += price;
                    }
                }
            %>
            <div class="product-info">
                <p>Tổng tiền</p>
                <p><%= totalPrice%>đ</p>              
            </div>
            <button type="submit" class="checkout-button" name="btnCart">Thanh toán</button>
            <%
                }
            %>
        </form>
        <%
            if (request.getParameter ("btnDelete") != null) {
                int cart_id = Integer.parseInt(request.getParameter("btnDelete"));
                if (dao.deleteCart(cart_id) > 0) {
                    response.sendRedirect("cart.jsp");
                }
            }
            if(request.getParameter("btnCart") != null){
                session.setAttribute("cart", "pay by cart");
                response.sendRedirect("payment.jsp");
            }

        %>
    </body>
</html>
