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

<%

    /*=====

       LOGIN CHECK
       ===================================================== */
    if (session.getAttribute("user") == null) {

        response.sendRedirect(

            request.getContextPath() + "/login.jsp"

        );

        return;

    }

    String role =

            (String) session.getAttribute("role");

    if (role == null ||

        !"DOCTOR".equalsIgnoreCase(role)) {

        response.sendRedirect(

            request.getContextPath()

            + "/login.jsp?error=invalidRole"

        );

        return;

    }

    /*=====

       LOGGED-IN USER
       ===================================================== */
    User loggedUser =

            (User) session.getAttribute("user");

    Integer sessionUserId =

            (Integer) session.getAttribute("userId");

    if (sessionUserId == null) {

        response.sendRedirect(

            request.getContextPath()

            + "/login.jsp?error=sessionExpired"

        );

        return;

    }

    int userId =

            sessionUserId;

    /*=====

       DAO OBJECTS
       ===================================================== */
    DoctorDAO doctorDAO =

            new DoctorDAOImpl();

    AppointmentDetailsDAO appointmentDetailsDAO =

            new AppointmentDetailsDAOImpl();

    MedicalRecordDetailsDAO medicalRecordDetailsDAO =

            new MedicalRecordDetailsDAOImpl();

    /*=====

       FIND LOGGED-IN DOCTOR
       ===================================================== */
    Doctor doctor = null;

    List<Doctor> allDoctors =

            doctorDAO.getAllDoctors();

    for (Doctor d : allDoctors) {

        if (d.getUserId() == userId) {

            doctor = d;

            break;

        }

    }

    /*=====

       DOCTOR NOT FOUND
       ===================================================== */
    if (doctor == null) {

        response.sendRedirect(

            request.getContextPath()

            + "/login.jsp?error=doctorNotFound"

        );

        return;

    }

    int doctorId =

            doctor.getDoctorId();

    int loggedInUserId =

            ((com.model.User) session.getAttribute("user"))

                    .getUserId();

    NotificationDAO notificationDAO =

            new NotificationDAOImpl();

    List<Notification> doctorNotifications =

            notificationDAO

                    .getNotificationsByUser(

                            loggedInUserId);

    int unreadNotificationCount =

            notificationDAO

                    .getUnreadNotificationCount(

                            loggedInUserId);

    /*=====

       LOAD DOCTOR DATA
       ===================================================== */
    List<AppointmentDetails> appointments =

            appointmentDetailsDAO

                .getAppointmentDetailsByDoctor(doctorId);

    List<MedicalRecordDetails> medicalRecords =

            medicalRecordDetailsDAO

                .getMedicalRecordDetailsByDoctor(doctorId);

    /*=====

       CALCULATE APPOINTMENT STATISTICS
       ===================================================== */
    int totalAppointments =

            appointments.size();

    int pendingAppointments = 0;

    int confirmedAppointments = 0;

    int completedAppointments = 0;

    int cancelledAppointments = 0;

    for (AppointmentDetails appointment :

            appointments) {

        String status =

                appointment.getStatus();

        if ("PENDING".equalsIgnoreCase(status)) {

            pendingAppointments++;

        } else if ("CONFIRMED".equalsIgnoreCase(status)) {

            confirmedAppointments++;

        } else if ("COMPLETED".equalsIgnoreCase(status)) {

            completedAppointments++;

        } else if ("CANCELLED".equalsIgnoreCase(status)) {

            cancelledAppointments++;

        }

    }

    /*=====

       UNIQUE PATIENT COUNT
       ===================================================== */
    Set<Integer> uniquePatients =

            new HashSet<Integer>();

    for (AppointmentDetails appointment :

            appointments) {

        uniquePatients.add(

            appointment.getPatientId()

        );

    }

    int totalPatients =
            uniquePatients.size();

    /* =====================================================
       TODAY'S UNIQUE PATIENT COUNT
       ===================================================== */
    java.time.LocalDate today = java.time.LocalDate.now();
    Set<Integer> todayPatientIds = new HashSet<Integer>();

    for (AppointmentDetails appointment : appointments) {
        if (appointment.getAppointmentDate() == null) {
            continue;
        }

        String appointmentDate = appointment.getAppointmentDate().toString();
        String appointmentStatus = appointment.getStatus();

        if (appointmentDate.startsWith(today.toString())
                && appointment.getPatientId() > 0
                && !"CANCELLED".equalsIgnoreCase(appointmentStatus)) {
            todayPatientIds.add(appointment.getPatientId());
        }
    }

    int todayPatients = todayPatientIds.size();

    /*=====

       DOCTOR DISPLAY INFORMATION
       ===================================================== */
    String doctorName =

            loggedUser.getFullName();

    String firstLetter =

            doctorName.substring(0, 1)

                      .toUpperCase();

    String displayDoctorName =

            doctorName;

    if (doctorName.startsWith("Dr. ")) {

        displayDoctorName =

                doctorName.substring(4);

    }

%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"

          content="width=device-width, initial-scale=1.0">

    <title>

        Doctor Dashboard | CareWell Hospital

    </title>

    <!-- Font Awesome -->

    <link rel="stylesheet"

          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <!-- CareWell CSS -->

    <link rel="stylesheet"

          href="${pageContext.request.contextPath}/css/style.css">

<link rel="stylesheet"

      href="${pageContext.request.contextPath}/css/doctor-common.css">

</head>

<body>

<div class="page-container">

    <aside class="sidebar">

        <!-- Hospital Brand -->

        <div class="brand">

            <div class="brand-icon">♥︎</div>

            <div>

                <h2>CareWell</h2>

                <span>HOSPITAL</span>

            </div>

        </div>

        <!-- Doctor Portal Navigation -->

        <div class="sidebar-section">

            <p class="section-title">DOCTOR PORTAL</p>

            <a class="sidebar-link active"

               href="<%= request.getContextPath() %>/doctor/dashboard.jsp">

                <span class="menu-icon">🏠</span>

                Dashboard

            </a>

            <a class="sidebar-link"

               href="<%= request.getContextPath() %>/doctor/appointments.jsp">

                <span class="menu-icon">📅</span>

                My Appointments

            </a>

        </div>

        <!-- Patient Care Navigation -->

        <div class="sidebar-section">

            <p class="section-title">PATIENT CARE</p>

            <a class="sidebar-link"

               href="<%= request.getContextPath() %>/doctor/medical-records.jsp">

                <span class="menu-icon">🏥</span>

                Medical Records

            </a>

            <a class="sidebar-link"

               href="<%= request.getContextPath() %>/doctor/prescriptions.jsp">

                <span class="menu-icon">℞</span>

                Prescriptions

            </a>

             <a class="sidebar-link"

               href="<%= request.getContextPath() %>/doctor/add-prescription.jsp">

               <span class ="menu-icon">📝</span>

               Add Prescription

            </a>

        </div>

        <!-- Account Navigation -->

        <div class="sidebar-section">

            <p class="section-title">ACCOUNT</p>

            <a class="sidebar-link "

               href="<%= request.getContextPath() %>/doctor/profile.jsp">

                <span class="menu-icon">👤</span>

                My Profile

            </a>

        </div>

        <!-- Logout -->

        <div class="sidebar-bottom">

            <a class="sidebar-link"

               href="<%= request.getContextPath() %>/LogoutController">

                <span class="menu-icon">🏃🚪</span>

                Logout

            </a>

        </div>

    </aside>

<!-- =====================================================

     MAIN CONTENT

     ===================================================== -->

<main class="main-content">

    <!-- TOPBAR -->

    <header class="topbar">

        <div class="topbar-left">

            <div style="

                display:flex;

                align-items:center;

                gap:12px;

            ">

                <button class="mobile-menu-btn">

                    <i class="fa-solid fa-bars"></i>

                </button>

                <div>

                    <h1>

                        Doctor Dashboard

                    </h1>

                    <p>

                        Manage your patients and consultations

                    </p>

                </div>

            </div>

        </div>

        <div class="topbar-right">

			<a href="<%= request.getContextPath() %>/doctor/notifications.jsp"

   class="notification">

    <i class="fa-regular fa-bell"></i>

    <% if (unreadNotificationCount > 0) { %>

        <span class="notification-badge">

            <%= unreadNotificationCount %>

        </span>

    <% } %>

</a>

			<a href="<%= request.getContextPath() %>/doctor/profile.jsp"

   class="user-profile">

    <div class="avatar">

        <%= firstLetter %>

    </div>

    <div class="user-info">

        <strong>

            <%= doctorName %>

        </strong>

        <span>

            <%= doctor.getSpecialization() %>

        </span>

    </div>

</a>

        </div>

    </header>

    <!-- =================================================

         PAGE CONTENT

         ================================================= -->

    <section class="page-content">

        <!-- WELCOME -->

        <div class="page-header">

            <div class="page-title">

                <h2>

                    Hello, Dr.

                    <%= displayDoctorName %> 👋

                </h2>

                <p>

                    Here's your clinical overview for today.

                </p>

            </div>

        </div>

        <!-- =================================================

             DOCTOR PROFILE CARD

             ================================================= -->

        <div class="profile-header">

            <div class="profile-avatar">

                <%= firstLetter %>

            </div>

            <div>

                <h2>

                    <%= doctorName %>

                </h2>

                <p>

                    <%= doctor.getSpecialization() %>

                    &nbsp; • &nbsp;

                    <%= doctor.getQualification() %>

                </p>

            </div>

            <div style="

                margin-left:auto;

                text-align:right;

            ">

                <div style="

                    font-size:10px;

                    color:#dbeafe;

                ">

                    Experience

                </div>

                <strong style="

                    font-size:17px;

                ">

                    <%= doctor.getExperienceYears() %> Years

                </strong>

            </div>

        </div>

<!-- STATISTICS -->

<div class="stats-grid">

   
<!-- OVERALL APPOINTMENTS -->

<a href="<%= request.getContextPath() %>/appointments?action=doctor"
   class="stat-card"
   style="text-decoration:none; color:inherit; display:block;">

    <div class="stat-top">
        <div class="stat-label">Overall Appointments</div>

        <div class="stat-icon blue">
            <i class="fa-solid fa-calendar-check"></i>
        </div>
    </div>

    <div class="stat-number"><%= totalAppointments %></div>

    <div class="stat-change positive">
        <i class="fa-solid fa-calendar"></i>
        All appointments assigned to you
    </div>

</a>
   

<!-- TODAY'S PATIENTS -->

<a href="<%= request.getContextPath() %>/appointments?action=doctor&amp;filter=today"

   class="stat-card"

   style="text-decoration:none; color:inherit; display:block;">

    <div class="stat-top">

        <div class="stat-label">Today's Patients</div>

        <div class="stat-icon teal">

            <i class="fa-solid fa-hospital-user"></i>

        </div>

    </div>

    <div class="stat-number"><%= todayPatients %></div>

    <div class="stat-change positive">

        <i class="fa-solid fa-calendar-day"></i>

        Unique patients scheduled today

    </div>

</a>

    <!-- PENDING APPOINTMENTS -->

    <a href="<%= request.getContextPath() %>/appointments?action=doctor&status=PENDING"

       class="stat-card"

       style="text-decoration:none; color:inherit; display:block;">

        <div class="stat-top">

            <div class="stat-label">Pending</div>

            <div class="stat-icon orange">

                <i class="fa-solid fa-clock"></i>

            </div>

        </div>

        <div class="stat-number"><%= pendingAppointments %></div>

        <div class="stat-change">

            Awaiting consultation

        </div>

    </a>

    <!-- COMPLETED APPOINTMENTS -->

    <a href="<%= request.getContextPath() %>/appointments?action=doctor&status=COMPLETED"

       class="stat-card"

       style="text-decoration:none; color:inherit; display:block;">

        <div class="stat-top">

            <div class="stat-label">Completed</div>

            <div class="stat-icon green">

                <i class="fa-solid fa-circle-check"></i>

            </div>

        </div>

        <div class="stat-number"><%= completedAppointments %></div>

        <div class="stat-change positive">

            <i class="fa-solid fa-check"></i>

            Completed visits

        </div>

    </a>

</div>

        <!-- =================================================

             APPOINTMENT OVERVIEW

             ================================================= -->

        <div class="dashboard-grid">

            <!-- APPOINTMENT OVERVIEW -->

            <div class="card">

                <div class="card-header">

                    <div>

                        <div class="card-title">

                            Appointment Overview

                        </div>

                        <div class="card-subtitle">

                            Your appointment status

                        </div>

                    </div>

                    <i class="fa-solid fa-chart-column"

                       style="color:#2563eb;">

                    </i>

                </div>

                <div class="card-body">

                    <!-- COMPLETED -->

                    <div style="margin-bottom:18px;">

                        <div style="

                            display:flex;

                            justify-content:space-between;

                            font-size:12px;

                            margin-bottom:7px;

                        ">

                            <strong>

                                Completed

                            </strong>

                            <span>

                                <%= completedAppointments %>

                            </span>

                        </div>

                        <div style="

                            height:8px;

                            background:#f1f5f9;

                            border-radius:20px;

                            overflow:hidden;

                        ">

                            <div style="

                                height:100%;

                                width:<%= totalAppointments == 0 ? 0 :

                                    completedAppointments * 100 /

                                    totalAppointments %>%;

                                background:#16a34a;

                                border-radius:20px;

                            ">

                            </div>

                        </div>

                    </div>

                    <!-- CONFIRMED -->

                    <div style="margin-bottom:18px;">

                        <div style="

                            display:flex;

                            justify-content:space-between;

                            font-size:12px;

                            margin-bottom:7px;

                        ">

                            <strong>

                                Confirmed

                            </strong>

                            <span>

                                <%= confirmedAppointments %>

                            </span>

                        </div>

                        <div style="

                            height:8px;

                            background:#f1f5f9;

                            border-radius:20px;

                            overflow:hidden;

                        ">

                            <div style="

                                height:100%;

                                width:<%= totalAppointments == 0 ? 0 :

                                    confirmedAppointments * 100 /

                                    totalAppointments %>%;

                                background:#0284c7;

                                border-radius:20px;

                            ">

                            </div>

                        </div>

                    </div>

<!-- =================================================

             RECENT APPOINTMENTS

             ================================================= -->

        <div class="card">

            <div class="card-header">

                <div>

                    <div class="card-title">

                        My Recent Appointments

                    </div>

                    <div class="card-subtitle">

                        Appointments assigned to you

                    </div>

                </div>

                <a href="${pageContext.request.contextPath}/appointments?action=doctor&doctorId=<%= doctorId %>"

                   class="btn btn-outline btn-sm">

                    View All

                    <i class="fa-solid fa-arrow-right"></i>

                </a>

            </div>

            <div class="table-container">

                <table class="data-table">

                    <thead>

                        <tr>

                            <th>ID</th>

                            <th>Patient</th>

                            <th>Department</th>

                            <th>Date</th>

                            <th>Time</th>

                            <th>Reason</th>

                            <th>Status</th>

                        </tr>

                    </thead>

                    <tbody>

                    <%

                        int displayCount = 0;

                        for (AppointmentDetails appointment :

                                appointments) {

                            if (displayCount >= 5) {

                                break;

                            }

                            String statusClass =

                                    "status-neutral";

                            if ("COMPLETED".equalsIgnoreCase(

                                    appointment.getStatus())) {

                                statusClass =

                                        "status-success";

                            } else if ("CONFIRMED".equalsIgnoreCase(

                                    appointment.getStatus())) {

                                statusClass =

                                        "status-info";

                            } else if ("PENDING".equalsIgnoreCase(

                                    appointment.getStatus())) {

                                statusClass =

                                        "status-warning";

                            } else if ("CANCELLED".equalsIgnoreCase(

                                    appointment.getStatus())) {

                                statusClass =

                                        "status-danger";

                            }

                    %>

                        <tr>

                            <td>

                                #<%= appointment.getAppointmentId() %>

                            </td>

                            <td>

                                <strong>

                                    <%= appointment.getPatientName() %>

                                </strong>

                            </td>

                            <td>

                                <%= appointment.getDepartmentName() %>

                            </td>

                            <td>

                                <%= appointment.getAppointmentDate() %>

                            </td>

                            <td>

                                <%= appointment.getAppointmentTime() %>

                            </td>

                            <td>

                                <%= appointment.getReason() %>

                            </td>

                            <td>

                                <span class="status <%= statusClass %>">

                                    <%= appointment.getStatus() %>

                                </span>

                            </td>

                        </tr>

                    <%

                            displayCount++;

                        }

                        if (displayCount == 0) {

                    %>

                        <tr>

                            <td colspan="7">

                                <div class="empty-state">

                                    <i class="fa-regular fa-calendar-xmark"></i>

                                    <h3>

                                        No appointments found

                                    </h3>

                                    <p>

                                        You currently have no appointments.

                                    </p>

                                </div>

                            </td>

                        </tr>

                    <%

                        }

                    %>

                    </tbody>

                </table>

            </div>

        </div>

        <!-- =================================================

             MEDICAL RECORD SUMMARY

             ================================================= -->

        <div class="card"

             style="margin-top:20px;">

            <div class="card-header">

                <div>

                    <div class="card-title">

                        Recent Medical Records

                    </div>

                    <div class="card-subtitle">

                        Records created by you

                    </div>

                </div>

                <a href="${pageContext.request.contextPath}/medical-records?action=doctor&doctorId=<%= doctorId %>"

                   class="btn btn-outline btn-sm">

                    View Records

                    <i class="fa-solid fa-arrow-right"></i>

                </a>

            </div>

            <div class="table-container">

                <table class="data-table">

                    <thead>

                        <tr>

                            <th>Record ID</th>

                            <th>PATIENT</th>

                            <th>Visit Date</th>

                            <th>Diagnosis</th>

                            <th>Blood Pressure</th>

                        </tr>

                    </thead>

                    <tbody>

                    <%

                        int recordCount = 0;

                    for (MedicalRecordDetails record : medicalRecords){

                            if (recordCount >= 5) {

                                break;

                            }

                    %>

                        <tr>

                            <td>

                                #<%= record.getRecordId() %>

                            </td>

                            <td>

                               <%= record.getPatientName() %>

                            </td>

                            <td>

                                <%= record.getVisitDate() %>

                            </td>

                            <td>

                                <%= record.getDiagnosis() %>

                            </td>

                            <td>

                                <%= record.getBloodPressure() %>

                            </td>

                        </tr>

                    <%

                            recordCount++;

                        }

                        if (recordCount == 0) {

                    %>

                        <tr>

                            <td colspan="5">

                                <div class="empty-state">

                                    <i class="fa-solid fa-file-medical"></i>

                                    <h3>

                                        No medical records yet

                                    </h3>

                                    <p>

                                        Medical records created by you

                                        will appear here.

                                    </p>

                                </div>

                            </td>

                        </tr>

                    <%

                        }

                    %>

                    </tbody>

                </table>

            </div>

        </div>

        <!-- FOOTER -->

        <div class="footer">

            © 2026 CareWell Hospital.

            Professional care, better health.

        </div>

    </section>

</main>

</body>

</html>
