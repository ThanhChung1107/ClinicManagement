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
import com.clinic.model.bean.User;
import com.clinic.model.bo.BookingBO;
import com.clinic.model.dao.DoctorDAO;

@WebServlet("/doctor-bookings")
public class DoctorBookingServlet extends HttpServlet{
	private BookingBO bookingBO = new BookingBO();
    private DoctorDAO doctorDAO = new DoctorDAO();
    
    @Override
    protected void doGet(HttpServletRequest request,HttpServletResponse response)
    		throws ServletException,IOException {
    	HttpSession session = request.getSession();
    	User user = (User) session.getAttribute("user");
    	
    	if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }
    	
    	int doctorId = doctorDAO.getDoctorIdByUserId(user.getUserId());
    	
    	List<Booking> bookings = bookingBO.getDoctorBookings(doctorId);
    	request.setAttribute("bookings", bookings);
    	
    	request.getRequestDispatcher("/doctor/doctor-bookings.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
    			throws ServletException, IOException {
    	request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        String bookingIdStr = request.getParameter("booking_id");
        
        try {
            int bookingId = Integer.parseInt(bookingIdStr);
            boolean success = false;
            
            if ("confirm".equals(action)) {
                success = bookingBO.updateBookingStatus(bookingId, "Đã xác nhận");  // ✅ SỬA
            } else if ("cancel".equals(action)) {
                success = bookingBO.updateBookingStatus(bookingId, "Hủy");  // ✅ SỬA
            } else if ("complete".equals(action)) {
                success = bookingBO.updateBookingStatus(bookingId, "Đã khám");  // ✅ SỬA
            }
            
            if (success) {
                response.sendRedirect("doctor-bookings?success=1");
            } else {
                response.sendRedirect("doctor-bookings?error=1");
            }
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("doctor-bookings?error=2");
        }	
    }
}
