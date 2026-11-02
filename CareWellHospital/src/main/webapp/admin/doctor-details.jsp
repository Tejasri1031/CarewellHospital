<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.model.Doctor" %>
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

    Doctor doctor = (Doctor) request.getAttribute("doctor");

    if (doctor == null) {
        response.sendError(HttpServletResponse.SC_NOT_FOUND,
                "Doctor information not found.");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Doctor Details | CareWell Hospital</title>

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
               class="admin-nav-item active">Doctors</a>

            <a href="#" class="admin-nav-item">Patients</a>
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
                <h1>Doctor Profile</h1>
                <p>Complete registered doctor information</p>
            </div>

            <div class="admin-welcome">
                Welcome, <strong><%=admin.getFullName()%></strong>
            </div>

        </header>

        <section class="doctor-details-container">

            <div class="doctor-details-header">
                <div>
                    <h2><%=doctor.getFullName()%></h2>
                    <p><%=doctor.getSpecialization()%></p>
                </div>

                <span class="doctor-profile-id">
                    Doctor ID: <%=doctor.getDoctorId()%>
                </span>
            </div>

            <div class="doctor-details-grid">

                <div class="doctor-detail-item">
                    <label>Full Name</label>
                    <p><%=doctor.getFullName()%></p>
                </div>

                <div class="doctor-detail-item">
                    <label>Email Address</label>
                    <p><%=doctor.getEmail()%></p>
                </div>

                <div class="doctor-detail-item">
                    <label>Phone Number</label>
                    <p><%=doctor.getPhone()%></p>
                </div>

                <div class="doctor-detail-item">
                    <label>Department</label>
                    <p><%=doctor.getDepartmentName()%></p>
                </div>

                <div class="doctor-detail-item">
                    <label>Specialization</label>
                    <p><%=doctor.getSpecialization()%></p>
                </div>

                <div class="doctor-detail-item">
                    <label>Qualification</label>
                    <p><%=doctor.getQualification()%></p>
                </div>

                <div class="doctor-detail-item">
                    <label>Experience</label>
                    <p><%=doctor.getExperienceYears()%> years</p>
                </div>

                <div class="doctor-detail-item">
                    <label>Consultation Fee</label>
                    <p>₹<%=doctor.getConsultationFee()%></p>
                </div>

                <div class="doctor-detail-item">
                    <label>Availability Status</label>
                    <p><%=doctor.getAvailabilityStatus()%></p>
                </div>

                <div class="doctor-detail-item">
                    <label>Account Status</label>
                    <p><%=doctor.getUserStatus()%></p>
                </div>

                <div class="doctor-detail-item">
                    <label>Registered On</label>
                    <p><%=doctor.getCreatedAt()%></p>
                </div>

            </div>

            <div class="doctor-bio-section">
                <h3>Doctor Biography</h3>
                <p><%=doctor.getBio() == null ? "No biography available." : doctor.getBio()%></p>
            </div>
			
				<form action="<%=request.getContextPath()%>/AdminDoctorStatusController"
      method="post">

    <input type="hidden" name="userId"
           value="<%=doctor.getUserId()%>">

    <input type="hidden" name="doctorId"
           value="<%=doctor.getDoctorId()%>">

    <% if ("ACTIVE".equalsIgnoreCase(doctor.getUserStatus())) { %>

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
				
				<a href="<%=request.getContextPath()%>/AdminEditDoctorController?doctorId=<%=doctor.getDoctorId()%>"
   class="doctor-edit-button">Edit Doctor</a>
				
                <a href="<%=request.getContextPath()%>/AdminDoctorController"
                   class="doctor-back-button">
                    Back to Doctors
                </a>

            </div>

        </section>

    </main>

</div>

</body>
</html>