package com.clinic.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.clinic.model.bean.User;
import com.clinic.model.bo.UserBO;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        // Lấy dữ liệu từ form
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String gender = request.getParameter("gender");
        String phone = request.getParameter("phone");
        
        // Tạo đối tượng user
        User user = new User();
        user.setFullname(fullname);
        user.setEmail(email);
        user.setGender(gender);
        user.setPassword(password);
        user.setPhone(phone);
        user.setRole("patient");
        
        // Xử lý logic đăng ký
        UserBO userBO = new UserBO();
        if (userBO.register(user)) {
            // Nếu là bệnh nhân thì tự động tạo profile trong bảng patients
            if ("patient".equals(user.getRole())) {
                userBO.createPatientProfile(user);
            }
            response.sendRedirect("login.jsp?success=1");
        } else {
            response.sendRedirect("register.jsp?error=1");
        }
    }
}
