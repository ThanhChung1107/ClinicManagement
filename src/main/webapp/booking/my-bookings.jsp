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
            transition: transform 0.3s ease;
        }
        .booking-card:hover {
            transform: translateY(-5px);
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
        .status-in-progress { background-color: #cce7ff; color: #004085; }
        
        /* Tabs styling */
        .nav-tabs .nav-link {
            border: none;
            color: #6c757d;
            font-weight: 500;
            padding: 0.75rem 1.5rem;
        }
        .nav-tabs .nav-link.active {
            color: #1a76d2;
            border-bottom: 3px solid #1a76d2;
            background: transparent;
        }
        .nav-tabs .nav-link:hover {
            border: none;
            border-bottom: 3px solid #dee2e6;
        }
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

        <!-- Tabs Navigation -->
        <ul class="nav nav-tabs mb-4" id="bookingsTab" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="all-tab" data-bs-toggle="tab" data-bs-target="#all" type="button" role="tab">
                    <i class="fas fa-list me-1"></i>Tất cả
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="pending-tab" data-bs-toggle="tab" data-bs-target="#pending" type="button" role="tab">
                    <i class="fas fa-clock me-1"></i>Chờ xác nhận
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="confirmed-tab" data-bs-toggle="tab" data-bs-target="#confirmed" type="button" role="tab">
                    <i class="fas fa-check-circle me-1"></i>Đã xác nhận
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="completed-tab" data-bs-toggle="tab" data-bs-target="#completed" type="button" role="tab">
                    <i class="fas fa-check-double me-1"></i>Đã hoàn thành
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="cancelled-tab" data-bs-toggle="tab" data-bs-target="#cancelled" type="button" role="tab">
                    <i class="fas fa-times-circle me-1"></i>Đã hủy
                </button>
            </li>
        </ul>

        <!-- Tab Content -->
        <div class="tab-content" id="bookingsTabContent">
            <!-- Tab Tất cả -->
            <div class="tab-pane fade show active" id="all" role="tabpanel">
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
                                                                case "Chờ xác nhận": out.print("Chờ xác nhận"); break;
                                                                case "Đã xác nhận": out.print("Đã xác nhận"); break;
                                                                case "Đã khám": out.print("Đã hoàn thành"); break;
                                                                case "cancelled": out.print("Đã hủy"); break;
                                                                case "in-progress": out.print("Đang khám"); break;
                                                                default: out.print(booking.getStatus());
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
                                                            <% if ("pending".equals(booking.getStatus()) || "confirmed".equals(booking.getStatus())) { %>
                                                                <li><a class="dropdown-item text-danger" href="#">
                                                                    <i class="fas fa-times me-2"></i>Hủy lịch hẹn
                                                                </a></li>
                                                            <% } %>
                                                            <% if ("completed".equals(booking.getStatus())) { %>
                                                                <li><a class="dropdown-item text-primary" href="${pageContext.request.contextPath}/patient-profile">
                                                                    <i class="fas fa-file-medical me-2"></i>Xem kết quả
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

            <!-- Các tab khác sẽ hiển thị booking theo status -->
            <div class="tab-pane fade" id="pending" role="tabpanel">
                <% 
                    List<Booking> pendingBookings = bookings.stream()
                        .filter(b -> "Chờ xác nhận".equals(b.getStatus()))
                        .collect(java.util.stream.Collectors.toList());
                %>
                <% if (pendingBookings.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="fas fa-clock fa-4x text-muted mb-3"></i>
                        <h4 class="text-muted">Không có lịch hẹn nào đang chờ xác nhận</h4>
                    </div>
                <% } else { %>
                    <div class="row">
                        <div class="col-12">
                            <% for (Booking booking : pendingBookings) { %>
                                <!-- Same card structure as above -->
                                <div class="card booking-card">
                                    <div class="card-body">
                                        <!-- Card content same as above -->
                                        <div class="row align-items-center">
                                            <div class="col-md-3">
                                                <div class="d-flex align-items-center">
                                                    <div class="bg-warning text-white rounded p-3 me-3">
                                                        <i class="fas fa-clock fa-2x"></i>
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
                                                <p class="mb-0"><%= booking.getSymptoms() != null ? booking.getSymptoms() : "Không có mô tả" %></p>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <span class="status-badge status-pending">Chờ xác nhận</span>
                                                    <div class="dropdown">
                                                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                                            <i class="fas fa-ellipsis-v"></i>
                                                        </button>
                                                        <ul class="dropdown-menu">
                                                            <li><a class="dropdown-item" href="#"><i class="fas fa-eye me-2"></i>Xem chi tiết</a></li>
                                                            <li><a class="dropdown-item text-danger" href="#"><i class="fas fa-times me-2"></i>Hủy lịch</a></li>
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

            <!-- Các tab confirmed, completed, cancelled sẽ có cấu trúc tương tự -->
            <div class="tab-pane fade" id="confirmed" role="tabpanel">
                <% 
                    List<Booking> confirmedBookings = bookings.stream()
                        .filter(b -> "Đã xác nhận".equals(b.getStatus()))
                        .collect(java.util.stream.Collectors.toList());
                %>
                <% if (confirmedBookings.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="fas fa-check-circle fa-4x text-muted mb-3"></i>
                        <h4 class="text-muted">Không có lịch hẹn nào đã xác nhận</h4>
                    </div>
                <% } else { %>
                    <div class="row">
                        <div class="col-12">
                            <% for (Booking booking : confirmedBookings) { %>
                                <div class="card booking-card">
                                    <div class="card-body">
                                        <div class="row align-items-center">
                                            <div class="col-md-3">
                                                <div class="d-flex align-items-center">
                                                    <div class="bg-success text-white rounded p-3 me-3">
                                                        <i class="fas fa-check-circle fa-2x"></i>
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
                                                <p class="mb-0"><%= booking.getSymptoms() != null ? booking.getSymptoms() : "Không có mô tả" %></p>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <span class="status-badge status-confirmed">Đã xác nhận</span>
                                                    <div class="dropdown">
                                                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                                            <i class="fas fa-ellipsis-v"></i>
                                                        </button>
                                                        <ul class="dropdown-menu">
                                                            <li><a class="dropdown-item" href="#"><i class="fas fa-eye me-2"></i>Xem chi tiết</a></li>
                                                            <li><a class="dropdown-item text-danger" href="#"><i class="fas fa-times me-2"></i>Hủy lịch</a></li>
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

            <!-- Tab Completed -->
            <div class="tab-pane fade" id="completed" role="tabpanel">
                <% 
                    List<Booking> completedBookings = bookings.stream()
                        .filter(b -> "Đã khám".equals(b.getStatus()))
                        .collect(java.util.stream.Collectors.toList());
                %>
                <% if (completedBookings.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="fas fa-check-double fa-4x text-muted mb-3"></i>
                        <h4 class="text-muted">Không có lịch hẹn nào đã hoàn thành</h4>
                    </div>
                <% } else { %>
                    <div class="row">
                        <div class="col-12">
                            <% for (Booking booking : completedBookings) { %>
                                <div class="card booking-card">
                                    <div class="card-body">
                                        <div class="row align-items-center">
                                            <div class="col-md-3">
                                                <div class="d-flex align-items-center">
                                                    <div class="bg-info text-white rounded p-3 me-3">
                                                        <i class="fas fa-check-double fa-2x"></i>
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
                                                <p class="mb-0"><%= booking.getSymptoms() != null ? booking.getSymptoms() : "Không có mô tả" %></p>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <span class="status-badge status-completed">Đã hoàn thành</span>
                                                    <div class="dropdown">
                                                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                                            <i class="fas fa-ellipsis-v"></i>
                                                        </button>
                                                        <ul class="dropdown-menu">
                                                            <li><a class="dropdown-item" href="#"><i class="fas fa-eye me-2"></i>Xem chi tiết</a></li>
                                                            <li><a class="dropdown-item text-primary" href="${pageContext.request.contextPath}/patient-profile">
                                                                <i class="fas fa-file-medical me-2"></i>Xem kết quả
                                                            </a></li>
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

            <!-- Tab Cancelled -->
            <div class="tab-pane fade" id="cancelled" role="tabpanel">
                <% 
                    List<Booking> cancelledBookings = bookings.stream()
                        .filter(b -> "cancelled".equals(b.getStatus()))
                        .collect(java.util.stream.Collectors.toList());
                %>
                <% if (cancelledBookings.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="fas fa-times-circle fa-4x text-muted mb-3"></i>
                        <h4 class="text-muted">Không có lịch hẹn nào đã hủy</h4>
                    </div>
                <% } else { %>
                    <div class="row">
                        <div class="col-12">
                            <% for (Booking booking : cancelledBookings) { %>
                                <div class="card booking-card">
                                    <div class="card-body">
                                        <div class="row align-items-center">
                                            <div class="col-md-3">
                                                <div class="d-flex align-items-center">
                                                    <div class="bg-danger text-white rounded p-3 me-3">
                                                        <i class="fas fa-times-circle fa-2x"></i>
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
                                                <p class="mb-0"><%= booking.getSymptoms() != null ? booking.getSymptoms() : "Không có mô tả" %></p>
                                            </div>
                                            <div class="col-md-3">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <span class="status-badge status-cancelled">Đã hủy</span>
                                                    <div class="dropdown">
                                                        <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                                            <i class="fas fa-ellipsis-v"></i>
                                                        </button>
                                                        <ul class="dropdown-menu">
                                                            <li><a class="dropdown-item" href="#"><i class="fas fa-eye me-2"></i>Xem chi tiết</a></li>
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
        </div>
    </div>

    <jsp:include page="../includes/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>