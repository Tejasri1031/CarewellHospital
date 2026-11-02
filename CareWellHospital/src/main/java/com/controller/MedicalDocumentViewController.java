package com.controller;

import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Locale;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.dao.AppointmentDAO;
import com.dao.DoctorDAO;
import com.dao.MedicalDocumentDAO;
import com.daoimpl.AppointmentDAOImpl;
import com.daoimpl.DoctorDAOImpl;
import com.daoimpl.MedicalDocumentDAOImpl;
import com.model.Appointment;
import com.model.Doctor;
import com.model.MedicalDocument;
import com.model.User;
import com.util.FileStorageUtil;

@WebServlet("/doctor/medical-document")
public class MedicalDocumentViewController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final AppointmentDAO appointmentDAO =
            new AppointmentDAOImpl();

    private final DoctorDAO doctorDAO =
            new DoctorDAOImpl();

    private final MedicalDocumentDAO medicalDocumentDAO =
            new MedicalDocumentDAOImpl();
    
    
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 1. Verify login
        if (session == null || session.getAttribute("user") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        User loggedUser = (User) session.getAttribute("user");

        // 2. Verify doctor role
        if (!"DOCTOR".equalsIgnoreCase(loggedUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // 3. Read IDs
        String appointmentIdParam = request.getParameter("appointmentId");
        String documentIdParam = request.getParameter("documentId");

        int appointmentId;
        int documentId;

        try {
            appointmentId = Integer.parseInt(appointmentIdParam);
            documentId = Integer.parseInt(documentIdParam);

            if (appointmentId <= 0 || documentId <= 0) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

        } catch (NumberFormatException | NullPointerException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // 4. Find logged-in doctor
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

        // 5. Verify appointment ownership
        Appointment appointment =
                appointmentDAO.getAppointmentById(appointmentId);

        if (appointment == null
                || appointment.getDoctorId() != loggedDoctor.getDoctorId()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // 6. Find document belonging to this appointment
        List<MedicalDocument> documents =
                medicalDocumentDAO.getDocumentsByAppointment(appointmentId);

        MedicalDocument selectedDocument = null;

        for (MedicalDocument document : documents) {
            if (document.getDocumentId() == documentId) {
                selectedDocument = document;
                break;
            }
        }

        if (selectedDocument == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // 7. Retrieve private file
        Path filePath;

        try {
            filePath = FileStorageUtil.getFilePath(
                    selectedDocument.getStorageKey());
        } catch (IOException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // 8. Allow only supported document types
        String contentType = selectedDocument.getContentType();

        if (contentType == null) {
            response.sendError(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE);
            return;
        }

        String safeContentType = contentType.toLowerCase(Locale.ROOT);

        if (!safeContentType.equals("application/pdf")
                && !safeContentType.equals("image/jpeg")
                && !safeContentType.equals("image/png")) {
            response.sendError(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE);
            return;
        }

        // 9. Send document to browser
        response.setContentType(safeContentType);
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader(
                "Content-Disposition",
                "inline; filename=\"medical-document\"");

        response.setContentLengthLong(Files.size(filePath));

        try (OutputStream outputStream = response.getOutputStream()) {
            Files.copy(filePath, outputStream);
        }
    }

}

