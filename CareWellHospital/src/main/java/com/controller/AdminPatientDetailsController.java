
package com.controller;

import java.io.IOException;

import com.dao.PatientDAO;
import com.daoimpl.PatientDAOImpl;
import com.model.Patient;
import com.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminPatientDetailsController")
public class AdminPatientDetailsController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PatientDAO patientDAO;

    @Override
    public void init() throws ServletException {
        patientDAO = new PatientDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
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
            int patientId = Integer.parseInt(
                    request.getParameter("patientId"));

            Patient patient =
                    patientDAO.getPatientDetailsForAdmin(patientId);

            if (patient == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Patient not found.");
                return;
            }

            request.setAttribute("patient", patient);

            request.getRequestDispatcher("/admin/patient-details.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid patient ID.");
        }
    }
}
