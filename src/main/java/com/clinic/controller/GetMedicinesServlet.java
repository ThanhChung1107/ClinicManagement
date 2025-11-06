package com.clinic.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.clinic.model.bean.Medicine;
import com.clinic.model.dao.MedicineDAO;

@WebServlet("/get-medicines")
public class GetMedicinesServlet extends HttpServlet {
    private MedicineDAO medicineDAO = new MedicineDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            String keyword = request.getParameter("keyword");
            List<Medicine> medicines;
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                medicines = medicineDAO.searchMedicines(keyword);
            } else {
                medicines = medicineDAO.getAllMedicines();
            }
            
            // Tạo JSON
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < medicines.size(); i++) {
                Medicine m = medicines.get(i);
                if (i > 0) json.append(",");
                
                json.append("{");
                json.append("\"medicineId\": ").append(m.getMedicineId()).append(",");
                json.append("\"name\": \"").append(escapeJson(m.getName())).append("\",");
                json.append("\"unit\": \"").append(escapeJson(m.getUnit())).append("\",");
                json.append("\"price\": ").append(m.getPrice());
                json.append("}");
            }
            json.append("]");
            
            out.print(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            out.print("[]");
        }
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r");
    }
}