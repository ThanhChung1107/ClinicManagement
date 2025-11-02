package com.clinic.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.clinic.model.bean.User;
import com.clinic.util.DBConnection;

public class UserDAO {
	public boolean register(User user) {
		 String sql = "INSERT INTO users(full_name, email, password, role, phone, gender) VALUES (?, ?, ?, ?, ?, ?)";
		 try(Connection conn = DBConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement(sql)) {
			 ps.setString(1, user.getFullname());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getGender());
            return ps.executeUpdate() > 0;
		} catch (Exception e) {
			e.printStackTrace();
		}
		 return false;
	}
	
	public User login(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setFullname(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
