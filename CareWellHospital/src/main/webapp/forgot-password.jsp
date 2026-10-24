
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password | CareWell Hospital</title>
    <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="auth-page">
        <div class="auth-form">
            <h2>Forgot Password?</h2>
            <p>Enter your registered email address to request a reset link.</p>

            <% if ("true".equals(request.getParameter("sent"))) { %>
                <p class="alert alert-success">
                    If an active account matches that email, a password-reset
                    link will be sent. Check your inbox.
                </p>
            <% } %>

            <form method="post"
                  action="${pageContext.request.contextPath}/forgot-password">
                <div class="form-group">
                    <label for="email">Registered Email Address</label>
                    <input type="email" id="email" name="email"
                           class="form-control"
                           placeholder="Enter your email address"
                           maxlength="254" required>
                </div>

                <button type="submit" class="btn btn-primary">
                    Send Reset Link
                </button>
            </form>

            <div class="auth-footer">
                <a href="${pageContext.request.contextPath}/login.jsp">
                    Back to Login
                </a>
            </div>
        </div>
    </div>
</body>
</html>
