
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.model.Appointment" %>
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

    Appointment appointment =
            (Appointment) request.getAttribute("appointment");

    if (appointment == null) {
        response.sendError(HttpServletResponse.SC_NOT_FOUND);
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Appointment Details | CareWell Hospital</title>

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
                class="admin-nav-item">Patients</a>

            <a href="<%=request.getContextPath()%>/AdminAppointmentController"
                class="admin-nav-item active">Appointments</a>

            <a href="<%=request.getContextPath()%>/departments?action=list"
   class="admin-nav-item">
    Departments
</a>

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
                <h1>Appointment Details</h1>
                <p>Complete appointment and tracking information</p>
            </div>

            <div class="admin-welcome">
                Welcome, <strong><%=admin.getFullName()%></strong>
            </div>

        </header>

        <section class="doctor-details-container">

            <div class="doctor-details-header">

                <div>
                    <h2>Appointment #<%=appointment.getAppointmentId()%></h2>

                    <p>
                        Status:
                        <strong><%=appointment.getStatus()%></strong>
                    </p>
                </div>

            </div>

            <div class="doctor-details-grid">

                <div class="doctor-detail-item">
                    <span>Appointment ID</span>
                    <strong><%=appointment.getAppointmentId()%></strong>
                </div>

                <div class="doctor-detail-item">
                    <span>Patient ID</span>
                    <strong><%=appointment.getPatientId()%></strong>
                </div>

                <div class="doctor-detail-item">
                    <span>Patient Name</span>
                    <strong><%=appointment.getPatientName()%></strong>
                </div>

                <div class="doctor-detail-item">
                    <span>Patient Email</span>
                    <strong><%=appointment.getPatientEmail()%></strong>
                </div>

                <div class="doctor-detail-item">
                    <span>Doctor ID</span>
                    <strong><%=appointment.getDoctorId()%></strong>
                </div>

                <div class="doctor-detail-item">
                    <span>Doctor Name</span>
                    <strong><%=appointment.getDoctorName()%></strong>
                </div>

                <div class="doctor-detail-item">
                    <span>Department ID</span>
                    <strong><%=appointment.getDepartmentId()%></strong>
                </div>

                <div class="doctor-detail-item">
                    <span>Department</span>
                    <strong><%=appointment.getDepartmentName()%></strong>
                </div>

                <div class="doctor-detail-item">
                    <span>Appointment Date</span>
                    <strong><%=appointment.getAppointmentDate()%></strong>
                </div>

                <div class="doctor-detail-item">
                    <span>Appointment Time</span>
                    <strong><%=appointment.getAppointmentTime()%></strong>
                </div>

                <div class="doctor-detail-item">
                    <span>Booking Date</span>
                    <strong><%=appointment.getCreatedAt() == null
                            ? "Not available" : appointment.getCreatedAt()%></strong>
                </div>

                <div class="doctor-detail-item">
                    <span>Appointment Status</span>
                    <strong><%=appointment.getStatus()%></strong>
                </div>

            </div>

            <div class="doctor-bio-section">

                <h3>Reason for Appointment</h3>

                <p>
                    <%=appointment.getReason() == null
                            ? "Not provided" : appointment.getReason()%>
                </p>

            </div>

            <div class="doctor-bio-section">

                <h3>Appointment Notes</h3>

                <p>
                    <%=appointment.getNotes() == null
                            ? "No additional notes" : appointment.getNotes()%>
                </p>

            </div>

            <div class="doctor-bio-section">

                <h3>Appointment Escalation & Notification Tracking</h3>

                <div class="doctor-details-grid">

                    <div class="doctor-detail-item">
                        <span>Response Due At</span>
                        <strong><%=appointment.getResponseDueAt() == null
                                ? "Not available" : appointment.getResponseDueAt()%></strong>
                    </div>

                    <div class="doctor-detail-item">
                        <span>Reminder Sent At</span>
                        <strong><%=appointment.getReminderSentAt() == null
                                ? "Not sent" : appointment.getReminderSentAt()%></strong>
                    </div>

                    <div class="doctor-detail-item">
                        <span>Escalated At</span>
                        <strong><%=appointment.getEscalatedAt() == null
                                ? "Not escalated" : appointment.getEscalatedAt()%></strong>
                    </div>

                    <div class="doctor-detail-item">
                        <span>Patient Notified At</span>
                        <strong><%=appointment.getPatientNotifiedAt() == null
                                ? "Not notified" : appointment.getPatientNotifiedAt()%></strong>
                    </div>

                </div>

            </div>

            <div class="doctor-details-actions">

    <% if ("PENDING".equalsIgnoreCase(appointment.getStatus())) { %>

        <form action="<%=request.getContextPath()%>/AdminAppointmentStatusController"
              method="post">

            <input type="hidden" name="appointmentId"
                   value="<%=appointment.getAppointmentId()%>">

            <input type="hidden" name="status" value="CONFIRMED">

            <button type="submit" class="doctor-view-button">
                Confirm Appointment
            </button>
        </form>

        <form action="<%=request.getContextPath()%>/AdminAppointmentStatusController"
              method="post">

            <input type="hidden" name="appointmentId"
                   value="<%=appointment.getAppointmentId()%>">

            <input type="hidden" name="status" value="CANCELLED">

            <button type="submit" class="doctor-back-button">
                Cancel Appointment
            </button>
        </form>

    <% } %>

    <a href="<%=request.getContextPath()%>/AdminAppointmentController"
       class="doctor-back-button">
        Back to Appointments
    </a>

</div>

        </section>

    </main>

</div>

</body>
</html>
