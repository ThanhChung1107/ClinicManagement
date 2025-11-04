package com.clinic.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.clinic.util.DBConnection;

public class DoctorDAO {
    
    public int getDoctorIdByUserId(int userId) {
        String sql = "SELECT doctor_id FROM doctors WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("doctor_id");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
}