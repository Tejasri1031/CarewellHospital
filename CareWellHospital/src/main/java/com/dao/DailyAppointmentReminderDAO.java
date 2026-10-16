
package com.dao;

import java.sql.Date;

public interface DailyAppointmentReminderDAO {

    boolean isReminderSent(int doctorId, Date reminderDate);

    boolean markReminderAsSent(int doctorId, Date reminderDate);
}
