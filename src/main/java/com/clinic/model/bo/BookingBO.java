package com.clinic.model.bo;

import java.util.List;
import java.util.Map;

import com.clinic.model.bean.Booking;
import com.clinic.model.dao.BookingDAO;

public class BookingBO {
    private BookingDAO bookingDAO = new BookingDAO();
    
    public boolean createBooking(Booking booking) {
        return bookingDAO.createBooking(booking);
    }
    
    public List<Booking> getPatientBookings(int patientId) {
        return bookingDAO.getBookingsByPatientId(patientId);
    }
    
    public List<Booking> getAvailableDoctors() {
        return bookingDAO.getAvailableDoctors();
    }
    public List<Booking> getDoctorBookings(int doctorId) {
        return bookingDAO.getBookingsByDoctorId(doctorId);
    }

    public boolean updateBookingStatus(int bookingId, String status) {
        return bookingDAO.updateBookingStatus(bookingId, status);
    }
    public List<Booking> getDoctorBookingsByMonth(int doctorId, int month, int year) {
        return bookingDAO.getBookingsByDoctorAndMonth(doctorId, month, year);
    }

    public Map<String, Integer> getBookingCountByDate(int doctorId, int month, int year) {
        return bookingDAO.countBookingsByDate(doctorId, month, year);
    }
}