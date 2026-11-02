package com.controller;

import java.io.IOException;

import com.dao.UserDAO;
import com.dao.PatientDAO;
import com.daoimpl.UserDAOImpl;
import com.daoimpl.PatientDAOImpl;
import com.model.User;
import com.model.Patient;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminPatientStatusController")
public class AdminPatientStatusController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;
    private PatientDAO patientDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImpl();
        patientDAO = new PatientDAOImpl();
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
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            int patientId = Integer.parseInt(request.getParameter("patientId"));
            String status = request.getParameter("status");

            Patient patient = patientDAO.getPatientDetailsForAdmin(patientId);

            if (patient == null || patient.getUserId() != userId) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid patient information.");
                return;
            }

            boolean updated = userDAO.updateUserStatus(userId, status);

            if (updated) {
                response.sendRedirect(request.getContextPath()
                        + "/AdminPatientDetailsController?patientId=" + patientId);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "Unable to update patient account status.");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid patient information.");
        }
    }
}