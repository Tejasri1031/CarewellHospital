
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

@WebServlet("/doctor/update-details")
public class DoctorUpdateDetailsController extends HttpServlet {

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

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        if (fullName == null || fullName.isBlank()
                || email == null || email.isBlank()) {
            response.sendRedirect(contextPath
                    + "/doctor/update-details.jsp?error=empty");
            return;
        }

        fullName = fullName.trim();
        email = email.trim();
        phone = phone == null ? "" : phone.trim();

        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            response.sendRedirect(contextPath
                    + "/doctor/update-details.jsp?error=email");
            return;
        }

        User existingUser = userDAO.getUserById(userId);

        if (existingUser == null
                || !"DOCTOR".equalsIgnoreCase(existingUser.getRole())) {
            response.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        User emailUser = userDAO.getUserByEmail(email);

        if (emailUser != null && emailUser.getUserId() != userId) {
            response.sendRedirect(contextPath
                    + "/doctor/update-details.jsp?error=emailExists");
            return;
        }

        // Change only editable fields.
        // Preserve password, role, status and other existing data.
        existingUser.setFullName(fullName);
        existingUser.setEmail(email);
        existingUser.setPhone(phone);

        boolean updated = userDAO.updateUser(existingUser);

        if (updated) {
            // Refresh the user information stored in the session.
            User sessionUser = (User) session.getAttribute("user");

            if (sessionUser != null) {
                sessionUser.setFullName(fullName);
                sessionUser.setEmail(email);
                sessionUser.setPhone(phone);
                session.setAttribute("user", sessionUser);
            }

            response.sendRedirect(contextPath
                    + "/doctor/update-details.jsp?success=1");
        } else {
            response.sendRedirect(contextPath
                    + "/doctor/update-details.jsp?error=failed");
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
                request.getContextPath() + "/doctor/update-details.jsp");
    }
}
