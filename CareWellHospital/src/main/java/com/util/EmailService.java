
package com.util;

import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailService {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";

    private static final String SENDER_EMAIL =
            System.getenv("CAREWELL_EMAIL");

    private static final String SENDER_APP_PASSWORD =
            System.getenv("CAREWELL_APP_PASSWORD");
    
    public static boolean sendEmail(
            String recipientEmail,
            String subject,
            String body) {

        if (SENDER_EMAIL == null || SENDER_EMAIL.isBlank()
                || SENDER_APP_PASSWORD == null
                || SENDER_APP_PASSWORD.isBlank()) {

        	System.err.println(
        	        "Email configuration error: CAREWELL_EMAIL or "
        	        + "CAREWELL_APP_PASSWORD is missing.");
        	
            return false;
        }

        try {
            Properties properties = new Properties();

            properties.put("mail.smtp.auth", "true");
            properties.put("mail.smtp.starttls.enable", "true");
            properties.put("mail.smtp.host", SMTP_HOST);
            properties.put("mail.smtp.port", SMTP_PORT);

            Session session = Session.getInstance(
                    properties,
                    new Authenticator() {
                        @Override
                        protected PasswordAuthentication
                                getPasswordAuthentication() {

                            return new PasswordAuthentication(
                                    SENDER_EMAIL,
                                    SENDER_APP_PASSWORD);
                        }
                    });

            Message message = new MimeMessage(session);

            message.setFrom(new InternetAddress(
                    SENDER_EMAIL,
                    "CareWell Hospital"));

            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(recipientEmail));

            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);

            System.out.println(
                    "Email sent successfully to: "
                    + recipientEmail);

            return true;

        } catch (Exception e) {
            System.err.println("Email sending failed.");
            e.printStackTrace();
            return false;
        }
    }
}
