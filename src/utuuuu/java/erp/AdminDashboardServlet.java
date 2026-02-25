package erp;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int totalStudents = 0;
        int activeCourses = 0;
        String nextExam = "—";

        try (Connection con = DBConnection.getConnection()) {

            try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM students");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) totalStudents = rs.getInt(1);
            }

            try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM courses");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) activeCourses = rs.getInt(1);
            }

            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT exam_name, exam_date FROM exam_timetable WHERE exam_date >= CURDATE() ORDER BY exam_date ASC LIMIT 1");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Date d = rs.getDate("exam_date");
                    nextExam = rs.getString("exam_name") + " — " + (d != null ? d.toString() : "");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("activeCourses", activeCourses);
        request.setAttribute("nextExam", nextExam);

        request.getRequestDispatcher("admin-dashboard.jsp").forward(request, response);
    }
}
