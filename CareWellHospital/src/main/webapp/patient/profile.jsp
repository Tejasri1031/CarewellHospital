<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dao.PatientDAO" %>
<%@ page import="com.daoimpl.PatientDAOImpl" %>
<%@ page import="com.model.User" %>
<%@ page import="com.model.Patient" %>

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
    if (user == null || !"PATIENT".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    PatientDAO patientDAO = new PatientDAOImpl();
    Patient patient = patientDAO.getPatientByUserId(user.getUserId());
    if (patient == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String fullName = user.getFullName() == null || user.getFullName().trim().isEmpty()
            ? "Patient" : user.getFullName().trim();
    String initial = fullName.substring(0, 1).toUpperCase();
    String context = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | CareWell Hospital</title>
    <link rel="stylesheet" href="<%= context %>/css/patient-common.css?v=3">
    <link rel="stylesheet" href="<%= context %>/css/patient-profile.css?v=10">
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
            <a href="<%= context %>/patient/dashboard.jsp" class="nav-item">
                <span class="nav-icon">🏠</span><span>Dashboard</span>
            </a>
            <a href="<%= context %>/patient/appointments.jsp" class="nav-item">
                <span class="nav-icon">📅</span><span>My Appointments</span>
            </a>
            <a href="<%= context %>/patient/book-appointment.jsp" class="nav-item">
                <span class="nav-icon">📝</span><span>Book Appointment</span>
            </a>

            <div class="nav-section-title">MY HEALTH</div>
            <a href="<%= context %>/patient/medical-records.jsp" class="nav-item">
                <span class="nav-icon">🏥</span><span>Medical Records</span>
            </a>
            <a href="<%= context %>/patient/prescriptions.jsp" class="nav-item">
                <span class="nav-icon">℞</span><span>Prescriptions</span>
            </a>
            <a href="<%= context %>/patient/bills.jsp" class="nav-item">
                <span class="nav-icon">💸</span><span>Bills &amp; Payments</span>
            </a>

            <div class="nav-section-title">ACCOUNT</div>
            <a href="<%= context %>/patient/profile.jsp" class="nav-item active" aria-current="page">
                <span class="nav-icon">👤</span><span>My Profile</span>
            </a>
        </nav>

        <div class="sidebar-bottom">
            <a href="<%= context %>/LogoutController" class="nav-item logout">
                <span class="nav-icon">↪</span><span>Logout</span>
            </a>
        </div>
    </aside>

    <main class="main-content">
        <header class="top-header">
            <div class="page-heading">
                <h1>My Profile</h1>
                <p>View your personal and emergency contact information</p>
            </div>

            
<div class="profile-menu">
    <button type="button"
            class="profile-menu-button"
            id="profileMenuButton"
            aria-expanded="false"
            aria-controls="profileDropdown">
        <!-- Keep your existing avatar, name and patient ID here -->
        <span class="profile-menu-avatar">R</span>
        <span class="profile-menu-user">
            <strong>Rahul Kumar</strong>
            <span>Patient #1</span>
        </span>
        <span class="profile-menu-arrow">▾</span>
    </button>

    <div class="profile-dropdown" id="profileDropdown" hidden>
        <a href="update-profile.jsp">✏️ Update Details</a>
        <a href="change-password.jsp">🔒 Change Password</a>
        <div class="profile-dropdown-divider"></div>
        <a class="profile-dropdown-logout"
           href="../LogoutController">↪ Logout</a>
    </div>
</div>
            
        </header>

        <section class="content">
            <div class="profile-overview" id="profileDetails">
                <div class="large-avatar"><%= escapeHtml(initial) %></div>
                <div class="profile-heading">
                    <h2><%= escapeHtml(fullName) %></h2>
                    <p>Patient #<%= patient.getPatientId() %></p>
                    <span class="patient-badge">PATIENT</span>
                </div>
            </div>

            <% if ("1".equals(request.getParameter("updated"))) { %>
                <div class="update-message" role="status"
                     style="color:#167744;background:#edfff5;border:1px solid #bdebd1;">
                    Your profile details were updated successfully.
                </div>
            <% } %>

            <div class="section-header">
                <div><h2>Personal Information</h2><p>Your registered personal details</p></div>
            </div>
            <div class="profile-card">
                <div class="details-grid">
                    <div class="detail-item"><span>FULL NAME</span><strong><%= escapeHtml(fullName) %></strong></div>
                    <div class="detail-item"><span>EMAIL ADDRESS</span><strong><%= escapeHtml(user.getEmail() == null ? "Not provided" : user.getEmail()) %></strong></div>
                    <div class="detail-item"><span>PHONE NUMBER</span><strong><%= escapeHtml(user.getPhone() == null ? "Not provided" : user.getPhone()) %></strong></div>
                    <div class="detail-item"><span>PATIENT ID</span><strong>#<%= patient.getPatientId() %></strong></div>
                    <div class="detail-item"><span>DATE OF BIRTH</span><strong><%= patient.getDateOfBirth() == null ? "Not provided" : patient.getDateOfBirth() %></strong></div>
                    <div class="detail-item"><span>GENDER</span><strong><%= escapeHtml(patient.getGender() == null ? "Not provided" : patient.getGender()) %></strong></div>
                    <div class="detail-item"><span>BLOOD GROUP</span><strong class="blood-group"><%= escapeHtml(patient.getBloodGroup() == null ? "Not provided" : patient.getBloodGroup()) %></strong></div>
                    <div class="detail-item"><span>ACCOUNT STATUS</span><strong class="active-status"><%= escapeHtml(user.getStatus() == null ? "Unknown" : user.getStatus()) %></strong></div>
                    <div class="detail-item full-width"><span>ADDRESS</span><strong><%= escapeHtml(patient.getAddress() == null ? "Not provided" : patient.getAddress()) %></strong></div>
                </div>
            </div>

            <div class="section-header emergency-header">
                <div><h2>Emergency Contact</h2><p>Person to contact in case of an emergency</p></div>
            </div>
            <div class="emergency-card">
                <div class="emergency-icon" aria-hidden="true">+</div>
                <div class="emergency-details">
                    <div><span>CONTACT NAME</span><strong><%= escapeHtml(patient.getEmergencyContactName() == null ? "Not provided" : patient.getEmergencyContactName()) %></strong></div>
                    <div><span>PHONE NUMBER</span><strong><%= escapeHtml(patient.getEmergencyContactPhone() == null ? "Not provided" : patient.getEmergencyContactPhone()) %></strong></div>
                </div>
            </div>

            <div class="section-header account-header">
                <div><h2>Account Information</h2><p>Information about your CareWell Hospital account</p></div>
            </div>
            <div class="account-card">
                <div class="account-item"><span>USER ID</span><strong>#<%= user.getUserId() %></strong></div>
                <div class="account-item"><span>ROLE</span><strong><%= escapeHtml(user.getRole()) %></strong></div>
                <div class="account-item"><span>ACCOUNT CREATED</span><strong><%= user.getCreatedAt() == null ? "Not available" : user.getCreatedAt() %></strong></div>
                <div class="account-item"><span>STATUS</span><strong class="active-status"><%= escapeHtml(user.getStatus() == null ? "Unknown" : user.getStatus()) %></strong></div>
            </div>

            <div class="information-card">
                <div class="information-icon" aria-hidden="true">ℹ</div>
                <div><h3>Profile Information</h3>
                    <p>Use Update Details to change your date of birth, gender, blood group, address, and emergency contact information. Contact hospital administration if your account name, email, or phone number needs to change.</p>
                </div>
            </div>

        </section>

        <footer class="footer"><span>© 2026 CareWell Hospital</span><span>Patient Portal</span></footer>
    </main>
</div>


<script>
document.addEventListener("DOMContentLoaded", function () {
    const button = document.getElementById("profileMenuButton");
    const dropdown = document.getElementById("profileDropdown");

    if (!button || !dropdown) {
        console.error("Profile dropdown elements not found.");
        return;
    }

    function openDropdown() {
        const rect = button.getBoundingClientRect();
        const menuWidth = Math.min(230, window.innerWidth - 16);

        let left = rect.right - menuWidth;
        left = Math.max(8, Math.min(left, window.innerWidth - menuWidth - 8));

        dropdown.style.position = "fixed";
        dropdown.style.top = (rect.bottom + 8) + "px";
        dropdown.style.left = left + "px";
        dropdown.style.right = "auto";
        dropdown.style.zIndex = "2147483647";

        dropdown.hidden = false;
        button.setAttribute("aria-expanded", "true");
    }

    function closeDropdown() {
        dropdown.hidden = true;
        button.setAttribute("aria-expanded", "false");
    }

    button.addEventListener("click", function (event) {
        event.preventDefault();
        event.stopPropagation();

        if (dropdown.hidden) {
            openDropdown();
        } else {
            closeDropdown();
        }
    });

    dropdown.addEventListener("click", function (event) {
        event.stopPropagation();
    });

    document.addEventListener("click", function (event) {
        if (!button.contains(event.target) &&
            !dropdown.contains(event.target)) {
            closeDropdown();
        }
    });

    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape") {
            closeDropdown();
            button.focus();
        }
    });

    window.addEventListener("resize", function () {
        if (!dropdown.hidden) {
            openDropdown();
        }
    });

    window.addEventListener("scroll", function () {
        if (!dropdown.hidden) {
            openDropdown();
        }
    }, true);
});
</script>

</body>
</html>
