package com.clinic.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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
    // Lấy tất cả bệnh nhân đã từng đặt lịch với bác sĩ
    public List<Patient> getPatientsByDoctorId(int doctorId) {
        String sql = """
            SELECT DISTINCT p.patient_id, u.full_name, u.email, u.phone, 
                   u.gender, u.date_of_birth, p.blood_type, p.allergies,
                   (SELECT COUNT(*) FROM bookings WHERE patient_id = p.patient_id AND doctor_id = ?) as total_visits,
                   (SELECT MAX(appointment_date) FROM bookings WHERE patient_id = p.patient_id AND doctor_id = ?) as last_visit
            FROM patients p
            JOIN users u ON p.user_id = u.user_id
            JOIN bookings b ON p.patient_id = b.patient_id
            WHERE b.doctor_id = ?
            ORDER BY last_visit DESC
        """;
        
        List<Patient> patients = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ps.setInt(2, doctorId);
            ps.setInt(3, doctorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Patient patient = new Patient();
                patient.setPatientId(rs.getInt("patient_id"));
                patient.setFullName(rs.getString("full_name"));
                patient.setEmail(rs.getString("email"));
                patient.setPhone(rs.getString("phone"));
                patient.setGender(rs.getString("gender"));
                patient.setDateOfBirth(rs.getDate("date_of_birth"));
                patient.setBloodType(rs.getString("blood_type"));
                patient.setAllergies(rs.getString("allergies"));
                patient.setTotalVisits(rs.getInt("total_visits"));
                patient.setLastVisit(rs.getTimestamp("last_visit"));
                patients.add(patient);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return patients;
    }
    
    // Lấy bệnh nhân có lịch hẹn đã xác nhận
    public List<Patient> getConfirmedPatientsByDoctorId(int doctorId) {
        String sql = """
            SELECT DISTINCT p.patient_id, u.full_name, u.email, u.phone, 
                   u.gender, u.date_of_birth, p.blood_type, p.allergies,
                   b.booking_id, b.appointment_date, b.symptoms, b.status
            FROM patients p
            JOIN users u ON p.user_id = u.user_id
            JOIN bookings b ON p.patient_id = b.patient_id
            WHERE b.doctor_id = ? AND b.status = 'Đã xác nhận'
            ORDER BY b.appointment_date ASC
        """;
        
        List<Patient> patients = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Patient patient = new Patient();
                patient.setPatientId(rs.getInt("patient_id"));
                patient.setFullName(rs.getString("full_name"));
                patient.setEmail(rs.getString("email"));
                patient.setPhone(rs.getString("phone"));
                patient.setGender(rs.getString("gender"));
                patient.setDateOfBirth(rs.getDate("date_of_birth"));
                patient.setBloodType(rs.getString("blood_type"));
                patient.setAllergies(rs.getString("allergies"));
                patient.setBookingId(rs.getInt("booking_id"));
                patient.setAppointmentDate(rs.getTimestamp("appointment_date"));
                patient.setSymptoms(rs.getString("symptoms"));
                patient.setStatus(rs.getString("status"));
                patients.add(patient);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return patients;
    }
    
    // Lấy chi tiết bệnh nhân theo patient_id
    public Patient getPatientById(int patientId) {
        String sql = """
            SELECT p.*, u.full_name, u.email, u.phone, u.gender, u.date_of_birth
            FROM patients p
            JOIN users u ON p.user_id = u.user_id
            WHERE p.patient_id = ?
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Patient patient = new Patient();
                patient.setPatientId(rs.getInt("patient_id"));
                patient.setUserId(rs.getInt("user_id"));
                patient.setFullName(rs.getString("full_name"));
                patient.setEmail(rs.getString("email"));
                patient.setPhone(rs.getString("phone"));
                patient.setGender(rs.getString("gender"));
                patient.setDateOfBirth(rs.getDate("date_of_birth"));
                patient.setBloodType(rs.getString("blood_type"));
                patient.setAllergies(rs.getString("allergies"));
                patient.setMedicalHistory(rs.getString("medical_history"));
                return patient;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
 // Cập nhật thông tin bệnh nhân
    public boolean updatePatient(Patient patient) {
        String sqlUser = """
            UPDATE users 
            SET full_name = ?, phone = ?, gender = ?, date_of_birth = ?
            WHERE user_id = ?
        """;
        
        String sqlPatient = """
            UPDATE patients 
            SET blood_type = ?, allergies = ?, medical_history = ?
            WHERE patient_id = ?
        """;
        
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // Update users table
            try (PreparedStatement ps = conn.prepareStatement(sqlUser)) {
                ps.setString(1, patient.getFullName());
                ps.setString(2, patient.getPhone());
                ps.setString(3, patient.getGender());
                ps.setDate(4, patient.getDateOfBirth() != null ? 
                    new java.sql.Date(patient.getDateOfBirth().getTime()) : null);
                ps.setInt(5, patient.getUserId());
                ps.executeUpdate();
            }
            
            // Update patients table
            try (PreparedStatement ps = conn.prepareStatement(sqlPatient)) {
                ps.setString(1, patient.getBloodType());
                ps.setString(2, patient.getAllergies());
                ps.setString(3, patient.getMedicalHistory());
                ps.setInt(4, patient.getPatientId());
                ps.executeUpdate();
            }
            
            conn.commit();
            return true;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        
        return false;
    }
}