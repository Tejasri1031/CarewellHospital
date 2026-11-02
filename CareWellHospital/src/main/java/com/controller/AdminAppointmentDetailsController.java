package com.controller;

import java.io.IOException;

import com.dao.AppointmentDAO;
import com.daoimpl.AppointmentDAOImpl;
import com.model.Appointment;
import com.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminAppointmentDetailsController")
public class AdminAppointmentDetailsController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentDAO appointmentDAO;

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAOImpl();
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
            int appointmentId = Integer.parseInt(
                    request.getParameter("appointmentId"));

            Appointment appointment =
                    appointmentDAO.getAppointmentDetailsForAdmin(appointmentId);

            if (appointment == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Appointment not found.");
                return;
            }

            request.setAttribute("appointment", appointment);

            request.getRequestDispatcher(
                    "/admin/appointment-details.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid appointment ID.");
        }
    }
}