package com.clinic.model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.clinic.model.bean.Booking;
import com.clinic.util.DBConnection;

public class BookingDAO {
	public boolean createBooking(Booking booking) {
        String sql = "INSERT INTO bookings (patient_id, doctor_id, appointment_date, symptoms, status) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, booking.getPatientId());
            ps.setInt(2, booking.getDoctorId());
            ps.setTimestamp(3, new Timestamp(booking.getAppointmentDate().getTime()));
            ps.setString(4, booking.getSymptoms());
            ps.setString(5, booking.getStatus());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
	// Lấy danh sách bác sĩ
    public List<Booking> getAvailableDoctors() {
        String sql = "SELECT d.doctor_id, u.full_name as doctor_name, d.specialization, u.phone " +
                    "FROM doctors d " +
                    "JOIN users u ON d.user_id = u.user_id " +
                    "WHERE u.role = 'doctor'";
        
        List<Booking> doctors = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Booking doctorInfo = new Booking();
                doctorInfo.setDoctorId(rs.getInt("doctor_id"));
                doctorInfo.setDoctorName(rs.getString("doctor_name"));
                doctorInfo.setSpecialization(rs.getString("specialization"));
                doctors.add(doctorInfo);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return doctors;
    }
 // Lấy danh sách booking theo patient_id
    public List<Booking> getBookingsByPatientId(int patientId) {
        String sql = "SELECT b.*, u.full_name as doctor_name, d.specialization " +
                    "FROM bookings b " +
                    "JOIN doctors d ON b.doctor_id = d.doctor_id " +
                    "JOIN users u ON d.user_id = u.user_id " +
                    "WHERE b.patient_id = ? " +
                    "ORDER BY b.appointment_date DESC";
        
        List<Booking> bookings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                bookings.add(extractBookingFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
    private Booking extractBookingFromResultSet(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingId(rs.getInt("booking_id"));
        booking.setPatientId(rs.getInt("patient_id"));
        booking.setDoctorId(rs.getInt("doctor_id"));
        booking.setAppointmentDate(rs.getTimestamp("appointment_date"));
        booking.setSymptoms(rs.getString("symptoms"));
        booking.setStatus(rs.getString("status"));
        booking.setDoctorName(rs.getString("doctor_name"));
        booking.setCreatedAt(rs.getTimestamp("created_at"));
        return booking;
    }
    
    //lấy danh sách booking theo bác sĩ
    public List<Booking> getBookingsByDoctorId(int doctorId){
    	String sql = """
    		    SELECT b.*,
    		           u.full_name AS patient_name,
    		           du.full_name AS doctor_name
    		    FROM bookings b
    		    JOIN patients p ON b.patient_id = p.patient_id
    		    JOIN users u ON p.user_id = u.user_id
    		    JOIN doctors d ON b.doctor_id = d.doctor_id
    		    JOIN users du ON d.user_id = du.user_id
    		    WHERE b.doctor_id = ?
    		    ORDER BY b.appointment_date DESC
    		""";
    	List<Booking> bookings = new ArrayList<>();
    	try(Connection conn = DBConnection.getConnection();
    			PreparedStatement ps = conn.prepareStatement(sql)){
    		ps.setInt(1, doctorId);
    		ResultSet rs = ps.executeQuery();
    		
    		while (rs.next()) {
                Booking booking = extractBookingFromResultSet(rs);
                booking.setPatientName(rs.getString("patient_name"));
                bookings.add(booking);
            }
    	}
    	catch (Exception e) {
			e.printStackTrace();
		}
    	return bookings;
    }
    
 // Cập nhật trạng thái booking
    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE bookings SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE booking_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
 // Thêm method này vào class BookingDAO hiện tại của bạn

 // Lấy danh sách booking theo doctor_id và tháng/năm
 public List<Booking> getBookingsByDoctorAndMonth(int doctorId, int month, int year) {
     String sql = """
         SELECT b.*,
                u.full_name AS patient_name,
                u.phone AS patient_phone,
                du.full_name AS doctor_name,
                d.specialization
         FROM bookings b
         JOIN patients p ON b.patient_id = p.patient_id
         JOIN users u ON p.user_id = u.user_id
         JOIN doctors d ON b.doctor_id = d.doctor_id
         JOIN users du ON d.user_id = du.user_id
         WHERE b.doctor_id = ?
         AND MONTH(b.appointment_date) = ?
         AND YEAR(b.appointment_date) = ?
         ORDER BY b.appointment_date ASC
     """;
     
     List<Booking> bookings = new ArrayList<>();
     
     try (Connection conn = DBConnection.getConnection();
          PreparedStatement ps = conn.prepareStatement(sql)) {
         
         ps.setInt(1, doctorId);
         ps.setInt(2, month);
         ps.setInt(3, year);
         ResultSet rs = ps.executeQuery();
         
         while (rs.next()) {
             Booking booking = extractBookingFromResultSet(rs);
             booking.setPatientName(rs.getString("patient_name"));
             bookings.add(booking);
         }
         
     } catch (SQLException e) {
         e.printStackTrace();
     }
     
     return bookings;
 }

 // Đếm số lượng booking theo ngày
 public Map<String, Integer> countBookingsByDate(int doctorId, int month, int year) {
     String sql = """
         SELECT DATE(appointment_date) as booking_date, COUNT(*) as count
         FROM bookings
         WHERE doctor_id = ?
         AND MONTH(appointment_date) = ?
         AND YEAR(appointment_date) = ?
         GROUP BY DATE(appointment_date)
     """;
     
     Map<String, Integer> countMap = new HashMap<>();
     
     try (Connection conn = DBConnection.getConnection();
          PreparedStatement ps = conn.prepareStatement(sql)) {
         
         ps.setInt(1, doctorId);
         ps.setInt(2, month);
         ps.setInt(3, year);
         ResultSet rs = ps.executeQuery();
         
         while (rs.next()) {
             String date = rs.getString("booking_date");
             int count = rs.getInt("count");
             countMap.put(date, count);
         }
         
     } catch (SQLException e) {
         e.printStackTrace();
     }
     
     return countMap;
 }
}
