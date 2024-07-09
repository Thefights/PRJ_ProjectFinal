<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Product</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f4;
                margin: 0;
                padding: 0;
            }
            .container {
                width: 80%;
                margin: 20px auto;
                background-color: white;
                padding: 20px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }
            form {
                display: flex;
                flex-direction: column;
            }
            label {
                margin: 10px 0 5px;
            }
            input[type="text"], input[type="number"], textarea {
                padding: 8px;
                width: 100%;
                box-sizing: border-box;
            }
            button {
                margin-top: 20px;
                padding: 10px;
                background-color: blue;
                color: white;
                border: none;
                cursor: pointer;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Edit Product</h2>
            <%
                String id = request.getParameter("id");
                if (id != null) {
                    String url = "jdbc:sqlserver://DESKTOP-P79FH3I;databaseName=aa;encrypt=true;trustServerCertificate=true";
                    String user = "sa";
                    String password = "bao1234567890";

                    try {
                        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                        Connection conn = DriverManager.getConnection(url, user, password);

                        // Get product details
                        String query = "SELECT * FROM Products WHERE pro_id = ?";
                        PreparedStatement pstmt = conn.prepareStatement(query);
                        pstmt.setInt(1, Integer.parseInt(id));
                        ResultSet rs = pstmt.executeQuery();

                        if (rs.next()) {
                            String pro_name = rs.getString("pro_name");
                            double pro_price = rs.getDouble("pro_price");
                            String description = rs.getString("description");
                            String image_url = rs.getString("image_url");
                            int cate_id = rs.getInt("cate_id");
            %>
            <form action="edit.jsp" method="post">
                <input type="hidden" name="pro_id" value="<%= id%>">
                <label for="pro_name">Product Name:</label>
                <input type="text" id="pro_name" name="pro_name" value="<%= pro_name%>" required>

                <label for="pro_price">Price:</label>
                <input type="number" id="pro_price" name="pro_price" value="<%= pro_price%>" required>

                <label for="description">Description:</label>
                <textarea id="description" name="description" required><%= description%></textarea>

                <label for="image_url">Image URL:</label>
                <input type="text" id="image_url" name="image_url" value="<%= image_url%>" required>

                <label for="cate_id">Category ID:</label>
                <input type="number" id="cate_id" name="cate_id" value="<%= cate_id%>" required>

                <button type="submit">Update Product</button>
            </form>
            <%
                        } else {
                            out.println("Product not found.");
                        }
                        rs.close();
                        pstmt.close();
                        conn.close();
                    } catch (SQLException | ClassNotFoundException ex) {
                        ex.printStackTrace();
                    }
                }
            %>
            <%
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    String pro_id = request.getParameter("pro_id");
                    String pro_name = request.getParameter("pro_name");
                    double pro_price = Double.parseDouble(request.getParameter("pro_price"));
                    String description = request.getParameter("description");
                    String image_url = request.getParameter("image_url");
                    int cate_id = Integer.parseInt(request.getParameter("cate_id"));

                    String url = "jdbc:sqlserver://DESKTOP-P79FH3I;databaseName=aa;encrypt=true;trustServerCertificate=true";
                    String user = "sa";
                    String password = "bao1234567890";

                    try {
                        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                        Connection conn = DriverManager.getConnection(url, user, password);

                        // Update product details
                        String updateQuery = "UPDATE Products SET pro_name = ?, pro_price = ?, description = ?, image_url = ?, cate_id = ? WHERE pro_id = ?";
                        PreparedStatement pstmt = conn.prepareStatement(updateQuery);
                        pstmt.setString(1, pro_name);
                        pstmt.setDouble(2, pro_price);
                        pstmt.setString(3, description);
                        pstmt.setString(4, image_url);
                        pstmt.setInt(5, cate_id);
                        pstmt.setInt(6, Integer.parseInt(pro_id));

                        int rowsAffected = pstmt.executeUpdate();

                        if (rowsAffected > 0) {
                            out.println("<div>Product updated successfully.</div>");
                        } else {
                            out.println("<div>Failed to update product.</div>");
                        }

                        pstmt.close();
                        conn.close();
                    } catch (SQLException | ClassNotFoundException ex) {
                        ex.printStackTrace();
                    }
                }
            %>
        </div>
    </body>
</html>
