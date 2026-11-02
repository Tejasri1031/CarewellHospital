package com.controller;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.dao.AppointmentDAO;
import com.dao.MedicalDocumentDAO;
import com.daoimpl.AppointmentDAOImpl;
import com.daoimpl.MedicalDocumentDAOImpl;
import com.model.Appointment;
import com.model.Doctor;
import com.model.MedicalDocument;
import com.model.User;
import com.dao.DoctorDAO;
import com.daoimpl.DoctorDAOImpl;
import com.util.FileStorageUtil;

@WebServlet("/doctor/medical-documents")
public class MedicalDocumentController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check login
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        User loggedUser = (User) session.getAttribute("user");

        // Allow only doctors
        if (!"DOCTOR".equalsIgnoreCase(loggedUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Retrieve appointment ID
        String appointmentIdParam = request.getParameter("appointmentId");

        if (appointmentIdParam == null || appointmentIdParam.isBlank()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int appointmentId;

        try {
            appointmentId = Integer.parseInt(appointmentIdParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // Initialize DAO
        DoctorDAO doctorDAO = new DoctorDAOImpl();
        AppointmentDAO appointmentDAO = new AppointmentDAOImpl();
        MedicalDocumentDAO medicalDocumentDAO =
                new MedicalDocumentDAOImpl();

        // Find logged-in doctor
        Doctor loggedDoctor = null;

        for (Doctor doctor : doctorDAO.getAllDoctors()) {
            if (doctor.getUserId() == loggedUser.getUserId()) {
                loggedDoctor = doctor;
                break;
            }
        }

        if (loggedDoctor == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Verify appointment ownership
        Appointment appointment =
                appointmentDAO.getAppointmentById(appointmentId);

        if (appointment == null
                || appointment.getDoctorId() != loggedDoctor.getDoctorId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Retrieve documents for this appointment
        List<MedicalDocument> documents =
                medicalDocumentDAO.getDocumentsByAppointment(appointmentId);

        request.setAttribute("documents", documents);
        request.setAttribute("appointment", appointment);

        request.getRequestDispatcher(
                "/doctor/appointment-documents.jsp")
                .forward(request, response);
    }

}