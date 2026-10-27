
package com.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import com.dao.NotificationDAO;
import com.model.Notification;
import com.util.DBConnection;

public class NotificationDAOImpl implements NotificationDAO {

    @Override
    public boolean addNotification(Notification notification) {

        String sql =
                "INSERT INTO notifications "
                + "(user_id, appointment_id, notification_type, "
                + "title, message, is_read) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, notification.getUserId());

            if (notification.getAppointmentId() != null) {
                statement.setInt(2, notification.getAppointmentId());
            } else {
                statement.setNull(2, Types.INTEGER);
            }

            statement.setString(
                    3, notification.getNotificationType());
            statement.setString(4, notification.getTitle());
            statement.setString(5, notification.getMessage());
            statement.setBoolean(6, notification.isRead());

            return statement.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Notification> getNotificationsByUser(int userId) {

        String sql =
                "SELECT * FROM notifications "
                + "WHERE user_id = ? "
                + "ORDER BY created_at DESC";

        List<Notification> notifications = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    notifications.add(mapNotification(resultSet));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return notifications;
    }

    @Override
    public List<Notification> getUnreadNotificationsByUser(int userId) {

        String sql =
                "SELECT * FROM notifications "
                + "WHERE user_id = ? "
                + "AND is_read = FALSE "
                + "ORDER BY created_at DESC";

        List<Notification> notifications = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    notifications.add(mapNotification(resultSet));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return notifications;
    }

    @Override
    public int getUnreadNotificationCount(int userId) {

        String sql =
                "SELECT COUNT(*) FROM notifications "
                + "WHERE user_id = ? AND is_read = FALSE";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    /*
     * Marks one notification as read only if it belongs
     * to the specified user.
     */
    public boolean markAsRead(int notificationId, int userId) {

        String sql =
                "UPDATE notifications "
                + "SET is_read = TRUE "
                + "WHERE notification_id = ? AND user_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, notificationId);
            statement.setInt(2, userId);

            return statement.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /*
     * Marks all notifications belonging to this user as read.
     */
    @Override
    public boolean markAllAsRead(int userId) {

        String sql =
                "UPDATE notifications "
                + "SET is_read = TRUE "
                + "WHERE user_id = ? AND is_read = FALSE";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, userId);
            statement.executeUpdate();

            // Success even when there were no unread rows.
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteNotification(int notificationId) {

        String sql =
                "DELETE FROM notifications "
                + "WHERE notification_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, notificationId);

            return statement.executeUpdate() == 1;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private Notification mapNotification(ResultSet resultSet)
            throws Exception {

        Notification notification = new Notification();

        notification.setNotificationId(
                resultSet.getInt("notification_id"));

        notification.setUserId(
                resultSet.getInt("user_id"));

        int appointmentId = resultSet.getInt("appointment_id");

        if (resultSet.wasNull()) {
            notification.setAppointmentId(null);
        } else {
            notification.setAppointmentId(appointmentId);
        }

        notification.setNotificationType(
                resultSet.getString("notification_type"));

        notification.setTitle(
                resultSet.getString("title"));

        notification.setMessage(
                resultSet.getString("message"));

        notification.setRead(
                resultSet.getBoolean("is_read"));

        notification.setCreatedAt(
                resultSet.getTimestamp("created_at"));

        return notification;
    }
}
