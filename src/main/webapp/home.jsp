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
                                <a class="nav-link text-dark" href="${pageContext.request.contextPath}/my-bookings">
                                    <i class="fas fa-list-alt me-1"></i>Lịch hẹn của tôi
                                </a>
                            </li>
                        <% } else if ("doctor".equals(role)) { %>
                            <li class="nav-item">
                                <a class="nav-link text-dark" href="${pageContext.request.contextPath}/doctor-calendar">
                                    <i class="fas fa-calendar-alt me-1"></i>Lịch làm việc
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link text-dark" href="${pageContext.request.contextPath}/doctor-patients">
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
                                <a href="${pageContext.request.contextPath}/booking" class="btn btn-light btn-lg px-4 py-2">
                                    <i class="fas fa-calendar-plus me-2"></i>Đặt lịch khám
                                </a>
                                <a href="patient-dashboard.jsp" class="btn btn-outline-light btn-lg px-4 py-2">
                                    <i class="fas fa-tachometer-alt me-2"></i>Quản lý hồ sơ
                                </a>
                            <% } else if ("doctor".equals(role)) { %>
                                <a href="${pageContext.request.contextPath}/doctor-bookings" class="btn btn-light btn-lg px-4 py-2">
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
                
				<div class="col-lg-6 text-center mt-4 mt-lg-0 ">
				    <div class="card shadow-lg border-0 rounded-4 mx-auto" style="max-width: 400px;">
				        <div class="card-body p-4">
				            <!-- Feature Icon -->
				            <div class="bg-primary bg-gradient rounded-circle d-flex align-items-center justify-content-center mx-auto mb-3" 
				                 style="width: 100px; height: 100px;">
				                <% if (user != null) { %>
				                    <% if ("doctor".equals(role)) { %>
				                        <i class="fas fa-user-md text-white fs-1"></i>
				                    <% } else if ("admin".equals(role)) { %>
				                        <i class="fas fa-cogs text-white fs-1"></i>
				                    <% } else { %>
				                        <i class="fas fa-clock text-white fs-1"></i>
				                    <% } %>
				                <% } else { %>
				                    <i class="fas fa-clock text-white fs-1"></i>
				                <% } %>
				            </div>
				            
				            <!-- Feature Title -->
				            <h4 class="card-title fw-bold text-primary mb-3">
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
				            
				            <!-- Feature Description -->
				            <p class="card-text text-muted">
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
        </div>
    </section>

    <!-- Stats Section - Simple Version -->
		<section class="stats-section py-5 bg-light">
		    <div class="container">
		        <div class="row text-center">
		            <div class="col-lg-3 col-md-6 mb-4">
		                <div class="stat-item p-4">
		                    <div class="stat-number h1 fw-bold text-primary mb-2">5,000+</div>
		                    <div class="stat-label">
		                        <i class="fas fa-smile text-success me-2"></i>
		                        <span class="fs-5 text-dark">Bệnh nhân hài lòng</span>
		                    </div>
		                </div>
		            </div>
		            
		            <div class="col-lg-3 col-md-6 mb-4">
		                <div class="stat-item p-4">
		                    <div class="stat-number h1 fw-bold text-success mb-2">50+</div>
		                    <div class="stat-label">
		                        <i class="fas fa-user-md text-primary me-2"></i>
		                        <span class="fs-5 text-dark">Bác sĩ chuyên khoa</span>
		                    </div>
		                </div>
		            </div>
		            
		            <div class="col-lg-3 col-md-6 mb-4">
		                <div class="stat-item p-4">
		                    <div class="stat-number h1 fw-bold text-info mb-2">24/7</div>
		                    <div class="stat-label">
		                        <i class="fas fa-headset text-info me-2"></i>
		                        <span class="fs-5 text-dark">Hỗ trợ trực tuyến</span>
		                    </div>
		                </div>
		            </div>
		            
		            <div class="col-lg-3 col-md-6 mb-4">
		                <div class="stat-item p-4">
		                    <div class="stat-number h1 fw-bold text-warning mb-2">15+</div>
		                    <div class="stat-label">
		                        <i class="fas fa-award text-warning me-2"></i>
		                        <span class="fs-5 text-dark">Năm kinh nghiệm</span>
		                    </div>
		                </div>
		            </div>
		        </div>
		    </div>
		</style>
		
		<style>
		.stats-section {
		    background: #f8f9fa;
		}
		
		.stat-item {
		    transition: transform 0.3s ease;
		}
		
		.stat-item:hover {
		    transform: scale(1.05);
		}
		
		.stat-number {
		    text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
		}
		
		.stat-label {
		    font-weight: 500;
		}
		</style>

    <!-- Services Section -->
<section id="services" class="services-section py-5">
    <div class="container">
        <div class="text-center mb-5">
            <h2 class="fw-bold text-primary mb-3">Dịch Vụ Y Tế Chất Lượng</h2>
            <p class="lead text-muted">Cung cấp đa dạng các dịch vụ chăm sóc sức khỏe toàn diện</p>
            <div class="title-underline mx-auto"></div>
        </div>
        
        <div class="row g-4">
            <div class="col-lg-4 col-md-6">
                <div class="service-card card h-100 text-center p-4">
                    <div class="service-icon mb-4">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <h4 class="service-title mb-3">Khám Tổng Quát</h4>
                    <p class="service-description text-muted">Khám sức khỏe định kỳ, tầm soát bệnh và tư vấn sức khỏe toàn diện</p>
                    <div class="service-overlay">
                        <a href="#" class="btn btn-outline-light">Tìm hiểu thêm</a>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4 col-md-6">
                <div class="service-card card h-100 text-center p-4">
                    <div class="service-icon mb-4">
                        <i class="fas fa-heartbeat"></i>
                    </div>
                    <h4 class="service-title mb-3">Chuyên Khoa Tim Mạch</h4>
                    <p class="service-description text-muted">Chẩn đoán và điều trị các bệnh lý về tim mạch với công nghệ hiện đại</p>
                    <div class="service-overlay">
                        <a href="#" class="btn btn-outline-light">Tìm hiểu thêm</a>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4 col-md-6">
                <div class="service-card card h-100 text-center p-4">
                    <div class="service-icon mb-4">
                        <i class="fas fa-baby"></i>
                    </div>
                    <h4 class="service-title mb-3">Nhi Khoa</h4>
                    <p class="service-description text-muted">Chăm sóc sức khỏe trẻ em với đội ngũ bác sĩ chuyên khoa nhi giàu kinh nghiệm</p>
                    <div class="service-overlay">
                        <a href="#" class="btn btn-outline-light">Tìm hiểu thêm</a>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4 col-md-6">
                <div class="service-card card h-100 text-center p-4">
                    <div class="service-icon mb-4">
                        <i class="fas fa-tooth"></i>
                    </div>
                    <h4 class="service-title mb-3">Nha Khoa</h4>
                    <p class="service-description text-muted">Dịch vụ nha khoa toàn diện từ cơ bản đến thẩm mỹ với công nghệ tiên tiến</p>
                    <div class="service-overlay">
                        <a href="#" class="btn btn-outline-light">Tìm hiểu thêm</a>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4 col-md-6">
                <div class="service-card card h-100 text-center p-4">
                    <div class="service-icon mb-4">
                        <i class="fas fa-eye"></i>
                    </div>
                    <h4 class="service-title mb-3">Khám Mắt</h4>
                    <p class="service-description text-muted">Kiểm tra thị lực và điều trị các bệnh lý về mắt với thiết bị hiện đại</p>
                    <div class="service-overlay">
                        <a href="#" class="btn btn-outline-light">Tìm hiểu thêm</a>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4 col-md-6">
                <div class="service-card card h-100 text-center p-4">
                    <div class="service-icon mb-4">
                        <i class="fas fa-ambulance"></i>
                    </div>
                    <h4 class="service-title mb-3">Cấp Cứu 24/7</h4>
                    <p class="service-description text-muted">Dịch vụ cấp cứu khẩn cấp, sẵn sàng hỗ trợ mọi lúc, mọi nơi</p>
                    <div class="service-overlay">
                        <a href="#" class="btn btn-outline-light">Tìm hiểu thêm</a>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="text-center mt-5">
            <a href="#" class="btn btn-primary btn-lg px-5">
                <i class="fas fa-calendar-plus me-2"></i>Đặt lịch khám ngay
            </a>
        </div>
    </div>
</section>

<style>
.services-section {
    background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
    position: relative;
}

.title-underline {
    width: 80px;
    height: 4px;
    background: linear-gradient(135deg, var(--primary), var(--secondary));
    border-radius: 2px;
}

.service-card {
    border: none;
    border-radius: 20px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
    transition: all 0.4s ease;
    overflow: hidden;
    position: relative;
    background: white;
}

.service-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 4px;
    background: linear-gradient(135deg, var(--primary), var(--secondary));
    transform: scaleX(0);
    transition: transform 0.4s ease;
}

.service-card:hover::before {
    transform: scaleX(1);
}

.service-card:hover {
    transform: translateY(-10px);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
}

.service-icon {
    width: 100px;
    height: 100px;
    margin: 0 auto;
    background: linear-gradient(135deg, var(--primary), var(--secondary));
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.4s ease;
}

.service-card:hover .service-icon {
    transform: scale(1.1) rotate(5deg);
    box-shadow: 0 10px 25px rgba(26, 118, 210, 0.3);
}

.service-icon i {
    font-size: 2.5rem;
    color: white;
}

.service-title {
    color: #2c3e50;
    font-weight: 700;
    transition: color 0.3s ease;
}

.service-card:hover .service-title {
    color: var(--primary);
}

.service-description {
    line-height: 1.6;
    margin-bottom: 0;
}

.service-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(135deg, rgba(26, 118, 210, 0.9), rgba(52, 168, 83, 0.9));
    display: flex;
    align-items: center;
    justify-content: center;
    opacity: 0;
    transition: all 0.4s ease;
    border-radius: 20px;
}

.service-card:hover .service-overlay {
    opacity: 1;
}

/* Responsive */
@media (max-width: 768px) {
    .service-card {
        margin: 0 10px;
    }
    
    .service-icon {
        width: 80px;
        height: 80px;
    }
    
    .service-icon i {
        font-size: 2rem;
    }
}

/* Animation for cards */
@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.service-card {
    animation: fadeInUp 0.6s ease forwards;
}

.service-card:nth-child(1) { animation-delay: 0.1s; }
.service-card:nth-child(2) { animation-delay: 0.2s; }
.service-card:nth-child(3) { animation-delay: 0.3s; }
.service-card:nth-child(4) { animation-delay: 0.4s; }
.service-card:nth-child(5) { animation-delay: 0.5s; }
.service-card:nth-child(6) { animation-delay: 0.6s; }
</style>

    <!-- CTA Section -->
    <!-- CTA Section - Simple but Beautiful -->
<!-- CTA Section with Subtle Gradient -->
	<section class="py-5 text-white" style="background: linear-gradient(135deg, #1a76d2, #1976d2);">
	    <div class="container text-center">
	        <h2 class="fw-bold mb-3 display-5">Sẵn sàng chăm sóc sức khỏe của bạn?</h2>
	        <p class="lead mb-4 fs-5">Đăng ký ngay để trải nghiệm dịch vụ y tế chất lượng cao</p>
	        <a href="register.jsp" class="btn btn-light btn-lg px-5 py-3 fw-bold">
	            <i class="fas fa-calendar-plus me-2"></i>Bắt đầu ngay
	        </a>
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