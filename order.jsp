<%@page import="DAOs.CartDAO"%>
<%@page import="Models.Account"%>
<%@page import="Models.Cart"%>
<%@page import="DAOs.AccountDAO"%>
<%@page import="Models.Order"%>
<%@page import="DAOs.OrderDAO"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="Models.Product"%>
<%@page import="DAOs.ProductDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Đặt hàng</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f4;
                margin: 0;
                padding: 0;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
            }

            .proOrder {
                background-color: #ffffff;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                width: 100%;
                max-width: 600px;
                margin: 20px;
            }

            .proOrder img {
                width: 100%;
                height: auto;
                border-radius: 10px;
            }

            .proOrder p {
                font-size: 16px;
                margin: 10px 0;
            }

            .proOrder .name-and-quantity {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 10px;
            }

            .quantity-container {
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .quantity-container button {
                padding: 10px;
                border: none;
                background-color: #333;
                color: #fff;
                cursor: pointer;
                font-size: 16px;
                width: 40px;
                height: 40px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 5px;
            }

            .quantity-container button:hover {
                background-color: #555;
            }

            .quantity-container input {
                width: 50px;
                text-align: center;
                font-size: 16px;
                border: 1px solid #ddd;
                border-radius: 5px;
                height: 40px;
                margin: 0 5px;
            }

            .proOrder textarea {
                width: 100%;
                height: 100px;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 10px;
                resize: none;
            }

            .proOrder hr {
                border: none;
                border-top: 1px solid #ddd;
                margin: 20px 0;
            }

            .proOrder button {
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                background-color: #333;
                color: #fff;
                cursor: pointer;
                transition: background-color 0.3s;
            }

            .proOrder button:hover {
                background-color: #555;
            }

            .proOrder button img {
                width: 20px;
                height: auto;
                vertical-align: middle;
            }

            .proOrder .price {
                color: #f57224;
                font-size: 18px;
                font-weight: 400;
            }

            .proOrder .total {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .proOrder .total p {
                margin: 0;
                font-size: 18px;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <%
            int pro_id = Integer.parseInt(request.getParameter("id"));
            ProductDAO dao = new ProductDAO();
            Product pro = dao.getProductByID(pro_id);
        %>

        <form class="proOrder" method="post">
            <img src="<%= pro.getPicture()%>" alt="<%= pro.getName()%>"/>
            <div class="name-and-quantity">
                <p style="font-size: 28px; font-weight: bolder"><%= pro.getName()%></p>
                <div class="quantity-container">
                    <button type="button" onclick="updateQuantity(-1)">-</button>
                    <input type="number" name="txtQuantity" id="quantity" value="1" min="1" max="10" readonly/>
                    <button type="button" onclick="updateQuantity(1)">+</button>
                </div>
            </div>
            <div class="price"><%= pro.getPrice()%> đ</div>
            <p><%= pro.getDescription()%></p>
            <hr>
            <div>
                <p>GHI CHÚ</p>
                <textarea placeholder="Nhập yêu cầu cần chú ý.." name="txtRequest"></textarea>
            </div>
            <div class="total">
                <p>Thành tiền</p>
                <p id="totalPriceDisplay"><%= pro.getPrice()%> đ</p>
            </div>
            <div>
                <button type="submit" name="btnOrder">Đặt hàng ngay</button>
                <button type="submit" name="btnCart"><img src="images/network.png" alt="Thêm vào giỏ hàng"/></button>
            </div>
        </form>
        <script>
            // Gọi hàm updateTotalPrice() khi trang web được tải lần đầu
            updateTotalPrice(1);

            function updateQuantity(change) {
                var quantityInput = document.getElementById('quantity');
                var currentQuantity = parseInt(quantityInput.value);
                var newQuantity = currentQuantity + change;

                if (newQuantity >= 1 && newQuantity <= 10) {
                    quantityInput.value = newQuantity;
                    updateTotalPrice(newQuantity);
                }
            }

            function updateTotalPrice(quantity) {
                var pricePerItem = <%= pro.getPrice()%>;
                var totalPrice = pricePerItem * quantity;
                document.getElementById('totalPriceDisplay').textContent = totalPrice + ' đ';
            }
        </script>
        <%
            AccountDAO acc = new AccountDAO();
            CartDAO cartDao = new CartDAO();
            Timestamp date = new Timestamp(System.currentTimeMillis()); // Lấy ngày và giờ hiện tại

            int acc_id = acc.getIDByUser((String) session.getAttribute("userLogin"));

            if (request.getParameter("btnOrder") != null) {
                int quantity = Integer.parseInt(request.getParameter("txtQuantity"));
                double totalPrice = pro.getPrice() * Integer.parseInt(request.getParameter("txtQuantity")); // Tính tổng tiền
                String note = request.getParameter("txtRequest");

                Order order = new Order(date, quantity, totalPrice, note, acc_id, pro_id);
                session.setAttribute("order", order);
                response.sendRedirect("payment.jsp");
            }
            if (request.getParameter("btnCart") != null) {
                int quantity = Integer.parseInt(request.getParameter("txtQuantity"));
                String note = request.getParameter("txtRequest");
                Cart cart = new Cart(acc_id, pro_id, quantity, note);

                if (cartDao.addNew(cart) > 0) {
                    response.sendRedirect("index.jsp");
                }
            }
        %>
    </body>
</html>
