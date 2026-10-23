
package com.util;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppointmentEscalationScheduler
        implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent event) {

        scheduler = Executors.newSingleThreadScheduledExecutor(r -> {
            Thread thread = new Thread(
                    r, "carewell-appointment-escalation");
            thread.setDaemon(true);
            return thread;
        });

        scheduler.scheduleAtFixedRate(() -> {
            System.out.println(
                    "CareWell escalation task triggered at: "
                    + new java.util.Date());

            try {
                new AppointmentEscalationService()
                        .processOverdueAppointments();

            } catch (Throwable e) {
                System.err.println(
                        "CareWell escalation task failed: "
                        + e.getMessage());
                e.printStackTrace();
            }

        }, 1, 60, TimeUnit.MINUTES);

        System.out.println(
                "CareWell appointment escalation scheduler started.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {

        if (scheduler != null) {
            scheduler.shutdownNow();

            System.out.println(
                    "CareWell appointment escalation scheduler stopped.");
        }
    }
}
