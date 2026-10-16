
package com.util;

import java.sql.Date;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.List;

import com.dao.AppointmentDAO;
import com.dao.DoctorDAO;
import com.dao.PatientDAO;
import com.dao.UserDAO;

import com.daoimpl.AppointmentDAOImpl;
import com.daoimpl.DoctorDAOImpl;
import com.daoimpl.DailyAppointmentReminderDAOImpl;
import com.daoimpl.PatientDAOImpl;
import com.daoimpl.UserDAOImpl;

import com.model.Appointment;
import com.model.Doctor;
import com.model.Patient;
import com.model.User;

public class DailyAppointmentReminderService {

    private final DoctorDAO doctorDAO = new DoctorDAOImpl();
    private final AppointmentDAO appointmentDAO = new AppointmentDAOImpl();
    private final PatientDAO patientDAO = new PatientDAOImpl();
    private final UserDAO userDAO = new UserDAOImpl();

    private final DailyAppointmentReminderDAOImpl reminderDAO =
            new DailyAppointmentReminderDAOImpl();
    private static final String TEST_RECIPIENT_EMAIL =
            "reethuroyal67@gmail.com";

    public void sendDailyAppointmentReminders() {

        Date today = Date.valueOf(LocalDate.now());

        System.out.println(
                "Starting daily appointment reminders for " + today);

        List<Doctor> doctors = doctorDAO.getAllDoctors();

        for (Doctor doctor : doctors) {

            try {

                int doctorId = doctor.getDoctorId();

                List<Appointment> appointments =
                        appointmentDAO.getAppointmentsByDoctorAndDate(
                                doctorId, today);

                StringBuilder emailBody = new StringBuilder();
                int confirmedCount = 0;

                for (Appointment appointment : appointments) {

                    if (!"CONFIRMED".equalsIgnoreCase(
                            appointment.getStatus())) {
                        continue;
                    }

                    Patient patient = patientDAO.getPatientById(
                            appointment.getPatientId());

                    if (patient == null) {
                        System.out.println(
                                "Patient not found for appointment "
                                + appointment.getAppointmentId());
                        continue;
                    }

                    User patientUser = userDAO.getUserById(
                            patient.getUserId());

                    String patientName = patientUser != null
                            ? patientUser.getFullName()
                            : "Patient";

                    confirmedCount++;

                    emailBody.append(confirmedCount)
                            .append(". Appointment ID: ")
                            .append(appointment.getAppointmentId())
                            .append("\n   Patient: ")
                            .append(patientName)
                            .append("\n   Time: ")
                            .append(appointment.getAppointmentTime())
                            .append("\n   Reason: ")
                            .append(appointment.getReason() == null
                                    ? "Not specified"
                                    : appointment.getReason())
                            .append("\n\n");
                }

                // No email is required if there are no confirmed appointments.
                if (confirmedCount == 0) {
                    continue;
                }

                // Skip reminders that have already been sent today.
                if (reminderDAO.isReminderSent(doctorId, today)) {
                    System.out.println(
                            "Reminder already sent for doctor ID: "
                            + doctorId);
                    continue;
                }

                User doctorUser = userDAO.getUserById(
                        doctor.getUserId());

                if (doctorUser == null
                        || doctorUser.getEmail() == null
                        || doctorUser.getEmail().trim().isEmpty()) {

                    System.out.println(
                            "Doctor email not found for doctor ID: "
                            + doctorId);
                    continue;
                }

                String subject =
                        "CareWell Hospital - Today's Confirmed Appointments";

                String body =
                        "Dear " + doctorUser.getFullName() + ",\n\n"
                        + "Here is your appointment summary for "
                        + today + ".\n\n"
                        + "Total confirmed appointments: "
                        + confirmedCount + "\n\n"
                        + emailBody
                        + "Please log in to CareWell Hospital for "
                        + "further details.\n\n"
                        + "Regards,\nCareWell Hospital";

                boolean emailSent = EmailService.sendEmail(
                		TEST_RECIPIENT_EMAIL,
                        subject,
                        body);

                if (emailSent) {
                    reminderDAO.markReminderAsSent(doctorId, today);

                    System.out.println(
                            "Daily reminder sent for doctor ID: "
                            + doctorId);
                }

            } catch (Exception e) {
                System.err.println(
                        "Failed to process reminder for doctor ID: "
                        + doctor.getDoctorId());
                e.printStackTrace();
            }
        }

        System.out.println("Daily appointment reminders completed.");
    }
}
