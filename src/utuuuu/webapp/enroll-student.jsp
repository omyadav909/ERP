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
    <title>Enroll Student | ERP Admin</title>
    <link rel="stylesheet" href="style.css">
    <script src="main.js" defer></script>
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
    <!-- LEFT SIDEBAR (identical to admin dashboard / add-student) -->
    <aside class="dash-sidebar">
        <div>
            <div class="dash-logo-row">
                <div class="dash-logo-dot"></div>
                <span class="dash-logo-text">ERP Admin</span>
            </div>

            <nav class="dash-nav">
                <div class="dash-nav-section-label">Main</div>

                <a href="admin-dashboard.jsp" class="dash-nav-link">
                    <span class="dash-nav-icon">🏠</span>
                    <span class="dash-nav-text">Overview</span>
                </a>

                <div class="dash-nav-section-label">Students</div>

                <a href="add-student.jsp" class="dash-nav-link">
                    <span class="dash-nav-icon">➕</span>
                    <span class="dash-nav-text">Add / Register Student</span>
                </a>

                <a href="enroll-student.jsp" class="dash-nav-link active">
                    <span class="dash-nav-icon">🧾</span>
                    <span class="dash-nav-text">Enroll Students</span>
                </a>

                <a href="search-student.jsp" class="dash-nav-link">
                    <span class="dash-nav-icon">🔍</span>
                    <span class="dash-nav-text">Search Student</span>
                </a>

                <div class="dash-nav-section-label">Academics</div>

                <a href="attendance.jsp" class="dash-nav-link">
                    <span class="dash-nav-icon">📋</span>
                    <span class="dash-nav-text">Attendance</span>
                </a>

                <a href="exam-timetable.jsp" class="dash-nav-link">
                    <span class="dash-nav-icon">📅</span>
                    <span class="dash-nav-text">Exam Timetable</span>
                </a>

                <a href="marks-entry.jsp" class="dash-nav-link">
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

    <!-- MAIN (uses same dash-main sizing as admin dashboard) -->
    <main class="dash-main">
        <header class="dash-header">
            <div>
                <h1 class="dash-title">Enroll Student in Course</h1>
                <p class="dash-subtitle">Create an enrollment by roll number or student name.</p>
            </div>

            <div class="dash-user-chip">
                <div class="dash-user-avatar"><%= (adminName != null && adminName.length()>0) ? adminName.charAt(0) : 'A' %></div>
                <div>
                    <div class="dash-user-name"><%= adminName %></div>
                    <div class="dash-user-role">Administrator</div>
                </div>
            </div>
        </header>

        <!-- message area -->
        <%
            String msg = request.getParameter("msg");
            String error = request.getParameter("error");
            if (msg != null) {
        %>
            <div style="margin-top:8px;"><div class="msg-success">Enrolled successfully.</div></div>
        <%
            } else if (error != null) {
        %>
            <div style="margin-top:8px;"><div class="msg-error"><%= java.net.URLDecoder.decode(error, "UTF-8") %></div></div>
        <%
            }
        %>

        <!-- FORM CARD: uses exact same classes & structure as Add Student -->
        <section class="dash-section">
            <div class="form-card">
                <div class="form-grid">
                    <!-- left column -->
                    <div class="form-column">
                        <div class="form-field">
                            <label>Student Roll No <span class="req">*</span></label>
                            <input form="enrollForm" type="text" name="roll_no" id="roll_no" placeholder="e.g. 2025CSE001" required>
                        </div>

                        <div class="form-field">
                            <label>Course Code <span class="req">*</span></label>
                            <input form="enrollForm" type="text" name="course_code" id="course_code" placeholder="e.g. CSE101" required>
                        </div>

                        <div class="form-field">
                            <label>Semester</label>
                            <input form="enrollForm" type="number" name="semester" id="semester" min="1" max="12" placeholder="e.g. 3">
                        </div>
                    </div>

                    <!-- right column -->
                    <div class="form-column">
                        <div class="form-field">
                            <label>Student Name (optional)</label>
                            <input form="enrollForm" type="text" name="student_name" id="student_name" placeholder="Confirmation only">
                        </div>

                        <div class="form-field">
                            <label>Course Name (optional)</label>
                            <input form="enrollForm" type="text" name="course_name" id="course_name" placeholder="e.g. Data Structures">
                        </div>

                        <div class="form-field">
                            <label>Enroll Date</label>
                            <input form="enrollForm" type="date" name="enroll_date" id="enroll_date">
                        </div>
                    </div>

                    <!-- actions row: full width, identical placement to Add Student -->
                    <div class="form-actions" style="grid-column: 1 / -1;">
                        <a class="btn-secondary-link" href="admin-dashboard.jsp">← Back to Dashboard</a>

                        <!-- Submit button placed inside the same grid area so sizing and alignment match Add Student -->
                        <form id="enrollForm" action="EnrollStudentServlet" method="post" style="display:inline-block; margin:0;">
                            <button type="submit" class="btn-primary-wide">Save Enrollment</button>
                        </form>
                    </div>
                </div>
            </div>
        </section>

        <!-- recent enrollments panel (same size/spacing as add-student) -->
        <section class="dash-section" style="margin-top:18px;">
            <div class="dash-panel-card">
                <h3 class="dash-panel-title">Recent Enrollments</h3>
                <p class="dash-panel-desc">No recent enrollments to display. After you create enrollments they will appear here.</p>
            </div>
        </section>
    </main>
</div>

</body>
</html>
