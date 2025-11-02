<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - MediCare Clinic</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #1a76d2;
            --secondary: #34a853;
        }
        
        .login-container {
            min-height: 100vh;
            background: linear-gradient(135deg, rgba(26, 118, 210, 0.1), rgba(52, 168, 83, 0.1));
            display: flex;
            align-items: center;
        }
        
        .login-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .login-header {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            padding: 2rem;
            text-align: center;
        }
        
        .login-body {
            padding: 2rem;
        }
        
        .form-control {
            border-radius: 10px;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 0.2rem rgba(26, 118, 210, 0.25);
        }
        
        .btn-login {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-6 col-lg-5">
                    <div class="card login-card">
                        <div class="login-header">
                            <i class="fas fa-stethoscope fa-3x mb-3"></i>
                            <h3>Đăng nhập hệ thống</h3>
                            <p class="mb-0">Chào mừng trở lại MediCare Clinic</p>
                        </div>
                        <div class="card-body login-body">
                            <form action="login" method="post">
                                <div class="mb-3">
                                    <label class="form-label fw-semibold">Email</label>
                                    <input type="email" name="email" class="form-control" placeholder="Nhập email của bạn" required>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label fw-semibold">Mật khẩu</label>
                                    <input type="password" name="password" class="form-control" placeholder="Nhập mật khẩu" required>
                                </div>
                                <div class="mb-3 form-check">
                                    <input type="checkbox" class="form-check-input" id="remember">
                                    <label class="form-check-label" for="remember">Ghi nhớ đăng nhập</label>
                                </div>
                                <button type="submit" class="btn btn-login text-white w-100 mb-3">
                                    <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                                </button>
                                <div class="text-center">
                                    <a href="#" class="text-decoration-none">Quên mật khẩu?</a>
                                </div>
                            </form>
                            <hr class="my-4">
                            <p class="text-center mb-0">Chưa có tài khoản? 
                                <a href="register.jsp" class="text-primary text-decoration-none fw-semibold">Đăng ký ngay</a>
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