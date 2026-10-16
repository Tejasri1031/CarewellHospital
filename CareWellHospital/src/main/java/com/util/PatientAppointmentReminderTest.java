
package com.util;

public class PatientAppointmentReminderTest {

    public static void main(String[] args) {

        PatientAppointmentReminderService service =
                new PatientAppointmentReminderService();

        service.sendTomorrowAppointmentReminders();
    }
}
