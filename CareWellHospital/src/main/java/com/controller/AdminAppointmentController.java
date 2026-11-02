package com.controller;

import java.io.IOException;
import java.util.List;

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

@WebServlet("/AdminAppointmentController")
public class AdminAppointmentController extends HttpServlet {

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

        List<Appointment> appointments =
                appointmentDAO.getAllAppointmentsForAdmin();

        request.setAttribute("appointments", appointments);

        request.getRequestDispatcher("/admin/appointments.jsp")
               .forward(request, response);
    }
}