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
<!-- Reference image (uploaded file) URL: sandbox:/mnt/data/08f19f7d-fe50-4ffd-90ae-d655b615f267.png -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Search Student | ERP Admin</title>

    <!-- adjust path if your CSS/JS locations differ -->
    <link rel="stylesheet" href="style.css">
    <script src="main.js" defer></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body class="dash-body">

<!-- animated background -->
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

    <!-- MAIN -->
    <main class="dash-main">
        <header class="dash-header">
            <div>
                <h1 class="dash-title">Search Student</h1>
                <p class="dash-subtitle">Search students by roll number or name. Results appear below — click a row to view or edit.</p>
            </div>

            <div class="dash-user-chip">
                <div class="dash-user-avatar"><%= (adminName != null && adminName.length() > 0) ? adminName.charAt(0) : 'A' %></div>
                <div>
                    <div class="dash-user-name"><%= adminName %></div>
                    <div class="dash-user-role">Administrator</div>
                </div>
            </div>
        </header>

        <!-- optional messages -->
        <%
            String msg = request.getParameter("msg");
            String error = request.getParameter("error");
            if (msg != null) {
        %>
            <div style="margin-top:8px;"><div class="msg-success"><%= java.net.URLDecoder.decode(msg,"UTF-8") %></div></div>
        <%
            } else if (error != null) {
        %>
            <div style="margin-top:8px;"><div class="msg-error"><%= java.net.URLDecoder.decode(error,"UTF-8") %></div></div>
        <%
            }
        %>

        <!-- SEARCH FORM -->
        <section class="dash-section">
            <div class="form-card">
                <form action="SearchStudentServlet" method="get" style="display:flex; gap:12px; align-items:center; flex-wrap:wrap;">
                    <input type="text" name="query" required placeholder="Roll no or student name" style="flex:1; padding:9px 10px; border-radius:10px; border:1px solid rgba(75,85,99,0.9); background:rgba(15,23,42,0.96); color:#e5e7eb;">
                    <button type="submit" class="btn-primary-wide" style="padding:9px 16px; border-radius:10px;">Search</button>
                    <a href="admin-dashboard.jsp" class="btn-secondary-link" style="margin-left:auto;">← Back</a>
                </form>

                <!-- results placeholder -->
                <div style="margin-top:16px;">
                    <h3 class="dash-panel-title" style="margin-bottom:8px; color:#cbd5f5;">Search Results</h3>
                    <p class="dash-panel-desc" id="no-results">No results to display. After searching, results will appear here.</p>

                    <!-- Example table (replace with DB-driven rows in servlet) -->
                    <!--
                    <table class="results-table">
                        <thead><tr><th>Roll</th><th>Name</th><th>Dept</th><th>Semester</th><th>Action</th></tr></thead>
                        <tbody>
                            <tr>
                                <td>2025CSE001</td>
                                <td>Ankit Yadav</td>
                                <td>CSE</td>
                                <td>3</td>
                                <td><a href="edit-student.jsp?roll=2025CSE001">Edit</a></td>
                            </tr>
                        </tbody>
                    </table>
                    -->
                </div>
            </div>
        </section>
    </main>
</div>

</body>
</html>
