
package com.util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppStartupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent event) {

        System.out.println(
                "CareWell Hospital application started.");

        DailyAppointmentReminderScheduler.start();

        // Start patient appointment reminders
        PatientAppointmentReminderScheduler.start();
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {

        System.out.println(
                "CareWell Hospital application is stopping.");

        DailyAppointmentReminderScheduler.stop();

        // Stop patient appointment reminders
        PatientAppointmentReminderScheduler.stop();
    }
}
