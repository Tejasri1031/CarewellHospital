
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.model.Patient" %>
<%@ page import="com.model.User" %>

<%
    User admin = (User) session.getAttribute("user");

    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (!"ADMIN".equalsIgnoreCase(admin.getRole())) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN,
                "Admin access required.");
        return;
    }

    Patient patient = (Patient) request.getAttribute("patient");

    if (patient == null) {
        response.sendError(HttpServletResponse.SC_NOT_FOUND,
                "Patient information not found.");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Patient Details | CareWell Hospital</title>

<link rel="stylesheet"
    href="<%=request.getContextPath()%>/css/admin.css">

</head>

<body>

<div class="admin-container">

    <aside class="admin-sidebar">

        <div class="admin-brand">
            <h2>CareWell</h2>
            <span>HOSPITAL ADMIN</span>
        </div>

        <nav class="admin-navigation">

            <a href="<%=request.getContextPath()%>/AdminDashboardController"
                class="admin-nav-item">Dashboard</a>

            <a href="<%=request.getContextPath()%>/AdminDoctorController"
                class="admin-nav-item">Doctors</a>

            <a href="<%=request.getContextPath()%>/AdminPatientController"
                class="admin-nav-item active">Patients</a>

            <a href="#" class="admin-nav-item">Appointments</a>

            <a href="#" class="admin-nav-item">Departments</a>

            <a href="#" class="admin-nav-item">Billing & Payments</a>

            <a href="#" class="admin-nav-item">Reports & Analytics</a>

        </nav>

        <div class="admin-logout">
            <a href="<%=request.getContextPath()%>/LogoutController">
                Logout
            </a>
        </div>

    </aside>

    <main class="admin-main">

        <header class="admin-header">

            <div>
                <h1>Patient Details</h1>
                <p>Complete registered patient information</p>
            </div>

            <div class="admin-welcome">
                Welcome, <strong><%=admin.getFullName()%></strong>
            </div>

        </header>

        <section class="dashboard-overview">

            <div class="doctor-details-container">

                <div class="doctor-details-header">
                    <div>
                        <h2><%=patient.getFullName()%></h2>
                        <p>Patient ID: <%=patient.getPatientId()%></p>
                    </div>
                </div>

                <div class="doctor-details-grid">

                    <div class="doctor-detail-item">
                        <span>Patient ID</span>
                        <strong><%=patient.getPatientId()%></strong>
                    </div>

                    <div class="doctor-detail-item">
                        <span>User ID</span>
                        <strong><%=patient.getUserId()%></strong>
                    </div>

                    <div class="doctor-detail-item">
                        <span>Full Name</span>
                        <strong><%=patient.getFullName()%></strong>
                    </div>

                    <div class="doctor-detail-item">
                        <span>Email</span>
                        <strong><%=patient.getEmail()%></strong>
                    </div>

                    <div class="doctor-detail-item">
                        <span>Phone</span>
                        <strong><%=patient.getPhone()%></strong>
                    </div>

                    <div class="doctor-detail-item">
                        <span>Date of Birth</span>
                        <strong>
                            <%=patient.getDateOfBirth() == null
                                ? "Not provided"
                                : patient.getDateOfBirth()%>
                        </strong>
                    </div>

                    <div class="doctor-detail-item">
                        <span>Gender</span>
                        <strong><%=patient.getGender()%></strong>
                    </div>

                    <div class="doctor-detail-item">
                        <span>Blood Group</span>
                        <strong><%=patient.getBloodGroup()%></strong>
                    </div>

                    <div class="doctor-detail-item">
                        <span>Account Status</span>
                        <strong><%=patient.getUserStatus()%></strong>
                    </div>

                    <div class="doctor-detail-item">
                        <span>Registration Date</span>
                        <strong>
                            <%=patient.getCreatedAt() == null
                                ? "Not available"
                                : patient.getCreatedAt()%>
                        </strong>
                    </div>

                </div>

                <div class="doctor-bio-section">
                    <h3>Address</h3>
                    <p><%=patient.getAddress() == null
                        ? "Not provided" : patient.getAddress()%></p>
                </div>

                <div class="doctor-bio-section">
                    <h3>Emergency Contact Information</h3>
                    <p>
                        <strong>Contact Name:</strong>
                        <%=patient.getEmergencyContactName() == null
                            ? "Not provided"
                            : patient.getEmergencyContactName()%>
                    </p>

                    <p>
                        <strong>Contact Phone:</strong>
                        <%=patient.getEmergencyContactPhone() == null
                            ? "Not provided"
                            : patient.getEmergencyContactPhone()%>
                    </p>
                </div>
                <form action="<%=request.getContextPath()%>/AdminPatientStatusController"
      method="post">

    <input type="hidden" name="userId"
           value="<%=patient.getUserId()%>">

    <input type="hidden" name="patientId"
           value="<%=patient.getPatientId()%>">

    <% if ("ACTIVE".equalsIgnoreCase(patient.getUserStatus())) { %>

        <input type="hidden" name="status" value="INACTIVE">

        <button type="submit" class="doctor-deactivate-button">
            Deactivate Account
        </button>

    <% } else { %>

        <input type="hidden" name="status" value="ACTIVE">

        <button type="submit" class="doctor-activate-button">
            Activate Account
        </button>

    <% } %>

</form>

                <div class="doctor-details-actions">

                    <a href="<%=request.getContextPath()%>/AdminPatientController"
                       class="doctor-back-button">
                        Back to Patients
                    </a>

                </div>

            </div>

        </section>

    </main>

</div>

</body>
</html>
