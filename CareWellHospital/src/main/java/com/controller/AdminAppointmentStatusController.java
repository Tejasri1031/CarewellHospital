package com.controller;

import java.io.IOException;

import com.dao.AppointmentDAO;
import com.daoimpl.AppointmentDAOImpl;
import com.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.model.Appointment;

import com.dao.NotificationDAO;
import com.dao.PatientDAO;
import com.dao.UserDAO;

import com.daoimpl.NotificationDAOImpl;
import com.daoimpl.PatientDAOImpl;
import com.daoimpl.UserDAOImpl;

import com.model.Notification;
import com.model.Patient;

import com.util.EmailService;

@WebServlet("/AdminAppointmentStatusController")
public class AdminAppointmentStatusController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final AppointmentDAO appointmentDAO = new AppointmentDAOImpl();
    
    private final PatientDAO patientDAO = new PatientDAOImpl();
    private final NotificationDAO notificationDAO = new NotificationDAOImpl();
    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User loggedUser = (User) session.getAttribute("user");

        if (loggedUser == null || !"ADMIN".equalsIgnoreCase(loggedUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
            String status = request.getParameter("status");

            if (!"CONFIRMED".equals(status) && !"CANCELLED".equals(status)) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            boolean updated = appointmentDAO.updateAppointmentStatus(appointmentId, status);

            if (updated) {

                Appointment appointment = appointmentDAO.getAppointmentById(appointmentId);

                if (appointment != null) {

                    Patient patient = patientDAO.getPatientById(appointment.getPatientId());

                    if (patient != null) {

                        // Create patient notification
                        try {
                            Notification notification = new Notification();

                            notification.setUserId(patient.getUserId());
                            notification.setAppointmentId(appointmentId);

                            if ("CONFIRMED".equals(status)) {
                                notification.setNotificationType("APPOINTMENT_CONFIRMED");
                                notification.setTitle("Appointment Confirmed");
                                notification.setMessage(
                                        "Your appointment has been confirmed by CareWell Hospital administration on "
                                        + appointment.getAppointmentDate()
                                        + " at " + appointment.getAppointmentTime() + ".");
                            } else {
                                notification.setNotificationType("APPOINTMENT_CANCELLED");
                                notification.setTitle("Appointment Cancelled");
                                notification.setMessage(
                                        "Your appointment has been cancelled by CareWell Hospital administration.");
                            }

                            notification.setRead(false);
                            notificationDAO.addNotification(notification);

                        } catch (Exception notificationException) {
                            notificationException.printStackTrace();
                        }

                        // Send patient email
                        try {
                            User patientUser = userDAO.getUserById(patient.getUserId());

                            if (patientUser != null
                                    && patientUser.getEmail() != null
                                    && !patientUser.getEmail().trim().isEmpty()) {

                                String subject;
                                String body;

                                if ("CONFIRMED".equals(status)) {

                                    subject = "CareWell Hospital - Appointment Confirmed";

                                    body = "Your appointment has been confirmed by CareWell Hospital administration.\n\n"
                                            + "Appointment ID: " + appointmentId + "\n"
                                            + "Date: " + appointment.getAppointmentDate() + "\n"
                                            + "Time: " + appointment.getAppointmentTime() + "\n\n"
                                            + "Please arrive on time for your appointment.\n\n"
                                            + "Regards,\nCareWell Hospital";

                                } else {

                                    subject = "CareWell Hospital - Appointment Cancelled";

                                    body = "Your appointment has been cancelled by CareWell Hospital administration.\n\n"
                                            + "Appointment ID: " + appointmentId + "\n"
                                            + "Date: " + appointment.getAppointmentDate() + "\n"
                                            + "Time: " + appointment.getAppointmentTime() + "\n\n"
                                            + "Please contact CareWell Hospital if you need further assistance.\n\n"
                                            + "Regards,\nCareWell Hospital";
                                }

                                boolean emailSent = EmailService.sendEmail(
                                        patientUser.getEmail(), subject, body);

                                if (!emailSent) {
                                    System.err.println(
                                            "Admin appointment status email failed for appointment "
                                            + appointmentId);
                                }
                            }

                        } catch (Exception emailException) {
                            System.err.println(
                                    "Appointment status updated, but patient email failed.");
                            emailException.printStackTrace();
                        }
                    }
                }
            }

            String result = updated ? "success" : "failed";

            response.sendRedirect(
                    request.getContextPath()
                    + "/AdminAppointmentDetailsController?appointmentId="
                    + appointmentId + "&statusUpdate=" + result);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}