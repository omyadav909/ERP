<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ERP Login</title>

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="style.css">
    <script src="main.js" defer></script>
</head>
<body class="login-light">

<div class="login2-wrapper">
    <div class="login2-card">

        <!-- LEFT: slider / image panel -->
        <div class="login2-image-panel">
            <div class="login2-slider">
                <!-- You can later replace these gradients with real images via CSS -->
                <div class="login2-slide login2-slide-1 active"></div>
                <div class="login2-slide login2-slide-2"></div>
                <div class="login2-slide login2-slide-3"></div>
            </div>
            <div class="login2-slider-footer">
                <div class="login2-slide-text">
                    <h2>Welcome Back</h2>
                    <p>Hello student / admin, sign in to get started.</p>
                </div>
                <div class="login2-dots">
                    <button class="login2-dot active"></button>
                    <button class="login2-dot"></button>
                    <button class="login2-dot"></button>
                </div>
            </div>
        </div>

        <!-- RIGHT: login form panel -->
        <div class="login2-form-panel">
            <div class="login2-header">
                <h2>Welcome Back 👋</h2>
                <p>Please enter your details to continue.</p>
            </div>

            <% String error = (String) request.getAttribute("error");
               if (error != null) { %>
                <div class="login2-error"><%= error %></div>
            <% } %>

            <!-- toggle buttons: student vs admin -->
            <div class="login2-toggle-row">
                <button id="student-toggle" class="login2-toggle active-pill">Student Login</button>
                <button id="admin-toggle" class="login2-toggle">Admin Login</button>
            </div>

            <!-- STUDENT LOGIN -->
            <form id="student-form" class="login2-form active" action="LoginServlet" method="post">
                <input type="hidden" name="role" value="student"/>

                <div class="login2-field">
                    <label>Roll Number</label>
                    <div class="login2-input-wrapper">
                        <span class="login2-input-icon">@</span>
                        <input type="text" name="roll_no" placeholder="Enter your roll number" required>
                    </div>
                </div>

                <div class="login2-field">
                    <label>Password</label>
                    <div class="login2-input-wrapper">
                        <span class="login2-input-icon">••</span>
                        <input type="password" name="password" placeholder="Enter your password" required>
                    </div>
                </div>

                <button type="submit" class="login2-btn-primary">Login as Student</button>
            </form>

            <!-- ADMIN LOGIN -->
            <form id="admin-form" class="login2-form" action="LoginServlet" method="post">
                <input type="hidden" name="role" value="admin"/>

                <div class="login2-field">
                    <label>Admin Username</label>
                    <div class="login2-input-wrapper">
                        <span class="login2-input-icon">@</span>
                        <input type="text" name="username" placeholder="Enter admin username" required>
                    </div>
                </div>

                <div class="login2-field">
                    <label>Password</label>
                    <div class="login2-input-wrapper">
                        <span class="login2-input-icon">••</span>
                        <input type="password" name="password" placeholder="Enter password" required>
                    </div>
                </div>

                <button type="submit" class="login2-btn-primary">Login as Admin</button>
            </form>

        </div>
    </div>
</div>

</body>
</html>
