
package com.daoimpl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

import com.dao.PatientAppointmentReminderDAO;
import com.util.DBConnection;

public class PatientAppointmentReminderDAOImpl
        implements PatientAppointmentReminderDAO {

    @Override
    public boolean isReminderSent(
            int appointmentId, Date reminderDate) {

        String sql = "SELECT reminder_id "
                + "FROM patient_appointment_reminders "
                + "WHERE appointment_id = ? "
                + "AND reminder_date = ? "
                + "AND email_sent_at IS NOT NULL";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, appointmentId);
            statement.setDate(2, reminderDate);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(
                    "Failed to check patient reminder status.", e);
        }
    }

    @Override
    public boolean saveReminder(
            int appointmentId,
            Date reminderDate,
            String responseTokenHash,
            Timestamp tokenExpiresAt) {

        String sql = "INSERT INTO patient_appointment_reminders "
                + "(appointment_id, reminder_date, "
                + "response_token_hash, token_expires_at) "
                + "VALUES (?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, appointmentId);
            statement.setDate(2, reminderDate);
            statement.setString(3, responseTokenHash);
            statement.setTimestamp(4, tokenExpiresAt);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(
                    "Failed to save patient reminder.", e);
        }
    }

    @Override
    public boolean recordEmailSent(
            int appointmentId, Date reminderDate) {

        String sql = "UPDATE patient_appointment_reminders "
                + "SET email_sent_at = CURRENT_TIMESTAMP "
                + "WHERE appointment_id = ? "
                + "AND reminder_date = ? "
                + "AND email_sent_at IS NULL";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, appointmentId);
            statement.setDate(2, reminderDate);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(
                    "Failed to record patient reminder email.", e);
        }
    }

    @Override
    public boolean recordPatientResponse(
            int appointmentId,
            String responseTokenHash,
            String patientResponse) {

        if (!"CONFIRMED".equals(patientResponse)
                && !"CANCELLATION_REQUESTED".equals(patientResponse)) {
            throw new IllegalArgumentException(
                    "Invalid patient response.");
        }

        String sql = "UPDATE patient_appointment_reminders "
                + "SET patient_response = ?, "
                + "responded_at = CURRENT_TIMESTAMP "
                + "WHERE appointment_id = ? "
                + "AND response_token_hash = ? "
                + "AND token_expires_at > CURRENT_TIMESTAMP "
                + "AND email_sent_at IS NOT NULL "
                + "AND patient_response = 'PENDING'";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, patientResponse);
            statement.setInt(2, appointmentId);
            statement.setString(3, responseTokenHash);

            return statement.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(
                    "Failed to record patient response.", e);
        }
    }

@Override
public boolean updateReminderToken(
        int appointmentId,
        Date reminderDate,
        String responseTokenHash,
        Timestamp tokenExpiresAt) {

    String sql = "UPDATE patient_appointment_reminders "
            + "SET response_token_hash = ?, token_expires_at = ? "
            + "WHERE appointment_id = ? "
            + "AND reminder_date = ? "
            + "AND email_sent_at IS NULL";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement statement =
                 connection.prepareStatement(sql)) {

        statement.setString(1, responseTokenHash);
        statement.setTimestamp(2, tokenExpiresAt);
        statement.setInt(3, appointmentId);
        statement.setDate(4, reminderDate);

        return statement.executeUpdate() > 0;

    } catch (SQLException e) {
        e.printStackTrace();
        throw new RuntimeException(
                "Failed to update patient reminder token.", e);
    }
}


}
