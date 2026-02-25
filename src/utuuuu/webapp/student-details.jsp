<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head><title>Student Details</title></head>
<body>
<h2>Student Details</h2>

<%
    if (request.getAttribute("notfound") != null) {
%>
<p>No student found.</p>
<%
    } else {
        java.sql.ResultSet student = (java.sql.ResultSet) request.getAttribute("student");
        if (student != null) {
%>
<ul>
    <li>Roll No: <%= student.getString("roll_no") %></li>
    <li>Name: <%= student.getString("full_name") %></li>
    <li>Email: <%= student.getString("email") %></li>
    <li>Phone: <%= student.getString("phone") %></li>
    <li>Address: <%= student.getString("address") %></li>
    <li>Department: <%= student.getString("department") %></li>
    <li>Semester: <%= student.getInt("semester") %></li>
</ul>
<%
        }
%>

<h3>Enrolled Courses</h3>
<ul>
<%
    java.util.List<erp.SearchStudentServlet.EnrollmentInfo> en =
        (java.util.List<erp.SearchStudentServlet.EnrollmentInfo>) request.getAttribute("enrollments");
    if (en != null) {
        for (erp.SearchStudentServlet.EnrollmentInfo ei : en) {
%>
    <li><%= ei.courseCode %> - <%= ei.courseName %></li>
<%
        }
    }
%>
</ul>

<h3>Attendance Records</h3>
<table border="1">
<tr><th>Course</th><th>Date</th><th>Status</th></tr>
<%
    java.util.List<erp.SearchStudentServlet.AttendanceInfo> atts =
        (java.util.List<erp.SearchStudentServlet.AttendanceInfo>) request.getAttribute("attendanceList");
    if (atts != null) {
        for (erp.SearchStudentServlet.AttendanceInfo ai : atts) {
%>
<tr>
    <td><%= ai.courseCode %></td>
    <td><%= ai.date %></td>
    <td><%= ai.status %></td>
</tr>
<%
        }
    }
%>
</table>

<h3>Exam Results</h3>
<table border="1">
<tr><th>Course</th><th>Exam</th><th>Date</th><th>Marks</th><th>Max</th><th>Grade</th></tr>
<%
    java.util.List<erp.SearchStudentServlet.ExamResultInfo> res =
        (java.util.List<erp.SearchStudentServlet.ExamResultInfo>) request.getAttribute("results");
    if (res != null) {
        for (erp.SearchStudentServlet.ExamResultInfo er : res) {
%>
<tr>
    <td><%= er.courseCode %></td>
    <td><%= er.examName %></td>
    <td><%= er.examDate %></td>
    <td><%= er.marks %></td>
    <td><%= er.maxMarks %></td>
    <td><%= er.grade %></td>
</tr>
<%
        }
    }
%>
</table>
<%
    }
%>

<a href="admin-dashboard.jsp">Back</a>
</body>
</html>
