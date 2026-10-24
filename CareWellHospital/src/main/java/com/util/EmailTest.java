
package com.util;

public class EmailTest {

    public static void main(String[] args) {

        String email = System.getenv("CAREWELL_EMAIL");
        String password = System.getenv("CAREWELL_APP_PASSWORD");

        if (email == null || email.isBlank()
                || password == null || password.isBlank()) {
            System.out.println("Email credentials are missing.");
            System.out.println(
                    "Check CAREWELL_EMAIL and CAREWELL_APP_PASSWORD.");
            return;
        }

        boolean sent = EmailService.sendEmail(
                email,
                "CareWell Hospital - Email Test",
                "Hello! This is a test email from CareWell Hospital. "
                        + "Your email service is configured."
        );

        if (sent) {
            System.out.println(
                    "TEST PASSED: Email accepted by the SMTP service.");
        } else {
            System.out.println(
                    "TEST FAILED: Check the Console for the actual error.");
        }
    }
}
