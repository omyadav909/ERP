package erp;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/SearchStudentServlet")
public class SearchStudentServlet extends HttpServlet {

    public static class EnrollmentInfo {
        public String courseCode, courseName;
    }
    public static class AttendanceInfo {
        public String courseCode;
        public Date date;
        public String status;
    }
    public static class ExamResultInfo {
        public String courseCode, examName;
        public Date examDate;
        public double marks, maxMarks;
        public String grade;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("query");
        if (query == null || query.trim().isEmpty()) {
            response.sendRedirect("search-student.jsp");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            // find student by roll or name
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM students WHERE roll_no=? OR full_name LIKE ?");
            ps.setString(1, query);
            ps.setString(2, "%" + query + "%");
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                request.setAttribute("notfound", true);
                request.getRequestDispatcher("student-details.jsp").forward(request, response);
                return;
            }

            int studentId = rs.getInt("student_id");
            request.setAttribute("student", rs);

            // enrollments
            PreparedStatement pEn = con.prepareStatement(
                "SELECT c.course_code, c.course_name " +
                "FROM enrollments e JOIN courses c ON e.course_id=c.course_id " +
                "WHERE e.student_id=?");
            pEn.setInt(1, studentId);
            ResultSet rsEn = pEn.executeQuery();
            List<EnrollmentInfo> enrollments = new ArrayList<>();
            while (rsEn.next()) {
                EnrollmentInfo ei = new EnrollmentInfo();
                ei.courseCode = rsEn.getString("course_code");
                ei.courseName = rsEn.getString("course_name");
                enrollments.add(ei);
            }
            request.setAttribute("enrollments", enrollments);

            // attendance (raw list)
            PreparedStatement pAtt = con.prepareStatement(
                "SELECT c.course_code, a.date, a.status " +
                "FROM attendance a JOIN courses c ON a.course_id=c.course_id " +
                "WHERE a.student_id=? ORDER BY a.date DESC");
            pAtt.setInt(1, studentId);
            ResultSet rsAtt = pAtt.executeQuery();
            List<AttendanceInfo> atts = new ArrayList<>();
            while (rsAtt.next()) {
                AttendanceInfo ai = new AttendanceInfo();
                ai.courseCode = rsAtt.getString("course_code");
                ai.date = rsAtt.getDate("date");
                ai.status = rsAtt.getString("status");
                atts.add(ai);
            }
            request.setAttribute("attendanceList", atts);

            // exam results
            PreparedStatement pRes = con.prepareStatement(
                "SELECT c.course_code, ex.exam_name, ex.exam_date, r.marks_obtained, r.max_marks, r.grade " +
                "FROM exam_results r " +
                "JOIN exams ex ON r.exam_id=ex.exam_id " +
                "JOIN courses c ON ex.course_id=c.course_id " +
                "WHERE r.student_id=?");
            pRes.setInt(1, studentId);
            ResultSet rsRes = pRes.executeQuery();
            List<ExamResultInfo> results = new ArrayList<>();
            while (rsRes.next()) {
                ExamResultInfo er = new ExamResultInfo();
                er.courseCode = rsRes.getString("course_code");
                er.examName = rsRes.getString("exam_name");
                er.examDate = rsRes.getDate("exam_date");
                er.marks = rsRes.getDouble("marks_obtained");
                er.maxMarks = rsRes.getDouble("max_marks");
                er.grade = rsRes.getString("grade");
                results.add(er);
            }
            request.setAttribute("results", results);

            request.getRequestDispatcher("student-details.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
