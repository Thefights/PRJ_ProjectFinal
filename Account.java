package Models;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Account {

    private int accId;
    private String username;
    private String password;
    private String name;
    private String phone;
    private String email;
    private String role;

    public Account() {
    }

    public Account(String username, String password, String name, String phone, String email) {
        this.username = username;
        this.password = password;
        this.name = name;
        this.phone = phone;
        this.email = email;
        this.role = "user";
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public Account(String username, String password) {
        this.username = username;
        this.password = password;
    }

    // Getters and Setters for each field
    public int getAccId() {
        return accId;
    }

    public void setAccId(int accId) {
        this.accId = accId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
    public void print(){
        System.out.println("Hello World");
    }
    public static String createMD5Hash(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : messageDigest) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}
