<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.clinic.model.bean.User"%>
<%
    User headerUser = (User) session.getAttribute("user");
    String headerRole = (headerUser != null) ? headerUser.getRole() : "";
%>
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
                    <a class="nav-link text-dark" href="home.jsp">Trang chủ</a>
                </li>
                
                <% if (headerUser != null) { %>
                    <!-- Menu dành cho user đã đăng nhập -->
                    <% if ("patient".equals(headerRole)) { %>
                        <li class="nav-item">
                            <a class="nav-link text-dark" href="${pageContext.request.contextPath}/booking">
                                <i class="fas fa-calendar-check me-1"></i>Đặt lịch
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-dark" href="${pageContext.request.contextPath}/my-bookings">
                                <i class="fas fa-list-alt me-1"></i>Lịch hẹn của tôi
                            </a>
                        </li>
                    <% } else if ("doctor".equals(headerRole)) { %>
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
                    <% } else if ("admin".equals(headerRole)) { %>
                        <li class="nav-item">
                            <a class="nav-link text-dark" href="admin-dashboard.jsp">
                                <i class="fas fa-cogs me-1"></i>Quản lý hệ thống
                            </a>
                        </li>
                    <% } %>
                <% } %>
            </ul>
            
            <div class="navbar-nav">
                <% if (headerUser != null) { %>
                    <!-- Hiển thị khi ĐÃ đăng nhập -->
                    <div class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle text-dark" href="#" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle me-1"></i><%= headerUser.getFullname() %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <% if ("patient".equals(headerRole)) { %>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/patient-profile">
                                    <i class="fas fa-user-edit me-2"></i>Hồ sơ bệnh nhân
                                </a></li>
                                <li><a class="dropdown-item" href="medical-history.jsp">
                                    <i class="fas fa-file-medical me-2"></i>Lịch sử khám bệnh
                                </a></li>
                            <% } else if ("doctor".equals(headerRole)) { %>
                                <li><a class="dropdown-item" href="doctor-profile.jsp">
                                    <i class="fas fa-user-md me-2"></i>Hồ sơ bác sĩ
                                </a></li>
                            <% } else if ("admin".equals(headerRole)) { %>
                                <li><a class="dropdown-item" href="admin-dashboard.jsp">
                                    <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                                </a></li>
                                <li><a class="dropdown-item" href="manage-users.jsp">
                                    <i class="fas fa-users-cog me-2"></i>Quản lý người dùng
                                </a></li>
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