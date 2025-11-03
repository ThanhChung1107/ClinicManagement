<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.clinic.model.bean.Booking"%>
<%@page import="java.util.List"%>
<%
    List<Booking> doctors = (List<Booking>) request.getAttribute("doctors");
    if (doctors == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lịch khám - MediCare Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .booking-header {
            background: linear-gradient(135deg, #1a76d2, #34a853);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .booking-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .doctor-card {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        .doctor-card:hover {
            border-color: #1a76d2;
            background-color: #f8f9fa;
        }
        .doctor-card.selected {
            border-color: #1a76d2;
            background-color: #e3f2fd;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/header.jsp" />
    
    <!-- Booking Header -->
    <div class="booking-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1><i class="fas fa-calendar-plus me-2"></i>Đặt lịch khám</h1>
                    <p class="mb-0">Chọn bác sĩ và thời gian phù hợp với bạn</p>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Thông báo -->
        <% if ("1".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>Có lỗi xảy ra khi đặt lịch! Vui lòng thử lại.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row mb-5">
            <div class="col-lg-8 mx-auto">
                <div class="card booking-card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="fas fa-calendar-alt me-2"></i>Thông tin đặt lịch</h5>
                    </div>
                    <div class="card-body">
                        <form action="booking" method="post" id="bookingForm">
                            <!-- Chọn bác sĩ -->
                            <div class="mb-4">
                                <label class="form-label fw-bold">Chọn bác sĩ <span class="text-danger">*</span></label>
                                <div class="doctors-list">
                                    <% for (Booking doctor : doctors) { %>
                                        <div class="doctor-card" data-doctor-id="<%= doctor.getDoctorId() %>">
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="doctor_id" 
                                                       value="<%= doctor.getDoctorId() %>" id="doctor<%= doctor.getDoctorId() %>" required>
                                                <label class="form-check-label w-100" for="doctor<%= doctor.getDoctorId() %>">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <div>
                                                            <h6 class="mb-1"><%= doctor.getDoctorName() %></h6>
                                                            <p class="text-muted mb-0">
                                                                <i class="fas fa-stethoscope me-1"></i><%= doctor.getSpecialization() %>
                                                            </p>
                                                        </div>
                                                        <i class="fas fa-check-circle text-success" style="display: none;"></i>
                                                    </div>
                                                </label>
                                            </div>
                                        </div>
                                    <% } %>
                                </div>
                            </div>

                            <!-- Chọn ngày -->
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <label for="appointment_date" class="form-label fw-bold">Ngày khám <span class="text-danger">*</span></label>
                                    <input type="date" class="form-control" id="appointment_date" name="appointment_date" 
                                           min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="appointment_time" class="form-label fw-bold">Giờ khám <span class="text-danger">*</span></label>
                                    <select class="form-select" id="appointment_time" name="appointment_time" required>
                                        <option value="">Chọn giờ</option>
                                        <option value="08:00">08:00</option>
                                        <option value="09:00">09:00</option>
                                        <option value="10:00">10:00</option>
                                        <option value="11:00">11:00</option>
                                        <option value="14:00">14:00</option>
                                        <option value="15:00">15:00</option>
                                        <option value="16:00">16:00</option>
                                        <option value="17:00">17:00</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Triệu chứng -->
                            <div class="mb-4">
                                <label for="symptoms" class="form-label fw-bold">Triệu chứng / Mô tả tình trạng</label>
                                <textarea class="form-control" id="symptoms" name="symptoms" rows="4" 
                                          placeholder="Mô tả các triệu chứng bạn đang gặp phải..."></textarea>
                                <div class="form-text">Thông tin này giúp bác sĩ chuẩn bị tốt hơn cho buổi khám của bạn.</div>
                            </div>

                            <!-- Nút submit -->
                            <div class="text-center">
                                <button type="submit" class="btn btn-primary btn-lg px-5">
                                    <i class="fas fa-calendar-check me-2"></i>Đặt lịch ngay
                                </button>
                                <a href="../home.jsp" class="btn btn-outline-secondary btn-lg px-5 ms-2">
                                    <i class="fas fa-arrow-left me-2"></i>Quay lại
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../includes/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Xử lý chọn bác sĩ
        document.querySelectorAll('.doctor-card').forEach(card => {
            card.addEventListener('click', function() {
                // Bỏ chọn tất cả
                document.querySelectorAll('.doctor-card').forEach(c => {
                    c.classList.remove('selected');
                    c.querySelector('.fa-check-circle').style.display = 'none';
                });
                
                // Chọn card này
                this.classList.add('selected');
                this.querySelector('.fa-check-circle').style.display = 'block';
                this.querySelector('input[type="radio"]').checked = true;
            });
        });

        // Validate form
        document.getElementById('bookingForm').addEventListener('submit', function(e) {
            const date = document.getElementById('appointment_date').value;
            const time = document.getElementById('appointment_time').value;
            const doctor = document.querySelector('input[name="doctor_id"]:checked');
            
            if (!doctor) {
                e.preventDefault();
                alert('Vui lòng chọn bác sĩ!');
                return;
            }
            
            if (!date || !time) {
                e.preventDefault();
                alert('Vui lòng chọn ngày và giờ khám!');
                return;
            }
            
            // Kiểm tra ngày không được là quá khứ
            const selectedDateTime = new Date(date + ' ' + time);
            if (selectedDateTime < new Date()) {
                e.preventDefault();
                alert('Không thể đặt lịch trong quá khứ! Vui lòng chọn thời gian khác.');
                return;
            }
        });

        // Set min date là ngày hiện tại
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('appointment_date').min = today;
    </script>
</body>
</html>