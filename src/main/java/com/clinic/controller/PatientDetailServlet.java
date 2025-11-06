package com.clinic.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.clinic.model.bean.Examination;
import com.clinic.model.bean.Patient;
import com.clinic.model.bean.Prescription;
import com.clinic.model.dao.ExaminationDAO;
import com.clinic.model.dao.PatientDAO;
import com.clinic.model.dao.PrescriptionDAO;

@WebServlet("/patient-detail")
public class PatientDetailServlet extends HttpServlet {
    private PatientDAO patientDAO = new PatientDAO();
    private ExaminationDAO examinationDAO = new ExaminationDAO();
    private PrescriptionDAO prescriptionDAO = new PrescriptionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int patientId = Integer.parseInt(request.getParameter("patient_id"));
            
            // Lấy thông tin bệnh nhân
            Patient patient = patientDAO.getPatientById(patientId);
            
            if (patient == null) {
                out.print("{\"error\": \"Không tìm thấy bệnh nhân\"}");
                return;
            }
            
            // Lấy lịch sử khám
            List<Examination> examinations = examinationDAO.getExaminationsByPatientId(patientId);
            
            // Tạo JSON response
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            SimpleDateFormat datetimeFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            
            StringBuilder json = new StringBuilder();
            json.append("{");
            
            // Thông tin bệnh nhân
            json.append("\"patient\": {");
            json.append("\"patientId\": ").append(patient.getPatientId()).append(",");
            json.append("\"fullName\": \"").append(escapeJson(patient.getFullName())).append("\",");
            json.append("\"email\": \"").append(escapeJson(patient.getEmail())).append("\",");
            json.append("\"phone\": \"").append(escapeJson(patient.getPhone())).append("\",");
            json.append("\"gender\": \"").append(escapeJson(patient.getGender())).append("\",");
            json.append("\"dateOfBirth\": \"").append(patient.getDateOfBirth() != null ? dateFormat.format(patient.getDateOfBirth()) : "").append("\",");
            json.append("\"bloodType\": \"").append(escapeJson(patient.getBloodType())).append("\",");
            json.append("\"allergies\": \"").append(escapeJson(patient.getAllergies())).append("\",");
            json.append("\"medicalHistory\": \"").append(escapeJson(patient.getMedicalHistory())).append("\"");
            json.append("},");
            
            // Lịch sử khám
            json.append("\"examinations\": [");
            for (int i = 0; i < examinations.size(); i++) {
                Examination exam = examinations.get(i);
                if (i > 0) json.append(",");
                
                json.append("{");
                json.append("\"examId\": ").append(exam.getExamId()).append(",");
                json.append("\"appointmentDate\": \"").append(datetimeFormat.format(exam.getAppointmentDate())).append("\",");
                json.append("\"symptoms\": \"").append(escapeJson(exam.getSymptoms())).append("\",");
                json.append("\"diagnosis\": \"").append(escapeJson(exam.getDiagnosis())).append("\",");
                json.append("\"doctorNotes\": \"").append(escapeJson(exam.getDoctorNotes())).append("\",");
                json.append("\"bloodPressure\": \"").append(escapeJson(exam.getBloodPressure())).append("\",");
                json.append("\"temperature\": ").append(exam.getTemperature()).append(",");
                json.append("\"pulseRate\": ").append(exam.getPulseRate()).append(",");
                json.append("\"doctorName\": \"").append(escapeJson(exam.getDoctorName())).append("\",");
                
                // Lấy đơn thuốc
                List<Prescription> prescriptions = prescriptionDAO.getPrescriptionsByExamId(exam.getExamId());
                json.append("\"prescriptions\": [");
                for (int j = 0; j < prescriptions.size(); j++) {
                    Prescription p = prescriptions.get(j);
                    if (j > 0) json.append(",");
                    json.append("{");
                    json.append("\"medicineName\": \"").append(escapeJson(p.getMedicineName())).append("\",");
                    json.append("\"quantity\": ").append(p.getQuantity()).append(",");
                    json.append("\"unit\": \"").append(escapeJson(p.getUnit())).append("\",");
                    json.append("\"dosage\": \"").append(escapeJson(p.getDosage())).append("\"");
                    json.append("}");
                }
                json.append("]");
                
                json.append("}");
            }
            json.append("]");
            
            json.append("}");
            
            out.print(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}