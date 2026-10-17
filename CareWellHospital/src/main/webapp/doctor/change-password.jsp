
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="com.model.User" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || !"DOCTOR".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password | CareWell Hospital</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/doctor-common.css">
          
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/doctor-changepassword.css">
    

</head>

<body>
<div class="page-container">

    <aside class="sidebar">
        <div class="brand">
            <div class="brand-icon">♥</div>
            <div>
                <h2>CareWell</h2>
                <span>HOSPITAL</span>
            </div>
        </div>

        <div class="sidebar-section">
            <p class="section-title">DOCTOR PORTAL</p>
            <a class="sidebar-link"
               href="<%= request.getContextPath() %>/doctor/dashboard.jsp">
                🏠 Dashboard
            </a>
            <a class="sidebar-link"
               href="<%= request.getContextPath() %>/doctor/appointments.jsp">
                📅 My Appointments
            </a>
        </div>

        <div class="sidebar-section">
            <p class="section-title">PATIENT CARE</p>
            <a class="sidebar-link"
               href="<%= request.getContextPath() %>/doctor/medical-records.jsp">
                🏥 Medical Records
            </a>
            <a class="sidebar-link"
               href="<%= request.getContextPath() %>/doctor/prescriptions.jsp">
                ℞ Prescriptions
            </a>
            <a class="sidebar-link"
               href="<%= request.getContextPath() %>/doctor/add-prescription.jsp">
                📝 Add Prescription
            </a>
        </div>

        <div class="sidebar-section">
            <p class="section-title">ACCOUNT</p>
            <a class="sidebar-link"
               href="<%= request.getContextPath() %>/doctor/profile.jsp">
                👤 My Profile
            </a>
        </div>

        <div class="sidebar-bottom">
            <a class="sidebar-link"
               href="<%= request.getContextPath() %>/LogoutController">
                🚪 Logout
            </a>
        </div>
    </aside>

    <main class="main-content">
        <header class="top-header">
            <div>
                <h1>🔒 Change Password</h1>
                <p>Update your account password securely</p>
            </div>
        </header>

        <section class="content-area">
            <div class="password-container">
                <h2>Change Password</h2>
                <p class="subtitle">
                    Enter your current password and choose a new password.
                </p>

                <% if ("success".equals(request.getParameter("password"))) { %>
                    <div class="message success">
                        Password changed successfully.
                    </div>
                <% } else if (request.getParameter("error") != null) { %>
                    <div class="message error">
                        <%= "invalid".equals(request.getParameter("error"))
                            ? "Your current password is incorrect."
                            : "Unable to change your password. Please try again." %>
                    </div>
                <% } %>

                <form action="<%= request.getContextPath() %>/doctor/change-password"
                      method="post">

                    <label for="currentPassword">Current Password</label>
                    <input type="password" id="currentPassword"
                           name="currentPassword" required
                           autocomplete="current-password">

                    <label for="newPassword">New Password</label>
                    <input type="password" id="newPassword"
                           name="newPassword" required minlength="8"
                           autocomplete="new-password">

                    <label for="confirmPassword">Confirm New Password</label>
                    <input type="password" id="confirmPassword"
                           name="confirmPassword" required minlength="8"
                           autocomplete="new-password">

                    <div class="password-actions">
                        <button type="submit">Update Password</button>
                        <a href="<%= request.getContextPath() %>/doctor/profile.jsp">
                            Cancel
                        </a>
                    </div>
                </form>
            </div>
            
            
<%
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<% if ("1".equals(success)) { %>
    <div class="password-alert password-success" role="alert">
        ✅ Password changed successfully!
    </div>
<% } %>

<% if ("empty".equals(error)) { %>
    <div class="password-alert password-error" role="alert">
        Please fill in all password fields.
    </div>
<% } else if ("weak".equals(error)) { %>
    <div class="password-alert password-error" role="alert">
        Your new password must contain at least 8 characters.
    </div>
<% } else if ("mismatch".equals(error)) { %>
    <div class="password-alert password-error" role="alert">
        New password and confirmation do not match.
    </div>
<% } else if ("same".equals(error)) { %>
    <div class="password-alert password-error" role="alert">
        Your new password must differ from your current password.
    </div>
<% } else if ("current".equals(error)) { %>
    <div class="password-alert password-error" role="alert">
        Your current password is incorrect.
    </div>
<% } else if ("failed".equals(error)) { %>
    <div class="password-alert password-error" role="alert">
        Password update failed. Please try again.
    </div>
<% } %>
            
        </section>

        <footer>
            © 2026 CareWell Hospital. Professional care, better health.
        </footer>
    </main>
</div>

</body>
</html>
