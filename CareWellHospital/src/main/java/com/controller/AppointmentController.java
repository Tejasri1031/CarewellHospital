package com.controller;



import java.io.IOException;

import java.sql.Date;

import java.sql.Time;

import java.util.List;

import java.util.ArrayList;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;



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

import com.dao.UserDAO;



import com.daoimpl.AppointmentDAOImpl;

import com.daoimpl.AppointmentDetailsDAOImpl;

import com.daoimpl.DoctorDAOImpl;

import com.daoimpl.NotificationDAOImpl;

import com.daoimpl.PatientDAOImpl;

import com.daoimpl.UserDAOImpl;



import com.model.Appointment;

import com.model.AppointmentDetails;

import com.model.Doctor;

import com.model.Notification;

import com.model.Patient;

import com.model.User;



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

                String customDateText =

                        request.getParameter("appointmentDate");



                // Normalize status

                if (status == null || status.trim().isEmpty()) {

                    status = "ALL";

                } else {

                    status = status.trim().toUpperCase();

                }



                if (!status.equals("ALL")

                        && !status.equals("PENDING")

                        && !status.equals("CONFIRMED")

                        && !status.equals("CANCELLED")

                        && !status.equals("COMPLETED")) {

                    status = "ALL";

                }



                // Normalize date filter

                if (dateFilter == null || dateFilter.trim().isEmpty()) {

                    dateFilter = "today".equalsIgnoreCase(filter)

                            ? "TODAY" : "ALL";

                } else {

                    dateFilter = dateFilter.trim().toUpperCase();

                }



                if (!dateFilter.equals("ALL")

                        && !dateFilter.equals("TODAY")

                        && !dateFilter.equals("UPCOMING")

                        && !dateFilter.equals("PAST")

                        && !dateFilter.equals("CUSTOM")) {

                    dateFilter = "ALL";

                }



                LocalDate today = LocalDate.now();

                LocalDate selectedDate = null;



                // Validate custom date safely

                if ("CUSTOM".equals(dateFilter)) {

                    try {

                        if (customDateText != null

                                && !customDateText.trim().isEmpty()) {

                            selectedDate =

                                    LocalDate.parse(customDateText.trim());

                        } else {

                            dateFilter = "ALL";

                        }

                    } catch (java.time.format.DateTimeParseException ex) {

                        dateFilter = "ALL";

                        customDateText = "";

                    }

                }



                // Load appointments for this doctor only

                List<AppointmentDetails> allDoctorAppointments =

                        appointmentDetailsDAO

                                .getAppointmentDetailsByDoctor(doctorId);



                List<AppointmentDetails> appointments = new ArrayList<>();



                for (AppointmentDetails appointment : allDoctorAppointments) {



                    if (appointment == null

                            || appointment.getAppointmentDate() == null) {

                        continue;

                    }



                    LocalDate appointmentDay =

                            appointment.getAppointmentDate().toLocalDate();



                    String appointmentStatus =

                            appointment.getStatus() == null

                                    ? ""

                                    : appointment.getStatus().trim().toUpperCase();



                    boolean statusMatches =

                            "ALL".equals(status)

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



                // Send filtered results and selected values to JSP

                request.setAttribute("appointments", appointments);

                request.setAttribute("selectedFilter", filter);

                request.setAttribute("selectedStatus", status);

                request.setAttribute("selectedDateFilter", dateFilter);

                request.setAttribute(

                        "selectedAppointmentDate", customDateText);



                request.getRequestDispatcher("/doctor/appointments.jsp")

                        .forward(request, response);

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



                HttpSession session = request.getSession(false);



                if (session == null) {

                    response.sendRedirect(

                            request.getContextPath() + "/login.jsp");

                    return;

                }



                User loggedUser =

                        (User) session.getAttribute("user");



                if (loggedUser == null

                        || !"PATIENT".equalsIgnoreCase(loggedUser.getRole())) {

                    response.sendRedirect(

                            request.getContextPath() + "/login.jsp");

                    return;

                }



                Patient loggedPatient =

                        patientDAO.getPatientByUserId(loggedUser.getUserId());



                if (loggedPatient == null) {

                    response.sendRedirect(

                            request.getContextPath()

                                    + "/patient/book-appointment.jsp"

                                    + "?error=patientNotFound");

                    return;

                }



                Appointment appointment = new Appointment();



                // Use the patient linked to the logged-in account.

                appointment.setPatientId(loggedPatient.getPatientId());



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





                // The doctor must respond by 6:00 PM IST on the day before
                // the appointment. Reject bookings after that deadline.
                LocalDateTime responseDeadline = LocalDateTime.of(
                        appointment.getAppointmentDate().toLocalDate().minusDays(1),
                        LocalTime.of(18, 0));

                LocalDateTime currentDateTime =
                        LocalDateTime.now(ZoneId.of("Asia/Kolkata"));

                if (!responseDeadline.isAfter(currentDateTime)) {
                    response.sendRedirect(
                            request.getContextPath()
                                    + "/patient/book-appointment.jsp"
                                    + "?error=responseDeadlinePassed");
                    return;
                }

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



                        Patient patient =

                                patientDAO.getPatientById(

                                        appointment.getPatientId());



                        String patientName = "Patient";



                        if (patient != null) {

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

                                        + ". Status: PENDING.");



                        notification.setRead(false);

                        notificationDAO.addNotification(notification);

                    }



                    // Send new-booking email to the CareWell Hospital inbox only.
                    try {
                        String hospitalEmail =
                                System.getenv("CAREWELL_HOSPITAL_EMAIL");

                        if (hospitalEmail == null
                                || hospitalEmail.trim().isEmpty()) {
                            System.err.println(
                                    "Booking email not sent: CAREWELL_HOSPITAL_EMAIL "
                                            + "is not configured. Appointment ID: "
                                            + appointmentId);
                        } else {
                            Patient bookingPatient =
                                    patientDAO.getPatientById(
                                            appointment.getPatientId());

                            String patientName = "Patient";
                            if (bookingPatient != null) {
                                User patientUser =
                                        userDAO.getUserById(
                                                bookingPatient.getUserId());
                                if (patientUser != null
                                        && patientUser.getFullName() != null
                                        && !patientUser.getFullName().trim().isEmpty()) {
                                    patientName = patientUser.getFullName();
                                }
                            }

                            String subject =
                                    "CareWell Hospital - New Appointment Request";

                            String body =
                                    "A new appointment request has been received.\\n\\n"
                                  + "Appointment ID: " + appointmentId + "\\n"
                                  + "Patient: " + patientName + "\\n"
                                  + "Doctor ID: " + appointment.getDoctorId() + "\\n"
                                  + "Department ID: " + appointment.getDepartmentId() + "\\n"
                                  + "Date: " + appointment.getAppointmentDate() + "\\n"
                                  + "Time: " + appointment.getAppointmentTime() + "\\n"
                                  + "Reason: " + appointment.getReason() + "\\n"
                                  + "Status: PENDING\\n\\n"
                                  + "Please sign in to CareWell Hospital to review "
                                  + "and confirm or reject this appointment.\\n\\n"
                                  + "Regards,\\nCareWell Hospital";

                            boolean emailSent = EmailService.sendEmail(
                                    hospitalEmail.trim(), subject, body);

                            if (!emailSent) {
                                System.err.println(
                                        "Appointment saved, but hospital booking email failed. "
                                                + "Appointment ID: " + appointmentId);
                            }
                        }
                    } catch (Exception emailException) {
                        System.err.println(
                                "Appointment saved, but hospital booking email failed.");
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

                                        + " at " + appointment.getAppointmentTime() + ".");

                        notification.setRead(false);



                        notificationDAO.addNotification(notification);

                    }



                    // Email only after successful confirmation.

                    try {

                        Patient confirmedPatient =

                                patientDAO.getPatientById(

                                        appointment.getPatientId());



                        if (confirmedPatient != null) {

                            User patientUser =

                                    userDAO.getUserById(confirmedPatient.getUserId());



                            if (patientUser != null

                                    && patientUser.getEmail() != null

                                    && !patientUser.getEmail().trim().isEmpty()) {



                                String subject =

                                        "CareWell Hospital - Appointment Confirmed";


                                String body =
                                        "Dear " + patientUser.getFullName() + ",\n\n"
                                      + "Your appointment has been confirmed by the doctor.\n\n"
                                      + "Appointment ID: " + appointment.getAppointmentId() + "\n"
                                      + "Date: " + appointment.getAppointmentDate() + "\n"
                                      + "Time: " + appointment.getAppointmentTime() + "\n\n"
                                      + "Please arrive on time for your appointment.\n\n"
                                      + "Regards,\nCareWell Hospital";

                                	

                                boolean emailSent = EmailService.sendEmail(

                                        patientUser.getEmail(), subject, body);



                                if (!emailSent) {

                                    System.err.println(

                                            "Confirmation email failed for appointment "

                                                    + appointment.getAppointmentId());

                                }

                            }

                        }

                    } catch (Exception emailException) {

                        System.err.println(

                                "Appointment confirmed, but patient email failed.");

                        emailException.printStackTrace();

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

                                        + " at " + appointment.getAppointmentTime() + ".");

                        notification.setRead(false);



                        notificationDAO.addNotification(notification);

                    }



                    // Email only after successful cancellation.

                    try {

                        Patient cancelledPatient =

                                patientDAO.getPatientById(

                                        appointment.getPatientId());



                        if (cancelledPatient != null) {

                            User patientUser =

                                    userDAO.getUserById(cancelledPatient.getUserId());



                            if (patientUser != null

                                    && patientUser.getEmail() != null

                                    && !patientUser.getEmail().trim().isEmpty()) {



                                String subject =

                                        "CareWell Hospital - Appointment Cancelled";



                                String body =

                                        "Dear " + patientUser.getFullName() + ",\n\n"

                                      + "Your appointment has been cancelled by the doctor.\n\n"

                                      + "Appointment ID: " + appointment.getAppointmentId() + "\n"

                                      + "Date: " + appointment.getAppointmentDate() + "\n"

                                      + "Time: " + appointment.getAppointmentTime() + "\n\n"

                                      + "Please contact CareWell Hospital if you need "

                                      + "help arranging another appointment.\n\n"

                                      + "Regards,\nCareWell Hospital";



                                boolean emailSent = EmailService.sendEmail(

                                        patientUser.getEmail(), subject, body);



                                if (!emailSent) {

                                    System.err.println(

                                            "Cancellation email failed for appointment "

                                                    + appointment.getAppointmentId());

                                }

                            }

                        }

                    } catch (Exception emailException) {

                        System.err.println(

                                "Appointment cancelled, but patient email failed.");

                        emailException.printStackTrace();

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
