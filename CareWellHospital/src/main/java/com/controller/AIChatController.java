
package com.controller;

import java.io.IOException;

import com.service.AIChatService;
import com.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/ai-chat")
public class AIChatController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final AIChatService aiChatService = new AIChatService();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Verify patient login
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Please log in first.\"}");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Allow only patients
        if (!"PATIENT".equalsIgnoreCase(user.getRole())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Access denied.\"}");
            return;
        }

        String message = request.getParameter("message");

        if (message == null || message.isBlank()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Please enter a message.\"}");
            return;
        }

        try {

            // Retrieve conversation history from patient session
            @SuppressWarnings("unchecked")
            List<Map<String, String>> conversationHistory =
                    (List<Map<String, String>>) session.getAttribute("aiChatHistory");

            // Create history for the first message
            if (conversationHistory == null) {
                conversationHistory = new ArrayList<>();
            }

            // Keep only the latest 20 previous messages
            while (conversationHistory.size() > 20) {
                conversationHistory.remove(0);
            }

            // Get AI response using previous conversation
            String aiReply = aiChatService.getAIResponse(
                    message,
                    conversationHistory
            );

            // Store patient message
            Map<String, String> userChat = new HashMap<>();
            userChat.put("role", "user");
            userChat.put("content", message);
            conversationHistory.add(userChat);

            // Store AI response
            Map<String, String> botChat = new HashMap<>();
            botChat.put("role", "assistant");
            botChat.put("content", aiReply);
            conversationHistory.add(botChat);

            // Save updated conversation in patient session
            session.setAttribute("aiChatHistory", conversationHistory);
         // Escape AI response before sending JSON
            String safeReply = aiReply
                    .replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");

            // Send successful response to browser
            response.getWriter().write(
                    "{\"success\":true,\"reply\":\"" + safeReply + "\"}"
            );
       
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();

            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"AI service was interrupted.\"}");

        } catch (Exception e) {
            e.printStackTrace();

            response.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"AI service is currently unavailable. Please try again.\"}");
        }
    }
}
