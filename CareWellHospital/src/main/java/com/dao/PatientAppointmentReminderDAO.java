
package com.dao;

import java.sql.Date;

public interface PatientAppointmentReminderDAO {

    boolean isReminderSent(int appointmentId, Date reminderDate);

    boolean saveReminder(
            int appointmentId,
            Date reminderDate,
            String responseTokenHash,
            java.sql.Timestamp tokenExpiresAt);

    boolean recordEmailSent(int appointmentId, Date reminderDate);

    boolean recordPatientResponse(
            int appointmentId,
            String responseTokenHash,
            String patientResponse);

boolean updateReminderToken(
        int appointmentId,
        Date reminderDate,
        String responseTokenHash,
        java.sql.Timestamp tokenExpiresAt);

}
