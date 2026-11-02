package com.service;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

import java.util.List;
import java.util.Map;

public class AIChatService {

	private static final String OLLAMA_URL =
	        System.getenv().getOrDefault(
	            "OLLAMA_URL",
	            "http://localhost:11434/api/chat"
	        );

    private static final String MODEL =
            "llama3.2:1b";
    
    private static final String SYSTEM_PROMPT =
            "You are CareWell Hospital's AI Medicine Assistant. "
          + "You help patients understand existing prescriptions "
          + "and general medicine information. "
          + "Use simple, clear English. "
          + "Never prescribe medicines or independently recommend "
          + "dosages, frequencies, or treatment durations. "
          + "Never invent missing prescription instructions. "
          + "Explain only information supported by reliable medicine "
          + "instructions. Ask for clarification when information is missing. "
          + "If a patient may have overdosed or has severe symptoms, "
          + "direct them to urgent medical care. "
          + "Do not assume every medicine should be taken after food. "
          + "Explain that food instructions depend on the specific medicine. "
          + "You are an informational assistant, not a replacement for a doctor.";

    private final HttpClient httpClient =
            HttpClient.newBuilder()
                    .connectTimeout(Duration.ofSeconds(20))
                    .build();

    public String getAIResponse(
            String userMessage,
            List<Map<String, String>> conversationHistory)
            throws IOException, InterruptedException {

        if (userMessage == null || userMessage.isBlank()) {
            throw new IllegalArgumentException(
                    "Message cannot be empty.");
        }
        
        String safetyResponse = checkMedicalSafety(userMessage);

        if (safetyResponse != null) {
            return safetyResponse;
        }

        String safeMessage = escapeJson(userMessage);

        StringBuilder json = new StringBuilder();

        json.append("{")
            .append("\"model\":\"").append(MODEL).append("\",")
            .append("\"stream\":false,")
            .append("\"messages\":[");

        // Add system instructions first
        json.append("{")
            .append("\"role\":\"system\",")
            .append("\"content\":\"")
            .append(escapeJson(SYSTEM_PROMPT))
            .append("\"")
            .append("},");

        // Add previous conversation messages
        if (conversationHistory != null) {

            for (Map<String, String> chat : conversationHistory) {

                String role = chat.get("role");
                String content = chat.get("content");

                if (role == null || content == null) {
                    continue;
                }

                if (!role.equals("user") && !role.equals("assistant")) {
                    continue;
                }

                json.append("{")
                    .append("\"role\":\"").append(role).append("\",")
                    .append("\"content\":\"")
                    .append(escapeJson(content))
                    .append("\"")
                    .append("},");
            }
        }

        // Add the current patient message
        json.append("{")
            .append("\"role\":\"user\",")
            .append("\"content\":\"")
            .append(escapeJson(userMessage))
            .append("\"")
            .append("}")
            .append("]")
            .append("}");

        String jsonRequest = json.toString();
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(OLLAMA_URL))
                .header("Content-Type", "application/json")
                .timeout(Duration.ofSeconds(180))
                .POST(HttpRequest.BodyPublishers.ofString(jsonRequest))
                .build();

        HttpResponse<String> response =
                httpClient.send(
                        request,
                        HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() != 200) {
            throw new IOException(
                    "Ollama API error: " + response.body());
        }

        return extractResponseContent(response.body());
    }
    
    private String checkMedicalSafety(String message) {

        String text = message.toLowerCase();

        String[] emergencyKeywords = {
            "overdose",
            "took too many",
            "taken too many",
            "extra dose",
            "took extra medicine",
            "difficulty breathing",
            "cannot breathe",
            "unconscious",
            "seizure",
            "severe allergic reaction"
        };

        for (String keyword : emergencyKeywords) {
            if (text.contains(keyword)) {
                return "Your message may indicate a medical emergency. "
                     + "Please seek urgent medical attention immediately. "
                     + "Contact local emergency services or visit the "
                     + "nearest emergency department. Do not wait for "
                     + "an AI response.";
            }
        }

        String[] dosageKeywords = {
            "how much should i take",
            "how many tablets",
            "what dose should i take",
            "how many mg",
            "dosage for me",
            "how often should i take",
            "when should i take",
            "how many times a day",
            "can i take another tablet",
            "should i increase my dose"
        };

        for (String keyword : dosageKeywords) {
            if (text.contains(keyword)) {
                return "I cannot independently determine your medicine "
                     + "dosage, frequency or timing. Please follow the "
                     + "prescription provided by your doctor. If the "
                     + "instructions are unclear, contact your doctor "
                     + "or pharmacist before taking the medicine.";
            }
        }

        return null;
    }

    private String escapeJson(String value) {
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    private String extractResponseContent(String json)
            throws IOException {

        String key = "\"content\":\"";
        int start = json.indexOf(key);

        if (start == -1) {
            throw new IOException(
                    "AI response content not found.");
        }

        start += key.length();

        StringBuilder result = new StringBuilder();
        boolean escaped = false;

        for (int i = start; i < json.length(); i++) {

            char c = json.charAt(i);

            if (escaped) {
                switch (c) {
                    case 'n': result.append('\n'); break;
                    case 'r': result.append('\r'); break;
                    case 't': result.append('\t'); break;
                    case '"': result.append('"'); break;
                    case '\\': result.append('\\'); break;
                    case '/': result.append('/'); break;
                    default:
                        result.append('\\').append(c);
                }

                escaped = false;

            } else if (c == '\\') {
                escaped = true;

            } else if (c == '"') {
                return result.toString();

            } else {
                result.append(c);
            }
        }

        throw new IOException("Invalid AI response JSON.");
    }
}