package com.controller;

import java.io.IOException;

import com.dao.DoctorDAO;
import com.daoimpl.DoctorDAOImpl;
import com.model.Doctor;
import com.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminDoctorDetailsController")
public class AdminDoctorDetailsController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DoctorDAO doctorDAO;

    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAOImpl();
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
            int doctorId = Integer.parseInt(
                    request.getParameter("doctorId"));

            Doctor doctor = doctorDAO.getDoctorDetailsForAdmin(doctorId);

            if (doctor == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Doctor not found.");
                return;
            }

            request.setAttribute("doctor", doctor);

            request.getRequestDispatcher("/admin/doctor-details.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid doctor ID.");
        }
    }
}