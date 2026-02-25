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
    <title>Exam Timetable | ERP Admin</title>

    <!-- IMPORTANT: use correct relative paths. style.css and main.js are in the same folder as your JSPs -->
    <link rel="stylesheet" href="style.css">
    <script src="main.js" defer></script>

    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body class="dash-body">

<div class="animated-bg">
    <div class="bg-gradient"></div>
    <div class="orb orb-1"></div>
    <div class="orb orb-2"></div>
    <div class="orb orb-3"></div>
</div>

<div class="dash-shell">
    <!-- SIDEBAR (copy same nav markup to all pages) -->
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

    <!-- MAIN -->
    <main class="dash-main">
        <header class="dash-header">
            <div>
                <h1 class="dash-title">Exam Timetable</h1>
                <p class="dash-subtitle">Add or update exam schedules for courses. Fields marked * are required.</p>
            </div>

            <div class="dash-user-chip">
                <div class="dash-user-avatar"><%= (adminName != null && adminName.length() > 0) ? adminName.charAt(0) : 'A' %></div>
                <div>
                    <div class="dash-user-name"><%= adminName %></div>
                    <div class="dash-user-role">Administrator</div>
                </div>
            </div>
        </header>

        <section class="dash-section">
            <div class="form-card">
                <h3 style="margin-bottom:12px; color:#cbd5f5;">Add Exam for Course</h3>

                <form action="ExamServlet" method="post" style="display:grid; grid-template-columns: 1fr 1fr; gap:16px;">
                    <div>
                        <div class="form-field">
                            <label>Course Code <span class="req">*</span></label>
                            <input type="text" name="course_code" placeholder="e.g. CSE101" required>
                        </div>

                        <div class="form-field">
                            <label>Exam Name <span class="req">*</span></label>
                            <input type="text" name="exam_name" placeholder="e.g. Mid Term" required>
                        </div>

                        <div class="form-row-two" style="margin-top:6px;">
                            <div>
                                <label>Date <span class="req">*</span></label>
                                <input type="date" name="exam_date" required>
                            </div>
                            <div>
                                <label>Time <span class="req">*</span></label>
                                <input type="time" name="exam_time" required>
                            </div>
                        </div>
                    </div>

                    <div>
                        <div class="form-field">
                            <label>Room / Classroom</label>
                            <input type="text" name="classroom" placeholder="e.g. B-201">
                        </div>

                        <div class="form-field">
                            <label>Semester</label>
                            <input type="number" name="semester" min="1" max="12" placeholder="e.g. 3">
                        </div>

                        <div class="form-field">
                            <label>Additional Notes</label>
                            <textarea name="notes" rows="4" placeholder="Optional notes for invigilation or materials"></textarea>
                        </div>
                    </div>

                    <div style="grid-column: 1 / -1; display:flex; justify-content:space-between; align-items:center; margin-top:6px;">
                        <a class="btn-secondary-link" href="admin-dashboard.jsp">← Back to Dashboard</a>
                        <div>
                            <button type="submit" class="btn-primary-wide">Save Exam</button>
                        </div>
                    </div>
                </form>
            </div>
        </section>

        <section class="dash-section" style="margin-top:18px;">
            <div class="dash-panel-card">
                <h3 class="dash-panel-title">Scheduled Exams</h3>
                <p class="dash-panel-desc">No exams scheduled yet. After adding, the list will appear here.</p>
            </div>
        </section>
    </main>
</div>

</body>
</html>
