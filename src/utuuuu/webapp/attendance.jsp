<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // session & auth check
    jakarta.servlet.http.HttpSession s = request.getSession(false);
    if (s == null || !"admin".equals(s.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    String adminName = (String) s.getAttribute("adminName");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Attendance | ERP Admin</title>
    <!-- paths assume style.css and main.js are in same folder as your JSPs -->
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
    <!-- SIDEBAR -->
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
                    String attendanceActive = path.endsWith("attendance.jsp") ? "active" : "";
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

                <a href="attendance.jsp" class="dash-nav-link <%= attendanceActive %>">
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
                <h1 class="dash-title">Mark Attendance</h1>
                <p class="dash-subtitle">Record student attendance for a course. Use the form below for a single entry. Use the attendance panel for bulk/roster options later.</p>
            </div>

            <div class="dash-user-chip">
                <div class="dash-user-avatar"><%= (adminName != null && adminName.length() > 0) ? adminName.charAt(0) : 'A' %></div>
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
            <div style="margin-top:8px;"><div class="msg-success">Attendance saved.</div></div>
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
                <h3 style="margin-bottom:12px; color:#cbd5f5;">Mark Attendance (Single Entry)</h3>

                <form action="AttendanceServlet" method="post" class="form-grid" style="gap:18px;">
                    <!-- left column -->
                    <div class="form-column">
                        <div class="form-field">
                            <label>Roll No <span class="req">*</span></label>
                            <input type="text" name="roll_no" placeholder="e.g. 2025CSE001" required>
                        </div>

                        <div class="form-field">
                            <label>Course Code <span class="req">*</span></label>
                            <input type="text" name="course_code" placeholder="e.g. CSE101" required>
                        </div>

                        <div class="form-field">
                            <label>Date <span class="req">*</span></label>
                            <input type="date" name="att_date" required>
                        </div>
                    </div>

                    <!-- right column -->
                    <div class="form-column">
                        <div class="form-field">
                            <label>Status <span class="req">*</span></label>
                            <select name="status" required style="padding:9px 10px; border-radius:10px;">
                                <option value="P">Present</option>
                                <option value="A">Absent</option>
                                <option value="L">Late</option>
                                <option value="E">Excused</option>
                            </select>
                        </div>

                        <div class="form-field">
                            <label>Marked By</label>
                            <input type="text" name="marked_by" placeholder="Your name or ID (optional)">
                        </div>

                        <div class="form-field">
                            <label>Notes</label>
                            <textarea name="notes" rows="3" placeholder="Optional notes"></textarea>
                        </div>
                    </div>

                    <!-- actions row -->
                    <div class="form-actions" style="grid-column:1 / -1;">
                        <a class="btn-secondary-link" href="admin-dashboard.jsp">← Back to Dashboard</a>
                        <button type="submit" class="btn-primary-wide">Save Attendance</button>
                    </div>
                </form>
            </div>
        </section>

        <!-- recent attendance panel -->
        <section class="dash-section" style="margin-top:18px;">
            <div class="dash-panel-card">
                <h3 class="dash-panel-title">Recent Attendance</h3>
                <p class="dash-panel-desc">No recent entries yet. After marking attendance they will appear here (replace with DB-driven list/table).</p>
            </div>
        </section>
    </main>
</div>

</body>
</html>
