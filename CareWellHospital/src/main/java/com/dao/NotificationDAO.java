package com.dao;

import java.util.List;

import com.model.Notification;

public interface NotificationDAO {

    boolean addNotification(Notification notification);

    List<Notification> getNotificationsByUser(int userId);

    List<Notification> getUnreadNotificationsByUser(int userId);

    int getUnreadNotificationCount(int userId);

    boolean markAsRead(int notificationId, int userId);

    boolean markAllAsRead(int userId);

    boolean deleteNotification(int notificationId);
}