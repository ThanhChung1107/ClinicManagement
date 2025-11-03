<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.clinic.model.bean.Patient"%>
<%
    Patient patient = (Patient) request.getAttribute("patient");
    if (patient == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ bệnh nhân - MediCare Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .profile-header {
            background: linear-gradient(135deg, #1a76d2, #34a853);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .profile-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        .info-label {
            font-weight: 600;
            color: #495057;
        }
        .section-title {
            color: #1a76d2;
            border-bottom: 2px solid #1a76d2;
            padding-bottom: 0.5rem;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>
    <!-- Navigation (sử dụng navigation từ home.jsp) -->
    <jsp:include page="/includes/header.jsp" />
    
    <!-- Profile Header -->
    <div class="profile-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1><i class="fas fa-user-injured me-2"></i>Hồ sơ bệnh nhân</h1>
                    <p class="mb-0">Quản lý thông tin sức khỏe và hồ sơ cá nhân</p>
                </div>
                <div class="col-md-4 text-end">
                    <span class="badge bg-light text-dark fs-6">
                        <i class="fas fa-id-card me-1"></i>Mã BN: <%= patient.getPatientId() %>
                    </span>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Thông báo -->
        <% if ("1".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>Cập nhật hồ sơ thành công!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        <% if ("1".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>Có lỗi xảy ra khi cập nhật hồ sơ!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <form action="patient-profile" method="post">
            <div class="row">
                <!-- Thông tin cá nhân -->
                <div class="col-lg-6">
                    <div class="card profile-card">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0"><i class="fas fa-user me-2"></i>Thông tin cá nhân</h5>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="info-label">Họ và tên</label>
                                    <p class="form-control-plaintext"><%= patient.getFullName() %></p>
                                </div>
                                <div class="col-md-6">
                                    <label class="info-label">Giới tính</label>
                                    <p class="form-control-plaintext"><%= patient.getGender() != null ? patient.getGender() : "Chưa cập nhật" %></p>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label class="info-label">Email</label>
                                    <p class="form-control-plaintext"><%= patient.getEmail() %></p>
                                </div>
                                <div class="col-md-6">
                                    <label class="info-label">Số điện thoại</label>
                                    <p class="form-control-plaintext"><%= patient.getPhone() != null ? patient.getPhone() : "Chưa cập nhật" %></p>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label class="info-label">Ngày sinh</label>
                                <p class="form-control-plaintext">
                                    <%= patient.getDateOfBirth() != null ? patient.getDateOfBirth() : "Chưa cập nhật" %>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Thông tin sức khỏe -->
                <div class="col-lg-6">
                    <div class="card profile-card">
                        <div class="card-header bg-success text-white">
                            <h5 class="mb-0"><i class="fas fa-heartbeat me-2"></i>Thông tin sức khỏe</h5>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label for="blood_type" class="form-label info-label">Nhóm máu</label>
                                <select class="form-select" id="blood_type" name="blood_type">
                                    <option value="">Chọn nhóm máu</option>
                                    <option value="A" <%= "A".equals(patient.getBloodType()) ? "selected" : "" %>>A</option>
                                    <option value="B" <%= "B".equals(patient.getBloodType()) ? "selected" : "" %>>B</option>
                                    <option value="AB" <%= "AB".equals(patient.getBloodType()) ? "selected" : "" %>>AB</option>
                                    <option value="O" <%= "O".equals(patient.getBloodType()) ? "selected" : "" %>>O</option>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label for="allergies" class="form-label info-label">Dị ứng</label>
                                <textarea class="form-control" id="allergies" name="allergies" 
                                          rows="3" placeholder="Khai báo các dị ứng (nếu có)"><%= patient.getAllergies() != null ? patient.getAllergies() : "" %></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label for="medical_history" class="form-label info-label">Tiền sử bệnh</label>
                                <textarea class="form-control" id="medical_history" name="medical_history" 
                                          rows="3" placeholder="Khai báo tiền sử bệnh (nếu có)"><%= patient.getMedicalHistory() != null ? patient.getMedicalHistory() : "" %></textarea>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <!-- Nút submit -->
            <div class="row mb-5">
                <div class="col-12 text-center">
                    <button type="submit" class="btn btn-primary btn-lg px-5">
                        <i class="fas fa-save me-2"></i>Cập nhật hồ sơ
                    </button>
                    <a href="patient-dashboard.jsp" class="btn btn-outline-secondary btn-lg px-5 ms-2">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </a>
                </div>
            </div>
        </form>
    </div>

    <!-- Footer -->
    <jsp:include page="/includes/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>