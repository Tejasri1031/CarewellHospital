
package com.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.dao.UserDAO;
import com.daoimpl.UserDAOImpl;
import com.model.User;
import com.util.PasswordUtil;

@WebServlet("/doctor/change-password")
public class DoctorChangePasswordController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath();

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("userId") == null
                || !"DOCTOR".equalsIgnoreCase(
                        String.valueOf(session.getAttribute("role")))) {

            response.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        int userId;

        try {
            userId = Integer.parseInt(
                    session.getAttribute("userId").toString());
        } catch (NumberFormatException e) {
            session.invalidate();
            response.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || currentPassword.isEmpty()
                || newPassword == null || newPassword.isEmpty()
                || confirmPassword == null || confirmPassword.isEmpty()) {

            response.sendRedirect(contextPath
                    + "/doctor/change-password.jsp?error=empty");
            return;
        }

        if (newPassword.length() < 8) {
            response.sendRedirect(contextPath
                    + "/doctor/change-password.jsp?error=weak");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect(contextPath
                    + "/doctor/change-password.jsp?error=mismatch");
            return;
        }

        if (currentPassword.equals(newPassword)) {
            response.sendRedirect(contextPath
                    + "/doctor/change-password.jsp?error=same");
            return;
        }

        User doctor = userDAO.getUserById(userId);

        if (doctor == null
                || !"DOCTOR".equalsIgnoreCase(doctor.getRole())
                || doctor.getPassword() == null) {

            response.sendRedirect(contextPath
                    + "/doctor/change-password.jsp?error=failed");
            return;
        }

        String storedPassword = doctor.getPassword();
        boolean passwordMatches;

        if (storedPassword.startsWith("$2a$")
                || storedPassword.startsWith("$2b$")
                || storedPassword.startsWith("$2y$")) {

            passwordMatches = PasswordUtil.verifyPassword(
                    currentPassword, storedPassword);

        } else {
            // Support legacy plaintext passwords.
            passwordMatches = storedPassword.equals(currentPassword);
        }

        if (!passwordMatches) {
            response.sendRedirect(contextPath
                    + "/doctor/change-password.jsp?error=current");
            return;
        }

        String hashedPassword = PasswordUtil.hashPassword(newPassword);

        boolean updated = userDAO.updatePassword(userId, hashedPassword);

        if (updated) {
            response.sendRedirect(contextPath
                    + "/doctor/change-password.jsp?success=1");
        } else {
            response.sendRedirect(contextPath
                    + "/doctor/change-password.jsp?error=failed");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("userId") == null
                || !"DOCTOR".equalsIgnoreCase(
                        String.valueOf(session.getAttribute("role")))) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        response.sendRedirect(
                request.getContextPath() + "/doctor/change-password.jsp");
    }
}
