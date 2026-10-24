
package com.util;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Base64;
import java.util.List;

import com.dao.AppointmentDAO;
import com.dao.DoctorDAO;
import com.dao.PatientDAO;
import com.dao.UserDAO;
import com.daoimpl.AppointmentDAOImpl;
import com.daoimpl.DoctorDAOImpl;
import com.daoimpl.PatientAppointmentReminderDAOImpl;
import com.daoimpl.PatientDAOImpl;
import com.daoimpl.UserDAOImpl;
import com.model.Appointment;
import com.model.Doctor;
import com.model.Patient;
import com.model.User;

public class PatientAppointmentReminderService {

	private static final String BASE_URL =
	        "https://carewellhospital.onrender.com"; 
   
    private static final ZoneId ZONE =
            ZoneId.of("Asia/Kolkata");

    private final AppointmentDAO appointmentDAO =
            new AppointmentDAOImpl();

    private final DoctorDAO doctorDAO =
            new DoctorDAOImpl();

    private final PatientDAO patientDAO =
            new PatientDAOImpl();

    private final UserDAO userDAO =
            new UserDAOImpl();

    private final PatientAppointmentReminderDAOImpl reminderDAO =
            new PatientAppointmentReminderDAOImpl();

    private final SecureRandom secureRandom = new SecureRandom();

    public void sendTomorrowAppointmentReminders() {

        LocalDate today = LocalDate.now(ZONE);
        LocalDate tomorrow = today.plusDays(1);

        Date reminderDate = Date.valueOf(today);
        Date appointmentDate = Date.valueOf(tomorrow);

        System.out.println(
                "Starting patient reminders for appointments on "
                + tomorrow);

        List<Appointment> appointments =
                appointmentDAO.getAppointmentsByDate(appointmentDate);

        for (Appointment appointment : appointments) {

            try {

                if (!"CONFIRMED".equalsIgnoreCase(
                        appointment.getStatus())) {
                    continue;
                }

                int appointmentId = appointment.getAppointmentId();

                if (reminderDAO.isReminderSent(
                        appointmentId, reminderDate)) {
                    System.out.println(
                            "Patient reminder already sent for appointment "
                            + appointmentId);
                    continue;
                }

                Patient patient = patientDAO.getPatientById(
                        appointment.getPatientId());

                if (patient == null) {
                    System.out.println(
                            "Patient not found for appointment "
                            + appointmentId);
                    continue;
                }

                User patientUser = userDAO.getUserById(
                        patient.getUserId());

                if (patientUser == null) {
                    System.out.println(
                            "Patient user not found for appointment "
                            + appointmentId);
                    continue;
                }

                Doctor doctor = doctorDAO.getDoctorById(
                        appointment.getDoctorId());

                if (doctor == null) {
                    System.out.println(
                            "Doctor not found for appointment "
                            + appointmentId);
                    continue;
                }

                User doctorUser = userDAO.getUserById(
                        doctor.getUserId());

                String doctorName = doctorUser != null
                        ? doctorUser.getFullName()
                        : "your doctor";

                String rawToken = generateToken();
                String tokenHash = sha256(rawToken);

                Timestamp tokenExpiry = Timestamp.valueOf(
                        LocalDateTime.now(ZONE).plusDays(2));


boolean saved;

if (reminderDAO.isReminderSent(
        appointmentId, reminderDate)) {

    System.out.println(
            "Patient reminder already sent for appointment "
            + appointmentId);
    continue;
}

saved = reminderDAO.updateReminderToken(
        appointmentId,
        reminderDate,
        tokenHash,
        tokenExpiry);

if (!saved) {
    saved = reminderDAO.saveReminder(
            appointmentId,
            reminderDate,
            tokenHash,
            tokenExpiry);
}

if (!saved) {
    System.out.println(
            "Could not save reminder for appointment "
            + appointmentId);
    continue;
}


                String confirmUrl = BASE_URL
                        + "/patient-appointment-response"
                        + "?appointmentId=" + appointmentId
                        + "&token=" + rawToken
                        + "&response=CONFIRMED";

                String cancelUrl = BASE_URL
                        + "/patient-appointment-response"
                        + "?appointmentId=" + appointmentId
                        + "&token=" + rawToken
                        + "&response=CANCELLATION_REQUESTED";

                String subject =
                        "CareWell Hospital - Your Appointment Is Tomorrow";

                String body =
                        "Dear " + patientUser.getFullName() + ",\n\n"
                        + "This is a reminder that your appointment "
                        + "is scheduled for tomorrow.\n\n"
                        + "Doctor: " + doctorName + "\n"
                        + "Date: " + appointment.getAppointmentDate() + "\n"
                        + "Time: " + appointment.getAppointmentTime() + "\n"
                        + "Reason: "
                        + (appointment.getReason() == null
                                ? "Not specified"
                                : appointment.getReason())
                        + "\n\n"
                        + "To confirm attendance, open this link:\n"
                        + confirmUrl + "\n\n"
                        + "To request cancellation, open this link:\n"
                        + cancelUrl + "\n\n"
                        + "These links expire in two days. "
                        + "A cancellation request may require hospital review.\n\n"
                        + "Regards,\nCareWell Hospital";

                String patientEmail = patientUser.getEmail();

                if (patientEmail == null || patientEmail.trim().isEmpty()) {
                    System.err.println(
                            "Patient email is missing for appointment "
                            + appointmentId);
                    continue;
                }

                boolean emailSent = EmailService.sendEmail(
                        patientEmail.trim(),
                        subject,
                        body);
                
                if (emailSent) {

                    reminderDAO.recordEmailSent(
                            appointmentId, reminderDate);

                    System.out.println(
                            "Patient reminder sent for appointment "
                            + appointmentId);

                } else {
                    System.out.println(
                            "Email sending failed for appointment "
                            + appointmentId);
                }

            } catch (Exception e) {
                System.err.println(
                        "Failed to process patient reminder for appointment "
                        + appointment.getAppointmentId());
                e.printStackTrace();
            }
        }

        System.out.println("Patient reminder processing completed.");
    }

    private String generateToken() {

        byte[] tokenBytes = new byte[32];
        secureRandom.nextBytes(tokenBytes);

        return Base64.getUrlEncoder()
                .withoutPadding()
                .encodeToString(tokenBytes);
    }

    private String sha256(String value) throws Exception {

        MessageDigest digest =
                MessageDigest.getInstance("SHA-256");

        byte[] hash = digest.digest(
                value.getBytes(java.nio.charset.StandardCharsets.UTF_8));

        StringBuilder result = new StringBuilder();

        for (byte b : hash) {
            result.append(String.format("%02x", b));
        }

        return result.toString();
    }
}
