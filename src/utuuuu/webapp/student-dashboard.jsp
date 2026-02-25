<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    jakarta.servlet.http.HttpSession s = request.getSession(false);
    if (s == null || !"student".equals(s.getAttribute("role"))) {
        response.sendRedirect("login.jsp"); return;
    }
    String studentName = (String) s.getAttribute("studentName");
    String rollNo = (String) s.getAttribute("rollNo");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard | ERP</title>
    <link rel="stylesheet" href="style.css">
    <script src="main.js" defer></script>
</head>
<body class="dash-body">

<div class="animated-bg">
    <div class="bg-gradient"></div>
    <div class="orb orb-1"></div>
    <div class="orb orb-2"></div>
    <div class="orb orb-3"></div>
</div>

<div class="dash-shell">
    <!-- SIDEBAR -->
    <aside class="dash-sidebar">
        <div class="dash-logo-row">
            <div class="dash-logo-dot"></div>
            <span class="dash-logo-text">Student ERP</span>
        </div>

        <nav class="dash-nav">
            <div class="dash-nav-section-label">Main</div>

            <a href="StudentDashboardServlet" class="dash-nav-link active">
                <span class="dash-nav-icon">🏠</span>
                <span class="dash-nav-text">Overview</span>
            </a>

            <div class="dash-nav-section-label">Academics</div>

            <a href="#" class="dash-nav-link">
                <span class="dash-nav-icon">📚</span>
                <span class="dash-nav-text">My Courses</span>
            </a>

            <a href="#" class="dash-nav-link">
                <span class="dash-nav-icon">📈</span>
                <span class="dash-nav-text">Attendance</span>
            </a>

            <a href="#" class="dash-nav-link">
                <span class="dash-nav-icon">🧪</span>
                <span class="dash-nav-text">Exam Schedule</span>
            </a>

            <a href="#" class="dash-nav-link">
                <span class="dash-nav-icon">📝</span>
                <span class="dash-nav-text">Marks / Result</span>
            </a>

            <div class="dash-nav-section-label">Profile</div>

            <a href="#" class="dash-nav-link">
                <span class="dash-nav-icon">👤</span>
                <span class="dash-nav-text">Profile</span>
            </a>
        </nav>

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
                <h1 class="dash-title">Hi, <%= studentName %></h1>
                <p class="dash-subtitle">Roll No: <%= rollNo %> • Here is your academic summary.</p>
            </div>
        </header>

        <!-- quick stats -->
        <section class="dash-grid-3 dash-gap-lg dash-section">
            <div class="dash-stat-card">
                <span class="dash-stat-label">Overall Attendance</span>
                <span class="dash-stat-value">—%</span>
                <span class="dash-stat-caption">Calculate from attendance table later.</span>
            </div>
            <div class="dash-stat-card">
                <span class="dash-stat-label">Upcoming Exam</span>
                <span class="dash-stat-value">—</span>
                <span class="dash-stat-caption">Nearest date from exam timetable.</span>
            </div>
            <div class="dash-stat-card">
                <span class="dash-stat-label">Last Semester SGPA</span>
                <span class="dash-stat-value">—</span>
                <span class="dash-stat-caption">Compute using marks table.</span>
            </div>
        </section>

        <!-- option dashboard for student -->
        <section class="dash-grid-2 dash-gap-lg dash-section">
            <div class="dash-panel-card">
                <h2 class="dash-panel-title">My Courses</h2>
                <p class="dash-panel-desc">View all courses you are enrolled in.</p>
                <ul class="dash-list">
                    <li>Data Structures & Algorithms</li>
                    <li>Engineering Mathematics</li>
                    <li>Operating Systems</li>
                    <!-- later: generate dynamically from DB -->
                </ul>
            </div>

            <div class="dash-panel-card">
                <h2 class="dash-panel-title">Exams & Results</h2>
                <p class="dash-panel-desc">Stay updated with your exams and marks.</p>
                <ul class="dash-list">
                    <li>Upcoming exams timeline</li>
                    <li>Your subject-wise marks</li>
                    <li>Download grade card / PDF</li>
                </ul>
            </div>
        </section>
    </main>
</div>

</body>
</html>
