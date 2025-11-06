<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.clinic.model.bean.Patient"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%
    List<Patient> allPatients = (List<Patient>) request.getAttribute("allPatients");
    List<Patient> confirmedPatients = (List<Patient>) request.getAttribute("confirmedPatients");
    
    if (allPatients == null || confirmedPatients == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat datetimeFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý bệnh nhân - MediCare Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .patients-header {
            background: linear-gradient(135deg, #27ae60, #2ecc71);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        
        .patient-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
        }
        
        .patient-card:hover {
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            transform: translateY(-5px);
        }
        
        .patient-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #3498db, #2980b9);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
            font-weight: bold;
        }
        
        .badge-info {
            background-color: #e3f2fd;
            color: #1976d2;
            padding: 5px 10px;
            border-radius: 10px;
            font-size: 0.85rem;
        }
        
        .nav-tabs .nav-link {
            color: #666;
            border: none;
            padding: 1rem 2rem;
        }
        
        .nav-tabs .nav-link.active {
            color: #27ae60;
            border-bottom: 3px solid #27ae60;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <jsp:include page="../includes/header.jsp" />
    
    <!-- Header -->
    <div class="patients-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1><i class="fas fa-users me-2"></i>Quản lý bệnh nhân</h1>
                    <p class="mb-0">Danh sách bệnh nhân và hồ sơ khám bệnh</p>
                </div>
                <div class="col-md-4 text-end">
                    <a href="doctor-bookings" class="btn btn-light me-2">
                        <i class="fas fa-list me-1"></i>Lịch hẹn
                    </a>
                    <a href="doctor-calendar" class="btn btn-light">
                        <i class="fas fa-calendar me-1"></i>Lịch làm việc
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Thông báo -->
        <% if ("1".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>Khám bệnh và kê đơn thuốc thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        
        <!-- Tabs -->
        <ul class="nav nav-tabs mb-4" id="patientTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="confirmed-tab" data-bs-toggle="tab" 
                        data-bs-target="#confirmed" type="button">
                    <i class="fas fa-check-circle me-2"></i>
                    Đã xác nhận (<%= confirmedPatients.size() %>)
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="all-tab" data-bs-toggle="tab" 
                        data-bs-target="#all" type="button">
                    <i class="fas fa-users me-2"></i>
                    Tất cả (<%= allPatients.size() %>)
                </button>
            </li>
        </ul>

        <div class="tab-content" id="patientTabsContent">
            <!-- Tab Đã xác nhận -->
            <div class="tab-pane fade show active" id="confirmed" role="tabpanel">
                <% if (confirmedPatients.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="fas fa-user-clock fa-4x text-muted mb-3"></i>
                        <h3 class="text-muted">Chưa có bệnh nhân nào đã xác nhận</h3>
                    </div>
                <% } else { %>
                    <% for (Patient patient : confirmedPatients) { %>
                        <div class="card patient-card">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-1">
                                        <div class="patient-avatar">
                                            <%= patient.getFullName().substring(0, 1).toUpperCase() %>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <h5 class="mb-1"><%= patient.getFullName() %></h5>
                                        <p class="mb-0 text-muted">
                                            <i class="fas fa-venus-mars me-1"></i><%= patient.getGender() %>
                                            <% if (patient.getDateOfBirth() != null) { %>
                                                | <%= dateFormat.format(patient.getDateOfBirth()) %>
                                            <% } %>
                                        </p>
                                    </div>
                                    <div class="col-md-3">
                                        <p class="mb-1">
                                            <i class="fas fa-phone me-2 text-muted"></i><%= patient.getPhone() %>
                                        </p>
                                        <p class="mb-0">
                                            <i class="fas fa-clock me-2 text-muted"></i>
                                            <%= datetimeFormat.format(patient.getAppointmentDate()) %>
                                        </p>
                                    </div>
                                    <div class="col-md-3">
                                        <span class="badge-info">
                                            <i class="fas fa-notes-medical me-1"></i>
                                            <%= patient.getSymptoms() != null && !patient.getSymptoms().isEmpty() ? 
                                                (patient.getSymptoms().length() > 30 ? 
                                                patient.getSymptoms().substring(0, 30) + "..." : 
                                                patient.getSymptoms()) : "Không có triệu chứng" %>
                                        </span>
                                    </div>
                                    <div class="col-md-2 text-end">
                                        <button class="btn btn-primary btn-sm" 
                                                onclick="viewPatientDetail(<%= patient.getPatientId() %>)">
                                            <i class="fas fa-eye me-1"></i>Chi tiết
                                        </button>
                                        <button class="btn btn-success btn-sm mt-1" 
                                                onclick="openExamForm(<%= patient.getBookingId() %>, '<%= patient.getFullName() %>', '<%= patient.getSymptoms() != null ? patient.getSymptoms().replace("'", "\\'") : "" %>')">
                                            <i class="fas fa-stethoscope me-1"></i>Khám
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } %>
                <% } %>
            </div>

            <!-- Tab Tất cả -->
            <div class="tab-pane fade" id="all" role="tabpanel">
                <% if (allPatients.isEmpty()) { %>
                    <div class="text-center py-5">
                        <i class="fas fa-users-slash fa-4x text-muted mb-3"></i>
                        <h3 class="text-muted">Chưa có bệnh nhân nào</h3>
                    </div>
                <% } else { %>
                    <% for (Patient patient : allPatients) { %>
                        <div class="card patient-card">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-1">
                                        <div class="patient-avatar">
                                            <%= patient.getFullName().substring(0, 1).toUpperCase() %>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <h5 class="mb-1"><%= patient.getFullName() %></h5>
                                        <p class="mb-0 text-muted">
                                            <i class="fas fa-venus-mars me-1"></i><%= patient.getGender() %>
                                            <% if (patient.getDateOfBirth() != null) { %>
                                                | <%= dateFormat.format(patient.getDateOfBirth()) %>
                                            <% } %>
                                        </p>
                                    </div>
                                    <div class="col-md-3">
                                        <p class="mb-1">
                                            <i class="fas fa-phone me-2 text-muted"></i><%= patient.getPhone() %>
                                        </p>
                                        <p class="mb-0">
                                            <i class="fas fa-tint me-2 text-muted"></i>
                                            Nhóm máu: <%= patient.getBloodType() != null ? patient.getBloodType() : "N/A" %>
                                        </p>
                                    </div>
                                    <div class="col-md-2">
                                        <span class="badge-info">
                                            <i class="fas fa-history me-1"></i>
                                            <%= patient.getTotalVisits() %> lần khám
                                        </span>
                                    </div>
                                    <div class="col-md-2 text-end">
                                        <button class="btn btn-primary btn-sm" 
                                                onclick="viewPatientDetail(<%= patient.getPatientId() %>)">
                                            <i class="fas fa-eye me-1"></i>Chi tiết
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </div>
    </div>

    <!-- Modal Chi tiết bệnh nhân -->
    <div class="modal fade" id="patientDetailModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-user-md me-2"></i>
                        Hồ sơ bệnh nhân
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="patientDetailContent">
                    <div class="text-center py-5">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Form khám bệnh -->
    <div class="modal fade" id="examModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-stethoscope me-2"></i>
                        Khám bệnh - <span id="examPatientName"></span>
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form id="examForm" action="create-examination" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="booking_id" id="examBookingId">
                        
                        <div class="row">
                            <!-- Cột trái: Thông tin khám -->
                            <div class="col-md-6">
                                <h6 class="text-primary mb-3">
                                    <i class="fas fa-notes-medical me-2"></i>Thông tin khám bệnh
                                </h6>
                                
                                <div class="mb-3">
                                    <label class="form-label">Triệu chứng</label>
                                    <textarea class="form-control" id="examSymptoms" rows="2" readonly></textarea>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Chẩn đoán <span class="text-danger">*</span></label>
                                    <textarea class="form-control" name="diagnosis" rows="3" required 
                                              placeholder="Nhập chẩn đoán bệnh..."></textarea>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Ghi chú của bác sĩ</label>
                                    <textarea class="form-control" name="doctor_notes" rows="3" 
                                              placeholder="Ghi chú thêm (không bắt buộc)..."></textarea>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Huyết áp</label>
                                        <input type="text" class="form-control" name="blood_pressure" 
                                               placeholder="VD: 120/80">
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Nhiệt độ (°C)</label>
                                        <input type="number" step="0.1" class="form-control" name="temperature" 
                                               placeholder="VD: 37.5">
                                    </div>
                                    <div class="col-md-4 mb-3">
                                        <label class="form-label">Mạch (/phút)</label>
                                        <input type="number" class="form-control" name="pulse_rate" 
                                               placeholder="VD: 75">
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label">Ngày tái khám</label>
                                    <input type="date" class="form-control" name="next_appointment_date">
                                </div>
                            </div>
                            
                            <!-- Cột phải: Kê đơn thuốc -->
                            <div class="col-md-6">
                                <h6 class="text-primary mb-3">
                                    <i class="fas fa-pills me-2"></i>Kê đơn thuốc
                                </h6>
                                
                                <div class="mb-3">
                                    <button type="button" class="btn btn-sm btn-outline-primary" 
                                            onclick="addMedicineRow()">
                                        <i class="fas fa-plus me-1"></i>Thêm thuốc
                                    </button>
                                </div>
                                
                                <div id="medicineList" style="max-height: 400px; overflow-y: auto;">
                                    <!-- Danh sách thuốc được thêm vào đây -->
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times me-1"></i>Hủy
                        </button>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-save me-1"></i>Lưu kết quả khám
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <jsp:include page="../includes/footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        let medicinesData = [];
        let medicineRowCounter = 0;
        
        // Load danh sách thuốc khi trang load
        fetch('get-medicines')
            .then(response => response.json())
            .then(data => {
                medicinesData = data;
            })
            .catch(error => console.error('Error loading medicines:', error));
        
        // Xem chi tiết bệnh nhân
        function viewPatientDetail(patientId) {
            const modal = new bootstrap.Modal(document.getElementById('patientDetailModal'));
            modal.show();
            
            fetch('patient-detail?patient_id=' + patientId)
                .then(response => response.json())
                .then(data => {
                    displayPatientDetail(data);
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('patientDetailContent').innerHTML = 
                        '<div class="alert alert-danger">Lỗi khi tải dữ liệu!</div>';
                });
        }
        
        // Hiển thị chi tiết bệnh nhân
        function displayPatientDetail(data) {
            if (data.error) {
                document.getElementById('patientDetailContent').innerHTML = 
                    '<div class="alert alert-danger">' + data.error + '</div>';
                return;
            }
            
            const patient = data.patient;
            const examinations = data.examinations;
            
            let html = '<div class="row">';
            
            // Thông tin cá nhân
            html += '<div class="col-md-4">';
            html += '<div class="card mb-3">';
            html += '<div class="card-header bg-primary text-white">';
            html += '<h6 class="mb-0"><i class="fas fa-user me-2"></i>Thông tin cá nhân</h6>';
            html += '</div>';
            html += '<div class="card-body">';
            html += '<p><strong>Họ tên:</strong> ' + patient.fullName + '</p>';
            html += '<p><strong>Email:</strong> ' + patient.email + '</p>';
            html += '<p><strong>Điện thoại:</strong> ' + patient.phone + '</p>';
            html += '<p><strong>Giới tính:</strong> ' + patient.gender + '</p>';
            html += '<p><strong>Ngày sinh:</strong> ' + (patient.dateOfBirth || 'N/A') + '</p>';
            html += '<p><strong>Nhóm máu:</strong> ' + (patient.bloodType || 'N/A') + '</p>';
            html += '<p><strong>Dị ứng:</strong> ' + (patient.allergies || 'Không') + '</p>';
            html += '<p><strong>Tiền sử:</strong> ' + (patient.medicalHistory || 'Không') + '</p>';
            html += '</div>';
            html += '</div>';
            html += '</div>';
            
            // Lịch sử khám
            html += '<div class="col-md-8">';
            html += '<div class="card">';
            html += '<div class="card-header bg-success text-white">';
            html += '<h6 class="mb-0"><i class="fas fa-history me-2"></i>Lịch sử khám bệnh</h6>';
            html += '</div>';
            html += '<div class="card-body" style="max-height: 500px; overflow-y: auto;">';
            
            if (examinations.length === 0) {
                html += '<p class="text-muted text-center py-4">Chưa có lịch sử khám bệnh</p>';
            } else {
                examinations.forEach(exam => {
                    html += '<div class="border rounded p-3 mb-3">';
                    html += '<div class="d-flex justify-content-between mb-2">';
                    html += '<h6 class="text-primary mb-0">' + exam.appointmentDate + '</h6>';
                    html += '<span class="badge bg-info">' + exam.doctorName + '</span>';
                    html += '</div>';
                    html += '<p class="mb-1"><strong>Triệu chứng:</strong> ' + (exam.symptoms || 'N/A') + '</p>';
                    html += '<p class="mb-1"><strong>Chẩn đoán:</strong> ' + (exam.diagnosis || 'N/A') + '</p>';
                    html += '<p class="mb-1"><strong>Ghi chú:</strong> ' + (exam.doctorNotes || 'Không có') + '</p>';
                    
                    if (exam.bloodPressure || exam.temperature || exam.pulseRate) {
                        html += '<p class="mb-1"><strong>Chỉ số:</strong> ';
                        if (exam.bloodPressure) html += 'Huyết áp: ' + exam.bloodPressure + ' | ';
                        if (exam.temperature) html += 'Nhiệt độ: ' + exam.temperature + '°C | ';
                        if (exam.pulseRate) html += 'Mạch: ' + exam.pulseRate + '/phút';
                        html += '</p>';
                    }
                    
                    // Đơn thuốc
                    if (exam.prescriptions && exam.prescriptions.length > 0) {
                        html += '<div class="mt-2">';
                        html += '<strong>Đơn thuốc:</strong>';
                        html += '<ul class="mb-0 mt-1">';
                        exam.prescriptions.forEach(p => {
                            html += '<li>' + p.medicineName + ' - ' + p.quantity + ' ' + p.unit + 
                                   ' (' + p.dosage + ')</li>';
                        });
                        html += '</ul>';
                        html += '</div>';
                    }
                    
                    html += '</div>';
                });
            }
            
            html += '</div>';
            html += '</div>';
            html += '</div>';
            
            html += '</div>';
            
            document.getElementById('patientDetailContent').innerHTML = html;
        }
        
        // Mở form khám bệnh
        function openExamForm(bookingId, patientName, symptoms) {
            document.getElementById('examBookingId').value = bookingId;
            document.getElementById('examPatientName').textContent = patientName;
            document.getElementById('examSymptoms').value = symptoms;
            document.getElementById('medicineList').innerHTML = '';
            medicineRowCounter = 0;
            
            const modal = new bootstrap.Modal(document.getElementById('examModal'));
            modal.show();
        }
        
        // Thêm dòng thuốc
        function addMedicineRow() {
            medicineRowCounter++;
            const rowId = 'medicine-row-' + medicineRowCounter;
            
            let html = '<div class="card mb-2" id="' + rowId + '">';
            html += '<div class="card-body p-2">';
            html += '<div class="row align-items-center">';
            
            // Chọn thuốc
            html += '<div class="col-md-5">';
            html += '<select class="form-select form-select-sm" name="medicine_ids[]" required>';
            html += '<option value="">Chọn thuốc...</option>';
            medicinesData.forEach(m => {
                html += '<option value="' + m.medicineId + '">' + m.name + ' (' + m.unit + ')</option>';
            });
            html += '</select>';
            html += '</div>';
            
            // Số lượng
            html += '<div class="col-md-2">';
            html += '<input type="number" class="form-control form-control-sm" name="quantities[]" ';
            html += 'placeholder="Số lượng" min="1" required>';
            html += '</div>';
            
            // Liều lượng
            html += '<div class="col-md-4">';
            html += '<input type="text" class="form-control form-control-sm" name="dosages[]" ';
            html += 'placeholder="VD: Ngày 2 lần, sáng tối" required>';
            html += '</div>';
            
            // Nút xóa
            html += '<div class="col-md-1">';
            html += '<button type="button" class="btn btn-sm btn-danger" onclick="removeMedicineRow(\'' + rowId + '\')">';
            html += '<i class="fas fa-trash"></i>';
            html += '</button>';
            html += '</div>';
            
            html += '</div>';
            html += '</div>';
            html += '</div>';
            
            document.getElementById('medicineList').insertAdjacentHTML('beforeend', html);
        }
        
        // Xóa dòng thuốc
        function removeMedicineRow(rowId) {
            document.getElementById(rowId).remove();
        }
    </script>
</body>
</html>