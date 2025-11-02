<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.clinic.model.bean.User"%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"doctor".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard Bác sĩ - MediCare</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation tương tự home.jsp -->
    
    <div class="container mt-4">
        <h2><i class="fas fa-user-md me-2"></i>Dashboard Bác sĩ</h2>
        <div class="row mt-4">
            <div class="col-md-4">
                <div class="card text-white bg-primary">
                    <div class="card-body">
                        <h5 class="card-title">Lịch hẹn hôm nay</h5>
                        <p class="card-text">Xem lịch hẹn trong ngày</p>
                        <a href="doctor-appointments.jsp" class="btn btn-light">Xem lịch hẹn</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white bg-success">
                    <div class="card-body">
                        <h5 class="card-title">Quản lý lịch trình</h5>
                        <p class="card-text">Đặt lịch làm việc</p>
                        <a href="doctor-schedule.jsp" class="btn btn-light">Quản lý lịch</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white bg-info">
                    <div class="card-body">
                        <h5 class="card-title">Hồ sơ bệnh nhân</h5>
                        <p class="card-text">Quản lý hồ sơ bệnh nhân</p>
                        <a href="patient-records.jsp" class="btn btn-light">Xem hồ sơ</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>