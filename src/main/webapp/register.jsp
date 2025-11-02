<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - MediCare Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #1a76d2;
            --secondary: #34a853;
        }
        
        .register-container {
            min-height: 100vh;
            background: linear-gradient(135deg, rgba(26, 118, 210, 0.1), rgba(52, 168, 83, 0.1));
            display: flex;
            align-items: center;
            padding: 2rem 0;
        }
        
        .register-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .register-header {
            background: linear-gradient(135deg, var(--secondary), var(--primary));
            color: white;
            padding: 2rem;
            text-align: center;
        }
        
        .register-body {
            padding: 2rem;
        }
        
        .form-control, .form-select {
            border-radius: 10px;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 0.2rem rgba(26, 118, 210, 0.25);
        }
        
        .btn-register {
            background: linear-gradient(135deg, var(--secondary), var(--primary));
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8">
                    <div class="card register-card">
                        <div class="register-header">
                            <i class="fas fa-user-plus fa-3x mb-3"></i>
                            <h3>Đăng ký tài khoản mới</h3>
                            <p class="mb-0">Tham gia cùng MediCare Clinic ngay hôm nay</p>
                        </div>
                        <div class="card-body register-body">
                            <form action="register" method="post">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label fw-semibold">Họ và tên <span class="text-danger">*</span></label>
                                            <input type="text" name="fullname" class="form-control" placeholder="Nhập họ và tên đầy đủ" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label fw-semibold">Email <span class="text-danger">*</span></label>
                                            <input type="email" name="email" class="form-control" placeholder="Nhập email của bạn" required>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label fw-semibold">Mật khẩu <span class="text-danger">*</span></label>
                                            <input type="password" name="password" class="form-control" placeholder="Tạo mật khẩu" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label fw-semibold">Số điện thoại</label>
                                            <input type="text" name="phone" class="form-control" placeholder="Nhập số điện thoại">
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label fw-semibold">Giới tính</label>
                                            <select name="gender" class="form-select">
                                                <option value="Nam">Nam</option>
                                                <option value="Nữ">Nữ</option>
                                                <option value="Khác">Khác</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label fw-semibold">Ngày sinh</label>
                                            <input type="date" name="dateOfBirth" class="form-control">
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mb-4 form-check">
                                    <input type="checkbox" class="form-check-input" id="agreeTerms" required>
                                    <label class="form-check-label" for="agreeTerms">
                                        Tôi đồng ý với <a href="#" class="text-primary text-decoration-none">điều khoản sử dụng</a> và <a href="#" class="text-primary text-decoration-none">chính sách bảo mật</a>
                                    </label>
                                </div>
                                
                                <button type="submit" class="btn btn-register text-white w-100 mb-3">
                                    <i class="fas fa-user-plus me-2"></i>Đăng ký tài khoản
                                </button>
                            </form>
                            <hr class="my-4">
                            <p class="text-center mb-0">Đã có tài khoản? 
                                <a href="login.jsp" class="text-primary text-decoration-none fw-semibold">Đăng nhập ngay</a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>