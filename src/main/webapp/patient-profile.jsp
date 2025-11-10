<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.clinic.model.bean.Patient"%>
<%@page import="com.clinic.model.bean.Examination"%>
<%@page import="com.clinic.model.bean.Prescription"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%
    Patient patient = (Patient) request.getAttribute("patient");
    List<Examination> examinations = (List<Examination>) request.getAttribute("examinations");
    
    if (patient == null) {
        response.sendRedirect("doctor-patients");
        return;
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat datetimeFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
    
    // Tính tuổi
    int age = 0;
    if (patient.getDateOfBirth() != null) {
        Calendar dob = Calendar.getInstance();
        dob.setTime(patient.getDateOfBirth());
        Calendar now = Calendar.getInstance();
        age = now.get(Calendar.YEAR) - dob.get(Calendar.YEAR);
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ bệnh nhân - <%= patient.getFullName() %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @media print {
            .no-print { display: none !important; }
            .card { break-inside: avoid; }
        }
        
        .profile-header {
            background: linear-gradient(135deg, #1a76d2, #34a853);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        
        .patient-avatar-large {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
            font-weight: bold;
            margin: 0 auto 1rem;
            border: 5px solid white;
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
        }
        
        .info-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
            overflow: hidden;
        }
        
        .info-card .card-header {
            border-radius: 15px 15px 0 0 !important;
            font-weight: 600;
            padding: 1rem 1.5rem;
        }
        
        .info-card .card-body {
            padding: 1.5rem;
        }
        
        .info-item {
            padding: 0.75rem 0;
            border-bottom: 1px solid #f0f0f0;
            margin: 0 0.5rem;
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-label {
            color: #666;
            font-weight: 500;
            min-width: 150px;
            display: inline-block;
            margin-bottom: 0.25rem;
        }
        
        .info-value {
            color: #333;
            font-weight: 600;
            display: block;
            margin-left: 1.75rem;
        }
        
        .exam-timeline {
            position: relative;
            padding-left: 30px;
            margin: 0 0.5rem;
        }
        
        .exam-timeline::before {
            content: '';
            position: absolute;
            left: 8px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: linear-gradient(135deg, #1a76d2, #34a853);
        }
        
        .exam-item {
            position: relative;
            margin-bottom: 2rem;
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border: 1px solid #e9ecef;
        }
        
        .exam-item::before {
            content: '';
            position: absolute;
            left: -26px;
            top: 20px;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            background: #667eea;
            border: 3px solid white;
            box-shadow: 0 0 0 3px #667eea;
        }
        
        .exam-date {
            color: #667eea;
            font-weight: 600;
            font-size: 1.1rem;
            margin-bottom: 0.5rem;
        }
        
        .prescription-table {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1rem;
            margin-top: 1rem;
            margin-left: 0.5rem;
            margin-right: 0.5rem;
        }
        
        .vital-signs {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            margin: 1rem 0.5rem;
        }
        
        .vital-sign-box {
            flex: 1;
            min-width: 150px;
            background: linear-gradient(135deg, #1a76d2, #34a853);
            color: white;
            padding: 1rem;
            border-radius: 10px;
            text-align: center;
            margin: 0.25rem;
        }
        
        .vital-sign-label {
            font-size: 0.85rem;
            opacity: 0.9;
        }
        
        .vital-sign-value {
            font-size: 1.5rem;
            font-weight: bold;
            margin-top: 0.5rem;
        }
        
        .badge-custom {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 500;
        }
        
        .stats-box {
            text-align: center;
            padding: 1.5rem;
            background: linear-gradient(135deg, #1a76d2, #34a853);
            color: white;
            border-radius: 15px;
            margin-bottom: 1rem;
            margin: 0 0.5rem 1rem 0.5rem;
        }
        
        .stats-number {
            font-size: 2.5rem;
            font-weight: bold;
        }
        
        .stats-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }
        
        /* Thêm margin cho các phần tử bên trong */
        .card-body > .info-item:first-child {
            padding-top: 0;
        }
        
        .card-body > .info-item:last-child {
            padding-bottom: 0;
        }
        
        /* Margin cho các section trong exam-item */
        .exam-item > div {
            margin-bottom: 1rem;
        }
        
        .exam-item > div:last-child {
            margin-bottom: 0;
        }
        
        /* Margin cho table */
        .table-responsive {
            margin: 0.5rem 0;
        }
        
        /* Margin cho alert */
        .alert {
            margin: 0.5rem;
        }
        
        /* Điều chỉnh padding cho container chính */
        .container.my-4 {
            margin-top: 2rem !important;
            margin-bottom: 2rem !important;
        }
        
        /* Margin cho row và col */
        .row {
            margin-left: -0.5rem;
            margin-right: -0.5rem;
        }
        
        .col-md-4, .col-md-8 {
            padding-left: 0.75rem;
            padding-right: 0.75rem;
        }
    </style>
</head>
<body>
    <jsp:include page="includes/header.jsp" />
    
    <!-- Profile Header -->
    <div class="profile-header no-print">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <a href="home.jsp" class="btn btn-light btn-sm mb-3">
                        <i class="fas fa-arrow-left me-1"></i>Quay lại
                    </a>
                    <h1><i class="fas fa-user-injured me-2"></i>Hồ sơ bệnh nhân</h1>
                    <p class="mb-0">Thông tin chi tiết và lịch sử khám bệnh</p>
                </div>
                <div class="col-md-4 text-end">
                    <button onclick="window.print()" class="btn btn-light">
                        <i class="fas fa-print me-1"></i>In hồ sơ
                    </button>
                </div>
            </div>
        </div>
    </div>

    <div class="container my-4">
        <div class="row">
            <!-- Cột trái: Thông tin cá nhân -->
            <div class="col-md-4">
                <!-- Avatar & Basic Info -->
                <div class="info-card">
                    <div class="card-body text-center">
                        <div class="patient-avatar-large">
                            <%= patient.getFullName().substring(0, 1).toUpperCase() %>
                        </div>
                        <h3 class="mb-1"><%= patient.getFullName() %></h3>
                        <p class="text-muted mb-3">
                            <i class="fas fa-venus-mars me-1"></i><%= patient.getGender() %>
                            <% if (age > 0) { %>
                                | <%= age %> tuổi
                            <% } %>
                        </p>
                        <div class="d-flex gap-2 justify-content-center">
                            <span class="badge bg-primary">ID: <%= patient.getPatientId() %></span>
                            <% if (patient.getBloodType() != null) { %>
                                <span class="badge bg-danger">
                                    <i class="fas fa-tint me-1"></i><%= patient.getBloodType() %>
                                </span>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- Contact Info -->
                <div class="info-card">
                    <div class="card-header bg-primary text-white">
                        <i class="fas fa-address-card me-2"></i>Thông tin liên hệ
                    </div>
                    <div class="card-body">
                        <div class="info-item">
                            <i class="fas fa-envelope text-primary me-2"></i>
                            <span class="info-label">Email:</span>
                            <span class="info-value"><%= patient.getEmail() %></span>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-phone text-success me-2"></i>
                            <span class="info-label">Điện thoại:</span>
                            <span class="info-value"><%= patient.getPhone() %></span>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-birthday-cake text-warning me-2"></i>
                            <span class="info-label">Ngày sinh:</span>
                            <span class="info-value">
                                <%= patient.getDateOfBirth() != null ? dateFormat.format(patient.getDateOfBirth()) : "N/A" %>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Medical Info -->
                <div class="info-card">
                    <div class="card-header bg-danger text-white">
                        <i class="fas fa-heartbeat me-2"></i>Thông tin y tế
                    </div>
                    <div class="card-body">
                        <div class="info-item">
                            <i class="fas fa-allergies text-danger me-2"></i>
                            <span class="info-label">Dị ứng:</span>
                            <span class="info-value">
                                <%= patient.getAllergies() != null && !patient.getAllergies().isEmpty() ? 
                                    patient.getAllergies() : "Không có" %>
                            </span>
                        </div>
                        <div class="info-item">
                            <i class="fas fa-file-medical text-info me-2"></i>
                            <span class="info-label">Tiền sử bệnh:</span>
                            <span class="info-value">
                                <%= patient.getMedicalHistory() != null && !patient.getMedicalHistory().isEmpty() ? 
                                    patient.getMedicalHistory() : "Không có" %>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Statistics -->
                <div class="stats-box">
                    <div class="stats-number"><%= examinations.size() %></div>
                    <div class="stats-label">Lần khám bệnh</div>
                </div>
            </div>

            <!-- Cột phải: Lịch sử khám bệnh -->
            <div class="col-md-8">
                <div class="info-card">
                    <div class="card-header bg-success text-white">
                        <i class="fas fa-history me-2"></i>
                        Lịch sử khám bệnh (<%= examinations.size() %> lần)
                    </div>
                    <div class="card-body">
                        <% if (examinations.isEmpty()) { %>
                            <div class="text-center py-5">
                                <i class="fas fa-clipboard-list fa-4x text-muted mb-3"></i>
                                <h5 class="text-muted">Chưa có lịch sử khám bệnh</h5>
                                <p class="text-muted">Bệnh nhân chưa được khám lần nào</p>
                            </div>
                        <% } else { %>
                            <div class="exam-timeline">
                                <% for (Examination exam : examinations) { %>
                                    <div class="exam-item">
                                        <!-- Header -->
                                        <div class="d-flex justify-content-between align-items-start mb-3">
                                            <div>
                                                <div class="exam-date">
                                                    <i class="fas fa-calendar-alt me-2"></i>
                                                    <%= datetimeFormat.format(exam.getAppointmentDate()) %>
                                                </div>
                                                <small class="text-muted">
                                                    <i class="fas fa-user-md me-1"></i>
                                                    BS. <%= exam.getDoctorName() %>
                                                </small>
                                            </div>
                                            <span class="badge bg-success">
                                                <i class="fas fa-check-circle me-1"></i>Đã khám
                                            </span>
                                        </div>

                                        <!-- Symptoms -->
                                        <div class="mb-3">
                                            <h6 class="text-primary">
                                                <i class="fas fa-notes-medical me-2"></i>Triệu chứng
                                            </h6>
                                            <p class="mb-0">
                                                <%= exam.getSymptoms() != null && !exam.getSymptoms().isEmpty() ? 
                                                    exam.getSymptoms() : "Không có mô tả" %>
                                            </p>
                                        </div>

                                        <!-- Diagnosis -->
                                        <div class="mb-3">
                                            <h6 class="text-danger">
                                                <i class="fas fa-diagnoses me-2"></i>Chẩn đoán
                                            </h6>
                                            <p class="mb-0">
                                                <%= exam.getDiagnosis() != null && !exam.getDiagnosis().isEmpty() ? 
                                                    exam.getDiagnosis() : "N/A" %>
                                            </p>
                                        </div>

                                        <!-- Vital Signs -->
                                        <% if (exam.getBloodPressure() != null || exam.getTemperature() > 0 || exam.getPulseRate() > 0) { %>
                                            <div class="vital-signs">
                                                <% if (exam.getBloodPressure() != null) { %>
                                                    <div class="vital-sign-box">
                                                        <div class="vital-sign-label">
                                                            <i class="fas fa-heartbeat me-1"></i>Huyết áp
                                                        </div>
                                                        <div class="vital-sign-value"><%= exam.getBloodPressure() %></div>
                                                    </div>
                                                <% } %>
                                                <% if (exam.getTemperature() > 0) { %>
                                                    <div class="vital-sign-box">
                                                        <div class="vital-sign-label">
                                                            <i class="fas fa-thermometer me-1"></i>Nhiệt độ
                                                        </div>
                                                        <div class="vital-sign-value"><%= exam.getTemperature() %>°C</div>
                                                    </div>
                                                <% } %>
                                                <% if (exam.getPulseRate() > 0) { %>
                                                    <div class="vital-sign-box">
                                                        <div class="vital-sign-label">
                                                            <i class="fas fa-heart me-1"></i>Mạch
                                                        </div>
                                                        <div class="vital-sign-value"><%= exam.getPulseRate() %>/phút</div>
                                                    </div>
                                                <% } %>
                                            </div>
                                        <% } %>

                                        <!-- Doctor Notes -->
                                        <% if (exam.getDoctorNotes() != null && !exam.getDoctorNotes().isEmpty()) { %>
                                            <div class="mb-3">
                                                <h6 class="text-info">
                                                    <i class="fas fa-comment-medical me-2"></i>Ghi chú của bác sĩ
                                                </h6>
                                                <p class="mb-0"><%= exam.getDoctorNotes() %></p>
                                            </div>
                                        <% } %>

                                        <!-- Prescriptions -->
                                        <% if (exam.getPrescriptions() != null && !exam.getPrescriptions().isEmpty()) { %>
                                            <div class="prescription-table">
                                                <h6 class="text-success mb-3">
                                                    <i class="fas fa-pills me-2"></i>Đơn thuốc
                                                </h6>
                                                <div class="table-responsive">
                                                    <table class="table table-sm table-bordered mb-0">
                                                        <thead class="table-light">
                                                            <tr>
                                                                <th width="5%">#</th>
                                                                <th width="40%">Tên thuốc</th>
                                                                <th width="15%">Số lượng</th>
                                                                <th width="40%">Liều dùng</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <% 
                                                            int index = 1;
                                                            for (Prescription p : exam.getPrescriptions()) { 
                                                            %>
                                                                <tr>
                                                                    <td><%= index++ %></td>
                                                                    <td><%= p.getMedicineName() %></td>
                                                                    <td><%= p.getQuantity() %> <%= p.getUnit() %></td>
                                                                    <td><%= p.getDosage() %></td>
                                                                </tr>
                                                            <% } %>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        <% } %>

                                        <!-- Next Appointment -->
                                        <% if (exam.getNextAppointmentDate() != null) { %>
                                            <div class="alert alert-info mt-3 mb-0">
                                                <i class="fas fa-calendar-plus me-2"></i>
                                                <strong>Tái khám:</strong> <%= dateFormat.format(exam.getNextAppointmentDate()) %>
                                            </div>
                                        <% } %>
                                    </div>
                                <% } %>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>