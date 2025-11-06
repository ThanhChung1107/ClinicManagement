package com.clinic.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.clinic.model.bean.Prescription;
import com.clinic.util.DBConnection;

public class PrescriptionDAO {
    
    // Tạo đơn thuốc
    public boolean createPrescription(Prescription prescription) {
        String sql = "INSERT INTO prescriptions (exam_id, medicine_id, quantity, dosage) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, prescription.getExamId());
            ps.setInt(2, prescription.getMedicineId());
            ps.setInt(3, prescription.getQuantity());
            ps.setString(4, prescription.getDosage());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    // Lấy đơn thuốc theo exam_id
    public List<Prescription> getPrescriptionsByExamId(int examId) {
        String sql = """
            SELECT p.*, m.name as medicine_name, m.unit, m.price
            FROM prescriptions p
            JOIN medicines m ON p.medicine_id = m.medicine_id
            WHERE p.exam_id = ?
        """;
        
        List<Prescription> prescriptions = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, examId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Prescription prescription = new Prescription();
                prescription.setPrescriptionId(rs.getInt("prescription_id"));
                prescription.setExamId(rs.getInt("exam_id"));
                prescription.setMedicineId(rs.getInt("medicine_id"));
                prescription.setQuantity(rs.getInt("quantity"));
                prescription.setDosage(rs.getString("dosage"));
                prescription.setMedicineName(rs.getString("medicine_name"));
                prescription.setUnit(rs.getString("unit"));
                prescription.setPrice(rs.getDouble("price"));
                prescriptions.add(prescription);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return prescriptions;
    }
}