package DAOs;

import Models.Account;
import DB.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AccountDAO {

    public boolean login(Account acc) throws SQLException {
        String sql = "SELECT * FROM Accounts WHERE Username=? AND Password=?";

        try ( Connection conn = DBConnection.getConnection();  PreparedStatement pst = conn.prepareStatement(sql)) {

            pst.setString(1, acc.getUsername());
            pst.setString(2, Account.createMD5Hash(acc.getPassword()));

            try ( ResultSet rs = pst.executeQuery()) {
                return rs.next(); // true if there's at least one row, false otherwise
            }
        }
    }

    public boolean existedAcc(String address) throws SQLException {
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement pst = conn.prepareStatement("SELECT * FROM Accounts WHERE email = ?")) {
            pst.setString(1, address);
            try ( ResultSet rs = pst.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean existedAccByEmail(String email) throws SQLException {
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement pst = conn.prepareStatement("SELECT * FROM Accounts WHERE email = ?")) {
            pst.setString(1, email);
            try ( ResultSet rs = pst.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean existedAccPhone(String phone) throws SQLException {
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement pst = conn.prepareStatement("SELECT * FROM Accounts WHERE phone = ?")) {
            pst.setString(1, phone);
            try ( ResultSet rs = pst.executeQuery()) {
                return rs.next();
            }
        }
    }

    public boolean existedAccByUsername(String username) throws SQLException {
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement pst = conn.prepareStatement("SELECT * FROM Accounts WHERE username = ?")) {
            pst.setString(1, username);
            try ( ResultSet rs = pst.executeQuery()) {
                return rs.next();
            }
        }
    }

    public Account getAccountByEmail(String address) {
        Account account = null;
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement pst = conn.prepareStatement("SELECT * FROM Accounts WHERE email = ?")) {
            pst.setString(1, address);
            try ( ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    account = new Account();
                    account.setAccId(rs.getInt("acc_id"));
                    account.setUsername(rs.getString("username"));
                    account.setPassword(rs.getString("password"));
                    account.setName(rs.getString("name"));
                    account.setPhone(rs.getString("phone"));
                    account.setEmail(rs.getString("email"));
                    account.setRole("user");
                }
            }
        } catch (SQLException e) {
        }
        return account;
    }
    public Account getAccountByUser(String user) {
        Account account = null;
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement pst = conn.prepareStatement("SELECT * FROM Accounts WHERE username = ?")) {
            pst.setString(1, user);
            try ( ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    account = new Account();
                    account.setAccId(rs.getInt("acc_id"));
                    account.setUsername(rs.getString("username"));
                    account.setPassword(rs.getString("password"));
                    account.setName(rs.getString("name"));
                    account.setPhone(rs.getString("phone"));
                    account.setEmail(rs.getString("email"));
                    account.setRole("user");
                }
            }
        } catch (SQLException e) {
        }
        return account;
    }

    public boolean updatePassword(Account account) {
        try ( Connection conn = DBConnection.getConnection();  PreparedStatement pst = conn.prepareStatement("UPDATE Accounts SET password = ? WHERE email = ?")) {
            pst.setString(1, Account.createMD5Hash(account.getPassword()));
            pst.setString(2, account.getEmail());
            return pst.executeUpdate() > 0;
        } catch (SQLException e) {
        }
        return false;
    }

    public boolean register(Account account) {
        try ( Connection connection = DBConnection.getConnection();  PreparedStatement preparedStatement = connection.prepareStatement("INSERT INTO Accounts (username, password, name, phone, email, role) VALUES (?, ?, ?, ?, ?, ?)")) {
            preparedStatement.setString(1, account.getUsername());
            preparedStatement.setString(2, Account.createMD5Hash(account.getPassword()));
            preparedStatement.setString(3, account.getName());
            preparedStatement.setString(4, account.getPhone());
            preparedStatement.setString(5, account.getEmail());
            preparedStatement.setString(6, account.getRole());
            return preparedStatement.executeUpdate() > 0;
        } catch (SQLException e) {
        }
        return false;
    }

    public int getIDByUser(String user) throws SQLException {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        int acc_id = -1; // Khởi tạo với giá trị không hợp lệ để kiểm tra sau này

        try {
            conn = DBConnection.getConnection();
            pst = conn.prepareStatement("SELECT acc_id FROM Accounts WHERE username = ?");
            pst.setString(1, user);
            rs = pst.executeQuery();

            if (rs.next()) {
                acc_id = rs.getInt("acc_id");
            }
        } finally {
            // Đóng ResultSet, PreparedStatement và Connection trong khối finally để đảm bảo chúng được giải phóng tài nguyên
            if (rs != null) {
                rs.close();
            }
            if (pst != null) {
                pst.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return acc_id;
    }
}
