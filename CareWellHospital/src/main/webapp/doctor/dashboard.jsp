<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="com.dao.MedicalRecordDetailsDAO" %>
<%@ page import="com.daoimpl.MedicalRecordDetailsDAOImpl" %>
<%@ page import="com.model.MedicalRecordDetails" %>
<%@ page import="com.dao.DoctorDAO" %>
<%@ page import="com.dao.AppointmentDetailsDAO" %>
<%@ page import="com.daoimpl.DoctorDAOImpl" %>
<%@ page import="com.daoimpl.AppointmentDetailsDAOImpl" %>
<%@ page import="com.model.User" %>
<%@ page import="com.model.Doctor" %>
<%@ page import="com.model.AppointmentDetails" %>
<%@ page import="com.dao.NotificationDAO" %>
<%@ page import="com.daoimpl.NotificationDAOImpl" %>
<%@ page import="com.model.Notification" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.Collections" %>

<%
    // Authentication and role validation
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String role = (String) session.getAttribute("role");
    if (role == null || !"DOCTOR".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=invalidRole");
        return;
    }

    User loggedUser = (User) session.getAttribute("user");
    Integer sessionUserId = (Integer) session.getAttribute("userId");
    if (sessionUserId == null && loggedUser != null) {
        sessionUserId = loggedUser.getUserId();
    }
    if (sessionUserId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=sessionExpired");
        return;
    }

    int userId = sessionUserId;
    DoctorDAO doctorDAO = new DoctorDAOImpl();
    AppointmentDetailsDAO appointmentDetailsDAO = new AppointmentDetailsDAOImpl();
    MedicalRecordDetailsDAO medicalRecordDetailsDAO = new MedicalRecordDetailsDAOImpl();

    Doctor doctor = null;
    List<Doctor> allDoctors = doctorDAO.getAllDoctors();
    if (allDoctors != null) {
        for (Doctor d : allDoctors) {
            if (d.getUserId() == userId) {
                doctor = d;
                break;
            }
        }
    }

    if (doctor == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=doctorNotFound");
        return;
    }

    int doctorId = doctor.getDoctorId();
    int loggedInUserId = loggedUser != null ? loggedUser.getUserId() : userId;

    NotificationDAO notificationDAO = new NotificationDAOImpl();
    List<Notification> doctorNotifications = notificationDAO.getNotificationsByUser(loggedInUserId);
    int unreadNotificationCount = notificationDAO.getUnreadNotificationCount(loggedInUserId);

    List<AppointmentDetails> appointments = appointmentDetailsDAO.getAppointmentDetailsByDoctor(doctorId);
    List<MedicalRecordDetails> medicalRecords = medicalRecordDetailsDAO.getMedicalRecordDetailsByDoctor(doctorId);
    if (appointments == null) appointments = Collections.emptyList();
    if (medicalRecords == null) medicalRecords = Collections.emptyList();

    int totalAppointments = appointments.size();
    int pendingAppointments = 0;
    int confirmedAppointments = 0;
    int completedAppointments = 0;
    int cancelledAppointments = 0;
    Set<Integer> uniquePatients = new HashSet<Integer>();
    Set<Integer> todayPatientIds = new HashSet<Integer>();
    LocalDate today = LocalDate.now();

    for (AppointmentDetails appointment : appointments) {
        String status = appointment.getStatus();
        if ("PENDING".equalsIgnoreCase(status)) pendingAppointments++;
        else if ("CONFIRMED".equalsIgnoreCase(status)) confirmedAppointments++;
        else if ("COMPLETED".equalsIgnoreCase(status)) completedAppointments++;
        else if ("CANCELLED".equalsIgnoreCase(status)) cancelledAppointments++;

        int patientId = appointment.getPatientId();
        if (patientId > 0) uniquePatients.add(patientId);
        if (appointment.getAppointmentDate() != null
                && appointment.getAppointmentDate().toString().startsWith(today.toString())
                && patientId > 0
                && !"CANCELLED".equalsIgnoreCase(status)) {
            todayPatientIds.add(patientId);
        }
    }

    int totalPatients = uniquePatients.size();
    int todayPatients = todayPatientIds.size();
    String doctorName = loggedUser != null ? loggedUser.getFullName() : "Doctor";
    if (doctorName == null || doctorName.trim().isEmpty()) doctorName = "Doctor";
    String firstLetter = doctorName.substring(0, 1).toUpperCase();
    String displayDoctorName = doctorName.startsWith("Dr. ") ? doctorName.substring(4) : doctorName;

    int completedPercent = totalAppointments == 0 ? 0 : completedAppointments * 100 / totalAppointments;
    int confirmedPercent = totalAppointments == 0 ? 0 : confirmedAppointments * 100 / totalAppointments;
    int pendingPercent = totalAppointments == 0 ? 0 : pendingAppointments * 100 / totalAppointments;
    int cancelledPercent = totalAppointments == 0 ? 0 : cancelledAppointments * 100 / totalAppointments;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Dashboard | CareWell Hospital</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/doctor-common.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/doctor-dashboard.css">
</head>
<body>
<div class="page-container">
    <aside class="sidebar" id="doctorSidebar">
        <div class="brand">
            <div class="brand-icon">♥</div>
            <div class="brand-text"><h2>CareWell</h2><span>HOSPITAL</span></div>
        </div>

        <nav aria-label="Doctor navigation">
            <div class="sidebar-section">
                <p class="section-title">DOCTOR PORTAL</p>
                <a href="<%= request.getContextPath() %>/doctor/dashboard.jsp" class="sidebar-link active"><span class="menu-icon">🏠</span>Dashboard</a>
                <a href="<%= request.getContextPath() %>/doctor/appointments.jsp" class="sidebar-link"><span class="menu-icon">📅</span>My Appointments</a>
            </div>
            <div class="sidebar-section">
                <p class="section-title">PATIENT CARE</p>
                <a href="<%= request.getContextPath() %>/doctor/medical-records.jsp" class="sidebar-link"><span class="menu-icon">🏥</span>Medical Records</a>
                <a href="<%= request.getContextPath() %>/doctor/prescriptions.jsp" class="sidebar-link"><span class="menu-icon">℞</span>Prescriptions</a>
                <a href="<%= request.getContextPath() %>/doctor/add-prescription.jsp" class="sidebar-link"><span class="menu-icon">📝</span>Add Prescription</a>
            </div>
            <div class="sidebar-section">
                <p class="section-title">ACCOUNT</p>
                <a href="<%= request.getContextPath() %>/doctor/profile.jsp" class="sidebar-link"><span class="menu-icon">👤</span>My Profile</a>
            </div>
        </nav>
        <div class="sidebar-bottom">
            <a href="<%= request.getContextPath() %>/LogoutController" class="sidebar-link logout-link"><span class="menu-icon">🚪</span>Logout</a>
        </div>
    </aside>

    <main class="main-content">
        <header class="topbar">
            <div class="topbar-left">
                <button type="button" class="mobile-menu-btn" aria-label="Toggle navigation" aria-expanded="false">☰</button>
                <div class="topbar-heading"><h1>Doctor Dashboard</h1><p>Manage your patients and consultations</p></div>
            </div>
            <div class="topbar-right">
                <a href="<%= request.getContextPath() %>/doctor/notifications.jsp" class="notification" aria-label="Notifications">
                    🔔
                    <% if (unreadNotificationCount > 0) { %><span class="notification-badge"><%= unreadNotificationCount %></span><% } %>
                </a>
                <div class="doctor-account-menu" id="doctorAccountMenu">
                    <button type="button" class="user-profile doctor-profile-trigger" id="doctorProfileTrigger" aria-expanded="false" aria-controls="doctorProfileDropdown">
                        <span class="avatar"><%= firstLetter %></span>
                        <span class="user-info"><strong><%= doctorName %></strong><span><%= doctor.getSpecialization() %></span></span>
                        <span class="doctor-chevron" aria-hidden="true">⌄</span>
                    </button>
                    <div class="doctor-dropdown" id="doctorProfileDropdown" hidden>
                        <a href="<%= request.getContextPath() %>/doctor/update-details.jsp" class="doctor-dropdown-item">✏️ <span>Update Details</span></a>
                        <a href="<%= request.getContextPath() %>/doctor/change-password.jsp" class="doctor-dropdown-item">🔒 <span>Change Password</span></a>
                        <div class="doctor-dropdown-divider"></div>
                        <a href="<%= request.getContextPath() %>/LogoutController" class="doctor-dropdown-item logout-item">🚪 <span>Logout</span></a>
                    </div>
                </div>
            </div>
        </header>

        <section class="page-content">
            <div class="page-header">
                <div class="page-title"><h2>Hello, Dr. <%= displayDoctorName %> 👋</h2><p>Here's your clinical overview for today.</p></div>
            </div>

            <section class="profile-header" aria-label="Doctor profile summary">
                <div class="profile-avatar"><%= firstLetter %></div>
                <div class="profile-header-details">
                    <h2><%= doctorName %></h2>
                    <p><%= doctor.getSpecialization() %><span class="profile-separator">•</span><%= doctor.getQualification() %></p>
                </div>
                <div class="experience-block"><span>Experience</span><strong><%= doctor.getExperienceYears() %> Years</strong></div>
                <div class="profile-decoration" aria-hidden="true"></div>
            </section>

            <section class="stats-grid" aria-label="Appointment statistics">
                <a href="<%= request.getContextPath() %>/appointments?action=doctor" class="stat-card">
                    <div class="stat-top"><span class="stat-label">Overall Appointments</span><span class="stat-icon blue">📅</span></div>
                    <div class="stat-number"><%= totalAppointments %></div><div class="stat-change">🗓️ All appointments assigned to you</div>
                </a>
                <a href="<%= request.getContextPath() %>/appointments?action=doctor&amp;filter=today" class="stat-card">
                    <div class="stat-top"><span class="stat-label">Today's Patients</span><span class="stat-icon teal">🏥</span></div>
                    <div class="stat-number"><%= todayPatients %></div><div class="stat-change">📆 Unique patients scheduled today</div>
                </a>
                <a href="<%= request.getContextPath() %>/appointments?action=doctor&amp;status=PENDING" class="stat-card">
                    <div class="stat-top"><span class="stat-label">Pending</span><span class="stat-icon orange">⏰</span></div>
                    <div class="stat-number"><%= pendingAppointments %></div><div class="stat-change">Awaiting consultation</div>
                </a>
                <a href="<%= request.getContextPath() %>/appointments?action=doctor&amp;status=COMPLETED" class="stat-card">
                    <div class="stat-top"><span class="stat-label">Completed</span><span class="stat-icon green">✅</span></div>
                    <div class="stat-number"><%= completedAppointments %></div><div class="stat-change">✔️ Completed visits</div>
                </a>
            </section>

            <section class="dashboard-grid">
                <article class="card overview-card">
                    <div class="card-header"><div><h3 class="card-title">Appointment Overview</h3><p class="card-subtitle">Your appointment status</p></div><span class="card-heading-icon">📊</span></div>
                    <div class="card-body">
                        <div class="appointment-status">
                            <div class="appointment-status-header"><strong>Completed</strong><span><%= completedAppointments %></span></div>
                            <div class="progress-track"><span class="progress-bar completed" style="width:<%= completedPercent %>%"></span></div>
                        </div>
                        <div class="appointment-status">
                            <div class="appointment-status-header"><strong>Confirmed</strong><span><%= confirmedAppointments %></span></div>
                            <div class="progress-track"><span class="progress-bar confirmed" style="width:<%= confirmedPercent %>%"></span></div>
                        </div>
                        <div class="appointment-status">
                            <div class="appointment-status-header"><strong>Pending</strong><span><%= pendingAppointments %></span></div>
                            <div class="progress-track"><span class="progress-bar pending" style="width:<%= pendingPercent %>%"></span></div>
                        </div>
                        <div class="appointment-status">
                            <div class="appointment-status-header"><strong>Cancelled</strong><span><%= cancelledAppointments %></span></div>
                            <div class="progress-track"><span class="progress-bar cancelled" style="width:<%= cancelledPercent %>%"></span></div>
                        </div>
                        <div class="overview-footer"><span>Total unique patients</span><strong><%= totalPatients %></strong></div>
                    </div>
                </article>

                <article class="card recent-appointments-card">
                    <div class="card-header"><div><h3 class="card-title">My Recent Appointments</h3><p class="card-subtitle">Appointments assigned to you</p></div><a href="<%= request.getContextPath() %>/appointments?action=doctor&amp;doctorId=<%= doctorId %>" class="btn btn-outline btn-sm">View All <span aria-hidden="true">→</span></a></div>
                    <div class="table-container">
                        <table class="data-table">
                            <thead><tr><th>ID</th><th>Patient</th><th>Department</th><th>Date</th><th>Time</th><th>Reason</th><th>Status</th></tr></thead>
                            <tbody>
                            <%
                                int displayCount = 0;
                                for (AppointmentDetails appointment : appointments) {
                                    if (displayCount >= 5) break;
                                    String statusClass = "status-neutral";
                                    if ("COMPLETED".equalsIgnoreCase(appointment.getStatus())) statusClass = "status-success";
                                    else if ("CONFIRMED".equalsIgnoreCase(appointment.getStatus())) statusClass = "status-info";
                                    else if ("PENDING".equalsIgnoreCase(appointment.getStatus())) statusClass = "status-warning";
                                    else if ("CANCELLED".equalsIgnoreCase(appointment.getStatus())) statusClass = "status-danger";
                            %>
                                <tr>
                                    <td>#<%= appointment.getAppointmentId() %></td>
                                    <td><strong><%= appointment.getPatientName() %></strong></td>
                                    <td><%= appointment.getDepartmentName() %></td>
                                    <td><%= appointment.getAppointmentDate() %></td>
                                    <td><%= appointment.getAppointmentTime() %></td>
                                    <td><%= appointment.getReason() %></td>
                                    <td><span class="status <%= statusClass %>"><%= appointment.getStatus() %></span></td>
                                </tr>
                            <%
                                    displayCount++;
                                }
                                if (displayCount == 0) {
                            %>
                                <tr><td colspan="7"><div class="empty-state"><span>📭</span><h3>No appointments found</h3><p>You currently have no appointments.</p></div></td></tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </article>
            </section>

            <article class="card medical-record-summary-card">
                <div class="card-header"><div><h3 class="card-title">Recent Medical Records</h3><p class="card-subtitle">Records created by you</p></div><a href="<%= request.getContextPath() %>/doctor/medical-records.jsp" class="btn btn-outline btn-sm">View Records <span aria-hidden="true">→</span></a></div>
                <div class="table-container">
                    <table class="data-table">
                        <thead><tr><th>Record ID</th><th>Patient</th><th>Visit Date</th><th>Diagnosis</th><th>Blood Pressure</th></tr></thead>
                        <tbody>
                        <%
                            int recordCount = 0;
                            for (MedicalRecordDetails record : medicalRecords) {
                                if (recordCount >= 5) break;
                        %>
                            <tr><td>#<%= record.getRecordId() %></td><td><strong><%= record.getPatientName() %></strong></td><td><%= record.getVisitDate() %></td><td><%= record.getDiagnosis() %></td><td><%= record.getBloodPressure() %></td></tr>
                        <%
                                recordCount++;
                            }
                            if (recordCount == 0) {
                        %>
                            <tr><td colspan="5"><div class="empty-state"><span>🩺</span><h3>No medical records yet</h3><p>Medical records created by you will appear here.</p></div></td></tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </article>

            <footer class="footer">© 2026 CareWell Hospital. Professional care, better health.</footer>
        </section>
    </main>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const menu = document.getElementById("doctorAccountMenu");
    const trigger = document.getElementById("doctorProfileTrigger");
    const dropdown = document.getElementById("doctorProfileDropdown");

    function closeMenu() {
        if (!menu || !trigger || !dropdown) return;
        menu.classList.remove("open");
        dropdown.hidden = true;
        trigger.setAttribute("aria-expanded", "false");
    }

    if (menu && trigger && dropdown) {
        trigger.addEventListener("click", function (event) {
            event.preventDefault();
            event.stopPropagation();
            const opening = dropdown.hidden;
            dropdown.hidden = !opening;
            menu.classList.toggle("open", opening);
            trigger.setAttribute("aria-expanded", String(opening));
        });
        dropdown.addEventListener("click", function (event) { event.stopPropagation(); });
        document.addEventListener("click", function (event) {
            if (!menu.contains(event.target)) closeMenu();
        });
        document.addEventListener("keydown", function (event) {
            if (event.key === "Escape") { closeMenu(); trigger.focus(); }
        });
    }

    const mobileButton = document.querySelector(".mobile-menu-btn");
    const sidebar = document.querySelector(".sidebar");
    if (mobileButton && sidebar) {
        mobileButton.addEventListener("click", function () {
            const opened = sidebar.classList.toggle("open");
            mobileButton.setAttribute("aria-expanded", String(opened));
        });
    }
});
</script>
</body>
</html>
