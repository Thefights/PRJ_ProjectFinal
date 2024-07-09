<%@page import="DAOs.ProductDAO"%>
<%@page import="Models.Product"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add New Product</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f2f2f2;
                margin: 0;
                padding: 0;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }

            .container {
                width: 30%;
                padding: 20px;
                background-color: #fff;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
            }

            h1 {
                text-align: center;
                color: #333;
                margin-bottom: 20px;
            }

            form {
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            form div {
                margin-bottom: 15px;
                width: 100%;
            }

            label {
                font-weight: bold;
                margin-bottom: 5px;
            }

            input[type="text"],
            input[type="number"],
            input[type="file"],
            textarea {
                width: calc(100% - 20px);
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
            }

            textarea {
                resize: vertical;
                height: 100px;
            }

            button {
                padding: 10px 20px;
                color: #fff;
                background-color: #4CAF50;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                margin-right: 10px;
            }

            button[type="reset"] {
                background-color: #f44336;
            }

            button:hover {
                opacity: 0.9;
            }

            .button {
                display: flex;
                justify-content: center;
                width: 100%;
            }

            .alert {
                color: #f44336;
                font-weight: bold;
                margin-top: 20px;
                text-align: center;
            }

            a {
                display: block;
                text-align: center;
                margin-top: 20px;
                text-decoration: none;
                color: #4CAF50;
                font-weight: bold;
            }

            a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Add New Product</h1>
            <form method="post">
                <div>
                    <label>Product Name</label>
                    <input type="text" name="txtName" required/>
                </div>
                <div>
                    <label>Product Price</label>
                    <input type="number" name="txtPrice" required/>
                </div>
                <div>
                    <label>cat</label>
                    <input type="number" name="txtCat" required/>
                </div>
                <div>
                    <label>Product Picture</label>
                    <input type="file" name="filePic"/>
                </div>
                <div>
                    <label>Product Description</label>
                    <textarea name="txtDes"></textarea>
                </div>
                <div class="button">
                    <button type="submit" name="btnAdd">Add Product</button>
                    <button type="reset">Reset</button>
                </div>
            </form>
            <hr/>
            <a href="adminPage.jsp">Back to list</a>
            <%
                if (request.getParameter("btnAdd") != null) {
                    String name = request.getParameter("txtName");
                    double price = Double.parseDouble(request.getParameter("txtPrice"));
                    int cat = Integer.parseInt(request.getParameter("txtCat"));
                    String picture = request.getParameter("filePic");
                    String description = request.getParameter("txtDes");

                    ProductDAO dao = new ProductDAO();
                    if (dao.getProduct(name) != null) {
                        out.println("<div class='alert alert-danger mt-3'>Product ID already exists. Please use a different ID.</div>");
                    } else {
                        Product product = new Product(name, price, picture, description, cat);
                        dao.addNew(product);
                        response.sendRedirect("adminPage.jsp");
                    }
                }
            %>
        </div>
    </body>
</html>
