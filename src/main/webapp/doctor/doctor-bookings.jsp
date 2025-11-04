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
    SimpleDateFormat datetimeFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý lịch hẹn - MediCare Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .doctor-header {
            background: linear-gradient(135deg, #8e44ad, #9b59b6);
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
        .action-buttons .btn {
            margin: 2px;
        }
        .tab-content {
        	min-height: 500px;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/header.jsp" />
    
    <!-- Doctor Header -->
    <div class="doctor-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1><i class="fas fa-user-md me-2"></i>Quản lý lịch hẹn</h1>
                    <p class="mb-0">Xác nhận và quản lý lịch hẹn của bệnh nhân</p>
                </div>
                <div class="col-md-4 text-end">
                    <span class="badge bg-light text-dark fs-6">
                        <i class="fas fa-list me-1"></i>Tổng: <%= bookings.size() %> lịch hẹn
                    </span>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Thông báo -->
        <% if ("1".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>Cập nhật trạng thái lịch hẹn thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        <% if ("1".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>Có lỗi xảy ra khi cập nhật trạng thái!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <!-- Filter Tabs -->
        <ul class="nav nav-tabs mb-4" id="bookingTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="all-tab" data-bs-toggle="tab" data-bs-target="#all" type="button">
                    Tất cả (<%= bookings.size() %>)
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="pending-tab" data-bs-toggle="tab" data-bs-target="#pending" type="button">
                    Chờ xác nhận (<%= bookings.stream().filter(b -> "Chờ xác nhận".equals(b.getStatus())).count() %>)
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="confirmed-tab" data-bs-toggle="tab" data-bs-target="#confirmed" type="button">
                    Đã xác nhận (<%= bookings.stream().filter(b -> "Đã xác nhận".equals(b.getStatus())).count() %>)
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="completed-tab" data-bs-toggle="tab" data-bs-target="#completed" type="button">
                    Đã khám (<%= bookings.stream().filter(b -> "Đã khám".equals(b.getStatus())).count() %>)
                </button>
            </li>
        </ul>

        <div class="tab-content" id="bookingTabsContent">
            <!-- Tab Tất cả -->
            <div class="tab-pane fade show active" id="all" role="tabpanel">
                <% if (bookings.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="fas fa-calendar-times fa-4x text-muted mb-3"></i>
                        <h3 class="text-muted">Chưa có lịch hẹn nào</h3>
                    </div>
                <% } else { %>
                    <% for (Booking booking : bookings) { %>
                        <%= renderBookingCard(booking, dateFormat, timeFormat, datetimeFormat) %>
                    <% } %>
                <% } %>
            </div>

            <!-- Tab Chờ xác nhận -->
            <div class="tab-pane fade" id="pending" role="tabpanel">
                <% 
                    List<Booking> pendingBookings = bookings.stream()
                        .filter(b -> "Chờ xác nhận".equals(b.getStatus()))
                        .collect(java.util.stream.Collectors.toList());
                %>
                <% if (pendingBookings.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="fas fa-check-circle fa-4x text-success mb-3"></i>
                        <h3 class="text-muted">Không có lịch hẹn nào chờ xác nhận</h3>
                    </div>
                <% } else { %>
                    <% for (Booking booking : pendingBookings) { %>
                        <%= renderBookingCard(booking, dateFormat, timeFormat, datetimeFormat) %>
                    <% } %>
                <% } %>
            </div>

            <!-- Tab Đã xác nhận -->
            <div class="tab-pane fade" id="confirmed" role="tabpanel">
                <% 
                    List<Booking> confirmedBookings = bookings.stream()
                        .filter(b -> "Đã xác nhận".equals(b.getStatus()))
                        .collect(java.util.stream.Collectors.toList());
                %>
                <% if (confirmedBookings.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="fas fa-calendar-check fa-4x text-primary mb-3"></i>
                        <h3 class="text-muted">Không có lịch hẹn nào đã xác nhận</h3>
                    </div>
                <% } else { %>
                    <% for (Booking booking : confirmedBookings) { %>
                        <%= renderBookingCard(booking, dateFormat, timeFormat, datetimeFormat) %>
                    <% } %>
                <% } %>
            </div>

            <!-- Tab Đã khám -->
            <div class="tab-pane fade" id="completed" role="tabpanel">
                <% 
                    List<Booking> completedBookings = bookings.stream()
                        .filter(b -> "Đã khám".equals(b.getStatus()))
                        .collect(java.util.stream.Collectors.toList());
                %>
                <% if (completedBookings.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="fas fa-check-double fa-4x text-success mb-3"></i>
                        <h3 class="text-muted">Không có lịch hẹn nào đã khám</h3>
                    </div>
                <% } else { %>
                    <% for (Booking booking : completedBookings) { %>
                        <%= renderBookingCard(booking, dateFormat, timeFormat, datetimeFormat) %>
                    <% } %>
                <% } %>
            </div>
        </div>
    </div>

    <jsp:include page="../includes/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Xác nhận hành động
        function confirmAction(bookingId, action, message) {
            if (confirm(message)) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'doctor-bookings';
                
                const bookingIdInput = document.createElement('input');
                bookingIdInput.type = 'hidden';
                bookingIdInput.name = 'booking_id';
                bookingIdInput.value = bookingId;
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = action;
                
                form.appendChild(bookingIdInput);
                form.appendChild(actionInput);
                document.body.appendChild(form);
                form.submit();
            }
        }
    </script>
</body>
</html>

<%!
// Helper method để render booking card
private String renderBookingCard(Booking booking, SimpleDateFormat dateFormat, 
                               SimpleDateFormat timeFormat, SimpleDateFormat datetimeFormat) {
    StringBuilder html = new StringBuilder();
    
    html.append("<div class=\"card booking-card\">")
        .append("<div class=\"card-body\">")
        .append("<div class=\"row align-items-center\">")
        
        // Thông tin lịch hẹn
        .append("<div class=\"col-md-2\">")
        .append("<div class=\"d-flex align-items-center\">")
        .append("<div class=\"bg-primary text-white rounded p-2 me-3\">")
        .append("<i class=\"fas fa-calendar-alt\"></i>")
        .append("</div>")
        .append("<div>")
        .append("<h6 class=\"mb-0\">").append(dateFormat.format(booking.getAppointmentDate())).append("</h6>")
        .append("<small class=\"text-muted\">").append(timeFormat.format(booking.getAppointmentDate())).append("</small>")
        .append("</div>")
        .append("</div>")
        .append("</div>")
        
        // Thông tin bệnh nhân
        .append("<div class=\"col-md-3\">")
        .append("<h6 class=\"mb-1\">Bệnh nhân</h6>")
        .append("<p class=\"mb-0 fw-bold\">").append(booking.getPatientName()).append("</p>")
        .append("</div>")
        
        // Triệu chứng
        .append("<div class=\"col-md-3\">")
        .append("<h6 class=\"mb-1\">Triệu chứng</h6>")
        .append("<p class=\"mb-0 text-truncate\" style=\"max-width: 200px;\">")
        .append(booking.getSymptoms() != null && !booking.getSymptoms().isEmpty() ? 
                booking.getSymptoms() : "Không có mô tả")
        .append("</p>")
        .append("</div>")
        
        // Trạng thái & Actions
        .append("<div class=\"col-md-4\">")
        .append("<div class=\"d-flex justify-content-between align-items-center\">")
        .append("<span class=\"status-badge status-").append(getStatusClass(booking.getStatus())).append("\">")
        .append(booking.getStatus())  // ✅ Hiển thị trực tiếp từ DB
        .append("</span>")
        .append("<div class=\"action-buttons\">")
        .append(getActionButtons(booking))
        .append("</div>")
        .append("</div>")
        .append("</div>")
        
        .append("</div>")
        .append("</div>")
        .append("</div>");
    
    return html.toString();
}

// ✅ SỬA: Helper method để lấy CSS class từ status tiếng Việt
private String getStatusClass(String status) {
    if (status == null) return "pending";
    
    switch(status) {
        case "Chờ xác nhận": return "pending";
        case "Đã xác nhận": return "confirmed";
        case "Đã khám": return "completed";
        case "Hủy": return "cancelled";
        default: return "pending";
    }
}

// ✅ SỬA: Helper method để lấy action buttons
private String getActionButtons(Booking booking) {
    StringBuilder buttons = new StringBuilder();
    String bookingId = String.valueOf(booking.getBookingId());
    String status = booking.getStatus();
    
    if ("Chờ xác nhận".equals(status)) {
        buttons.append("<button class=\"btn btn-success btn-sm\" onclick=\"confirmAction(")
               .append(bookingId)
               .append(", 'confirm', 'Xác nhận lịch hẹn này?')\">")
               .append("<i class=\"fas fa-check\"></i> Xác nhận")
               .append("</button>")
               .append("<button class=\"btn btn-danger btn-sm\" onclick=\"confirmAction(")
               .append(bookingId)
               .append(", 'cancel', 'Hủy lịch hẹn này?')\">")
               .append("<i class=\"fas fa-times\"></i> Hủy")
               .append("</button>");
    } 
    else if ("Đã xác nhận".equals(status)) {
        buttons.append("<button class=\"btn btn-info btn-sm\" onclick=\"confirmAction(")
               .append(bookingId)
               .append(", 'complete', 'Đánh dấu đã hoàn thành khám?')\">")
               .append("<i class=\"fas fa-flag-checkered\"></i> Hoàn thành")
               .append("</button>");
    }
    else {
        buttons.append("<span class=\"text-muted\"><i class=\"fas fa-check-circle\"></i> Đã xử lý</span>");
    }
    
    return buttons.toString();
}
%>