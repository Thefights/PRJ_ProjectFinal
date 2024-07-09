/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBConnection;
import Models.Cart;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Shinpei
 */
public class CartDAO {

    public int addNew(Cart obj) {
        Connection conn = DBConnection.getConnection();
        String sql = "INSERT INTO Cart (acc_id, pro_id, quantity, note) Values(?,?,?,?)";
        int count = 0;
        try {
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setInt(1, obj.getAcc_id());
            pst.setInt(2, obj.getPro_id());
            pst.setInt(3, obj.getQuantity());
            pst.setString(4, obj.getNote());
            count = pst.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(CartDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(CartDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return count;
    }

    public ResultSet getAllCartByUserID(int id) {
        Connection conn = DBConnection.getConnection();
        ResultSet rs = null;
        try {
            if (conn != null) {
                String sql = "SELECT * FROM Cart WHERE acc_id = ?";
                PreparedStatement pst = conn.prepareStatement(sql);
                pst.setInt(1, id);
                rs = pst.executeQuery();
            }
        } catch (SQLException ex) {
            Logger.getLogger(CartDAO.class.getName()).log(Level.SEVERE, null, ex);
        } 
        return rs;
    }
    
    public int deleteCart(int id){
        Connection conn=DBConnection.getConnection();
        int count;
        try {
            String sql="delete from Cart where cart_id = ?";
            PreparedStatement pst=conn.prepareStatement(sql);
            pst.setInt(1, id);
            count=pst.executeUpdate();
        } catch (SQLException e) {
            count =0;
        }
        return count;
    }
    public int deleteCartByUser(int id){
        Connection conn=DBConnection.getConnection();
        int count;
        try {
            String sql="delete from Cart where acc_id = ?";
            PreparedStatement pst=conn.prepareStatement(sql);
            pst.setInt(1, id);
            count=pst.executeUpdate();
        } catch (SQLException e) {
            count =0;
        }
        return count;
    }

}
