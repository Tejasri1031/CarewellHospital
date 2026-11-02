package com.controller;

import java.io.IOException;

import com.dao.DoctorDAO;
import com.dao.DepartmentDAO;
import com.daoimpl.DoctorDAOImpl;
import com.daoimpl.DepartmentDAOImpl;
import com.model.Doctor;
import com.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminEditDoctorController")
public class AdminEditDoctorController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DoctorDAO doctorDAO;
    private DepartmentDAO departmentDAO;

    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAOImpl();
        departmentDAO = new DepartmentDAOImpl();
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
            request.setAttribute("departments",
                    departmentDAO.getAllDepartments());

            request.getRequestDispatcher("/admin/edit-doctor.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid doctor ID.");
        }
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
            int doctorId = Integer.parseInt(
                    request.getParameter("doctorId"));

            int departmentId = Integer.parseInt(
                    request.getParameter("departmentId"));

            int experienceYears = Integer.parseInt(
                    request.getParameter("experienceYears"));

            double consultationFee = Double.parseDouble(
                    request.getParameter("consultationFee"));

            String specialization = request.getParameter("specialization");
            String qualification = request.getParameter("qualification");
            String availabilityStatus = request.getParameter("availabilityStatus");
            String bio = request.getParameter("bio");

            if (specialization == null || specialization.isBlank()
                    || qualification == null || qualification.isBlank()
                    || experienceYears < 0 || consultationFee < 0
                    || bio == null || bio.length() > 1000
                    || !("AVAILABLE".equals(availabilityStatus)
                         || "UNAVAILABLE".equals(availabilityStatus))) {

                response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid doctor information.");
                return;
            }

            Doctor doctor = doctorDAO.getDoctorDetailsForAdmin(doctorId);

            if (doctor == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                        "Doctor not found.");
                return;
            }

            doctor.setDepartmentId(departmentId);
            doctor.setSpecialization(specialization.trim());
            doctor.setQualification(qualification.trim());
            doctor.setExperienceYears(experienceYears);
            doctor.setConsultationFee(consultationFee);
            doctor.setAvailabilityStatus(availabilityStatus);
            doctor.setBio(bio.trim());

            boolean updated = doctorDAO.updateDoctor(doctor);

            if (updated) {
                response.sendRedirect(request.getContextPath()
                        + "/AdminDoctorDetailsController?doctorId=" + doctorId);
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Unable to update doctor information.");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid numeric value.");
        }
    }
}