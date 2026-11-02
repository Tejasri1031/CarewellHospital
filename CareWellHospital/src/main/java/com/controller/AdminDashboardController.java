package com.controller;

import java.io.IOException;

import com.daoimpl.AdminDAOImpl;
import com.dao.AdminDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminDashboardController")
public class AdminDashboardController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AdminDAO adminDAO;

    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAOImpl();
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

        com.model.User user =
                (com.model.User) session.getAttribute("user");

        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Admin access required.");
            return;
        }

        request.setAttribute("totalPatients",
                adminDAO.getTotalPatients());

        request.setAttribute("totalDoctors",
                adminDAO.getTotalDoctors());

        request.setAttribute("totalAppointments",
                adminDAO.getTotalAppointments());

        request.setAttribute("pendingAppointments",
                adminDAO.getPendingAppointments());

        request.getRequestDispatcher("/admin/dashboard.jsp")
               .forward(request, response);
    }
}