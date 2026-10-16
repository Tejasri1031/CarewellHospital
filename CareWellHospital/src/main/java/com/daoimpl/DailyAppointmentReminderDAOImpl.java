
package com.daoimpl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.dao.DailyAppointmentReminderDAO;
import com.util.DBConnection;

public class DailyAppointmentReminderDAOImpl
        implements DailyAppointmentReminderDAO {

    @Override
    public boolean isReminderSent(int doctorId, Date reminderDate) {

        String sql = "SELECT reminder_id "
                   + "FROM daily_appointment_reminders "
                   + "WHERE doctor_id = ? AND reminder_date = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, doctorId);
            statement.setDate(2, reminderDate);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(
                    "Failed to check daily reminder status.", e);
        }
    }

    @Override
    public boolean markReminderAsSent(int doctorId, Date reminderDate) {

        String sql = "INSERT INTO daily_appointment_reminders "
                   + "(doctor_id, reminder_date) VALUES (?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, doctorId);
            statement.setDate(2, reminderDate);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(
                    "Failed to record daily reminder status.", e);
        }
    }
}
