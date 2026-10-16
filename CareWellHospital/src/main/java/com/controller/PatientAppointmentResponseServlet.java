
package com.controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.HexFormat;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.dao.PatientAppointmentReminderDAO;
import com.daoimpl.PatientAppointmentReminderDAOImpl;
import com.util.EmailService;

@WebServlet("/patient-appointment-response")
public class PatientAppointmentResponseServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final PatientAppointmentReminderDAO reminderDAO =
            new PatientAppointmentReminderDAOImpl();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        response.setContentType("text/html;charset=UTF-8");
        response.setHeader("Cache-Control", "no-store");

        String appointmentIdText =
                request.getParameter("appointmentId");
        String token = request.getParameter("token");
        String patientResponse =
                request.getParameter("response");

        if (appointmentIdText == null || token == null
                || token.isBlank() || patientResponse == null) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "The response link is incomplete.");
            return;
        }

        int appointmentId;

        try {
            appointmentId = Integer.parseInt(appointmentIdText);
            if (appointmentId <= 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid appointment ID.");
            return;
        }

        if (!"CONFIRMED".equals(patientResponse)
                && !"CANCELLATION_REQUESTED".equals(patientResponse)) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid response.");
            return;
        }

        /*
         * GET only displays a confirmation page.
         * The database is not changed until the patient submits the form.
         */
        String actionLabel =
                "CONFIRMED".equals(patientResponse)
                        ? "Confirm Attendance"
                        : "Request Cancellation";

        String escapedToken = escapeHtml(token);

        response.getWriter().println(
                "<!DOCTYPE html><html><head>"
                + "<meta charset='UTF-8'>"
                + "<meta name='viewport' content='width=device-width, initial-scale=1'>"
                + "<title>CareWell Hospital</title>"
                + "</head><body>"
                + "<h2>CareWell Hospital</h2>"
                + "<p>You selected: " + actionLabel + ".</p>"
                + "<p>Please submit below to record your response.</p>"
                + "<form method='post' action='"
                + request.getContextPath()
                + "/patient-appointment-response'>"
                + "<input type='hidden' name='appointmentId' value='"
                + appointmentId + "'>"
                + "<input type='hidden' name='token' value='"
                + escapedToken + "'>"
                + "<input type='hidden' name='response' value='"
                + patientResponse + "'>"
                + "<button type='submit'>"
                + "Submit " + actionLabel
                + "</button></form></body></html>");
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        request.setCharacterEncoding("UTF-8");

        String appointmentIdText =
                request.getParameter("appointmentId");
        String token = request.getParameter("token");
        String patientResponse =
                request.getParameter("response");

        if (appointmentIdText == null || token == null
                || token.isBlank() || patientResponse == null) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "The response is incomplete.");
            return;
        }

        int appointmentId;

        try {
            appointmentId = Integer.parseInt(appointmentIdText);
            if (appointmentId <= 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid appointment ID.");
            return;
        }

        if (!"CONFIRMED".equals(patientResponse)
                && !"CANCELLATION_REQUESTED".equals(patientResponse)) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid response.");
            return;
        }

        try {
            String tokenHash = sha256(token);

            boolean updated = reminderDAO.recordPatientResponse(
                    appointmentId, tokenHash, patientResponse);

            response.setContentType("text/html;charset=UTF-8");
            response.setHeader("Cache-Control", "no-store");

            if (!updated) {
                response.setStatus(
                        HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().println(
                        "<h2>CareWell Hospital</h2>"
                        + "<p>This link is invalid, expired, "
                        + "or has already been used.</p>");
                return;
            }

            String responseLabel =
                    "CONFIRMED".equals(patientResponse)
                            ? "Attendance confirmed"
                            : "Cancellation request received";

            response.getWriter().println(
                    "<h2>CareWell Hospital</h2>"
                    + "<p>" + responseLabel + " successfully.</p>"
                    + "<p>Thank you for responding.</p>");

            /*
             * Notify the configured hospital test inbox.
             * This does not change the appointment's actual status.
             */
            String hospitalEmail =
                    System.getenv("CAREWELL_EMAIL");

            if (hospitalEmail != null
                    && !hospitalEmail.isBlank()) {

                String subject =
                        "CareWell Hospital - Patient Appointment Response";

                String body =
                        "A patient has responded to an appointment reminder.\n\n"
                        + "Appointment ID: " + appointmentId + "\n"
                        + "Response: " + patientResponse + "\n\n"
                        + "Please review the appointment in CareWell Hospital.";

                EmailService.sendEmail(
                        hospitalEmail, subject, body);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to process the response right now.");
        }
    }

    private String sha256(String value) throws Exception {

        byte[] hash = MessageDigest.getInstance("SHA-256")
                .digest(value.getBytes(StandardCharsets.UTF_8));

        return HexFormat.of().formatHex(hash);
    }

    private String escapeHtml(String value) {

        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }
}
