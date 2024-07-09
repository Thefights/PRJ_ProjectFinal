/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBConnection;
import Models.Order;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Shinpei
 */
public class OrderDAO {

    public boolean addNewOrder(Order order) throws SQLException {
        Connection conn = DBConnection.getConnection();
        String sql = "INSERT INTO Orders(date, quantity, total_price, note, acc_id, pro_id) VALUES (?,?,?,?,?,?)";
        PreparedStatement pst = conn.prepareStatement(sql);
        pst.setTimestamp(1, order.getDate());
        pst.setInt(2, order.getQuantity());
        pst.setDouble(3, order.getTotalPrice());
        pst.setString(4, order.getNote());
        pst.setInt(5, order.getAcc_id());
        pst.setInt(6, order.getPro_id());
        return pst.executeUpdate() > 0;
    }

    public String getProNameByOrder(int id) throws SQLException {
        String proName;
        try (Connection conn = DBConnection.getConnection()) {
            ResultSet rs = null;
            proName = null;
            String sql = "SELECT P.pro_name FROM Orders O JOIN Products P ON O.pro_id = P.pro_id WHERE O.pro_id = ?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setInt(1, id);
            rs = pst.executeQuery();
            if (rs.next()) {
                proName = rs.getString("pro_name");
            }   rs.close();
            pst.close();
        }

        return proName;
    }

}
