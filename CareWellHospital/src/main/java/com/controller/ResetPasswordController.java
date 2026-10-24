
package com.controller;

import java.io.IOException;
import java.security.MessageDigest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.dao.PasswordResetDAO;
import com.daoimpl.PasswordResetDAOImpl;
import com.util.PasswordUtil;

@WebServlet("/reset-password")
public class ResetPasswordController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final PasswordResetDAO resetDAO =
            new PasswordResetDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");

        if (token == null || token.isBlank()) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/reset-password.jsp?error=invalid");
            return;
        }

        request.getRequestDispatcher("/reset-password.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");
        String password = request.getParameter("password");
        String confirmPassword =
                request.getParameter("confirmPassword");

        if (token == null || token.isBlank()
                || password == null
                || confirmPassword == null
                || password.length() < 8
                || password.length() > 72
                || !password.equals(confirmPassword)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/reset-password.jsp?error=invalid");
            return;
        }

        try {
            String tokenHash = sha256(token);

            String hashedPassword =
                    PasswordUtil.hashPassword(password);

            boolean updated = resetDAO.resetPasswordAtomically(
                    tokenHash, hashedPassword);

            if (updated) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/login.jsp?reset=success");
            } else {
                response.sendRedirect(
                        request.getContextPath()
                        + "/reset-password.jsp?error=expired");
            }

        } catch (Exception e) {
            System.err.println("Password reset failed.");
            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/reset-password.jsp?error=failed");
        }
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
