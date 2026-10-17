
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

@WebServlet("/patient/change-password")
public class PatientChangePasswordController extends HttpServlet {

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

        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);

        // Validate patient session
        if (session == null
                || !"PATIENT".equals(session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        Object idValue = session.getAttribute("userId");

        if (!(idValue instanceof Integer)) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) idValue;

        String currentPassword =
                request.getParameter("currentPassword");

        String newPassword =
                request.getParameter("newPassword");

        String confirmPassword =
                request.getParameter("confirmPassword");

        // All password results return to the separate password page
        String redirect = request.getContextPath()
                + "/patient/change-password.jsp";

        // Validate input
        if (currentPassword == null
                || currentPassword.isEmpty()
                || newPassword == null
                || newPassword.length() < 8
                || confirmPassword == null
                || !newPassword.equals(confirmPassword)) {

            response.sendRedirect(
                    redirect + "?passwordError=invalid");
            return;
        }

        // Load the logged-in user
        User user = userDAO.getUserById(userId);

        if (user == null || user.getPassword() == null) {
            response.sendRedirect(
                    redirect + "?passwordError=failed");
            return;
        }

        String storedPassword = user.getPassword();
        boolean matches;

        // Verify the existing password
        if (storedPassword.startsWith("$2a$")
                || storedPassword.startsWith("$2b$")
                || storedPassword.startsWith("$2y$")) {

            matches = PasswordUtil.verifyPassword(
                    currentPassword, storedPassword);

        } else {
            // Legacy plaintext accounts, if still supported
            matches = storedPassword.equals(currentPassword);
        }

        if (!matches) {
            response.sendRedirect(
                    redirect + "?passwordError=current");
            return;
        }

        // Do not allow the same password again
        if (PasswordUtil.verifyPassword(
                newPassword, storedPassword)) {

            response.sendRedirect(
                    redirect + "?passwordError=same");
            return;
        }

        // Hash the new password before saving
        String hashedPassword =
                PasswordUtil.hashPassword(newPassword);

        boolean updated =
                userDAO.updatePassword(userId, hashedPassword);

        if (!updated) {
            response.sendRedirect(
                    redirect + "?passwordError=failed");
            return;
        }

        // Password updated successfully
        response.sendRedirect(
                redirect + "?passwordSuccess=1");
    }
}
