/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBConnection;
import Models.Product;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Nguyen Quoc Bao
 */
public class ProductDAO {

    public ResultSet getAllProduct() {
        Connection conn = DBConnection.getConnection();
        ResultSet rs = null;
        if (conn != null) {
            try {
                Statement st = conn.createStatement();
                rs = st.executeQuery("SELECT * FROM Product");
            } catch (SQLException ex) {
                Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return rs;
    }

    public int addNew(Product obj) {
        Connection conn = DBConnection.getConnection();
        String sql = "INSERT INTO Products (pro_name, pro_price, cate_id, image_url, description) Values(?,?,?,?,?)";
        int count = 0;
        try {
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, obj.getName());
            pst.setDouble(2, obj.getPrice());
            pst.setInt(3, obj.getCat_id());
            pst.setString(4, obj.getPicture());
            pst.setString(5, obj.getDescription());
            count = pst.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return count;
    }

    public Product getProduct(String name) {
        Connection conn = DBConnection.getConnection();
        Product obj;
        try {
            String sql = "Select * from Product where pro_name = ?";
            PreparedStatement pst = conn.prepareCall(sql);
            pst.setString(1, name);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                obj = new Product();
                obj.setId(rs.getInt("pro_id"));
                obj.setName(rs.getString("pro_name"));
                obj.setPrice(rs.getLong("pro_price"));
                obj.setPrice(rs.getLong("cate_id"));
                obj.setPicture(rs.getString("image_url"));
                obj.setDescription(rs.getString("description"));
            } else {
                obj = null;
            }
        } catch (SQLException e) {
            obj = null;
        }
        return obj;
    }

    public Product getProductByID(int id) {
        Connection conn = DBConnection.getConnection();
        Product obj;
        try {
            String sql = "Select * from Products where pro_id = ?";
            PreparedStatement pst = conn.prepareCall(sql);
            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
                obj = new Product();
                obj.setId(rs.getInt("pro_id"));
                obj.setName(rs.getString("pro_name"));
                obj.setPrice(rs.getDouble("pro_price"));
                obj.setCat_id(rs.getInt("cate_id"));
                obj.setPicture(rs.getString("image_url"));
                obj.setDescription(rs.getString("description"));
            } else {
                obj = null;
            }
        } catch (SQLException e) {
            obj = null;
        }
        return obj;
    }

    public ResultSet getProductByCartID(int id) throws SQLException {
        Connection conn = DBConnection.getConnection();
        ResultSet rs = null;
        if (conn != null) {
            String sql = "Select * from Products P JOIN Cart C ON C.pro_id = P.pro_id where C.cart_id = ?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setInt(1, id);
            rs = pst.executeQuery();
        }
        return rs;
    }
    
    public int delete(String id){
        Connection conn=DBConnection.getConnection();
        int count;
        try {
            String sql="delete from Products where pro_id=?";
            PreparedStatement pst=conn.prepareStatement(sql);
            pst.setString(1, id);
            count=pst.executeUpdate();
        } catch (Exception e) {
            count =0;
        }
        return count;
    }

}
