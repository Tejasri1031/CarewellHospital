package com.controller;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.dao.PatientDAO;
import com.daoimpl.PatientDAOImpl;
import com.model.Patient;

@WebServlet("/patients")
public class PatientController extends HttpServlet {

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

        String action = request.getParameter("action");

        if (action == null || action.equals("list")) {

            List<Patient> patients =
                    patientDAO.getAllPatients();

            request.setAttribute("patients", patients);

            request.getRequestDispatcher(
                    "/admin/patients.jsp")
                    .forward(request, response);

        } else if (action.equals("view")) {

            int patientId =
                    Integer.parseInt(
                            request.getParameter("patientId"));

            Patient patient =
                    patientDAO.getPatientById(patientId);

            request.setAttribute("patient", patient);

            request.getRequestDispatcher(
                    "/admin/patient-details.jsp")
                    .forward(request, response);

        } else if (action.equals("delete")) {

            int patientId =
                    Integer.parseInt(
                            request.getParameter("patientId"));

            patientDAO.deletePatient(patientId);

            response.sendRedirect(
                    request.getContextPath()
                    + "/patients?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {

            if ("add".equals(action)) {

                Patient patient = new Patient();

                patient.setUserId(
                        Integer.parseInt(
                                request.getParameter("userId")));

                String dateOfBirth =
                        request.getParameter("dateOfBirth");

                if (dateOfBirth != null
                        && !dateOfBirth.isEmpty()) {

                    patient.setDateOfBirth(
                            Date.valueOf(dateOfBirth));
                }

                patient.setGender(
                        request.getParameter("gender"));

                patient.setBloodGroup(
                        request.getParameter("bloodGroup"));

                patient.setAddress(
                        request.getParameter("address"));

                patient.setEmergencyContactName(
                        request.getParameter(
                                "emergencyContactName"));

                patient.setEmergencyContactPhone(
                        request.getParameter(
                                "emergencyContactPhone"));

                boolean success =
                        patientDAO.addPatient(patient);

                if (success) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/patients?action=list");

                } else {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/admin/add-patient.jsp?error=failed");
                }

            } else if ("update".equals(action)) {

                Patient patient = new Patient();

                patient.setPatientId(
                        Integer.parseInt(
                                request.getParameter("patientId")));

                patient.setUserId(
                        Integer.parseInt(
                                request.getParameter("userId")));

                String dateOfBirth =
                        request.getParameter("dateOfBirth");

                if (dateOfBirth != null
                        && !dateOfBirth.isEmpty()) {

                    patient.setDateOfBirth(
                            Date.valueOf(dateOfBirth));
                }

                patient.setGender(
                        request.getParameter("gender"));

                patient.setBloodGroup(
                        request.getParameter("bloodGroup"));

                patient.setAddress(
                        request.getParameter("address"));

                patient.setEmergencyContactName(
                        request.getParameter(
                                "emergencyContactName"));

                patient.setEmergencyContactPhone(
                        request.getParameter(
                                "emergencyContactPhone"));

                boolean success =
                        patientDAO.updatePatient(patient);

                if (success) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/patients?action=list");

                } else {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/patients?action=list"
                            + "&error=updateFailed");
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/patients?action=list"
                    + "&error=invalidData");
        }
    }
}