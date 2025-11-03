package com.clinic.controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
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

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {
	private BookingBO bookingBO = new BookingBO();
    private PatientBO patientBO = new PatientBO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
    		throws ServletException, IOException {
    	HttpSession session = request.getSession();
    	
    	User user = (User) session.getAttribute("user");
    	
    	if(user == null || !"patient".equals(user.getRole())) {
    		response.sendRedirect("login.jsp");
    		return;
    	}
    	
    	//lấy danh sách bác sĩ
    	List<Booking> doctors = bookingBO.getAvailableDoctors();
    	request.setAttribute("doctors", doctors);
    	
    	request.getRequestDispatcher("/booking/booking.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
    			throws ServletException, IOException {
    	request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        //lấy dữ liệu
        String doctorIdStr = request.getParameter("doctor_id");
        String appointmentDateStr = request.getParameter("appointment_date");
        String appointmentTimeStr = request.getParameter("appointment_time");
        String symptoms = request.getParameter("symptoms");
        
        //lấy bệnh nhân từ user_id
        Patient patient = patientBO.getPatientProfile(user.getUserId());
        
        try {
        	int doctorId = Integer.parseInt(doctorIdStr);
        	
        	// Kết hợp date và time
            String dateTimeStr = appointmentDateStr + " " + appointmentTimeStr;
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            Date appointmentDate = sdf.parse(dateTimeStr);
            
            //tạo booking
            Booking booking = new Booking();
            booking.setPatientId(patient.getPatientId());
            booking.setDoctorId(doctorId);
            booking.setAppointmentDate(appointmentDate);
            booking.setSymptoms(symptoms);
            
            boolean success = bookingBO.createBooking(booking);
            
            if (success) {
                response.sendRedirect("my-bookings?success=1");
            } else {
                response.sendRedirect("booking?error=1");
            }
		} catch (Exception e) {
			// TODO: handle exception
		}
    }
}
