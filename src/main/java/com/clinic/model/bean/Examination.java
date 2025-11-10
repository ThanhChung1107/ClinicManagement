package com.clinic.model.bean;

import java.util.Date;
import java.util.List;

public class Examination {
    private int examId;
    private int bookingId;
    private String doctorNotes;
    private String diagnosis;
    private String bloodPressure;
    private double temperature;
    private int pulseRate;
    private Date nextAppointmentDate;
    private Date createdAt;
    
    // Thông tin bổ sung
    private Date appointmentDate;
    private String symptoms;
    private String doctorName;
    private List<Prescription> prescriptions;
    
    // Constructors
    public Examination() {}
    
    // Getters and Setters
    public int getExamId() { return examId; }
    public void setExamId(int examId) { this.examId = examId; }
    
    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    
    public String getDoctorNotes() { return doctorNotes; }
    public void setDoctorNotes(String doctorNotes) { this.doctorNotes = doctorNotes; }
    
    public String getDiagnosis() { return diagnosis; }
    public void setDiagnosis(String diagnosis) { this.diagnosis = diagnosis; }
    
    public String getBloodPressure() { return bloodPressure; }
    public void setBloodPressure(String bloodPressure) { this.bloodPressure = bloodPressure; }
    
    public double getTemperature() { return temperature; }
    public void setTemperature(double temperature) { this.temperature = temperature; }
    
    public int getPulseRate() { return pulseRate; }
    public void setPulseRate(int pulseRate) { this.pulseRate = pulseRate; }
    
    public Date getNextAppointmentDate() { return nextAppointmentDate; }
    public void setNextAppointmentDate(Date nextAppointmentDate) { 
        this.nextAppointmentDate = nextAppointmentDate; 
    }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public Date getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(Date appointmentDate) { this.appointmentDate = appointmentDate; }
    
    public String getSymptoms() { return symptoms; }
    public void setSymptoms(String symptoms) { this.symptoms = symptoms; }
    
    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }
    
    public List<Prescription> getPrescriptions() { return prescriptions; }
    public void setPrescriptions(List<Prescription> prescriptions) { this.prescriptions = prescriptions; }
}