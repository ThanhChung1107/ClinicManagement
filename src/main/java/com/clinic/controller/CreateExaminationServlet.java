package com.clinic.controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.clinic.model.bean.Examination;
import com.clinic.model.bean.Prescription;
import com.clinic.model.dao.BookingDAO;
import com.clinic.model.dao.ExaminationDAO;
import com.clinic.model.dao.PrescriptionDAO;

@WebServlet("/create-examination")
public class CreateExaminationServlet extends HttpServlet {
    private ExaminationDAO examinationDAO = new ExaminationDAO();
    private PrescriptionDAO prescriptionDAO = new PrescriptionDAO();
    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        try {
            // Lấy thông tin examination
            int bookingId = Integer.parseInt(request.getParameter("booking_id"));
            String doctorNotes = request.getParameter("doctor_notes");
            String diagnosis = request.getParameter("diagnosis");
            String bloodPressure = request.getParameter("blood_pressure");
            double temperature = Double.parseDouble(request.getParameter("temperature"));
            int pulseRate = Integer.parseInt(request.getParameter("pulse_rate"));
            
            String nextAppointmentDateStr = request.getParameter("next_appointment_date");
            Date nextAppointmentDate = null;
            if (nextAppointmentDateStr != null && !nextAppointmentDateStr.isEmpty()) {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                nextAppointmentDate = sdf.parse(nextAppointmentDateStr);
            }
            
            // Tạo examination
            Examination examination = new Examination();
            examination.setBookingId(bookingId);
            examination.setDoctorNotes(doctorNotes);
            examination.setDiagnosis(diagnosis);
            examination.setBloodPressure(bloodPressure);
            examination.setTemperature(temperature);
            examination.setPulseRate(pulseRate);
            examination.setNextAppointmentDate(nextAppointmentDate);
            
            int examId = examinationDAO.createExamination(examination);
            
            if (examId > 0) {
                // Lấy danh sách thuốc đã chọn
                String[] medicineIds = request.getParameterValues("medicine_ids[]");
                String[] quantities = request.getParameterValues("quantities[]");
                String[] dosages = request.getParameterValues("dosages[]");
                
                // Lưu đơn thuốc
                if (medicineIds != null && medicineIds.length > 0) {
                    for (int i = 0; i < medicineIds.length; i++) {
                        Prescription prescription = new Prescription();
                        prescription.setExamId(examId);
                        prescription.setMedicineId(Integer.parseInt(medicineIds[i]));
                        prescription.setQuantity(Integer.parseInt(quantities[i]));
                        prescription.setDosage(dosages[i]);
                        
                        prescriptionDAO.createPrescription(prescription);
                    }
                }
                
                // Cập nhật trạng thái booking thành "Đã khám"
                bookingDAO.updateBookingStatus(bookingId, "Đã khám");
                
                response.sendRedirect("doctor-patients?success=1");
            } else {
                response.sendRedirect("doctor-patients?error=1");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("doctor-patients?error=1");
        }
    }
}