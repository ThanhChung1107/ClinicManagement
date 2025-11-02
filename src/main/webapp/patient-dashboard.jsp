<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.clinic.model.bean.User"%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"patient".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard Bệnh nhân - MediCare</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation tương tự home.jsp -->
    
    <div class="container mt-4">
        <h2><i class="fas fa-user me-2"></i>Dashboard Bệnh nhân</h2>
        <div class="row mt-4">
            <div class="col-md-4">
                <div class="card text-white bg-primary">
                    <div class="card-body">
                        <h5 class="card-title">Đặt lịch khám</h5>
                        <p class="card-text">Đặt lịch khám với bác sĩ</p>
                        <a href="booking.jsp" class="btn btn-light">Đặt lịch ngay</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white bg-success">
                    <div class="card-body">
                        <h5 class="card-title">Lịch hẹn của tôi</h5>
                        <p class="card-text">Xem và quản lý lịch hẹn</p>
                        <a href="my-appointments.jsp" class="btn btn-light">Xem lịch hẹn</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white bg-info">
                    <div class="card-body">
                        <h5 class="card-title">Lịch sử khám</h5>
                        <p class="card-text">Xem lịch sử khám bệnh</p>
                        <a href="medical-history.jsp" class="btn btn-light">Xem lịch sử</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>