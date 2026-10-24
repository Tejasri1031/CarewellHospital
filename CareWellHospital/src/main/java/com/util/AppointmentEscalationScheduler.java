
package com.util;

import java.time.Duration;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppointmentEscalationScheduler
        implements ServletContextListener {

    private static final ZoneId INDIA_ZONE =
            ZoneId.of("Asia/Kolkata");

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent event) {

        scheduler = Executors.newSingleThreadScheduledExecutor(r -> {
            Thread thread = new Thread(
                    r, "carewell-appointment-escalation");
            thread.setDaemon(true);
            return thread;
        });

        // Check overdue appointments immediately after startup.
        scheduler.execute(this::runEscalationSafely);

        // Schedule the regular daily check for 6:00 PM India time.
        ZonedDateTime now = ZonedDateTime.now(INDIA_ZONE);

        ZonedDateTime nextRun = now.toLocalDate()
                .atTime(18, 0)
                .atZone(INDIA_ZONE);

        if (!nextRun.isAfter(now)) {
            nextRun = nextRun.plusDays(1);
        }

        long initialDelaySeconds =
                Duration.between(now, nextRun).getSeconds();

        long dailyIntervalSeconds = Duration.ofDays(1).getSeconds();

        scheduler.scheduleAtFixedRate(
                this::runEscalationSafely,
                initialDelaySeconds,
                dailyIntervalSeconds,
                TimeUnit.SECONDS);

        System.out.println(
                "CareWell appointment escalation scheduler started.");

        System.out.println(
                "Next cancellation check scheduled for: " + nextRun);
    }

    private void runEscalationSafely() {

        System.out.println(
                "CareWell escalation task triggered at: "
                + ZonedDateTime.now(INDIA_ZONE));

        try {
            new AppointmentEscalationService()
                    .processOverdueAppointments();

        } catch (Exception e) {
            System.err.println(
                    "CareWell escalation task failed: "
                    + e.getMessage());
            e.printStackTrace();
        }
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
