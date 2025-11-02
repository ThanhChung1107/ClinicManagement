package com.clinic.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.clinic.model.bean.Patient;
import com.clinic.model.bean.User;
import com.clinic.model.bo.PatientBO;

@WebServlet("/patient-profile")  
public class PatientProfileServlet extends HttpServlet {
    private PatientBO patientBO = new PatientBO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Kiểm tra đăng nhập và role
        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Lấy thông tin patient
        Patient patient = patientBO.getPatientProfile(user.getUserId());
        
        // Nếu chưa có patient profile, tạo mới
        if (patient == null) {
            patientBO.createPatientProfile(user.getUserId());
            patient = patientBO.getPatientProfile(user.getUserId());
        }
        
        request.setAttribute("patient", patient);
        request.getRequestDispatcher("/patient/patient-profile.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Lấy dữ liệu từ form
        String bloodType = request.getParameter("blood_type");
        String allergies = request.getParameter("allergies");
        String medicalHistory = request.getParameter("medical_history");
        
        // Cập nhật thông tin
        Patient patient = new Patient();
        patient.setUserId(user.getUserId());
        patient.setBloodType(bloodType);
        patient.setAllergies(allergies);
        patient.setMedicalHistory(medicalHistory);
        
        boolean success = patientBO.updatePatientProfile(patient);
        
        if (success) {
            response.sendRedirect("patient-profile?success=1");
        } else {
            response.sendRedirect("patient-profile?error=1");
        }
    }
}