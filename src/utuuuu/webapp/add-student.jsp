<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    jakarta.servlet.http.HttpSession s = request.getSession(false);
    if (s == null || !"admin".equals(s.getAttribute("role"))) {
        response.sendRedirect("login.jsp"); return;
    }
    String adminName = (String) s.getAttribute("adminName");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add / Register Student | ERP Admin</title>

    <!-- paths assume style.css and main.js are in same folder as JSPs -->
    <link rel="stylesheet" href="style.css">
    <script src="main.js" defer></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body class="dash-body">

<!-- animated background (shared) -->
<div class="animated-bg">
    <div class="bg-gradient"></div>
    <div class="orb orb-1"></div>
    <div class="orb orb-2"></div>
    <div class="orb orb-3"></div>
</div>

<div class="dash-shell">
    <!-- LEFT SIDEBAR -->
    <aside class="dash-sidebar">
        <div>
            <div class="dash-logo-row">
                <div class="dash-logo-dot"></div>
                <span class="dash-logo-text">ERP Admin</span>
            </div>

            <nav class="dash-nav">
                <div class="dash-nav-section-label">Main</div>
                <%
                    String path = request.getRequestURI();
                    String dash = path.endsWith("admin-dashboard.jsp") ? "active" : "";
                    String addStudent = path.endsWith("add-student.jsp") ? "active" : "";
                    String enroll = path.endsWith("enroll-student.jsp") ? "active" : "";
                    String search = path.endsWith("search-student.jsp") ? "active" : "";
                    String attendance = path.endsWith("attendance.jsp") ? "active" : "";
                    String exam = path.endsWith("exam-timetable.jsp") ? "active" : "";
                    String marks = path.endsWith("marks-entry.jsp") ? "active" : "";
                %>

                <a href="admin-dashboard.jsp" class="dash-nav-link <%= dash %>">
                    <span class="dash-nav-icon">🏠</span>
                    <span class="dash-nav-text">Overview</span>
                </a>

                <div class="dash-nav-section-label">Students</div>

                <a href="add-student.jsp" class="dash-nav-link <%= addStudent %>">
                    <span class="dash-nav-icon">➕</span>
                    <span class="dash-nav-text">Add / Register Student</span>
                </a>

                <a href="enroll-student.jsp" class="dash-nav-link <%= enroll %>">
                    <span class="dash-nav-icon">🧾</span>
                    <span class="dash-nav-text">Enroll Students</span>
                </a>

                <a href="search-student.jsp" class="dash-nav-link <%= search %>">
                    <span class="dash-nav-icon">🔍</span>
                    <span class="dash-nav-text">Search Student</span>
                </a>

                <div class="dash-nav-section-label">Academics</div>

                <a href="attendance.jsp" class="dash-nav-link <%= attendance %>">
                    <span class="dash-nav-icon">📋</span>
                    <span class="dash-nav-text">Attendance</span>
                </a>

                <a href="exam-timetable.jsp" class="dash-nav-link <%= exam %>">
                    <span class="dash-nav-icon">📅</span>
                    <span class="dash-nav-text">Exam Timetable</span>
                </a>

                <a href="marks-entry.jsp" class="dash-nav-link <%= marks %>">
                    <span class="dash-nav-icon">📊</span>
                    <span class="dash-nav-text">Marks Entry</span>
                </a>
            </nav>
        </div>

        <div class="dash-sidebar-bottom">
            <form action="LogoutServlet" method="get">
                <button class="dash-btn-ghost" type="submit">Logout</button>
            </form>
        </div>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="dash-main">
        <header class="dash-header">
            <div>
                <h1 class="dash-title">Add / Register Student</h1>
                <p class="dash-subtitle">Fill the student details carefully. All fields with <span style="color:#f97373">*</span> are mandatory.</p>
            </div>

            <div class="dash-user-chip">
                <div class="dash-user-avatar"><%= (adminName != null && adminName.length() > 0) ? adminName.charAt(0) : 'A' %></div>
                <div>
                    <div class="dash-user-name"><%= adminName %></div>
                    <div class="dash-user-role">Administrator</div>
                </div>
            </div>
        </header>

        <!-- message area (success / error) -->
        <%
            String msg = request.getParameter("msg");
            String error = request.getParameter("error");
            if (msg != null) {
        %>
            <div style="margin-top:8px;"><div class="msg-success">Saved successfully.</div></div>
        <%
            } else if (error != null) {
        %>
            <div style="margin-top:8px;"><div class="msg-error"><%= java.net.URLDecoder.decode(error, "UTF-8") %></div></div>
        <%
            }
        %>

        <!-- FORM CARD -->
        <section class="dash-section">
            <div class="form-card">
                <form action="AddStudentServlet" method="post" class="form-grid" style="align-items:start;">

                    <!-- Left column -->
                    <div class="form-column">
                        <div class="form-field">
                            <label>Roll No <span class="req">*</span></label>
                            <input type="text" name="roll_no" required placeholder="e.g. 2025CSE001">
                        </div>

                        <div class="form-field">
                            <label>Full Name <span class="req">*</span></label>
                            <input type="text" name="full_name" required placeholder="Student full name">
                        </div>

                        <div class="form-field">
                            <label>Email</label>
                            <input type="email" name="email" placeholder="example@college.edu">
                        </div>

                        <div class="form-field">
                            <label>Phone</label>
                            <input type="text" name="phone" placeholder="10-digit mobile number">
                        </div>
                    </div>

                    <!-- Right column -->
                    <div class="form-column">
                        <div class="form-field">
                            <label>Address</label>
                            <textarea name="address" rows="3" placeholder="House no, street, city, state"></textarea>
                        </div>

                        <div class="form-field">
                            <label>Date of Birth</label>
                            <input type="date" name="dob">
                        </div>

                        <div class="form-row-two">
                            <div class="form-field">
                                <label>Department</label>
                                <input type="text" name="department" placeholder="CSE / ECE / ME / CE...">
                            </div>
                            <div class="form-field">
                                <label>Semester</label>
                                <input type="number" name="semester" min="1" max="12">
                            </div>
                        </div>

                        <div class="form-field">
                            <label>Password (Student Login) <span class="req">*</span></label>
                            <input type="password" name="password" required>
                        </div>
                    </div>

                    <!-- Buttons row (full width) -->
                    <div class="form-actions" style="grid-column:1 / -1;">
                        <a href="admin-dashboard.jsp" class="btn-secondary-link">← Back to Dashboard</a>
                        <button type="submit" class="btn-primary-wide">Save Student</button>
                    </div>
                </form>
            </div>
        </section>
    </main>
</div>

</body>
</html>
