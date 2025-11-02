package com.clinic.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.clinic.model.bean.Patient;
import com.clinic.model.bean.User;
import com.clinic.util.DBConnection;

public class PatientDAO {
    
    public boolean createPatient(User user) {
        String sql = "INSERT INTO patients (user_id, blood_type, allergies, medical_history) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // Lấy user_id từ user vừa đăng ký
            int userId = getUserIdByEmail(user.getEmail());
            
            if (userId != -1) {
                ps.setInt(1, userId);
                ps.setString(2, ""); // blood_type mặc định
                ps.setString(3, ""); // allergies mặc định  
                ps.setString(4, ""); // medical_history mặc định
                
                return ps.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean createPatient(int userId) {
        String sql = "INSERT INTO patients (user_id, blood_type, allergies, medical_history) VALUES (?, '', '', '')";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    private int getUserIdByEmail(String email) {
        String sql = "SELECT user_id FROM users WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            var rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("user_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    public Patient getPatientByUserId(int userId) {
        String sql = "SELECT p.*, u.full_name, u.email, u.phone, u.gender, u.date_of_birth " +
                    "FROM patients p " +
                    "JOIN users u ON p.user_id = u.user_id " +
                    "WHERE p.user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractPatientFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    private Patient extractPatientFromResultSet(ResultSet rs) throws SQLException {
        Patient patient = new Patient();
        patient.setPatientId(rs.getInt("patient_id"));
        patient.setUserId(rs.getInt("user_id"));
        patient.setBloodType(rs.getString("blood_type"));
        patient.setAllergies(rs.getString("allergies"));
        patient.setMedicalHistory(rs.getString("medical_history"));
        patient.setFullName(rs.getString("full_name"));
        patient.setEmail(rs.getString("email"));
        patient.setPhone(rs.getString("phone"));
        patient.setGender(rs.getString("gender"));
        patient.setDateOfBirth(rs.getDate("date_of_birth"));
        patient.setCreatedAt(rs.getTimestamp("created_at"));
        patient.setUpdatedAt(rs.getTimestamp("updated_at"));
        return patient;
    }
    public boolean updatePatient(Patient patient) {
        String sql = "UPDATE patients SET blood_type = ?, allergies = ?, medical_history = ?, " +
                    ", updated_at = CURRENT_TIMESTAMP " +
                    "WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, patient.getBloodType());
            ps.setString(2, patient.getAllergies());
            ps.setString(3, patient.getMedicalHistory());
            ps.setInt(4, patient.getUserId());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}