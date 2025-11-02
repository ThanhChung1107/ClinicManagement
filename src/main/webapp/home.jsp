<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.clinic.model.bean.User"%>
<%
    User user = (User) session.getAttribute("user");
    String role = (user != null) ? user.getRole() : "";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phòng Khám Đa Khoa Sức Khỏe</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #1a76d2;
            --secondary: #34a853;
            --doctor: #8e44ad;
            --admin: #e74c3c;
        }
        
        .hero-section {
            background: linear-gradient(135deg, rgba(26, 118, 210, 0.9), rgba(52, 168, 83, 0.8)),
                        url('https://images.unsplash.com/photo-1551076805-e1869033e561?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80');
            background-size: cover;
            background-position: center;
            color: white;
            padding: 120px 0;
            position: relative;
        }
        
        .role-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .badge-patient {
            background: var(--secondary);
            color: white;
        }
        
        .badge-doctor {
            background: var(--doctor);
            color: white;
        }
        
        .badge-admin {
            background: var(--admin);
            color: white;
        }
        
        .user-welcome {
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            padding: 10px 15px;
            margin-right: 15px;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top">
        <div class="container">
            <a class="navbar-brand text-primary" href="home.jsp">
                <i class="fas fa-stethoscope me-2"></i>MediCare Clinic
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item">
                        <a class="nav-link active text-dark" href="#home">Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-dark" href="#services">Dịch vụ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-dark" href="#about">Giới thiệu</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-dark" href="#contact">Liên hệ</a>
                    </li>
                    
                    <% if (user != null) { %>
                        <!-- Menu dành cho user đã đăng nhập -->
                        <% if ("patient".equals(role)) { %>
                            <li class="nav-item">
                                <a class="nav-link text-dark" href="booking.jsp">
                                    <i class="fas fa-calendar-check me-1"></i>Đặt lịch
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-dark" href="my-appointments.jsp">
                                    <i class="fas fa-list-alt me-1"></i>Lịch hẹn của tôi
                                </a>
                            </li>
                        <% } else if ("doctor".equals(role)) { %>
                            <li class="nav-item">
                                <a class="nav-link text-dark" href="doctor-schedule.jsp">
                                    <i class="fas fa-calendar-alt me-1"></i>Lịch làm việc
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-dark" href="doctor-appointments.jsp">
                                    <i class="fas fa-user-md me-1"></i>Bệnh nhân của tôi
                                </a>
                            </li>
                        <% } else if ("admin".equals(role)) { %>
                            <li class="nav-item">
                                <a class="nav-link text-dark" href="admin-dashboard.jsp">
                                    <i class="fas fa-cogs me-1"></i>Quản lý hệ thống
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-dark" href="manage-doctors.jsp">
                                    <i class="fas fa-users me-1"></i>Quản lý bác sĩ
                                </a>
                            </li>
                        <% } %>
                    <% } %>
                </ul>
                
                <div class="navbar-nav">
                    <% if (user != null) { %>
                        <!-- Hiển thị khi ĐÃ đăng nhập -->
                        <div class="user-welcome">
                            <span class="text-dark">
                                <i class="fas fa-user me-1"></i>Xin chào, <strong><%= user.getFullname() %></strong>
                                <span class="role-badge badge-<%= role %> ms-2">
                                    <% 
                                        if ("patient".equals(role)) out.print("Bệnh nhân");
                                        else if ("doctor".equals(role)) out.print("Bác sĩ");
                                        else if ("admin".equals(role)) out.print("Quản trị viên");
                                    %>
                                </span>
                            </span>
                        </div>
                        <div class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle text-dark" href="#" role="button" data-bs-toggle="dropdown">
                                <i class="fas fa-cog me-1"></i>Tài khoản
                            </a>
                            <ul class="dropdown-menu">
                                <% if ("patient".equals(role)) { %>
                                    <li><a class="dropdown-item" href="patient-dashboard.jsp"><i class="fas fa-tachometer-alt me-2"></i>Dashboard bệnh nhân</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/patient-profile">
									    <i class="fas fa-user-edit me-2"></i>Hồ sơ bệnh nhân
									</a></li>
                                    <li><a class="dropdown-item" href="medical-history.jsp"><i class="fas fa-file-medical me-2"></i>Lịch sử khám bệnh</a></li>
                                <% } else if ("doctor".equals(role)) { %>
                                    <li><a class="dropdown-item" href="doctor-dashboard.jsp"><i class="fas fa-tachometer-alt me-2"></i>Dashboard bác sĩ</a></li>
                                    <li><a class="dropdown-item" href="doctor-profile.jsp"><i class="fas fa-user-md me-2"></i>Hồ sơ bác sĩ</a></li>
                                    <li><a class="dropdown-item" href="doctor-schedule.jsp"><i class="fas fa-calendar-alt me-2"></i>Quản lý lịch trình</a></li>
                                <% } else if ("admin".equals(role)) { %>
                                    <li><a class="dropdown-item" href="admin-dashboard.jsp"><i class="fas fa-tachometer-alt me-2"></i>Dashboard quản trị</a></li>
                                    <li><a class="dropdown-item" href="manage-users.jsp"><i class="fas fa-users-cog me-2"></i>Quản lý người dùng</a></li>
                                    <li><a class="dropdown-item" href="system-settings.jsp"><i class="fas fa-cog me-2"></i>Cài đặt hệ thống</a></li>
                                <% } %>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
								    <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
								</a></li>
                            </ul>
                        </div>
                    <% } else { %>
                        <!-- Hiển thị khi CHƯA đăng nhập -->
                        <a class="btn btn-outline-primary me-2" href="login.jsp">
                            <i class="fas fa-sign-in-alt me-1"></i>Đăng nhập
                        </a>
                        <a class="btn btn-primary" href="register.jsp">
                            <i class="fas fa-user-plus me-1"></i>Đăng ký
                        </a>
                    <% } %>
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section id="home" class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h1 class="display-4 fw-bold mb-4">Chăm Sóc Sức Khỏe Toàn Diện</h1>
                    <p class="lead mb-4">Đội ngũ bác sĩ chuyên môn cao, trang thiết bị hiện đại, dịch vụ chăm sóc tận tâm 24/7</p>
                    <div class="d-flex flex-wrap gap-3">
                        <% if (user != null) { %>
                            <!-- Hiển thị khi ĐÃ đăng nhập -->
                            <% if ("patient".equals(role)) { %>
                                <a href="booking.jsp" class="btn btn-light btn-lg px-4 py-2">
                                    <i class="fas fa-calendar-plus me-2"></i>Đặt lịch khám
                                </a>
                                <a href="patient-dashboard.jsp" class="btn btn-outline-light btn-lg px-4 py-2">
                                    <i class="fas fa-tachometer-alt me-2"></i>Quản lý hồ sơ
                                </a>
                            <% } else if ("doctor".equals(role)) { %>
                                <a href="doctor-appointments.jsp" class="btn btn-light btn-lg px-4 py-2">
                                    <i class="fas fa-user-md me-2"></i>Xem lịch hẹn
                                </a>
                                <a href="doctor-dashboard.jsp" class="btn btn-outline-light btn-lg px-4 py-2">
                                    <i class="fas fa-tachometer-alt me-2"></i>Dashboard bác sĩ
                                </a>
                            <% } else if ("admin".equals(role)) { %>
                                <a href="admin-dashboard.jsp" class="btn btn-light btn-lg px-4 py-2">
                                    <i class="fas fa-cogs me-2"></i>Quản lý hệ thống
                                </a>
                                <a href="manage-users.jsp" class="btn btn-outline-light btn-lg px-4 py-2">
                                    <i class="fas fa-users-cog me-2"></i>Quản lý người dùng
                                </a>
                            <% } %>
                        <% } else { %>
                            <!-- Hiển thị khi CHƯA đăng nhập -->
                            <a href="register.jsp" class="btn btn-light btn-lg px-4 py-2">
                                <i class="fas fa-calendar-plus me-2"></i>Đặt lịch khám
                            </a>
                            <a href="#services" class="btn btn-outline-light btn-lg px-4 py-2">
                                <i class="fas fa-info-circle me-2"></i>Tìm hiểu thêm
                            </a>
                        <% } %>
                    </div>
                </div>
                <div class="col-lg-6 text-center">
                    <div class="feature-card bg-white text-dark p-4 mx-auto" style="max-width: 400px;">
                        <div class="feature-icon">
                            <% if (user != null) { %>
                                <% if ("doctor".equals(role)) { %>
                                    <i class="fas fa-user-md"></i>
                                <% } else if ("admin".equals(role)) { %>
                                    <i class="fas fa-cogs"></i>
                                <% } else { %>
                                    <i class="fas fa-clock"></i>
                                <% } %>
                            <% } else { %>
                                <i class="fas fa-clock"></i>
                            <% } %>
                        </div>
                        <h4>
                            <% if (user != null) { %>
                                <% if ("doctor".equals(role)) { %>
                                    Quản lý bệnh nhân
                                <% } else if ("admin".equals(role)) { %>
                                    Quản trị hệ thống
                                <% } else { %>
                                    Lịch khám linh hoạt
                                <% } %>
                            <% } else { %>
                                Lịch khám linh hoạt
                            <% } %>
                        </h4>
                        <p class="text-muted">
                            <% if (user != null && "doctor".equals(role)) { %>
                                Quản lý lịch hẹn và hồ sơ bệnh nhân một cách chuyên nghiệp
                            <% } else if (user != null && "admin".equals(role)) { %>
                                Quản lý toàn bộ hệ thống phòng khám hiệu quả
                            <% } else { %>
                                Đặt lịch khám online 24/7, lựa chọn thời gian phù hợp với bạn
                            <% } %>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="stats-section">
        <div class="container">
            <div class="row text-center">
                <div class="col-md-3 col-6 mb-4">
                    <div class="stat-number">5000+</div>
                    <p class="mb-0">Bệnh nhân hài lòng</p>
                </div>
                <div class="col-md-3 col-6 mb-4">
                    <div class="stat-number">50+</div>
                    <p class="mb-0">Bác sĩ chuyên khoa</p>
                </div>
                <div class="col-md-3 col-6 mb-4">
                    <div class="stat-number">24/7</div>
                    <p class="mb-0">Hỗ trợ trực tuyến</p>
                </div>
                <div class="col-md-3 col-6 mb-4">
                    <div class="stat-number">15+</div>
                    <p class="mb-0">Năm kinh nghiệm</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Services Section -->
    <section id="services" class="py-5 bg-light">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="fw-bold text-primary">Dịch Vụ Y Tế Chất Lượng</h2>
                <p class="text-muted">Cung cấp đa dạng các dịch vụ chăm sóc sức khỏe toàn diện</p>
            </div>
            
            <div class="row g-4">
                <div class="col-lg-4 col-md-6">
                    <div class="card service-card h-100 text-center p-4">
                        <div class="service-icon">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <h5>Khám Tổng Quát</h5>
                        <p class="text-muted">Khám sức khỏe định kỳ, tầm soát bệnh và tư vấn sức khỏe toàn diện</p>
                    </div>
                </div>
                
                <div class="col-lg-4 col-md-6">
                    <div class="card service-card h-100 text-center p-4">
                        <div class="service-icon">
                            <i class="fas fa-heartbeat"></i>
                        </div>
                        <h5>Chuyên Khoa Tim Mạch</h5>
                        <p class="text-muted">Chẩn đoán và điều trị các bệnh lý về tim mạch với công nghệ hiện đại</p>
                    </div>
                </div>
                
                <div class="col-lg-4 col-md-6">
                    <div class="card service-card h-100 text-center p-4">
                        <div class="service-icon">
                            <i class="fas fa-baby"></i>
                        </div>
                        <h5>Nhi Khoa</h5>
                        <p class="text-muted">Chăm sóc sức khỏe trẻ em với đội ngũ bác sĩ chuyên khoa nhi giàu kinh nghiệm</p>
                    </div>
                </div>
                
                <div class="col-lg-4 col-md-6">
                    <div class="card service-card h-100 text-center p-4">
                        <div class="service-icon">
                            <i class="fas fa-teeth"></i>
                        </div>
                        <h5>Nha Khoa</h5>
                        <p class="text-muted">Dịch vụ nha khoa toàn diện từ cơ bản đến thẩm mỹ</p>
                    </div>
                </div>
                
                <div class="col-lg-4 col-md-6">
                    <div class="card service-card h-100 text-center p-4">
                        <div class="service-icon">
                            <i class="fas fa-eye"></i>
                        </div>
                        <h5>Khám Mắt</h5>
                        <p class="text-muted">Kiểm tra thị lực và điều trị các bệnh lý về mắt</p>
                    </div>
                </div>
                
                <div class="col-lg-4 col-md-6">
                    <div class="card service-card h-100 text-center p-4">
                        <div class="service-icon">
                            <i class="fas fa-ambulance"></i>
                        </div>
                        <h5>Cấp Cứu 24/7</h5>
                        <p class="text-muted">Dịch vụ cấp cứu khẩn cấp, sẵn sàng hỗ trợ mọi lúc</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="py-5 bg-primary text-white">
        <div class="container text-center">
            <h2 class="fw-bold mb-3">Sẵn sàng chăm sóc sức khỏe của bạn?</h2>
            <p class="lead mb-4">Đăng ký ngay để trải nghiệm dịch vụ y tế chất lượng cao</p>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-dark text-white py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-3">
                    <h5><i class="fas fa-stethoscope me-2"></i>MediCare Clinic</h5>
                    <p class="text-white">Chăm sóc sức khỏe toàn diện - Vì một cộng đồng khỏe mạnh</p>
                </div>
                <div class="col-md-4 mb-3">
                    <h5>Liên hệ</h5>
                    <p class="text-white mb-1">
                        <i class="fas fa-map-marker-alt me-2"></i>123 Đường ABC, Quận 1, TP.HCM
                    </p>
                    <p class="text-muted mb-1">
                        <i class="fas fa-phone me-2"></i>(028) 1234 5678
                    </p>
                    <p class="text-muted">
                        <i class="fas fa-envelope me-2"></i>info@medicare.com
                    </p>
                </div>
                <div class="col-md-4 mb-3">
                    <h5>Kết nối với chúng tôi</h5>
                    <div class="d-flex gap-3">
                        <a href="#" class="text-white"><i class="fab fa-facebook fa-2x"></i></a>
                        <a href="#" class="text-white"><i class="fab fa-twitter fa-2x"></i></a>
                        <a href="#" class="text-white"><i class="fab fa-instagram fa-2x"></i></a>
                        <a href="#" class="text-white"><i class="fab fa-youtube fa-2x"></i></a>
                    </div>
                </div>
            </div>
            <hr class="my-4">
            <div class="text-center text-muted">
                <p class="mb-0">&copy; 2025 MediCare Clinic. Tất cả các quyền được bảo lưu.</p>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>