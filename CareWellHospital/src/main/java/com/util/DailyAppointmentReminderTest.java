
package com.util;

public class DailyAppointmentReminderTest {

    public static void main(String[] args) {

        System.out.println(
                "========== DAILY REMINDER TEST STARTED ==========");

        DailyAppointmentReminderService service =
                new DailyAppointmentReminderService();

        service.sendDailyAppointmentReminders();

        System.out.println(
                "========== DAILY REMINDER TEST FINISHED ==========");
    }
}
