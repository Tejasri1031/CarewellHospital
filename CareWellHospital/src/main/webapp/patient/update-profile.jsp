<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Arrays" %>
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
    String context = request.getContextPath();

    if (user == null || !"PATIENT".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(context + "/login.jsp");
        return;
    }

    PatientDAO patientDAO = new PatientDAOImpl();
    Patient patient = patientDAO.getPatientByUserId(user.getUserId());

    if (patient == null) {
        response.sendRedirect(context + "/login.jsp");
        return;
    }

    String error = null;
    String[] allowedGenders = {"MALE", "FEMALE", "OTHER"};
    String[] allowedBloodGroups = {"A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"};

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");

        String dobText = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String bloodGroup = request.getParameter("bloodGroup");
        String address = request.getParameter("address");
        String emergencyName = request.getParameter("emergencyContactName");
        String emergencyPhone = request.getParameter("emergencyContactPhone");

        if (isBlank(dobText) || isBlank(gender) || isBlank(bloodGroup)
                || isBlank(address) || isBlank(emergencyName) || isBlank(emergencyPhone)) {
            error = "Please complete all fields.";
        } else if (!Arrays.asList(allowedGenders).contains(gender.trim().toUpperCase())
                || !Arrays.asList(allowedBloodGroups).contains(bloodGroup.trim().toUpperCase())) {
            error = "Please select a valid gender and blood group.";
        } else if (address.trim().length() > 500 || emergencyName.trim().length() > 100
                || emergencyPhone.trim().length() > 20) {
            error = "One or more fields exceed the allowed length.";
        } else if (!emergencyPhone.trim().matches("[0-9+() .-]{7,20}")) {
            error = "Please enter a valid emergency contact phone number.";
        } else {
            try {
                Date dob = Date.valueOf(dobText.trim());
                if (dob.after(new Date(System.currentTimeMillis()))) {
                    error = "Date of birth cannot be in the future.";
                } else {
                    patient.setDateOfBirth(dob);
                    patient.setGender(gender.trim().toUpperCase());
                    patient.setBloodGroup(bloodGroup.trim().toUpperCase());
                    patient.setAddress(address.trim());
                    patient.setEmergencyContactName(emergencyName.trim());
                    patient.setEmergencyContactPhone(emergencyPhone.trim());
                    // IDs come from the authenticated session and database record, not form fields.
                    patient.setUserId(user.getUserId());

                    if (patientDAO.updatePatient(patient)) {
                        response.sendRedirect(context + "/patient/profile.jsp?updated=1");
                        return;
                    }
                    error = "Unable to update your details. Please try again.";
                }
            } catch (IllegalArgumentException ex) {
                error = "Please enter a valid date of birth.";
            }
        }

        if (error != null) {
            if (dobText != null && !dobText.trim().isEmpty()) {
                try { patient.setDateOfBirth(Date.valueOf(dobText.trim())); }
                catch (IllegalArgumentException ignored) { }
            }
            if (gender != null) patient.setGender(gender);
            if (bloodGroup != null) patient.setBloodGroup(bloodGroup);
            if (address != null) patient.setAddress(address);
            if (emergencyName != null) patient.setEmergencyContactName(emergencyName);
            if (emergencyPhone != null) patient.setEmergencyContactPhone(emergencyPhone);
        }
    }

    String fullName = user.getFullName() == null || user.getFullName().trim().isEmpty()
            ? "Patient" : user.getFullName().trim();
    String initial = fullName.substring(0, 1).toUpperCase();
%>
<%!
    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Details | CareWell Hospital</title>
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
            <a class="nav-item" href="<%= context %>/patient/dashboard.jsp"><span class="nav-icon">🏠</span><span>Dashboard</span></a>
            <a class="nav-item" href="<%= context %>/patient/appointments.jsp"><span class="nav-icon">📅</span><span>My Appointments</span></a>
            <a class="nav-item" href="<%= context %>/patient/book-appointment.jsp"><span class="nav-icon">📝</span><span>Book Appointment</span></a>
            <div class="nav-section-title">MY HEALTH</div>
            <a class="nav-item" href="<%= context %>/patient/medical-records.jsp"><span class="nav-icon">🏥</span><span>Medical Records</span></a>
            <a class="nav-item" href="<%= context %>/patient/prescriptions.jsp"><span class="nav-icon">℞</span><span>Prescriptions</span></a>
            <a class="nav-item" href="<%= context %>/patient/bills.jsp"><span class="nav-icon">💸</span><span>Bills &amp; Payments</span></a>
            <div class="nav-section-title">ACCOUNT</div>
            <a class="nav-item" href="<%= context %>/patient/profile.jsp"><span class="nav-icon">👤</span><span>My Profile</span></a>
        </nav>
        <div class="sidebar-bottom">
            <a class="nav-item logout" href="<%= context %>/LogoutController"><span class="nav-icon">↪</span><span>Logout</span></a>
        </div>
    </aside>

    <main class="main-content">
        <header class="top-header">
            <div class="page-heading">
                <h1>Update Details</h1>
                <p>Keep your personal and emergency contact details up to date</p>
            </div>
            <a class="back-profile-link" href="<%= context %>/patient/profile.jsp">← My Profile</a>
        </header>

        <section class="content">
            <div class="profile-overview">
                <div class="large-avatar"><%= escapeHtml(initial) %></div>
                <div class="profile-heading">
                    <h2><%= escapeHtml(fullName) %></h2>
                    <p>Patient #<%= patient.getPatientId() %></p>
                    <span class="patient-badge">PATIENT</span>
                </div>
            </div>

            <% if (error != null) { %>
                <div class="update-message update-error" role="alert"><%= escapeHtml(error) %></div>
            <% } %>

            <div class="section-header">
                <div><h2>Personal Information</h2><p>Your name, email and phone are managed by your account.</p></div>
            </div>
            <div class="profile-card">
                <div class="details-grid readonly-details">
                    <div class="detail-item"><span>FULL NAME</span><strong><%= escapeHtml(fullName) %></strong></div>
                    <div class="detail-item"><span>EMAIL ADDRESS</span><strong><%= escapeHtml(user.getEmail() == null ? "Not provided" : user.getEmail()) %></strong></div>
                    <div class="detail-item"><span>PHONE NUMBER</span><strong><%= escapeHtml(user.getPhone() == null ? "Not provided" : user.getPhone()) %></strong></div>
                    <div class="detail-item"><span>PATIENT ID</span><strong>#<%= patient.getPatientId() %></strong></div>
                </div>
            </div>

            <div class="section-header account-header">
                <div><h2>Edit Patient Details</h2><p>Update your medical and contact information below.</p></div>
            </div>
            <div class="profile-card">
                <form method="post" action="<%= context %>/patient/update-profile.jsp" class="update-profile-form">
                    <div class="update-form-grid">
                        <div class="form-group">
                            <label for="dateOfBirth">Date of Birth</label>
                            <input type="date" id="dateOfBirth" name="dateOfBirth"
                                   max="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"
                                   value="<%= patient.getDateOfBirth() == null ? "" : patient.getDateOfBirth().toString() %>" required>
                        </div>

                        <div class="form-group">
                            <label for="gender">Gender</label>
                            <select id="gender" name="gender" required>
                                <option value="">Select gender</option>
                                <option value="MALE" <%= "MALE".equalsIgnoreCase(patient.getGender()) ? "selected" : "" %>>Male</option>
                                <option value="FEMALE" <%= "FEMALE".equalsIgnoreCase(patient.getGender()) ? "selected" : "" %>>Female</option>
                                <option value="OTHER" <%= "OTHER".equalsIgnoreCase(patient.getGender()) ? "selected" : "" %>>Other</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="bloodGroup">Blood Group</label>
                            <select id="bloodGroup" name="bloodGroup" required>
                                <option value="">Select blood group</option>
                                <% for (String bg : allowedBloodGroups) { %>
                                    <option value="<%= bg %>" <%= bg.equalsIgnoreCase(patient.getBloodGroup() == null ? "" : patient.getBloodGroup()) ? "selected" : "" %>><%= bg %></option>
                                <% } %>
                            </select>
                        </div>

                        <div class="form-group full-width">
                            <label for="address">Address</label>
                            <textarea id="address" name="address" rows="3" maxlength="500" required><%= escapeHtml(patient.getAddress()) %></textarea>
                        </div>

                        <div class="form-group">
                            <label for="emergencyContactName">Emergency Contact Name</label>
                            <input type="text" id="emergencyContactName" name="emergencyContactName"
                                   maxlength="100" value="<%= escapeHtml(patient.getEmergencyContactName()) %>" required>
                        </div>

                        <div class="form-group">
                            <label for="emergencyContactPhone">Emergency Contact Phone</label>
                            <input type="tel" id="emergencyContactPhone" name="emergencyContactPhone"
                                   maxlength="20" pattern="[0-9+() .-]{7,20}"
                                   value="<%= escapeHtml(patient.getEmergencyContactPhone()) %>" required>
                        </div>
                    </div>

                    <div class="update-form-actions">
                        <a class="cancel-update-button" href="<%= context %>/patient/profile.jsp">Cancel</a>
                        <button type="submit" class="change-password-button">Save Changes</button>
                    </div>
                </form>
            </div>
        </section>

        <footer class="footer"><span>© 2026 CareWell Hospital</span><span>Patient Portal</span></footer>
    </main>
</div>
</body>
</html>
