<%@ page contentType="text/html;charset=UTF-8" language="java" import="erp.DBConnection,java.sql.*" %>
<%
    // SESSION CHECK
    jakarta.servlet.http.HttpSession s = request.getSession(false);
    if (s == null || !"admin".equals(s.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    String adminName = (String) s.getAttribute("adminName");

    // ====== defaults ======
    int totalStudents = 0;
    int activeCourses = 0;
    String nextExam = "—";

    // ====== SAFELY fetch live stats from DB ======
    // each query wrapped so missing table/column will not break the page
    try (Connection con = DBConnection.getConnection()) {

        // total students
        try {
            String q = "SELECT COUNT(*) AS cnt FROM students";
            try (PreparedStatement ps = con.prepareStatement(q);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalStudents = rs.getInt("cnt");
            }
        } catch (Exception ex) {
            // table may not exist or other issue — keep default and log
            ex.printStackTrace();
        }

        // active courses
        try {
            String q = "SELECT COUNT(*) AS cnt FROM courses";
            try (PreparedStatement ps = con.prepareStatement(q);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) activeCourses = rs.getInt("cnt");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        // next upcoming exam (if exam_timetable exists)
        try {
            String q = "SELECT exam_name, exam_date FROM exam_timetable WHERE exam_date >= CURDATE() ORDER BY exam_date ASC LIMIT 1";
            try (PreparedStatement ps = con.prepareStatement(q);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Date d = rs.getDate("exam_date");
                    String name = rs.getString("exam_name");
                    nextExam = (name != null ? name : "Exam") + (d != null ? " — " + d.toString() : "");
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }

    } catch (Exception e) {
        // DBConnection failure — log and continue with defaults
        e.printStackTrace();
    }

    // ====== robust active link detection ======
    // get last path segment (filename or servlet mapping)
    String uri = request.getRequestURI();
    String current = uri.substring(uri.lastIndexOf('/') + 1); // e.g. admin-dashboard.jsp or student-exams
    String ctx = request.getContextPath(); // for building links
    // helper - returns "active" if matches
    java.util.function.Function<String, String> isActive = (name) -> {
        if (name == null) return "";
        // match exact filename OR if current contains name (for servlet mappings)
        if (current.equals(name) || current.equals(name + ".jsp") || current.contains(name)) return "active";
        return "";
    };
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | ERP Admin</title>
    <link rel="stylesheet" href="style.css">
    <script src="main.js" defer></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        /* small helper to keep numeric stat width stable */
        .dash-stat-value { min-width: 80px; display:inline-block; }
    </style>
</head>
<body class="dash-body">

<!-- animated background shared across pages -->
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

                <a href="<%= ctx %>/admin-dashboard.jsp" class="dash-nav-link <%= isActive.apply("admin-dashboard") %>">
                    <span class="dash-nav-icon">🏠</span>
                    <span class="dash-nav-text">Overview</span>
                </a>

                <div class="dash-nav-section-label">Students</div>

                <a href="<%= ctx %>/add-student.jsp" class="dash-nav-link <%= isActive.apply("add-student") %>">
                    <span class="dash-nav-icon">➕</span>
                    <span class="dash-nav-text">Add / Register Student</span>
                </a>

                <a href="<%= ctx %>/enroll-student.jsp" class="dash-nav-link <%= isActive.apply("enroll-student") %>">
                    <span class="dash-nav-icon">🧾</span>
                    <span class="dash-nav-text">Enroll Students</span>
                </a>

                <a href="<%= ctx %>/search-student.jsp" class="dash-nav-link <%= isActive.apply("search-student") %>">
                    <span class="dash-nav-icon">🔍</span>
                    <span class="dash-nav-text">Search Student</span>
                </a>

                <div class="dash-nav-section-label">Academics</div>

                <a href="<%= ctx %>/attendance.jsp" class="dash-nav-link <%= isActive.apply("attendance") %>">
                    <span class="dash-nav-icon">📋</span>
                    <span class="dash-nav-text">Attendance</span>
                </a>

                <a href="<%= ctx %>/exam-timetable.jsp" class="dash-nav-link <%= isActive.apply("exam-timetable") %>">
                    <span class="dash-nav-icon">📅</span>
                    <span class="dash-nav-text">Exam Timetable</span>
                </a>

                <a href="<%= ctx %>/marks-entry.jsp" class="dash-nav-link <%= isActive.apply("marks-entry") %>">
                    <span class="dash-nav-icon">📊</span>
                    <span class="dash-nav-text">Marks Entry</span>
                </a>
            </nav>
        </div>

        <div class="dash-sidebar-bottom">
            <form action="<%= ctx %>/LogoutServlet" method="get">
                <button class="dash-btn-ghost" type="submit">Logout</button>
            </form>
        </div>
    </aside>

    <!-- MAIN -->
    <main class="dash-main">
        <header class="dash-header">
            <div>
                <h1 class="dash-title">Admin Dashboard</h1>
                <p class="dash-subtitle">Welcome, <%= adminName != null ? adminName : "Administrator" %>. Manage students, courses, exams and attendance.</p>
            </div>

            <div class="dash-user-chip">
                <div class="dash-user-avatar"><%= (adminName != null && adminName.length() > 0) ? adminName.charAt(0) : 'A' %></div>
                <div>
                    <div class="dash-user-name"><%= adminName %></div>
                    <div class="dash-user-role">Administrator</div>
                </div>
            </div>
        </header>

        <!-- QUICK STATS -->
        <section class="dash-grid-3 dash-gap-lg dash-section" aria-live="polite">
            <div class="dash-stat-card">
                <span class="dash-stat-label">Total Students</span>
                <span class="dash-stat-value dash-stat-value"><%= totalStudents %></span>
                <span class="dash-stat-caption">(Live count from students table)</span>
            </div>

            <div class="dash-stat-card">
                <span class="dash-stat-label">Active Courses</span>
                <span class="dash-stat-value"><%= activeCourses %></span>
                <span class="dash-stat-caption">(Courses count)</span>
            </div>

            <div class="dash-stat-card">
                <span class="dash-stat-label">Upcoming Exams</span>
                <span class="dash-stat-value"><%= nextExam %></span>
                <span class="dash-stat-caption">(Next scheduled exam)</span>
            </div>
        </section>

        <!-- PANELS -->
        <section class="dash-grid-2 dash-gap-lg dash-section">
            <div class="dash-panel-card">
                <h3 class="dash-panel-title">Student Management</h3>
                <p class="dash-panel-desc">Create, update and search student records.</p>
                <div class="dash-chip-row">
                    <a href="<%= ctx %>/add-student.jsp" class="dash-chip">Add Student</a>
                    <a href="<%= ctx %>/search-student.jsp" class="dash-chip">View / Edit Student</a>
                    <a href="<%= ctx %>/enroll-student.jsp" class="dash-chip">Enroll in Course</a>
                </div>
            </div>

            <div class="dash-panel-card">
                <h3 class="dash-panel-title">Academics</h3>
                <p class="dash-panel-desc">Control attendance, exams and results.</p>
                <div class="dash-chip-row">
                    <a href="<%= ctx %>/attendance.jsp" class="dash-chip">Mark Attendance</a>
                    <a href="<%= ctx %>/exam-timetable.jsp" class="dash-chip">Exam Timetable</a>
                    <a href="<%= ctx %>/marks-entry.jsp" class="dash-chip">Enter Marks</a>
                </div>
            </div>
        </section>

        <!-- RECENT ACTIVITY / NOTIFICATIONS (optional) -->
        <section class="dash-section" style="margin-top:12px;">
            <div class="dash-panel-card">
                <h3 class="dash-panel-title">Recent Activity</h3>
                <p class="dash-panel-desc">No activity yet. After performing actions, logs will appear here.</p>
            </div>
        </section>
    </main>
</div>

</body>
</html>
