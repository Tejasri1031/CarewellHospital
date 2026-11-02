package com.controller;

import java.io.IOException;

import com.dao.UserDAO;
import com.daoimpl.UserDAOImpl;
import com.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminDoctorStatusController")
public class AdminDoctorStatusController extends HttpServlet {

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

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Admin access required.");
            return;
        }

        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String status = request.getParameter("status");
            int doctorId = Integer.parseInt(request.getParameter("doctorId"));

            boolean updated = userDAO.updateUserStatus(userId, status);

            if (updated) {
                response.sendRedirect(request.getContextPath()
                        + "/AdminDoctorDetailsController?doctorId=" + doctorId);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "Unable to update doctor account status.");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid doctor information.");
        }
    }
}