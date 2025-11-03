package com.clinic.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.clinic.model.bean.Booking;
import com.clinic.model.bean.Patient;
import com.clinic.model.bean.User;
import com.clinic.model.bo.BookingBO;
import com.clinic.model.bo.PatientBO;

@WebServlet("/my-bookings")
public class MyBookingsServlet extends HttpServlet {
    private BookingBO bookingBO = new BookingBO();
    private PatientBO patientBO = new PatientBO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Lấy patient_id từ user
        Patient patient = patientBO.getPatientProfile(user.getUserId());
        
        // Lấy danh sách booking của patient
        List<Booking> bookings = bookingBO.getPatientBookings(patient.getPatientId());
        request.setAttribute("bookings", bookings);
        
        request.getRequestDispatcher("/booking/my-bookings.jsp").forward(request, response);
    }
}