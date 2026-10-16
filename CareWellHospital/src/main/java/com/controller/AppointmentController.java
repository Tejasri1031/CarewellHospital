
package com.controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;
import java.util.ArrayList;
import java.time.LocalDate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.dao.AppointmentDAO;
import com.dao.AppointmentDetailsDAO;
import com.dao.DoctorDAO;
import com.dao.NotificationDAO;
import com.dao.PatientDAO;

import com.daoimpl.AppointmentDAOImpl;
import com.daoimpl.AppointmentDetailsDAOImpl;
import com.daoimpl.DoctorDAOImpl;
import com.daoimpl.NotificationDAOImpl;
import com.daoimpl.PatientDAOImpl;

import com.model.Appointment;
import com.model.AppointmentDetails;
import com.model.Doctor;
import com.model.Notification;
import com.model.Patient;
import com.model.User;

import com.dao.UserDAO;
import com.daoimpl.UserDAOImpl;
import com.util.EmailService;

@WebServlet("/appointments")
public class AppointmentController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentDAO appointmentDAO;
    private AppointmentDetailsDAO appointmentDetailsDAO;
    private DoctorDAO doctorDAO;
    private PatientDAO patientDAO;
    private NotificationDAO notificationDAO;
    private UserDAO userDAO;
  

    @Override
    public void init() throws ServletException {
        appointmentDAO = new AppointmentDAOImpl();
        appointmentDetailsDAO = new AppointmentDetailsDAOImpl();
        doctorDAO = new DoctorDAOImpl();
        patientDAO = new PatientDAOImpl();
        notificationDAO = new NotificationDAOImpl();
        userDAO = new UserDAOImpl();
    }

    // =========================================================
    // GET
    // =========================================================

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            // ADMIN - ALL APPOINTMENTS
            if (action == null || action.equals("list")) {

                List<Appointment> appointments =
                        appointmentDAO.getAllAppointments();

                request.setAttribute("appointments", appointments);

                request.getRequestDispatcher(
                        "/admin/appointments.jsp").forward(request, response);
            }

            // PATIENT - APPOINTMENTS
            else if (action.equals("patient")) {

                int patientId = Integer.parseInt(
                        request.getParameter("patientId"));

                List<Appointment> appointments =
                        appointmentDAO.getAppointmentsByPatient(patientId);

                request.setAttribute("appointments", appointments);

                request.getRequestDispatcher(
                        "/patient/appointments.jsp").forward(request, response);
            }

            // DOCTOR - APPOINTMENTS
            else if (action.equals("doctor")) {

                HttpSession session = request.getSession(false);

                if (session == null) {
                    response.sendRedirect(
                            request.getContextPath() + "/login.jsp");
                    return;
                }

                User loggedUser = (User) session.getAttribute("user");

                if (loggedUser == null
                        || !"DOCTOR".equalsIgnoreCase(loggedUser.getRole())) {
                    response.sendRedirect(
                            request.getContextPath() + "/login.jsp");
                    return;
                }

                Doctor loggedDoctor = findLoggedDoctor(loggedUser);

                if (loggedDoctor == null) {
                    response.sendRedirect(
                            request.getContextPath()
                                    + "/login.jsp?error=doctorNotFound");
                    return;
                }

                int doctorId = loggedDoctor.getDoctorId();

                String filter = request.getParameter("filter");
                String status = request.getParameter("status");
                String dateFilter = request.getParameter("dateFilter");
                String customDateText = request.getParameter("appointmentDate");

                // Keep compatibility with the existing dashboard link: filter=today.
                if ((dateFilter == null || dateFilter.trim().isEmpty())
                        && "today".equalsIgnoreCase(filter)) {
                    dateFilter = "TODAY";
                }
                if (dateFilter == null || dateFilter.trim().isEmpty()) {
                    dateFilter = "ALL";
                }
                dateFilter = dateFilter.trim().toUpperCase();

                if (status != null) {
                    status = status.trim().toUpperCase();
                    if (!"PENDING".equals(status)
                            && !"CONFIRMED".equals(status)
                            && !"CANCELLED".equals(status)
                            && !"COMPLETED".equals(status)
                            && !"ALL".equals(status)) {
                        status = "ALL";
                    }
                } else {
                    status = "ALL";
                }

                LocalDate today = LocalDate.now();
                LocalDate selectedDate = null;
                if ("CUSTOM".equals(dateFilter)) {
                    if (customDateText == null || customDateText.trim().isEmpty()) {
                        dateFilter = "ALL";
                    } else {
                        selectedDate = LocalDate.parse(customDateText.trim());
                    }
                }

                // Fetch only the logged-in doctor's appointments first.
                List<AppointmentDetails> allDoctorAppointments =
                        appointmentDetailsDAO.getAppointmentDetailsByDoctor(doctorId);
                List<AppointmentDetails> appointments = new ArrayList<>();

                for (AppointmentDetails appointment : allDoctorAppointments) {
                    if (appointment == null || appointment.getAppointmentDate() == null) {
                        continue;
                    }

                    LocalDate appointmentDay = appointment.getAppointmentDate().toLocalDate();
                    String appointmentStatus = appointment.getStatus() == null
                            ? "" : appointment.getStatus().trim().toUpperCase();

                    boolean statusMatches = "ALL".equals(status)
                            || status.equals(appointmentStatus);
                    boolean dateMatches;

                    switch (dateFilter) {
                        case "TODAY":
                            dateMatches = appointmentDay.equals(today);
                            break;
                        case "UPCOMING":
                            dateMatches = appointmentDay.isAfter(today);
                            break;
                        case "PAST":
                            dateMatches = appointmentDay.isBefore(today);
                            break;
                        case "CUSTOM":
                            dateMatches = selectedDate != null
                                    && appointmentDay.equals(selectedDate);
                            break;
                        default:
                            dateMatches = true;
                            break;
                    }

                    if (statusMatches && dateMatches) {
                        appointments.add(appointment);
                    }
                }

                request.setAttribute("appointments", appointments);
                request.setAttribute("selectedFilter", filter);
                request.setAttribute("selectedStatus", status);
                request.setAttribute("selectedDateFilter", dateFilter);
                request.setAttribute("selectedAppointmentDate", customDateText);

                request.getRequestDispatcher(
                        "/doctor/appointments.jsp").forward(request, response);    
          

            }
            // ADMIN - APPOINTMENTS BY DATE
            else if (action.equals("date")) {

                Date appointmentDate = Date.valueOf(
                        request.getParameter("appointmentDate"));

                List<Appointment> appointments =
                        appointmentDAO.getAppointmentsByDate(appointmentDate);

                request.setAttribute("appointments", appointments);

                request.getRequestDispatcher(
                        "/admin/appointments.jsp").forward(request, response);
            }

            // ADMIN - DELETE
            else if (action.equals("delete")) {

                int appointmentId = Integer.parseInt(
                        request.getParameter("appointmentId"));

                appointmentDAO.deleteAppointment(appointmentId);

                response.sendRedirect(
                        request.getContextPath()
                                + "/appointments?action=list");
            }

        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                            + "/appointments?action=list&error=invalidData");
        }
    }

    // =========================================================
    // POST
    // =========================================================

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            // PATIENT - BOOK APPOINTMENT
            if ("add".equals(action)) {

                Appointment appointment = new Appointment();

                appointment.setPatientId(Integer.parseInt(
                        request.getParameter("patientId")));

                appointment.setDoctorId(Integer.parseInt(
                        request.getParameter("doctorId")));

                appointment.setDepartmentId(Integer.parseInt(
                        request.getParameter("departmentId")));

                appointment.setAppointmentDate(Date.valueOf(
                        request.getParameter("appointmentDate")));

                String appointmentTime =
                        request.getParameter("appointmentTime");

                if (appointmentTime != null
                        && appointmentTime.length() == 5) {
                    appointmentTime += ":00";
                }

                appointment.setAppointmentTime(Time.valueOf(appointmentTime));
                appointment.setReason(request.getParameter("reason"));
                appointment.setStatus("PENDING");
                appointment.setNotes(request.getParameter("notes"));

                boolean slotAvailable = appointmentDAO.isSlotAvailable(
                        appointment.getDoctorId(),
                        appointment.getAppointmentDate(),
                        appointment.getAppointmentTime());

                if (!slotAvailable) {
                    response.sendRedirect(
                            request.getContextPath()
                                    + "/patient/book-appointment.jsp"
                                    + "?error=slotUnavailable");
                    return;
                }

                int appointmentId =
                        appointmentDAO.addAppointmentAndGetId(appointment);

                if (appointmentId > 0) {

                    Doctor doctor =
                            doctorDAO.getDoctorById(appointment.getDoctorId());

                    if (doctor != null) {
                        Notification notification = new Notification();

                        notification.setUserId(doctor.getUserId());
                        notification.setAppointmentId(appointmentId);
                        notification.setNotificationType("APPOINTMENT_REQUEST");

notification.setTitle("New Appointment Request");

// Get the patient linked to this appointment.
Patient patient =
        patientDAO.getPatientById(appointment.getPatientId());

String patientName = "Patient";

if (patient != null) {

    // Retrieve the patient's name from the users table.
    UserDAO userDAO = new UserDAOImpl();

    User patientUser =
            userDAO.getUserById(patient.getUserId());

    if (patientUser != null
            && patientUser.getFullName() != null
            && !patientUser.getFullName().trim().isEmpty()) {

        patientName = patientUser.getFullName();
    }
}

notification.setMessage(
        patientName
        + " has requested an appointment with you. "
        + "Date: " + appointment.getAppointmentDate()
        + ". Time: " + appointment.getAppointmentTime()
        + ". Status: PENDING."
);

                        notification.setRead(false);

                        notificationDAO.addNotification(notification);
                    }
                 // Send email notification to the assigned doctor.
                    try {
                        if (doctor != null) {
                            User doctorUser = userDAO.getUserById(doctor.getUserId());

                            if (doctorUser != null
                                    && doctorUser.getEmail() != null
                                    && !doctorUser.getEmail().trim().isEmpty()) {

                                String subject =
                                        "CareWell Hospital - New Appointment Request";

                                String body =
                                        "Hello Dr. " + doctorUser.getFullName() + ",\n\n"
                                        + "A new appointment request has been received.\n\n"
                                        + "Appointment ID: " + appointmentId + "\n"
                                        + "Date: " + appointment.getAppointmentDate() + "\n"
                                        + "Time: " + appointment.getAppointmentTime() + "\n"
                                        + "Reason: " + appointment.getReason() + "\n\n"
                                        + "Please sign in to CareWell Hospital to review "
                                        + "and confirm or reject this appointment.\n\n"
                                        + "Regards,\n"
                                        + "CareWell Hospital";

                                boolean emailSent = EmailService.sendEmail(
                                        "reethuroyal67@gmail.com",
                                        subject,
                                        body
                                );

                                if (!emailSent) {
                                    System.out.println(
                                            "Appointment saved, but doctor email failed. "
                                            + "Appointment ID: " + appointmentId
                                    );
                                }
                            }
                        }
                    } catch (Exception emailException) {
                        // Email failure must not undo a successfully saved appointment.
                        System.out.println(
                                "Appointment saved, but doctor email notification failed."
                        );
                        emailException.printStackTrace();
                    }

                    response.sendRedirect(
                            request.getContextPath()
                                    + "/patient/booking-success.jsp");

                } else {
                    response.sendRedirect(
                            request.getContextPath()
                                    + "/patient/book-appointment.jsp"
                                    + "?error=bookingFailed");
                }
            }

            // ADMIN - UPDATE APPOINTMENT
            else if ("update".equals(action)) {

                Appointment appointment = new Appointment();

                appointment.setAppointmentId(Integer.parseInt(
                        request.getParameter("appointmentId")));
                appointment.setPatientId(Integer.parseInt(
                        request.getParameter("patientId")));
                appointment.setDoctorId(Integer.parseInt(
                        request.getParameter("doctorId")));
                appointment.setDepartmentId(Integer.parseInt(
                        request.getParameter("departmentId")));
                appointment.setAppointmentDate(Date.valueOf(
                        request.getParameter("appointmentDate")));

                String appointmentTime =
                        request.getParameter("appointmentTime");

                if (appointmentTime != null
                        && appointmentTime.length() == 5) {
                    appointmentTime += ":00";
                }

                appointment.setAppointmentTime(Time.valueOf(appointmentTime));
                appointment.setReason(request.getParameter("reason"));
                appointment.setStatus(request.getParameter("status"));
                appointment.setNotes(request.getParameter("notes"));

                boolean success = appointmentDAO.updateAppointment(appointment);

                if (success) {
                    response.sendRedirect(
                            request.getContextPath()
                                    + "/appointments?action=list");
                } else {
                    response.sendRedirect(
                            request.getContextPath()
                                    + "/appointments?action=list&error=updateFailed");
                }
            }

            // DOCTOR - CONFIRM APPOINTMENT
            else if ("confirm".equals(action)) {

                User loggedUser = getLoggedDoctorUser(request, response);
                if (loggedUser == null) {
                    return;
                }

                int appointmentId = Integer.parseInt(
                        request.getParameter("appointmentId"));

                Doctor loggedDoctor = findLoggedDoctor(loggedUser);
                if (loggedDoctor == null) {
                    response.sendRedirect(
                            request.getContextPath() + "/login.jsp");
                    return;
                }

                Appointment appointment =
                        appointmentDAO.getAppointmentById(appointmentId);

                if (appointment == null
                        || appointment.getDoctorId()
                                != loggedDoctor.getDoctorId()
                        || !"PENDING".equalsIgnoreCase(appointment.getStatus())) {
                    response.sendRedirect(
                            request.getContextPath()
                                    + "/appointments?action=doctor&error=invalidAppointment");
                    return;
                }

                appointment.setStatus("CONFIRMED");

                boolean success = appointmentDAO.updateAppointment(appointment);

                if (success) {
                    Patient patient =
                            patientDAO.getPatientById(appointment.getPatientId());

                    if (patient != null) {
                        Notification notification = new Notification();

                        notification.setUserId(patient.getUserId());
                        notification.setAppointmentId(
                                appointment.getAppointmentId());
                        notification.setNotificationType("APPOINTMENT_CONFIRMED");
                        notification.setTitle("Appointment Confirmed");
                        notification.setMessage(
                                loggedUser.getFullName()
                                        + " has confirmed your appointment on "
                                        + appointment.getAppointmentDate()
                                        + " at " + appointment.getAppointmentTime()
                                        + ".");
                        notification.setRead(false);

                        notificationDAO.addNotification(notification);
                    }
                }

                response.sendRedirect(
                        request.getContextPath()
                                + "/appointments?action=doctor&message=confirmed");
            }

            // DOCTOR - CANCEL / REJECT APPOINTMENT
            else if ("cancel".equals(action)) {

                User loggedUser = getLoggedDoctorUser(request, response);
                if (loggedUser == null) {
                    return;
                }

                int appointmentId = Integer.parseInt(
                        request.getParameter("appointmentId"));

                Doctor loggedDoctor = findLoggedDoctor(loggedUser);
                if (loggedDoctor == null) {
                    response.sendRedirect(
                            request.getContextPath() + "/login.jsp");
                    return;
                }

                Appointment appointment =
                        appointmentDAO.getAppointmentById(appointmentId);

                if (appointment == null
                        || appointment.getDoctorId()
                                != loggedDoctor.getDoctorId()
                        || !"PENDING".equalsIgnoreCase(appointment.getStatus())) {
                    response.sendRedirect(
                            request.getContextPath()
                                    + "/appointments?action=doctor&error=invalidAppointment");
                    return;
                }

                appointment.setStatus("CANCELLED");

                boolean success = appointmentDAO.updateAppointment(appointment);

                if (success) {
                    Patient patient =
                            patientDAO.getPatientById(appointment.getPatientId());

                    if (patient != null) {
                        Notification notification = new Notification();

                        notification.setUserId(patient.getUserId());
                        notification.setAppointmentId(
                                appointment.getAppointmentId());
                        notification.setNotificationType("APPOINTMENT_CANCELLED");
                        notification.setTitle("Appointment Cancelled");
                        notification.setMessage(
                                loggedUser.getFullName()
                                        + " has cancelled your appointment scheduled for "
                                        + appointment.getAppointmentDate()
                                        + " at " + appointment.getAppointmentTime()
                                        + ".");
                        notification.setRead(false);

                        notificationDAO.addNotification(notification);
                    }
                }

                response.sendRedirect(
                        request.getContextPath()
                                + "/appointments?action=doctor&message=cancelled");
            }

        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                            + "/appointments?action=list&error=invalidData");
        }
    }

    // =========================================================
    // HELPER METHODS
    // =========================================================

    private Doctor findLoggedDoctor(User user) {
        List<Doctor> doctors = doctorDAO.getAllDoctors();

        for (Doctor doctor : doctors) {
            if (doctor.getUserId() == user.getUserId()) {
                return doctor;
            }
        }

        return null;
    }

    private User getLoggedDoctorUser(HttpServletRequest request,
                                     HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return null;
        }

        User user = (User) session.getAttribute("user");

        if (user == null
                || !"DOCTOR".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return null;
        }

        return user;
    }
}
