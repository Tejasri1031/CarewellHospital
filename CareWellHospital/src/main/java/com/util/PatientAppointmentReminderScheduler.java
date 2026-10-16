
package com.util;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class PatientAppointmentReminderScheduler {

    private static final ZoneId ZONE =
            ZoneId.of("Asia/Kolkata");

    private static final ScheduledExecutorService scheduler =
            Executors.newSingleThreadScheduledExecutor(runnable -> {
                Thread thread = new Thread(
                        runnable,
                        "CareWell-Patient-Reminder");
                thread.setDaemon(true);
                return thread;
            });

    private static boolean started = false;

    public static synchronized void start() {

        if (started) {
            return;
        }

        started = true;
        scheduleNextRun();
    }

    private static void scheduleNextRun() {

        if (scheduler.isShutdown()) {
            return;
        }

        LocalDateTime now = LocalDateTime.now(ZONE);

        LocalDateTime nextRun =
                now.toLocalDate().atTime(18, 0);

        if (!nextRun.isAfter(now)) {
            nextRun = nextRun.plusDays(1);
        }

        long delayMillis = Duration.between(
                now, nextRun).toMillis();

        scheduler.schedule(() -> {
            try {
                new PatientAppointmentReminderService()
                        .sendTomorrowAppointmentReminders();

            } catch (Exception e) {
                System.err.println(
                        "Patient reminder scheduler failed.");
                e.printStackTrace();

            } finally {
                scheduleNextRun();
            }

        }, delayMillis, TimeUnit.MILLISECONDS);

        System.out.println(
                "Next patient reminder scheduled for: "
                + nextRun + " (" + ZONE + ")");
    }

    public static synchronized void stop() {
        started = false;
        scheduler.shutdownNow();
    }
}
