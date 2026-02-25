package erp;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/MarksServlet")
public class MarksServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String rollNo     = request.getParameter("roll_no");
        String courseCode = request.getParameter("course_code");
        String examName   = request.getParameter("exam_name");
        String marksStr   = request.getParameter("marks_obtained");
        String maxStr     = request.getParameter("max_marks");
        String grade      = request.getParameter("grade");

        double marks = Double.parseDouble(marksStr);
        double max   = Double.parseDouble(maxStr);

        try (Connection con = DBConnection.getConnection()) {

            // student
            PreparedStatement s1 = con.prepareStatement(
                    "SELECT student_id FROM students WHERE roll_no=?");
            s1.setString(1, rollNo);
            ResultSet rs1 = s1.executeQuery();
            if (!rs1.next()) {
                response.sendRedirect("marks-entry.jsp?err=nostudent");
                return;
            }
            int studentId = rs1.getInt("student_id");

            // course
            PreparedStatement s2 = con.prepareStatement(
                    "SELECT course_id FROM courses WHERE course_code=?");
            s2.setString(1, courseCode);
            ResultSet rs2 = s2.executeQuery();
            if (!rs2.next()) {
                response.sendRedirect("marks-entry.jsp?err=nocourse");
                return;
            }
            int courseId = rs2.getInt("course_id");

            // exam
            PreparedStatement s3 = con.prepareStatement(
                    "SELECT exam_id FROM exams WHERE course_id=? AND exam_name=?");
            s3.setInt(1, courseId);
            s3.setString(2, examName);
            ResultSet rs3 = s3.executeQuery();
            if (!rs3.next()) {
                response.sendRedirect("marks-entry.jsp?err=noexam");
                return;
            }
            int examId = rs3.getInt("exam_id");

            // insert result
            PreparedStatement s4 = con.prepareStatement(
                    "INSERT INTO exam_results (exam_id, student_id, marks_obtained, max_marks, grade) " +
                    "VALUES (?,?,?,?,?)");
            s4.setInt(1, examId);
            s4.setInt(2, studentId);
            s4.setDouble(3, marks);
            s4.setDouble(4, max);
            s4.setString(5, grade);
            s4.executeUpdate();

            response.sendRedirect("marks-entry.jsp?msg=saved");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
