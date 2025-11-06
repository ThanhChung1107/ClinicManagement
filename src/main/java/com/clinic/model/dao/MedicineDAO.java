package com.clinic.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.clinic.model.bean.Medicine;
import com.clinic.util.DBConnection;

public class MedicineDAO {
    
    // Lấy tất cả thuốc
    public List<Medicine> getAllMedicines() {
        String sql = "SELECT * FROM medicines ORDER BY name ASC";
        List<Medicine> medicines = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Medicine medicine = new Medicine();
                medicine.setMedicineId(rs.getInt("medicine_id"));
                medicine.setName(rs.getString("name"));
                medicine.setUnit(rs.getString("unit"));
                medicine.setPrice(rs.getDouble("price"));
                medicines.add(medicine);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return medicines;
    }
    
    // Tìm thuốc theo tên
    public List<Medicine> searchMedicines(String keyword) {
        String sql = "SELECT * FROM medicines WHERE name LIKE ? ORDER BY name ASC";
        List<Medicine> medicines = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Medicine medicine = new Medicine();
                medicine.setMedicineId(rs.getInt("medicine_id"));
                medicine.setName(rs.getString("name"));
                medicine.setUnit(rs.getString("unit"));
                medicine.setPrice(rs.getDouble("price"));
                medicines.add(medicine);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return medicines;
    }
}