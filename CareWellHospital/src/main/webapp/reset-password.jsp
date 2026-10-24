
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password | CareWell Hospital</title>
    <link rel="stylesheet"
        href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="auth-page">
        <div class="auth-form">
            <h2>Set a New Password</h2>
            <p>Enter your new password below.</p>

            <%
                String error = request.getParameter("error");
                if ("invalid".equals(error)) {
            %>
                <div class="alert alert-danger">
                    Please enter valid password details.
                </div>
            <% } else if ("expired".equals(error)) { %>
                <div class="alert alert-danger">
                    This reset link is invalid, expired, or already used.
                    Please request a new link.
                </div>
            <% } else if ("failed".equals(error)) { %>
                <div class="alert alert-danger">
                    We couldn't reset your password. Please try again.
                </div>
            <% } %>

            <form method="post"
                  action="${pageContext.request.contextPath}/reset-password">

               <input type="hidden" name="token"
    value="<%= java.net.URLEncoder.encode(
        request.getParameter("token") == null
            ? "" : request.getParameter("token"),
        "UTF-8") %>">
               
                <div class="form-group">
                    <label for="password">New Password</label>
                    <input type="password" id="password" name="password"
                           class="form-control" minlength="8" maxlength="72"
                           autocomplete="new-password" required>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm New Password</label>
                    <input type="password" id="confirmPassword"
                           name="confirmPassword" class="form-control"
                           minlength="8" maxlength="72"
                           autocomplete="new-password" required>
                </div>

                <button type="submit" class="btn btn-primary">
                    Reset Password
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
