
package com.util;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

public class EmailService {

    private static final String BREVO_API_URL =
            "https://api.brevo.com/v3/smtp/email";

    private static final String SENDER_EMAIL =
            System.getenv("CAREWELL_EMAIL");

    private static final String BREVO_API_KEY =
            System.getenv("BREVO_API_KEY");

    private static final HttpClient HTTP_CLIENT =
            HttpClient.newBuilder()
                    .connectTimeout(Duration.ofSeconds(15))
                    .build();

    public static boolean sendEmail(
            String recipientEmail,
            String subject,
            String body) {

        if (BREVO_API_KEY == null || BREVO_API_KEY.isBlank()
                || SENDER_EMAIL == null || SENDER_EMAIL.isBlank()) {

            System.err.println(
                    "Email configuration error: BREVO_API_KEY "
                    + "or CAREWELL_EMAIL is missing.");
            return false;
        }

        if (recipientEmail == null || recipientEmail.isBlank()) {
            System.err.println(
                    "Email sending skipped: recipient email is missing.");
            return false;
        }

        if (subject == null || body == null) {
            System.err.println(
                    "Email sending skipped: subject or body is missing.");
            return false;
        }

        try {
            String jsonBody =
                    "{"
                    + "\"sender\":{"
                    + "\"name\":\"CareWell Hospital\","
                    + "\"email\":\"" + jsonEscape(SENDER_EMAIL) + "\""
                    + "},"
                    + "\"to\":[{"
                    + "\"email\":\"" + jsonEscape(recipientEmail) + "\""
                    + "}],"
                    + "\"subject\":\"" + jsonEscape(subject) + "\","
                    + "\"textContent\":\"" + jsonEscape(body) + "\""
                    + "}";

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(BREVO_API_URL))
                    .timeout(Duration.ofSeconds(30))
                    .header("accept", "application/json")
                    .header("api-key", BREVO_API_KEY)
                    .header("content-type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(jsonBody))
                    .build();

            HttpResponse<String> response = HTTP_CLIENT.send(
                    request,
                    HttpResponse.BodyHandlers.ofString());

            int statusCode = response.statusCode();

            if (statusCode == 201) {
                System.out.println(
                        "Email accepted by Brevo for recipient: "
                        + recipientEmail);
                return true;
            }

            System.err.println(
                    "Brevo email request failed. HTTP status: "
                    + statusCode);
            System.err.println("Brevo response: " + response.body());
            return false;

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            System.err.println("Brevo email request was interrupted.");
            return false;

        } catch (IOException | IllegalArgumentException e) {
            System.err.println("Brevo email request failed.");
            System.err.println(
                    "Failure type: " + e.getClass().getName());
            System.err.println(
                    "Failure message: " + e.getMessage());
            return false;
        }
    }

    private static String jsonEscape(String value) {
        StringBuilder escaped = new StringBuilder();

        for (int i = 0; i < value.length(); i++) {
            char c = value.charAt(i);

            switch (c) {
                case '"':
                    escaped.append("\\\"");
                    break;
                case '\\':
                    escaped.append("\\\\");
                    break;
                case '\b':
                    escaped.append("\\b");
                    break;
                case '\f':
                    escaped.append("\\f");
                    break;
                case '\n':
                    escaped.append("\\n");
                    break;
                case '\r':
                    escaped.append("\\r");
                    break;
                case '\t':
                    escaped.append("\\t");
                    break;
                default:
                    if (c < 0x20) {
                        escaped.append(
                                String.format("\\u%04x", (int) c));
                    } else {
                        escaped.append(c);
                    }
            }
        }

        return escaped.toString();
    }
}
