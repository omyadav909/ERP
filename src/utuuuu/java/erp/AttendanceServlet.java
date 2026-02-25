package erp;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/AttendanceServlet")
public class AttendanceServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String rollNo = request.getParameter("roll_no");
        String courseCode = request.getParameter("course_code");
        String date = request.getParameter("date");
        String status = request.getParameter("status"); // P or A

        try (Connection con = DBConnection.getConnection()) {

            // student_id
            PreparedStatement ps1 = con.prepareStatement(
                    "SELECT student_id FROM students WHERE roll_no=?");
            ps1.setString(1, rollNo);
            ResultSet rs1 = ps1.executeQuery();
            if (!rs1.next()) {
                response.sendRedirect("attendance.jsp?err=nostudent");
                return;
            }
            int studentId = rs1.getInt("student_id");

            // course_id
            PreparedStatement ps2 = con.prepareStatement(
                    "SELECT course_id FROM courses WHERE course_code=?");
            ps2.setString(1, courseCode);
            ResultSet rs2 = ps2.executeQuery();
            if (!rs2.next()) {
                response.sendRedirect("attendance.jsp?err=nocourse");
                return;
            }
            int courseId = rs2.getInt("course_id");

            PreparedStatement ps3 = con.prepareStatement(
                    "INSERT INTO attendance (student_id, course_id, date, status) VALUES (?,?,?,?)");
            ps3.setInt(1, studentId);
            ps3.setInt(2, courseId);
            ps3.setString(3, date);
            ps3.setString(4, status);
            ps3.executeUpdate();

            response.sendRedirect("attendance.jsp?msg=saved");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
