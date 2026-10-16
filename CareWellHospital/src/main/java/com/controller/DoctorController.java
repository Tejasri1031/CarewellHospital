package com.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.dao.DoctorDAO;
import com.daoimpl.DoctorDAOImpl;
import com.model.Doctor;

@WebServlet("/doctors")
public class DoctorController extends HttpServlet {

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

        String action = request.getParameter("action");

        if (action == null || action.equals("list")) {

            List<Doctor> doctors =
                    doctorDAO.getAllDoctors();

            request.setAttribute("doctors", doctors);

            request.getRequestDispatcher(
                    "/admin/doctors.jsp")
                    .forward(request, response);

        } else if (action.equals("department")) {

            int departmentId =
                    Integer.parseInt(
                            request.getParameter("departmentId"));

            List<Doctor> doctors =
                    doctorDAO.getDoctorsByDepartment(departmentId);

            request.setAttribute("doctors", doctors);

            request.getRequestDispatcher(
                    "/admin/doctors.jsp")
                    .forward(request, response);

        } else if (action.equals("delete")) {

            int doctorId =
                    Integer.parseInt(
                            request.getParameter("doctorId"));

            doctorDAO.deleteDoctor(doctorId);

            response.sendRedirect(
                    request.getContextPath()
                    + "/doctors?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {

            Doctor doctor = new Doctor();

            doctor.setUserId(
                    Integer.parseInt(
                            request.getParameter("userId")));

            doctor.setDepartmentId(
                    Integer.parseInt(
                            request.getParameter("departmentId")));

            doctor.setSpecialization(
                    request.getParameter("specialization"));

            doctor.setQualification(
                    request.getParameter("qualification"));

            doctor.setExperienceYears(
                    Integer.parseInt(
                            request.getParameter("experienceYears")));

            doctor.setConsultationFee(
                    Double.parseDouble(
                            request.getParameter("consultationFee")));

            doctor.setBio(
                    request.getParameter("bio"));

            doctor.setProfileImage(
                    request.getParameter("profileImage"));

            doctor.setAvailabilityStatus("AVAILABLE");

            boolean success =
                    doctorDAO.addDoctor(doctor);

            if (success) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/doctors?action=list");

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/add-doctor.jsp?error=failed");
            }

        } else if ("update".equals(action)) {

            Doctor doctor = new Doctor();

            doctor.setDoctorId(
                    Integer.parseInt(
                            request.getParameter("doctorId")));

            doctor.setUserId(
                    Integer.parseInt(
                            request.getParameter("userId")));

            doctor.setDepartmentId(
                    Integer.parseInt(
                            request.getParameter("departmentId")));

            doctor.setSpecialization(
                    request.getParameter("specialization"));

            doctor.setQualification(
                    request.getParameter("qualification"));

            doctor.setExperienceYears(
                    Integer.parseInt(
                            request.getParameter("experienceYears")));

            doctor.setConsultationFee(
                    Double.parseDouble(
                            request.getParameter("consultationFee")));

            doctor.setBio(
                    request.getParameter("bio"));

            doctor.setProfileImage(
                    request.getParameter("profileImage"));

            doctor.setAvailabilityStatus(
                    request.getParameter("availabilityStatus"));

            boolean success =
                    doctorDAO.updateDoctor(doctor);

            if (success) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/doctors?action=list");

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/doctors?action=list&error=updateFailed");
            }
        }
    }
}