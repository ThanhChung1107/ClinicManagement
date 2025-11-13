package com.clinic.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.clinic.model.bean.Examination;
import com.clinic.model.bean.Patient;
import com.clinic.model.bean.Prescription;
import com.clinic.model.bean.User;
import com.clinic.model.bo.PatientBO;
import com.clinic.model.dao.ExaminationDAO;
import com.clinic.model.dao.PrescriptionDAO;

@WebServlet("/patient-profile")
public class PatientProfileServlet extends HttpServlet {
    private PatientBO patientBO = new PatientBO();
    private ExaminationDAO examinationDAO = new ExaminationDAO();
    private PrescriptionDAO prescriptionDAO = new PrescriptionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Kiểm tra đăng nhập và quyền
        if (user == null || !"patient".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Lấy thông tin hồ sơ bệnh nhân dựa trên user_id
        Patient patient = patientBO.getPatientProfile(user.getUserId());

        // Nếu chưa có hồ sơ, tạo mới
        if (patient == null) {
            patientBO.createPatientProfile(user.getUserId());
            patient = patientBO.getPatientProfile(user.getUserId());
        }

        // Lấy lịch sử khám dựa trên patient_id
        List<Examination> examinations = examinationDAO.getExaminationsByPatientId(patient.getPatientId());

        // Gắn đơn thuốc cho từng lần khám
        for (Examination exam : examinations) {
            List<Prescription> prescriptions = prescriptionDAO.getPrescriptionsByExamId(exam.getExamId());
            exam.setPrescriptions(prescriptions);
        }

        // Gửi dữ liệu sang JSP
        request.setAttribute("patient", patient);
        request.setAttribute("examinations", examinations);
        request.getRequestDispatcher("/patient-profile.jsp").forward(request, response);
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

        try {
            // Lấy thông tin bệnh nhân hiện tại (để có patient_id và user_id)
            Patient currentPatient = patientBO.getPatientProfile(user.getUserId());
            if (currentPatient == null) {
                response.sendRedirect("patient-profile?error=1");
                return;
            }

            // Lấy TẤT CẢ dữ liệu từ form
            String fullName = request.getParameter("full_name");
            String phone = request.getParameter("phone");
            String gender = request.getParameter("gender");
            String dobString = request.getParameter("date_of_birth"); // Định dạng yyyy-MM-dd
            
            String bloodType = request.getParameter("blood_type");
            String allergies = request.getParameter("allergies");
            String medicalHistory = request.getParameter("medical_history");

            // Chuyển đổi ngày sinh
            java.util.Date dateOfBirth = null;
            if (dobString != null && !dobString.isEmpty()) {
                try {
                    // Định dạng input type="date" là yyyy-MM-dd
                    dateOfBirth = new java.text.SimpleDateFormat("yyyy-MM-dd").parse(dobString);
                } catch (java.text.ParseException e) {
                    e.printStackTrace(); // Xử lý lỗi nếu ngày không đúng định dạng
                }
            }

            // Tạo đối tượng Patient MỚI với đầy đủ thông tin để cập nhật
            Patient patientToUpdate = new Patient();
            
            // ID (Rất quan trọng để biết cập nhật hàng nào)
            patientToUpdate.setUserId(currentPatient.getUserId());
            patientToUpdate.setPatientId(currentPatient.getPatientId());
            
            // Thông tin từ bảng users
            patientToUpdate.setFullName(fullName);
            patientToUpdate.setPhone(phone);
            patientToUpdate.setGender(gender);
            patientToUpdate.setDateOfBirth(dateOfBirth);
            
            // Thông tin từ bảng patients
            patientToUpdate.setBloodType(bloodType);
            patientToUpdate.setAllergies(allergies);
            patientToUpdate.setMedicalHistory(medicalHistory);

            // Gọi BO để cập nhật
            boolean success = patientBO.updatePatientProfile(patientToUpdate);

            if (success) {
                // Cập nhật lại thông tin user trong session nếu tên thay đổi
                user.setFullname(fullName);
                session.setAttribute("user", user);
                
                response.sendRedirect("patient-profile?success=1");
            } else {
                response.sendRedirect("patient-profile?error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("patient-profile?error=1");
        }
    }
}
