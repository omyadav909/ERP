package erp;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/StudentDashboardServlet")
public class StudentDashboardServlet extends HttpServlet {

    public static class CourseInfo {
        public String courseCode, courseName;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int studentId = (int) session.getAttribute("studentId");

        try (Connection con = DBConnection.getConnection()) {

            // basic info
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM students WHERE student_id=?");
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                request.setAttribute("student", rs);
            }

            // enrolled courses
            PreparedStatement pEn = con.prepareStatement(
                "SELECT c.course_code, c.course_name " +
                "FROM enrollments e JOIN courses c ON e.course_id=c.course_id " +
                "WHERE e.student_id=?");
            pEn.setInt(1, studentId);
            ResultSet rsEn = pEn.executeQuery();
            List<CourseInfo> courses = new ArrayList<>();
            while (rsEn.next()) {
                CourseInfo ci = new CourseInfo();
                ci.courseCode = rsEn.getString("course_code");
                ci.courseName = rsEn.getString("course_name");
                courses.add(ci);
            }
            request.setAttribute("courses", courses);

            // upcoming exams for his courses
            PreparedStatement pEx = con.prepareStatement(
                "SELECT c.course_code, ex.exam_name, ex.exam_date, ex.exam_time, ex.classroom " +
                "FROM exams ex " +
                "JOIN courses c ON ex.course_id=c.course_id " +
                "JOIN enrollments e ON e.course_id=c.course_id " +
                "WHERE e.student_id=? ORDER BY ex.exam_date");
            pEx.setInt(1, studentId);
            ResultSet rsEx = pEx.executeQuery();
            request.setAttribute("exams", rsEx);

            // marks
            PreparedStatement pRes = con.prepareStatement(
                "SELECT c.course_code, ex.exam_name, r.marks_obtained, r.max_marks, r.grade " +
                "FROM exam_results r " +
                "JOIN exams ex ON r.exam_id=ex.exam_id " +
                "JOIN courses c ON ex.course_id=c.course_id " +
                "WHERE r.student_id=?");
            pRes.setInt(1, studentId);
            ResultSet rsRes = pRes.executeQuery();
            request.setAttribute("results", rsRes);

            request.getRequestDispatcher("student-dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
