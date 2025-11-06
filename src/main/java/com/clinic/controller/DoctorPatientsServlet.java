package com.clinic.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.clinic.model.bean.Patient;
import com.clinic.model.bean.User;
import com.clinic.model.dao.DoctorDAO;
import com.clinic.model.dao.PatientDAO;

@WebServlet("/doctor-patients")
public class DoctorPatientsServlet extends HttpServlet{
	private PatientDAO patientDAO = new PatientDAO();
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
    	
    	int doctorId = doctorDAO.getDoctorIdByUserId(user.getUserId());
    	
    	//lấy tất cả bệnh nhân
    	List<Patient> allPatients = patientDAO.getPatientsByDoctorId(doctorId);
    	
    	//lấy các bệnh nhân đã xác nhận
    	List<Patient> confirmedPatients = patientDAO.getConfirmedPatientsByDoctorId(doctorId);
    	
    	request.setAttribute("allPatients", allPatients);
        request.setAttribute("confirmedPatients", confirmedPatients);
        
        request.getRequestDispatcher("/doctor/doctor-patients.jsp").forward(request, response);
    }
}
