
package com.util;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AppointmentEscalationService {

    // Test recipient for both admin and patient emails.
    private static final String TEST_EMAIL =
            "reethuroyal67@gmail.com";

    public void processOverdueAppointments() {

        String sql =
                "SELECT a.appointment_id, a.patient_id, a.doctor_id, "
              + "a.appointment_date, a.appointment_time, "
              + "a.status, u.full_name, u.role "
              + "FROM appointments a "
              + "JOIN patients p ON a.patient_id = p.patient_id "
              + "JOIN users u ON p.user_id = u.user_id "
              + "WHERE a.response_due_at <= NOW() "
              + "AND (a.status = 'PENDING' "
              + "OR (a.status = 'CANCELLED' "
              + "AND a.patient_notified_at IS NULL))";

        System.out.println(
                "Appointment escalation service running at: "
                + new java.util.Date());

        int foundCount = 0;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            System.out.println(
                    "DEBUG: Database = " + con.getCatalog());
            try (PreparedStatement debugPs = con.prepareStatement(
                    "SELECT appointment_id, status, response_due_at, "
                  + "patient_notified_at, NOW() AS db_now "
                  + "FROM appointments WHERE appointment_id = 23");
                 ResultSet debugRs = debugPs.executeQuery()) {

                if (debugRs.next()) {
                    System.out.println(
                            "DEBUG appointment 23: status="
                            + debugRs.getString("status")
                            + ", deadline="
                            + debugRs.getTimestamp("response_due_at")
                            + ", dbNow="
                            + debugRs.getTimestamp("db_now")
                            + ", notified="
                            + debugRs.getTimestamp("patient_notified_at"));
                } else {
                    System.out.println(
                            "DEBUG: Appointment 23 does not exist "
                            + "in this application's database.");
                }
            }

            System.out.println(
                    "DEBUG: Running overdue appointment query.");

            try (ResultSet rs = ps.executeQuery()) {

                System.out.println(
                        "DEBUG: Query executed. Checking results.");

                while (rs.next()) {

                    foundCount++;

                    int appointmentId =
                            rs.getInt("appointment_id");

                    System.out.println(
                            "DEBUG: Overdue appointment found: "
                            + appointmentId);

                    int patientId = rs.getInt("patient_id");
                    int doctorId = rs.getInt("doctor_id");

                    String status = rs.getString("status");
                    String patientName = rs.getString("full_name");
                    String role = rs.getString("role");

                    String appointmentDate =
                            rs.getDate("appointment_date").toString();

                    String appointmentTime =
                            rs.getTime("appointment_time").toString();

                    if (!"PATIENT".equalsIgnoreCase(role)) {
                        System.out.println(
                                "Skipping appointment " + appointmentId
                                + ": linked account role is " + role);
                        continue;
                    }

                    // 1. Escalate pending appointments to the test admin inbox.
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
                                  + "The appointment is awaiting a doctor response.";

                            if (EmailService.sendEmail(
                                    TEST_EMAIL, adminSubject, adminBody)) {

                                markAsEscalated(appointmentId);

                                System.out.println(
                                        "Admin escalation email sent for appointment: "
                                        + appointmentId);
                            } else {
                                System.err.println(
                                        "Admin escalation email failed for appointment: "
                                        + appointmentId);
                            }
                        }

                        // Cancel only if it is still pending and overdue.
                        if (!cancelPendingAppointment(appointmentId)) {

                            System.out.println(
                                    "Appointment was not cancelled: "
                                    + appointmentId);

                            continue;
                        }

                        System.out.println(
                                "Appointment automatically cancelled: "
                                + appointmentId);
                    }

                    // 2. Notify the patient, or retry a failed notification.
                    if (!isPatientNotified(appointmentId)) {

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
                                TEST_EMAIL, patientSubject, patientBody)) {

                            markPatientNotified(appointmentId);

                            System.out.println(
                                    "Patient cancellation email sent for appointment: "
                                    + appointmentId);
                        } else {
                            System.err.println(
                                    "Patient cancellation email failed for appointment: "
                                    + appointmentId);
                        }
                    }
                }
            }

            System.out.println(
                    "DEBUG: Total overdue appointments found: "
                    + foundCount);

        } catch (Exception e) {
            System.err.println(
                    "Appointment escalation processing failed.");

            e.printStackTrace();
        }

        System.out.println(
                "Appointment escalation processing completed.");
    }

    private boolean isNotifiedAdmin(int appointmentId)
            throws Exception {

        return checkTimestamp(
                "SELECT escalated_at FROM appointments "
              + "WHERE appointment_id = ?",
                appointmentId,
                "escalated_at");
    }

    private boolean isPatientNotified(int appointmentId)
            throws Exception {

        return checkTimestamp(
                "SELECT patient_notified_at FROM appointments "
              + "WHERE appointment_id = ?",
                appointmentId,
                "patient_notified_at");
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

            int rowsUpdated = ps.executeUpdate();

            System.out.println(
                    "DEBUG: Cancellation update affected "
                    + rowsUpdated + " row(s) for appointment "
                    + appointmentId);

            return rowsUpdated == 1;
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

        if (!"escalated_at".equals(column)
                && !"patient_notified_at".equals(column)) {

            throw new IllegalArgumentException(
                    "Invalid timestamp column.");
        }

        String sql =
                "UPDATE appointments SET " + column
              + " = NOW() WHERE appointment_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);

            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated != 1) {
                throw new SQLException(
                        "Expected to update one row for appointment "
                        + appointmentId + ", but updated "
                        + rowsUpdated + " rows.");
            }

            System.out.println(
                    "DEBUG: Updated " + column
                    + " for appointment " + appointmentId);
        }
    }
}
