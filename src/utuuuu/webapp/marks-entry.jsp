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
    <title>Marks Entry | ERP Admin</title>

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
                <h1 class="dash-title">Marks Entry</h1>
                <p class="dash-subtitle">Record student marks for exams. Use the form below to save marks (required fields marked <span style="color:#f97373">*</span>).</p>
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
                <h3 class="dash-panel-title" style="margin-bottom:12px; color:#cbd5f5;">Enter Marks</h3>

                <form action="MarksServlet" method="post" class="form-grid" style="gap:18px;">
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
                            <label>Exam Name <span class="req">*</span></label>
                            <input type="text" name="exam_name" placeholder="e.g. Mid Term" required>
                        </div>

                        <div class="form-field">
                            <label>Marks Obtained <span class="req">*</span></label>
                            <input type="number" step="0.01" name="marks_obtained" placeholder="e.g. 78.50" required>
                        </div>
                    </div>

                    <!-- right column -->
                    <div class="form-column">
                        <div class="form-field">
                            <label>Max Marks</label>
                            <input type="number" step="0.01" name="max_marks" value="100">
                        </div>

                        <div class="form-field">
                            <label>Grade</label>
                            <input type="text" name="grade" placeholder="e.g. A / B+">
                        </div>

                        <div class="form-field">
                            <label>Remarks</label>
                            <textarea name="remarks" rows="4" placeholder="Optional remarks or feedback"></textarea>
                        </div>
                    </div>

                    <!-- actions row -->
                    <div class="form-actions" style="grid-column: 1 / -1;">
                        <a class="btn-secondary-link" href="admin-dashboard.jsp">← Back to Dashboard</a>
                        <button type="submit" class="btn-primary-wide">Save Marks</button>
                    </div>
                </form>
            </div>
        </section>

        <!-- recent marks panel -->
        <section class="dash-section" style="margin-top:18px;">
            <div class="dash-panel-card">
                <h3 class="dash-panel-title">Recent Marks Entries</h3>
                <p class="dash-panel-desc">No entries yet. After saving marks they'll appear here (you can later replace this with a DB-driven table).</p>
            </div>
        </section>
    </main>
</div>

</body>
</html>
