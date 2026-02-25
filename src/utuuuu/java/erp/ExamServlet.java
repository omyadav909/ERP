package erp;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ExamServlet")
public class ExamServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String courseCode = request.getParameter("course_code");
        String examName   = request.getParameter("exam_name");
        String examDate   = request.getParameter("exam_date");
        String examTime   = request.getParameter("exam_time");
        String room       = request.getParameter("classroom");

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps1 = con.prepareStatement(
                    "SELECT course_id FROM courses WHERE course_code=?");
            ps1.setString(1, courseCode);
            ResultSet rs1 = ps1.executeQuery();
            if (!rs1.next()) {
                response.sendRedirect("exam-timetable.jsp?err=nocourse");
                return;
            }
            int courseId = rs1.getInt("course_id");

            PreparedStatement ps2 = con.prepareStatement(
                    "INSERT INTO exams (course_id, exam_name, exam_date, exam_time, classroom) " +
                    "VALUES (?,?,?,?,?)");
            ps2.setInt(1, courseId);
            ps2.setString(2, examName);
            ps2.setString(3, examDate);
            ps2.setString(4, examTime);
            ps2.setString(5, room);
            ps2.executeUpdate();

            response.sendRedirect("exam-timetable.jsp?msg=added");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
