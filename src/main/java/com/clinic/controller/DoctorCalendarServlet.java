package com.clinic.controller;

import java.io.IOException;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

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

@WebServlet("/doctor-calendar")
public class DoctorCalendarServlet extends HttpServlet {
    private BookingBO bookingBO = new BookingBO();
    private DoctorDAO doctorDAO = new DoctorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"doctor".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy doctor_id
        int doctorId = doctorDAO.getDoctorIdByUserId(user.getUserId());

        // Lấy tháng/năm từ request (nếu không có thì dùng tháng hiện tại)
        Calendar cal = Calendar.getInstance();
        int currentMonth = cal.get(Calendar.MONTH) + 1; // Calendar.MONTH bắt đầu từ 0
        int currentYear = cal.get(Calendar.YEAR);

        String monthParam = request.getParameter("month");
        String yearParam = request.getParameter("year");

        int month = (monthParam != null) ? Integer.parseInt(monthParam) : currentMonth;
        int year = (yearParam != null) ? Integer.parseInt(yearParam) : currentYear;

        // Lấy danh sách booking trong tháng
        List<Booking> bookings = bookingBO.getDoctorBookingsByMonth(doctorId, month, year);
        Map<String, Integer> bookingCounts = bookingBO.getBookingCountByDate(doctorId, month, year);

        // Set attributes
        request.setAttribute("bookings", bookings);
        request.setAttribute("bookingCounts", bookingCounts);
        request.setAttribute("month", month);
        request.setAttribute("year", year);
        request.setAttribute("currentMonth", currentMonth);
        request.setAttribute("currentYear", currentYear);

        request.getRequestDispatcher("/doctor/doctor-calendar.jsp").forward(request, response);
    }
}