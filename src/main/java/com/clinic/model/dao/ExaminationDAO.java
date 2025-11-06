package com.clinic.model.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.clinic.model.bean.Examination;
import com.clinic.util.DBConnection;

public class ExaminationDAO {
    
    // Tạo examination mới và trả về exam_id
    public int createExamination(Examination exam) {
        String sql = """
            INSERT INTO examinations 
            (booking_id, doctor_notes, diagnosis, blood_pressure, temperature, pulse_rate, next_appointment_date) 
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, exam.getBookingId());
            ps.setString(2, exam.getDoctorNotes());
            ps.setString(3, exam.getDiagnosis());
            ps.setString(4, exam.getBloodPressure());
            ps.setDouble(5, exam.getTemperature());
            ps.setInt(6, exam.getPulseRate());
            ps.setDate(7, exam.getNextAppointmentDate() != null ? 
                new Date(exam.getNextAppointmentDate().getTime()) : null);
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return -1;
    }
    
    // Lấy lịch sử khám của bệnh nhân
    public List<Examination> getExaminationsByPatientId(int patientId) {
        String sql = """
            SELECT e.*, b.appointment_date, b.symptoms, u.full_name as doctor_name
            FROM examinations e
            JOIN bookings b ON e.booking_id = b.booking_id
            JOIN doctors d ON b.doctor_id = d.doctor_id
            JOIN users u ON d.user_id = u.user_id
            WHERE b.patient_id = ?
            ORDER BY e.created_at DESC
        """;
        
        List<Examination> examinations = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Examination exam = extractExaminationFromResultSet(rs);
                exam.setAppointmentDate(rs.getTimestamp("appointment_date"));
                exam.setSymptoms(rs.getString("symptoms"));
                exam.setDoctorName(rs.getString("doctor_name"));
                examinations.add(exam);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return examinations;
    }
    
    // Lấy examination theo booking_id
    public Examination getExaminationByBookingId(int bookingId) {
        String sql = "SELECT * FROM examinations WHERE booking_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractExaminationFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Helper method
    private Examination extractExaminationFromResultSet(ResultSet rs) throws SQLException {
        Examination exam = new Examination();
        exam.setExamId(rs.getInt("exam_id"));
        exam.setBookingId(rs.getInt("booking_id"));
        exam.setDoctorNotes(rs.getString("doctor_notes"));
        exam.setDiagnosis(rs.getString("diagnosis"));
        exam.setBloodPressure(rs.getString("blood_pressure"));
        exam.setTemperature(rs.getDouble("temperature"));
        exam.setPulseRate(rs.getInt("pulse_rate"));
        exam.setNextAppointmentDate(rs.getDate("next_appointment_date"));
        exam.setCreatedAt(rs.getTimestamp("created_at"));
        return exam;
    }
}