
package com.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AppointmentEscalationService {

    private static final String ADMIN_EMAIL =
            "reethuroyal67@gmail.com";

    public void processOverdueAppointments() {

        String sql =
                "SELECT a.appointment_id, a.patient_id, a.doctor_id, "
              + "a.appointment_date, a.appointment_time, "
              + "a.status, u.full_name, u.email, u.role "
              + "FROM appointments a "
              + "JOIN patients p ON a.patient_id = p.patient_id "
              + "JOIN users u ON p.user_id = u.user_id "
              + "WHERE a.response_due_at <= NOW() "
              + "AND ( "
              + "a.status = 'PENDING' "
              + "OR (a.status = 'CANCELLED' "
              + "AND a.patient_notified_at IS NULL) "
              + ")";

        System.out.println(
                "Appointment escalation service running at: "
                + new java.util.Date()
        );

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                int appointmentId =
                        rs.getInt("appointment_id");

                int patientId = rs.getInt("patient_id");
                int doctorId = rs.getInt("doctor_id");

                String status = rs.getString("status");
                String patientName = rs.getString("full_name");
                String patientEmail = rs.getString("email");
                String role = rs.getString("role");

                String appointmentDate =
                        rs.getDate("appointment_date").toString();

                String appointmentTime =
                        rs.getTime("appointment_time").toString();

                // Process only actual patient accounts.
                if (!"PATIENT".equalsIgnoreCase(role)) {
                    continue;
                }

                // 1. Escalate to admin and cancel overdue appointments.
                if ("PENDING".equalsIgnoreCase(status)) {

                    if (!isNotifiedAdmin(appointmentId)) {

                        String adminSubject =
                                "CareWell: Appointment requires attention";

                        String adminBody =
                                "An appointment has passed its response deadline.\n\n"
                              + "Appointment ID: " + appointmentId + "\n"
                              + "Patient: " + patientName + "\n"
                              + "Patient ID: " + patientId + "\n"
                              + "Doctor ID: " + doctorId + "\n"
                              + "Appointment date: " + appointmentDate + "\n"
                              + "Appointment time: " + appointmentTime + "\n\n"
                              + "The appointment is still pending. "
                              + "Please review the delayed response.";

                        if (EmailService.sendEmail(
                                ADMIN_EMAIL, adminSubject, adminBody)) {

                            markAsEscalated(appointmentId);

                            System.out.println(
                                    "Admin escalation email sent for appointment: "
                                    + appointmentId
                            );
                        }
                    }

                    // Cancel only if it is still pending and overdue.
                    if (!cancelPendingAppointment(appointmentId)) {

                        System.out.println(
                                "Appointment was not cancelled: "
                                + appointmentId
                        );

                        // The status may have changed while processing.
                        continue;
                    }

                    System.out.println(
                            "Appointment automatically cancelled: "
                            + appointmentId
                    );
                }

                // 2. Send or retry the patient cancellation email.
                // This block runs for newly cancelled appointments and
                // previously cancelled appointments awaiting notification.
                if (!isPatientNotified(appointmentId)
                        && patientEmail != null
                        && !patientEmail.trim().isEmpty()) {

                    String patientSubject =
                            "CareWell: Appointment automatically cancelled";

                    String patientBody =
                            "Dear " + patientName + ",\n\n"
                          + "Your CareWell appointment has been "
                          + "automatically cancelled because the doctor "
                          + "did not respond before the response deadline.\n\n"
                          + "Appointment ID: " + appointmentId + "\n"
                          + "Appointment date: " + appointmentDate + "\n"
                          + "Appointment time: " + appointmentTime + "\n\n"
                          + "Please log in to CareWell Hospital to book "
                          + "another appointment or contact the hospital "
                          + "for assistance.\n\n"
                          + "We apologize for the inconvenience.\n\n"
                          + "Regards,\nCareWell Hospital";

                    if (EmailService.sendEmail(
                            patientEmail, patientSubject, patientBody)) {

                        markPatientNotified(appointmentId);

                        System.out.println(
                                "Patient cancellation email sent for appointment: "
                                + appointmentId
                        );
                    } else {
                        System.err.println(
                                "Patient cancellation email failed for appointment: "
                                + appointmentId
                        );
                    }
                }
            }

        } catch (Exception e) {
            System.err.println(
                    "Appointment escalation processing failed."
            );

            System.err.println(
                    "Appointment escalation error: " + e.getMessage()
            );

            e.printStackTrace();
        }
    }

    private boolean isNotifiedAdmin(int appointmentId)
            throws Exception {

        return checkTimestamp(
                "SELECT escalated_at FROM appointments "
              + "WHERE appointment_id = ?",
                appointmentId,
                "escalated_at"
        );
    }

    private boolean isPatientNotified(int appointmentId)
            throws Exception {

        return checkTimestamp(
                "SELECT patient_notified_at FROM appointments "
              + "WHERE appointment_id = ?",
                appointmentId,
                "patient_notified_at"
        );
    }

    private boolean checkTimestamp(
            String sql, int appointmentId, String column)
            throws Exception {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next()
                        && rs.getTimestamp(column) != null;
            }
        }
    }

    private boolean cancelPendingAppointment(int appointmentId)
            throws Exception {

        String sql =
                "UPDATE appointments "
              + "SET status = 'CANCELLED', "
              + "patient_notified_at = NULL "
              + "WHERE appointment_id = ? "
              + "AND status = 'PENDING' "
              + "AND response_due_at <= NOW()";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);

            return ps.executeUpdate() == 1;
        }
    }

    private void markAsEscalated(int appointmentId)
            throws Exception {

        updateTimestamp(appointmentId, "escalated_at");
    }

    private void markPatientNotified(int appointmentId)
            throws Exception {

        updateTimestamp(appointmentId, "patient_notified_at");
    }

    private void updateTimestamp(
            int appointmentId, String column)
            throws Exception {

        String sql =
                "UPDATE appointments SET " + column
              + " = NOW() WHERE appointment_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            ps.executeUpdate();
        }
    }
}
