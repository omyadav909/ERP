package erp;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/AddStudentServlet")
public class AddStudentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String rollNo   = request.getParameter("roll_no");
        String fullName = request.getParameter("full_name");
        String email    = request.getParameter("email");
        String phone    = request.getParameter("phone");
        String address  = request.getParameter("address");
        String dob      = request.getParameter("dob");
        String dept     = request.getParameter("department");
        String semStr   = request.getParameter("semester");
        String password = request.getParameter("password");

        int semester = 0;
        try { semester = Integer.parseInt(semStr); } catch (Exception ignored) {}

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO students (roll_no, full_name, email, phone, address, dob, department, semester, password) " +
                "VALUES (?,?,?,?,?,?,?,?,?)"
            );
            ps.setString(1, rollNo);
            ps.setString(2, fullName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, address);
            ps.setString(6, dob);
            ps.setString(7, dept);
            ps.setInt(8, semester);
            ps.setString(9, password);

            ps.executeUpdate();
            response.sendRedirect("admin-dashboard.jsp?msg=student_added");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
