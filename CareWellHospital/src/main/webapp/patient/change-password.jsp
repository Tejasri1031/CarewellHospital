<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.model.User" %>
<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>
<%
    User user = (User) session.getAttribute("user");
    String context = request.getContextPath();

    if (user == null || !"PATIENT".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(context + "/login.jsp");
        return;
    }

    String fullName = user.getFullName() == null || user.getFullName().trim().isEmpty()
            ? "Patient" : user.getFullName().trim();
    String initial = fullName.substring(0, 1).toUpperCase();
    String passwordError = request.getParameter("passwordError");
    boolean passwordSuccess = "1".equals(request.getParameter("passwordSuccess"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password | CareWell Hospital</title>
    <link rel="stylesheet" href="<%= context %>/css/patient-common.css?v=3">
    <link rel="stylesheet" href="<%= context %>/css/patient-profile.css?v=11">
</head>
<body>
<div class="layout">
    <aside class="sidebar">
        <div class="brand">
            <div class="brand-icon">♥</div>
            <div><h2>CareWell</h2><span>HOSPITAL</span></div>
        </div>

        <nav class="navigation" aria-label="Patient navigation">
            <div class="nav-section-title">PATIENT PORTAL</div>
            <a href="<%= context %>/patient/dashboard.jsp" class="nav-item"><span class="nav-icon">🏠</span><span>Dashboard</span></a>
            <a href="<%= context %>/patient/appointments.jsp" class="nav-item"><span class="nav-icon">📅</span><span>My Appointments</span></a>
            <a href="<%= context %>/patient/book-appointment.jsp" class="nav-item"><span class="nav-icon">📝</span><span>Book Appointment</span></a>
            <div class="nav-section-title">MY HEALTH</div>
            <a href="<%= context %>/patient/medical-records.jsp" class="nav-item"><span class="nav-icon">🏥</span><span>Medical Records</span></a>
            <a href="<%= context %>/patient/prescriptions.jsp" class="nav-item"><span class="nav-icon">℞</span><span>Prescriptions</span></a>
            <a href="<%= context %>/patient/bills.jsp" class="nav-item"><span class="nav-icon">💸</span><span>Bills &amp; Payments</span></a>
            <div class="nav-section-title">ACCOUNT</div>
            <a href="<%= context %>/patient/profile.jsp" class="nav-item"><span class="nav-icon">👤</span><span>My Profile</span></a>
        </nav>

        <div class="sidebar-bottom">
            <a href="<%= context %>/LogoutController" class="nav-item logout"><span class="nav-icon">↪</span><span>Logout</span></a>
        </div>
    </aside>

    <main class="main-content">
        <header class="top-header">
            <div class="page-heading">
                <h1>Change Password</h1>
                <p>Keep your CareWell Hospital account secure</p>
            </div>

            <div class="profile-menu">
                <button type="button" class="profile-menu-button"
                        id="profileMenuButton" aria-expanded="false"
                        aria-controls="profileDropdown">
                    <span class="profile-menu-avatar"><%= escapeHtml(initial) %></span>
                    <span class="profile-menu-user">
                        <strong><%= escapeHtml(fullName) %></strong>
                        <span>Patient Account</span>
                    </span>
                    <span class="profile-menu-arrow" aria-hidden="true">▾</span>
                </button>
                <div class="profile-dropdown" id="profileDropdown" hidden>
                    <a href="<%= context %>/patient/profile.jsp"><span>👤</span><span>My Profile</span></a>
                    <a href="<%= context %>/patient/update-profile.jsp"><span>✏️</span><span>Update Details</span></a>
                    <a href="<%= context %>/patient/change-password.jsp"><span>🔒</span><span>Change Password</span></a>
                    <div class="profile-dropdown-divider"></div>
                    <a class="profile-dropdown-logout" href="<%= context %>/LogoutController"><span>↪</span><span>Logout</span></a>
                </div>
            </div>
        </header>

        <section class="content">
            <div class="section-header">
                <div>
                    <h2>Update Your Password</h2>
                    <p>Choose a strong password that you have not used before.</p>
                </div>
            </div>

            <% if (passwordSuccess) { %>
                <div class="update-message password-success" role="status">
                    Your password was changed successfully.
                </div>
            <% } %>

            <% if (passwordError != null) { %>
                <div class="update-message update-error" role="alert">
                    <% if ("current".equals(passwordError)) { %>
                        Your current password is incorrect.
                    <% } else if ("invalid".equals(passwordError)) { %>
                        Please enter a new password of at least 8 characters and make sure both new passwords match.
                    <% } else { %>
                        Password change failed. Please try again.
                    <% } %>
                </div>
            <% } %>

            <div class="profile-card">
                <form action="<%= context %>/patient/change-password" method="post"
                      class="change-password-form" autocomplete="on">
                    <div class="form-group">
                        <label for="currentPassword">Current Password</label>
                        <input type="password" id="currentPassword" name="currentPassword"
                               autocomplete="current-password" required>
                    </div>

                    <div class="form-group">
                        <label for="newPassword">New Password</label>
                        <input type="password" id="newPassword" name="newPassword"
                               minlength="8" autocomplete="new-password" required>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Confirm New Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword"
                               minlength="8" autocomplete="new-password" required>
                    </div>

                    <div class="update-form-actions">
                        <a class="cancel-update-button" href="<%= context %>/patient/profile.jsp">Cancel</a>
                        <button type="submit" class="change-password-button">Change Password</button>
                    </div>
                </form>
            </div>
        </section>

        <footer class="footer"><span>© 2026 CareWell Hospital</span><span>Patient Portal</span></footer>
    </main>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const button = document.getElementById("profileMenuButton");
    const dropdown = document.getElementById("profileDropdown");
    if (!button || !dropdown) return;

    function positionDropdown() {
        const rect = button.getBoundingClientRect();
        const width = Math.min(230, window.innerWidth - 16);
        const left = Math.max(8, Math.min(rect.right - width, window.innerWidth - width - 8));
        dropdown.style.top = (rect.bottom + 8) + "px";
        dropdown.style.left = left + "px";
    }

    function closeDropdown() {
        dropdown.hidden = true;
        button.setAttribute("aria-expanded", "false");
    }

    button.addEventListener("click", function (event) {
        event.preventDefault();
        event.stopPropagation();
        if (!dropdown.hidden) {
            closeDropdown();
        } else {
            positionDropdown();
            dropdown.hidden = false;
            button.setAttribute("aria-expanded", "true");
        }
    });

    dropdown.addEventListener("click", function (event) {
        event.stopPropagation();
    });
    document.addEventListener("click", closeDropdown);
    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape") {
            closeDropdown();
            button.focus();
        }
    });
    window.addEventListener("resize", function () {
        if (!dropdown.hidden) positionDropdown();
    });
    window.addEventListener("scroll", function () {
        if (!dropdown.hidden) positionDropdown();
    }, true);
});
</script>
</body>
</html>
