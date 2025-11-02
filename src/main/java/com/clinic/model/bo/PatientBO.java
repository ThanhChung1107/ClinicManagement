package com.clinic.model.bo;

import com.clinic.model.bean.Patient;
import com.clinic.model.dao.PatientDAO;

public class PatientBO {
    private PatientDAO patientDAO = new PatientDAO();
    
    public boolean createPatientProfile(int userId) {
        return patientDAO.createPatient(userId);
    }
    
    public Patient getPatientProfile(int userId) {
        return patientDAO.getPatientByUserId(userId);
    }
    
    public boolean updatePatientProfile(Patient patient) {
        return patientDAO.updatePatient(patient);
    }
}