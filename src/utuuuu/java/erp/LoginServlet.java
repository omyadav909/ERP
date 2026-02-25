package erp;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = request.getParameter("role");

        try (Connection con = DBConnection.getConnection()) {

            if ("admin".equals(role)) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");

                PreparedStatement ps = con.prepareStatement(
                        "SELECT * FROM admins WHERE username=? AND password=?");
                ps.setString(1, username);
                ps.setString(2, password);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("role", "admin");
                    session.setAttribute("adminId", rs.getInt("admin_id"));
                    session.setAttribute("adminName", rs.getString("full_name"));
                    response.sendRedirect("admin-dashboard.jsp");
                } else {
                    request.setAttribute("error", "Invalid admin credentials");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }

            } else if ("student".equals(role)) {
                String rollNo = request.getParameter("roll_no");
                String password = request.getParameter("password");

                PreparedStatement ps = con.prepareStatement(
                        "SELECT * FROM students WHERE roll_no=? AND password=?");
                ps.setString(1, rollNo);
                ps.setString(2, password);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("role", "student");
                    session.setAttribute("studentId", rs.getInt("student_id"));
                    session.setAttribute("rollNo", rs.getString("roll_no"));
                    session.setAttribute("studentName", rs.getString("full_name"));
                    response.sendRedirect("StudentDashboardServlet");
                } else {
                    request.setAttribute("error", "Invalid student credentials");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }

            } else {
                request.setAttribute("error", "Unknown role");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
