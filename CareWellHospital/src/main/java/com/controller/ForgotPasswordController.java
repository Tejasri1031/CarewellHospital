
package com.controller;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Base64;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.dao.UserDAO;
import com.dao.PasswordResetDAO;
import com.daoimpl.UserDAOImpl;
import com.daoimpl.PasswordResetDAOImpl;
import com.model.User;
import com.util.EmailService;

@WebServlet("/forgot-password")
public class ForgotPasswordController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String BASE_URL =
            "https://carewellhospital.onrender.com";

    private final UserDAO userDAO = new UserDAOImpl();
    private final PasswordResetDAO resetDAO =
            new PasswordResetDAOImpl();

    private final SecureRandom secureRandom = new SecureRandom();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/forgot-password.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        // Use the same public response whether the account exists or not.
        String message =
                "If an active account matches that email, "
                + "a password-reset link will be sent.";

        if (email != null && !email.isBlank()) {
            User user = userDAO.getUserByEmail(email.trim());

            if (user != null
                    && "ACTIVE".equalsIgnoreCase(user.getStatus())) {

                try {
                    byte[] bytes = new byte[32];
                    secureRandom.nextBytes(bytes);

                    String token = Base64.getUrlEncoder()
                            .withoutPadding()
                            .encodeToString(bytes);

                    String tokenHash = sha256(token);

                    // Expire the previous links before issuing a new one.
                    if (resetDAO.invalidatePreviousTokens(
                            user.getUserId())) {

                        Timestamp expiresAt = Timestamp.valueOf(
                                LocalDateTime.now().plusMinutes(30));

                        boolean saved = resetDAO.saveResetToken(
                                user.getUserId(),
                                tokenHash,
                                expiresAt);

                        if (saved) {
                        	String resetLink = BASE_URL
                        	        + "/reset-password?token=" + token;

                            String subject =
                                    "CareWell Hospital - Password Reset";

                            String body =
                                    "Dear " + user.getFullName() + ",\n\n"
                                    + "We received a request to reset "
                                    + "your CareWell Hospital password.\n\n"
                                    + "Use the link below within 30 minutes:\n"
                                    + resetLink + "\n\n"
                                    + "If you did not request this, "
                                    + "you can ignore this email.\n\n"
                                    + "Regards,\nCareWell Hospital";

                            if (!EmailService.sendEmail(
                                    user.getEmail(), subject, body)) {
                                System.err.println(
                                        "Password reset email could not "
                                        + "be sent for user ID "
                                        + user.getUserId());
                            }
                        }
                    }
                } catch (Exception e) {
                    // Do not expose account details or internal errors.
                    System.err.println(
                            "Password reset request processing failed.");
                    e.printStackTrace();
                }
            }
        }

        response.sendRedirect(
                request.getContextPath()
                + "/forgot-password.jsp?sent=true");
    }

    private String sha256(String value) throws Exception {
        byte[] hash = MessageDigest.getInstance("SHA-256")
                .digest(value.getBytes(
                        java.nio.charset.StandardCharsets.UTF_8));

        StringBuilder result = new StringBuilder();
        for (byte b : hash) {
            result.append(String.format("%02x", b));
        }
        return result.toString();
    }
}
