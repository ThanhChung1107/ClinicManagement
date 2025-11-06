<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.clinic.model.bean.Booking"%>
<%@page import="java.util.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.stream.Collectors"%>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    Map<String, Integer> bookingCounts = (Map<String, Integer>) request.getAttribute("bookingCounts");
    int month = (Integer) request.getAttribute("month");
    int year = (Integer) request.getAttribute("year");
    int currentMonth = (Integer) request.getAttribute("currentMonth");
    int currentYear = (Integer) request.getAttribute("currentYear");
    
    if (bookings == null || bookingCounts == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    SimpleDateFormat monthYearFormat = new SimpleDateFormat("MMMM yyyy", new Locale("vi", "VN"));
    
    // Tạo Calendar
    Calendar cal = Calendar.getInstance();
    cal.set(year, month - 1, 1);
    int daysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
    int firstDayOfWeek = cal.get(Calendar.DAY_OF_WEEK); // 1=CN, 2=T2, ...
    
    // Tính tháng trước/sau
    int prevMonth = (month == 1) ? 12 : month - 1;
    int prevYear = (month == 1) ? year - 1 : year;
    int nextMonth = (month == 12) ? 1 : month + 1;
    int nextYear = (month == 12) ? year + 1 : year;
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch làm việc - MediCare Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #8e44ad;
            --secondary-color: #9b59b6;
            --success-color: #27ae60;
            --warning-color: #f39c12;
            --danger-color: #e74c3c;
            --info-color: #3498db;
        }
        
        .calendar-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        
        .calendar-controls {
            background: white;
            border-radius: 15px;
            padding: 1rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        
        .calendar-grid {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }
        
        .calendar-weekdays {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            background: var(--primary-color);
            color: white;
        }
        
        .calendar-weekday {
            padding: 1rem;
            text-align: center;
            font-weight: 600;
            border-right: 1px solid rgba(255,255,255,0.2);
        }
        
        .calendar-weekday:last-child {
            border-right: none;
        }
        
        .calendar-days {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 1px;
            background: #e0e0e0;
        }
        
        .calendar-day {
            background: white;
            min-height: 120px;
            padding: 0.5rem;
            position: relative;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .calendar-day:hover {
            background: #f8f9fa;
            transform: scale(1.02);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            z-index: 10;
        }
        
        .calendar-day.empty {
            background: #f5f5f5;
            cursor: default;
        }
        
        .calendar-day.empty:hover {
            transform: none;
            box-shadow: none;
        }
        
        .calendar-day.today {
            background: linear-gradient(135deg, #fff3e0, #ffe0b2);
            border: 2px solid var(--warning-color);
        }
        
        .day-number {
            font-weight: 600;
            font-size: 1.1rem;
            color: #333;
            margin-bottom: 0.5rem;
        }
        
        .today .day-number {
            color: var(--warning-color);
            font-size: 1.3rem;
        }
        
        .booking-badge {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 0.75rem;
            margin: 2px;
            font-weight: 500;
        }
        
        .badge-pending { background: #fff3cd; color: #856404; }
        .badge-confirmed { background: #d1ecf1; color: #0c5460; }
        .badge-completed { background: #d4edda; color: #155724; }
        .badge-cancelled { background: #f8d7da; color: #721c24; }
        
        .booking-count {
            position: absolute;
            top: 5px;
            right: 5px;
            background: var(--primary-color);
            color: white;
            border-radius: 50%;
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.75rem;
            font-weight: bold;
        }
        
        .modal-booking-list {
            max-height: 400px;
            overflow-y: auto;
        }
        
        .booking-item {
            border-left: 4px solid var(--primary-color);
            padding: 1rem;
            margin-bottom: 1rem;
            background: #f8f9fa;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        
        .booking-item:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transform: translateX(5px);
        }
        
        .booking-item.pending { border-left-color: #f39c12; }
        .booking-item.confirmed { border-left-color: #3498db; }
        .booking-item.completed { border-left-color: #27ae60; }
        .booking-item.cancelled { border-left-color: #e74c3c; }
        
        .legend {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 10px;
            margin-bottom: 1rem;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .legend-color {
            width: 20px;
            height: 20px;
            border-radius: 5px;
        }
        
        @media (max-width: 768px) {
            .calendar-day {
                min-height: 80px;
                font-size: 0.85rem;
            }
            
            .booking-badge {
                display: none;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/header.jsp" />
    
    <!-- Calendar Header -->
    <div class="calendar-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1><i class="fas fa-calendar-alt me-2"></i>Lịch làm việc</h1>
                    <p class="mb-0">Quản lý lịch hẹn theo tháng</p>
                </div>
                <div class="col-md-4 text-end">
                    <div class="d-flex gap-2 justify-content-end">
                        <a href="doctor-bookings" class="btn btn-light">
                            <i class="fas fa-list me-1"></i>Danh sách
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Legend -->
        <div class="legend">
            <div class="legend-item">
                <div class="legend-color badge-pending"></div>
                <span>Chờ xác nhận</span>
            </div>
            <div class="legend-item">
                <div class="legend-color badge-confirmed"></div>
                <span>Đã xác nhận</span>
            </div>
            <div class="legend-item">
                <div class="legend-color badge-completed"></div>
                <span>Đã khám</span>
            </div>
            <div class="legend-item">
                <div class="legend-color badge-cancelled"></div>
                <span>Đã hủy</span>
            </div>
        </div>
        
        <!-- Calendar Controls -->
        <div class="calendar-controls">
            <div class="row align-items-center">
                <div class="col-md-4">
                    <a href="doctor-calendar?month=<%= prevMonth %>&year=<%= prevYear %>" 
                       class="btn btn-outline-primary">
                        <i class="fas fa-chevron-left me-1"></i>Tháng trước
                    </a>
                </div>
                <div class="col-md-4 text-center">
                    <h3 class="mb-0">
                        <i class="fas fa-calendar me-2"></i>
                        Tháng <%= month %> / <%= year %>
                    </h3>
                </div>
                <div class="col-md-4 text-end">
                    <% if (month != currentMonth || year != currentYear) { %>
                        <a href="doctor-calendar" class="btn btn-outline-secondary me-2">
                            <i class="fas fa-calendar-day me-1"></i>Hôm nay
                        </a>
                    <% } %>
                    <a href="doctor-calendar?month=<%= nextMonth %>&year=<%= nextYear %>" 
                       class="btn btn-outline-primary">
                        Tháng sau<i class="fas fa-chevron-right ms-1"></i>
                    </a>
                </div>
            </div>
        </div>
        
        <!-- Calendar Grid -->
        <div class="calendar-grid">
            <!-- Weekdays Header -->
            <div class="calendar-weekdays">
                <div class="calendar-weekday">Chủ Nhật</div>
                <div class="calendar-weekday">Thứ Hai</div>
                <div class="calendar-weekday">Thứ Ba</div>
                <div class="calendar-weekday">Thứ Tư</div>
                <div class="calendar-weekday">Thứ Năm</div>
                <div class="calendar-weekday">Thứ Sáu</div>
                <div class="calendar-weekday">Thứ Bảy</div>
            </div>
            
            <!-- Days Grid -->
            <div class="calendar-days">
                <%
                // Empty cells trước ngày đầu tháng
                for (int i = 1; i < firstDayOfWeek; i++) {
                %>
                    <div class="calendar-day empty"></div>
                <%
                }
                
                // Calendar để check ngày hôm nay
                Calendar today = Calendar.getInstance();
                int todayDay = today.get(Calendar.DAY_OF_MONTH);
                int todayMonth = today.get(Calendar.MONTH) + 1;
                int todayYear = today.get(Calendar.YEAR);
                
                // Render các ngày trong tháng
                for (int day = 1; day <= daysInMonth; day++) {
                    cal.set(year, month - 1, day);
                    String dateStr = dateFormat.format(cal.getTime());
                    
                    // Lọc bookings cho ngày này
                    final int currentDay = day;
                    List<Booking> dayBookings = bookings.stream()
                        .filter(b -> {
                            Calendar bookCal = Calendar.getInstance();
                            bookCal.setTime(b.getAppointmentDate());
                            return bookCal.get(Calendar.DAY_OF_MONTH) == currentDay;
                        })
                        .collect(Collectors.toList());
                    
                    Integer count = bookingCounts.get(dateStr);
                    boolean isToday = (day == todayDay && month == todayMonth && year == todayYear);
                    String todayClass = isToday ? "today" : "";
                %>
                    <div class="calendar-day <%= todayClass %>" 
                         onclick="showBookings('<%= dateStr %>', <%= day %>)">
                        <div class="day-number"><%= day %></div>
                        
                        <% if (count != null && count > 0) { %>
                            <div class="booking-count"><%= count %></div>
                            
                            <% for (Booking booking : dayBookings) { 
                                String statusClass = "";
                                switch(booking.getStatus()) {
                                    case "Chờ xác nhận": statusClass = "pending"; break;
                                    case "Đã xác nhận": statusClass = "confirmed"; break;
                                    case "Đã khám": statusClass = "completed"; break;
                                    case "Hủy": statusClass = "cancelled"; break;
                                }
                            %>
                                <div class="booking-badge badge-<%= statusClass %>">
                                    <%= timeFormat.format(booking.getAppointmentDate()) %>
                                </div>
                            <% } %>
                        <% } %>
                    </div>
                <%
                }
                %>
            </div>
        </div>
        
        <div class="text-center mt-4 mb-5">
            <p class="text-muted">
                <i class="fas fa-info-circle me-1"></i>
                Tổng số lịch hẹn trong tháng: <strong><%= bookings.size() %></strong>
            </p>
        </div>
    </div>

    <!-- Modal hiển thị chi tiết lịch hẹn -->
    <div class="modal fade" id="bookingModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-calendar-day me-2"></i>
                        Lịch hẹn ngày <span id="modalDate"></span>
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="modalBookings" class="modal-booking-list"></div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../includes/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Dữ liệu bookings từ server
        const bookingsData = <%= convertBookingsToJSON(bookings, timeFormat) %>;
        
        // Debug
        console.log('📅 Total bookings:', bookingsData.length);
        console.log('📊 Bookings data:', bookingsData);
        
        function showBookings(dateStr, day) {
            console.log('🔍 Clicked date:', dateStr);
            const dayBookings = bookingsData.filter(b => {
                console.log('Comparing:', b.date, 'with', dateStr);
                return b.date === dateStr;
            });
            console.log('📋 Bookings for this day:', dayBookings);
            
            if (dayBookings.length === 0) {
                console.log('⚠️ No bookings found for this date');
                alert('Không có lịch hẹn nào trong ngày này!');
                return;
            }
            
            console.log('✅ Found bookings, opening modal...');
            document.getElementById('modalDate').textContent = day + '/' + <%= month %> + '/' + <%= year %>;
            
            let html = '';
            
            console.log('🔨 Building HTML for', dayBookings.length, 'bookings');
            
            dayBookings.forEach((booking, index) => {
                console.log('Processing booking', index, booking);
                
                let statusClass = '';
                let statusText = booking.status || 'Chờ xác nhận';
                
                switch(booking.status) {
                    case 'Chờ xác nhận': statusClass = 'pending'; break;
                    case 'Đã xác nhận': statusClass = 'confirmed'; break;
                    case 'Đã khám': statusClass = 'completed'; break;
                    case 'Hủy': statusClass = 'cancelled'; break;
                    default: statusClass = 'pending';
                }
                
                // Escape HTML characters
                const patientName = (booking.patientName || 'N/A').replace(/</g, '&lt;').replace(/>/g, '&gt;');
                const symptoms = (booking.symptoms || 'Không có mô tả').replace(/</g, '&lt;').replace(/>/g, '&gt;');
                const time = booking.time || '00:00';
                
                // Tạo action buttons
                let actionButtons = '';
                if (booking.status === 'Chờ xác nhận') {
                    actionButtons = '<button class="btn btn-success btn-sm me-1" onclick="updateStatus(' + booking.bookingId + ', \'confirm\')" title="Xác nhận">' +
                        '<i class="fas fa-check"></i>' +
                        '</button>' +
                        '<button class="btn btn-danger btn-sm" onclick="updateStatus(' + booking.bookingId + ', \'cancel\')" title="Hủy">' +
                        '<i class="fas fa-times"></i>' +
                        '</button>';
                } else if (booking.status === 'Đã xác nhận') {
                    actionButtons = '<button class="btn btn-info btn-sm" onclick="updateStatus(' + booking.bookingId + ', \'complete\')" title="Hoàn thành">' +
                        '<i class="fas fa-flag-checkered"></i>' +
                        '</button>';
                } else {
                    actionButtons = '<span class="text-muted"><i class="fas fa-check-circle"></i> Đã xử lý</span>';
                }
                
                html += '<div class="booking-item ' + statusClass + '">' +
                    '<div class="row">' +
                        '<div class="col-md-8">' +
                            '<h6 class="mb-2">' +
                                '<i class="fas fa-user me-2"></i>' + patientName +
                            '</h6>' +
                            '<p class="mb-1">' +
                                '<i class="fas fa-clock me-2 text-muted"></i>' +
                                '<strong>' + time + '</strong>' +
                            '</p>' +
                            '<p class="mb-1">' +
                                '<i class="fas fa-notes-medical me-2 text-muted"></i>' +
                                symptoms +
                            '</p>' +
                        '</div>' +
                        '<div class="col-md-4 text-end">' +
                            '<span class="badge booking-badge badge-' + statusClass + '">' +
                                statusText +
                            '</span>' +
                            '<div class="mt-3">' +
                                actionButtons +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                '</div>';
            });
            
            console.log('📝 Generated HTML length:', html.length);
            console.log('📝 HTML preview:', html.substring(0, 200));
            
            const modalElement = document.getElementById('modalBookings');
            if (!modalElement) {
                console.error('❌ Modal element not found!');
                alert('Lỗi: Không tìm thấy element modal!');
                return;
            }
            
            modalElement.innerHTML = html;
            console.log('✅ HTML inserted into modal');
            
            const modalInstance = new bootstrap.Modal(document.getElementById('bookingModal'));
            modalInstance.show();
            console.log('✅ Modal opened');
        }
        
        function updateStatus(bookingId, action) {
            let message = '';
            switch(action) {
                case 'confirm':
                    message = 'Xác nhận lịch hẹn này?';
                    break;
                case 'cancel':
                    message = 'Hủy lịch hẹn này?';
                    break;
                case 'complete':
                    message = 'Đánh dấu đã hoàn thành khám?';
                    break;
            }
            
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
// Helper method để convert bookings sang JSON
private String convertBookingsToJSON(List<Booking> bookings, SimpleDateFormat timeFormat) {
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    StringBuilder json = new StringBuilder("[");
    
    for (int i = 0; i < bookings.size(); i++) {
        Booking b = bookings.get(i);
        if (i > 0) json.append(",");
        
        String symptoms = b.getSymptoms() != null ? 
            b.getSymptoms().replace("\"", "\\\"").replace("\n", " ").replace("\r", " ") : "";
        
        String patientName = b.getPatientName() != null ?
            b.getPatientName().replace("\"", "\\\"") : "";
            
        json.append("{")
            .append("\"bookingId\":").append(b.getBookingId()).append(",")
            .append("\"date\":\"").append(dateFormat.format(b.getAppointmentDate())).append("\",")
            .append("\"time\":\"").append(timeFormat.format(b.getAppointmentDate())).append("\",")
            .append("\"patientName\":\"").append(patientName).append("\",")
            .append("\"symptoms\":\"").append(symptoms).append("\",")
            .append("\"status\":\"").append(b.getStatus()).append("\"")
            .append("}");
    }
    
    json.append("]");
    return json.toString();
}
%>