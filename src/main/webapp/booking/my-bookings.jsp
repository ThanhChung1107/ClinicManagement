<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.clinic.model.bean.Booking"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    if (bookings == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch hẹn của tôi - MediCare Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .bookings-header {
            background: linear-gradient(135deg, #1a76d2, #34a853);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .booking-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
        }
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .status-pending { background-color: #fff3cd; color: #856404; }
        .status-confirmed { background-color: #d1ecf1; color: #0c5460; }
        .status-completed { background-color: #d4edda; color: #155724; }
        .status-cancelled { background-color: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <jsp:include page="../includes/header.jsp" />
    
    <!-- Bookings Header -->
    <div class="bookings-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1><i class="fas fa-calendar-check me-2"></i>Lịch hẹn của tôi</h1>
                    <p class="mb-0">Quản lý và theo dõi các lịch hẹn khám bệnh</p>
                </div>
                <div class="col-md-4 text-end">
                    <a href="booking" class="btn btn-light">
                        <i class="fas fa-plus me-2"></i>Đặt lịch mới
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Thông báo -->
        <% if ("1".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>Đặt lịch thành công! Vui lòng chờ xác nhận từ phòng khám.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <% if (bookings.isEmpty()) { %>
            <div class="text-center py-5">
                <i class="fas fa-calendar-times fa-4x text-muted mb-3"></i>
                <h3 class="text-muted">Chưa có lịch hẹn nào</h3>
                <p class="text-muted">Hãy đặt lịch khám đầu tiên của bạn</p>
                <a href="booking" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>Đặt lịch ngay
                </a>
            </div>
        <% } else { %>
            <div class="row">
                <div class="col-12">
                    <% for (Booking booking : bookings) { %>
                        <div class="card booking-card">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-3">
                                        <div class="d-flex align-items-center">
                                            <div class="bg-primary text-white rounded p-3 me-3">
                                                <i class="fas fa-calendar-alt fa-2x"></i>
                                            </div>
                                            <div>
                                                <h6 class="mb-1"><%= dateFormat.format(booking.getAppointmentDate()) %></h6>
                                                <p class="text-muted mb-0"><%= timeFormat.format(booking.getAppointmentDate()) %></p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <h6 class="mb-1">Bác sĩ</h6>
                                        <p class="mb-0"><%= booking.getDoctorName() %></p>
                                        <small class="text-muted"><%= booking.getSpecialization() %></small>
                                    </div>
                                    <div class="col-md-3">
                                        <h6 class="mb-1">Triệu chứng</h6>
                                        <p class="mb-0 text-truncate" style="max-width: 200px;">
                                            <%= booking.getSymptoms() != null && !booking.getSymptoms().isEmpty() ? 
                                                booking.getSymptoms() : "Không có mô tả" %>
                                        </p>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <span class="status-badge status-<%= booking.getStatus() %>">
                                                <% 
                                                    switch(booking.getStatus()) {
                                                        case "pending": out.print("Chờ xác nhận"); break;
                                                        case "confirmed": out.print("Đã xác nhận"); break;
                                                        case "completed": out.print("Đã hoàn thành"); break;
                                                        case "cancelled": out.print("Đã hủy"); break;
                                                    }
                                                %>
                                            </span>
                                            <div class="dropdown">
                                                <button class="btn btn-sm btn-outline-secondary dropdown-toggle" 
                                                        type="button" data-bs-toggle="dropdown">
                                                    <i class="fas fa-ellipsis-v"></i>
                                                </button>
                                                <ul class="dropdown-menu">
                                                    <li><a class="dropdown-item" href="#">
                                                        <i class="fas fa-eye me-2"></i>Xem chi tiết
                                                    </a></li>
                                                    <% if ("pending".equals(booking.getStatus())) { %>
                                                        <li><a class="dropdown-item text-danger" href="#">
                                                            <i class="fas fa-times me-2"></i>Hủy lịch hẹn
                                                        </a></li>
                                                    <% } %>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        <% } %>
    </div>

    <jsp:include page="../includes/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>