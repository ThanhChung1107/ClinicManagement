package com.clinic.model.bo;

import com.clinic.model.bean.User;
import com.clinic.model.dao.PatientDAO;
import com.clinic.model.dao.UserDAO;

public class UserBO {
    private UserDAO userDAO = new UserDAO();
    private PatientDAO patientDAO = new PatientDAO();

    public boolean register(User user) {
        return userDAO.register(user);
    }

    public User login(String email, String password) {
        return userDAO.login(email, password);
    }
    public boolean createPatientProfile(User user) {
        return patientDAO.createPatient(user);
    }
    
}