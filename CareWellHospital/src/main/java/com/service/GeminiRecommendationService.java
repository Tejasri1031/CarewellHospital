
package com.service;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

public class GeminiRecommendationService {

    private static final String API_KEY =
            System.getenv("GEMINI_API_KEY");

    private static final String MODEL = getModelName();

    private static final String API_URL =
            "https://generativelanguage.googleapis.com/v1beta/models/"
            + MODEL + ":generateContent";

    private final HttpClient httpClient;
    private final Gson gson;

    public GeminiRecommendationService() {

        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(20))
                .build();

        this.gson = new Gson();
        
        System.out.println("Gemini API Key loaded: " +
                (API_KEY != null && !API_KEY.isBlank()));
    }

    private static String getModelName() {

        String model = System.getenv("GEMINI_MODEL");

        if (model == null || model.trim().isEmpty()) {
            return "gemini-3.8-flash";
        }

        return model.trim();
    }

    public DepartmentRecommendation recommendDepartment(
            String symptoms,
            List<String> availableDepartments)
            throws IOException, InterruptedException {

        if (API_KEY == null || API_KEY.trim().isEmpty()) {
            throw new IllegalStateException(
                    "GEMINI_API_KEY environment variable is not configured.");
        }

        if (symptoms == null || symptoms.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Symptoms cannot be empty.");
        }

        if (availableDepartments == null
                || availableDepartments.isEmpty()) {
            throw new IllegalArgumentException(
                    "No hospital departments are available.");
        }

        String prompt =
                "You assist patients with hospital department navigation. "
                + "You are not a doctor. Do not diagnose diseases or "
                + "recommend medicines.\n\n"
                + "Patient symptoms:\n"
                + symptoms.trim() + "\n\n"
                + "Available hospital departments:\n"
                + gson.toJson(availableDepartments) + "\n\n"
                + "Select the most relevant department from the supplied "
                + "list. Use its exact name. Briefly explain the reason.\n"
                + "If no department can reasonably be suggested, return "
                + "an empty departmentName.\n"
                + "If symptoms indicate a possible emergency, set "
                + "emergency to true.\n"
                + "Never invent a department.\n\n"
                + "Return only JSON in this format:\n"
                + "{"
                + "\"departmentName\":\"\","
                + "\"reason\":\"\","
                + "\"emergency\":false"
                + "}";

        JsonObject requestBody = new JsonObject();

        JsonArray contents = new JsonArray();
        JsonObject content = new JsonObject();
        JsonArray parts = new JsonArray();
        JsonObject part = new JsonObject();

        part.addProperty("text", prompt);

        parts.add(part);
        content.add("parts", parts);
        contents.add(content);

        requestBody.add("contents", contents);

        JsonObject generationConfig = new JsonObject();

        generationConfig.addProperty(
                "responseMimeType", "application/json");
        generationConfig.addProperty("temperature", 0.2);
        generationConfig.addProperty("maxOutputTokens", 300);

        requestBody.add("generationConfig", generationConfig);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(API_URL))
                .timeout(Duration.ofSeconds(120))
                .header("Content-Type", "application/json")
                .header("x-goog-api-key", API_KEY)
                .POST(HttpRequest.BodyPublishers.ofString(
                        gson.toJson(requestBody)))
                .build();

        
        HttpResponse<String> response = null;

        int maxAttempts = 3;

        for (int attempt = 1; attempt <= maxAttempts; attempt++) {

            try {
                System.out.println(
                        "Sending Gemini request. Attempt: " + attempt);

                response = httpClient.send(
                        request,
                        HttpResponse.BodyHandlers.ofString());

                if (response.statusCode() == 200) {
                    break;
                }

                if ((response.statusCode() == 503
                        || response.statusCode() == 429
                        || response.statusCode() >= 500)
                        && attempt < maxAttempts) {

                    System.out.println(
                            "Gemini returned HTTP "
                            + response.statusCode()
                            + ". Retrying...");
                } else {
                    break;
                }

            } catch (java.net.http.HttpTimeoutException e) {

                System.out.println(
                        "Gemini request timed out on attempt " + attempt);

                if (attempt == maxAttempts) {
                    throw e;
                }
            }

            long waitTime = 2000L * attempt;

            System.out.println(
                    "Waiting " + waitTime / 1000
                    + " seconds before retry...");

            Thread.sleep(waitTime);
        }
        
        if (response.statusCode() != 200) {
            throw new IOException(
                    "Gemini API request failed. HTTP status: "
                    + response.statusCode()
                    + ". Response: " + response.body());
        }

        JsonObject responseJson =
                JsonParser.parseString(response.body())
                        .getAsJsonObject();

        JsonArray candidates =
                responseJson.getAsJsonArray("candidates");

        if (candidates == null || candidates.size() == 0) {
            throw new IOException(
                    "Gemini returned no recommendation.");
        }

        JsonObject candidate =
                candidates.get(0).getAsJsonObject();

        JsonObject responseContent =
                candidate.getAsJsonObject("content");

        if (responseContent == null
                || !responseContent.has("parts")) {
            throw new IOException(
                    "Gemini returned an invalid response.");
        }

        JsonArray responseParts =
                responseContent.getAsJsonArray("parts");

        if (responseParts.size() == 0
                || !responseParts.get(0).getAsJsonObject()
                        .has("text")) {
            throw new IOException(
                    "Gemini returned an empty response.");
        }

        String responseText = responseParts.get(0)
                .getAsJsonObject()
                .get("text")
                .getAsString();

        System.out.println("Gemini raw response text: " + responseText);
        JsonObject recommendationJson;

        try {
            recommendationJson =
                    JsonParser.parseString(responseText)
                            .getAsJsonObject();
        } catch (Exception e) {
            throw new IOException(
                    "Gemini returned invalid recommendation JSON.", e);
        }

        String departmentName =
                recommendationJson.has("departmentName")
                ? recommendationJson.get("departmentName").getAsString()
                : "";

        String reason =
                recommendationJson.has("reason")
                ? recommendationJson.get("reason").getAsString()
                : "";

        boolean emergency =
                recommendationJson.has("emergency")
                && recommendationJson.get("emergency").getAsBoolean();

        // Validate department against the actual hospital list.
        String matchedDepartment = "";

        for (String department : availableDepartments) {

            if (department.equalsIgnoreCase(departmentName)) {
                matchedDepartment = department;
                break;
            }
        }

        departmentName = matchedDepartment;

        return new DepartmentRecommendation(
                departmentName, reason, emergency);
    }

    public static class DepartmentRecommendation {

        private final String departmentName;
        private final String reason;
        private final boolean emergency;

        public DepartmentRecommendation(
                String departmentName,
                String reason,
                boolean emergency) {

            this.departmentName = departmentName;
            this.reason = reason;
            this.emergency = emergency;
        }

        public String getDepartmentName() {
            return departmentName;
        }

        public String getReason() {
            return reason;
        }

        public boolean isEmergency() {
            return emergency;
        }
    }
}
