package com.clinic.model.bo;

import java.util.List;
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
}