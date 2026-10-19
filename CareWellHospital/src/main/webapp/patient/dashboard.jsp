<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="java.sql.Date"%>

<%@ page import="com.dao.PatientDAO"%>
<%@ page import="com.dao.AppointmentDetailsDAO"%>
<%@ page import="com.dao.NotificationDAO"%>

<%@ page import="com.daoimpl.PatientDAOImpl"%>
<%@ page import="com.daoimpl.AppointmentDetailsDAOImpl"%>
<%@ page import="com.daoimpl.NotificationDAOImpl"%>

<%@ page import="com.model.User"%>
<%@ page import="com.model.Patient"%>
<%@ page import="com.model.AppointmentDetails"%>

<%
    /* =====================================================
       LOGIN CHECK
       ===================================================== */

    User user = (User) session.getAttribute("user");

    if (user == null || !"PATIENT".equalsIgnoreCase(user.getRole())) {

        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );

        return;
    }


    /* =====================================================
       FIND LOGGED-IN PATIENT
       ===================================================== */

    int userId = user.getUserId();

    PatientDAO patientDAO =
            new PatientDAOImpl();

    Patient patient =
            patientDAO.getPatientByUserId(userId);

    if (patient == null) {

        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );

        return;
    }

    int patientId =
            patient.getPatientId();


    /* =====================================================
       LOAD APPOINTMENTS
       ===================================================== */

    AppointmentDetailsDAO appointmentDetailsDAO =
            new AppointmentDetailsDAOImpl();

    List<AppointmentDetails> appointments =
            appointmentDetailsDAO
                    .getAppointmentDetailsByPatient(patientId);


    /* =====================================================
       DASHBOARD STATISTICS
       ===================================================== */

    int totalAppointments =
            appointments != null
                    ? appointments.size()
                    : 0;

    int upcomingAppointments = 0;

    int completedAppointments = 0;

    int cancelledAppointments = 0;

    Date today =
            new Date(System.currentTimeMillis());


    if (appointments != null) {

        for (AppointmentDetails appointment : appointments) {

            String status =
                    appointment.getStatus();


            /* COMPLETED */

            if ("COMPLETED".equalsIgnoreCase(status)) {

                completedAppointments++;
            }


            /* CANCELLED */

            else if ("CANCELLED".equalsIgnoreCase(status)) {

                cancelledAppointments++;
            }


            /* UPCOMING */

            if (appointment.getAppointmentDate() != null
                    && !appointment.getAppointmentDate().before(today)
                    && ("PENDING".equalsIgnoreCase(status)
                    || "CONFIRMED".equalsIgnoreCase(status))) {

                upcomingAppointments++;
            }
        }
    }


    /* =====================================================
       FIND NEXT APPOINTMENT
       ===================================================== */

    AppointmentDetails nextAppointment = null;


    if (appointments != null) {

        for (AppointmentDetails appointment : appointments) {

            String status =
                    appointment.getStatus();


            if (appointment.getAppointmentDate() == null) {

                continue;
            }


            if (!"PENDING".equalsIgnoreCase(status)
                    && !"CONFIRMED".equalsIgnoreCase(status)) {

                continue;
            }


            if (appointment.getAppointmentDate().before(today)) {

                continue;
            }


            if (nextAppointment == null
                    || appointment.getAppointmentDate()
                            .before(
                                nextAppointment.getAppointmentDate()
                            )) {

                nextAppointment = appointment;
            }
        }
    }


    /* =====================================================
       PATIENT NOTIFICATIONS
       ===================================================== */

    NotificationDAO notificationDAO =
            new NotificationDAOImpl();

    int notificationCount =
            notificationDAO.getUnreadNotificationCount(userId);


    /* =====================================================
       PATIENT DISPLAY DATA
       ===================================================== */

    String patientName =
            user.getFullName();

    if (patientName == null
            || patientName.trim().isEmpty()) {

        patientName = "Patient";
    }

    String firstLetter =
            patientName.substring(0, 1).toUpperCase();

%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Patient Dashboard | CareWell Hospital</title>


<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/patient-common.css?v=4">

<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/patient-notifications.css?v=13">

<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/patient-dashboard.css?v=4">



<body>


<div class="page-container">

<!-- =========================
     PATIENT SIDEBAR
     ========================= -->

<aside class="sidebar">

    <!-- BRAND -->
    <div class="brand">

        <div class="brand-icon">♥︎</div>

        <div>
            <h2>CareWell</h2>
            <span>HOSPITAL</span>
        </div>

    </div>


    <!-- NAVIGATION -->
    <nav class="navigation">

        <!-- PATIENT PORTAL -->
        <div class="nav-section-title">
            PATIENT PORTAL
        </div>


        <!-- DASHBOARD -->
        <a href="<%= request.getContextPath() %>/patient/dashboard.jsp"
           class="nav-item active">

            <span class="nav-icon">🏠</span>
            <span>Dashboard</span>

        </a>


        <!-- MY APPOINTMENTS -->
        <a href="<%= request.getContextPath() %>/patient/appointments.jsp"
           class="nav-item">

            <span class="nav-icon">📅</span>
            <span>My Appointments</span>

        </a>


        <!-- BOOK APPOINTMENT -->
        <a href="<%= request.getContextPath() %>/patient/book-appointment.jsp"
           class="nav-item">

            <span class="nav-icon">📝</span>
            <span>Book Appointment</span>

        </a>


        <!-- MY HEALTH -->
        <div class="nav-section-title">
            MY HEALTH
        </div>


        <!-- MEDICAL RECORDS -->
        <a href="<%= request.getContextPath() %>/patient/medical-records.jsp"
           class="nav-item">

            <span class="nav-icon">🏥</span>
            <span>Medical Records</span>

        </a>


        <!-- PRESCRIPTIONS -->
        <a href="<%= request.getContextPath() %>/patient/prescriptions.jsp"
           class="nav-item">

            <span class="nav-icon">℞</span>
            <span>Prescriptions</span>

        </a>


        <!-- BILLS & PAYMENTS -->
        <a href="<%= request.getContextPath() %>/patient/bills.jsp"
           class="nav-item">

            <span class="nav-icon">💸</span>
            <span>Bills & Payments</span>

        </a>


        <!-- ACCOUNT -->
        <div class="nav-section-title">
            ACCOUNT
        </div>


        <!-- MY PROFILE -->
        <a href="<%= request.getContextPath() %>/patient/profile.jsp"
           class="nav-item">

            <span class="nav-icon">👤</span>
            <span>My Profile</span>

        </a>

    </nav>


    <!-- LOGOUT -->
    <div class="sidebar-bottom">

        <a href="<%= request.getContextPath() %>/LogoutController"
           class="nav-item logout">

            <span class="nav-icon">🏃🚪</span>
            <span>Logout</span>

        </a>

    </div>

</aside>

    <!-- =====================================================
         MAIN CONTENT
         ===================================================== -->

    <main class="main-content">


        <!-- TOP HEADER -->

        <header class="top-header">


            <div class="header-title">

                <h1>
                    Patient Dashboard
                </h1>

                <p>
                    Welcome back, <%= patientName %>
                </p>

            </div>


            <div class="header-actions">


                <!-- =================================================
                     NOTIFICATION
                     ================================================= -->

                <a href="<%= request.getContextPath() %>/patient/notifications.jsp"
                   class="notification-button"
                   title="View Notifications">

                    <span class="notification-icon">
                        🔔
                    </span>


                    <% if (notificationCount > 0) { %>

                        <span class="notification-count">
                            <%= notificationCount %>
                        </span>

                    <% } %>

                </a>


                <!-- =================================================
                     PATIENT PROFILE
                     ================================================= -->

                <a href="<%= request.getContextPath() %>/patient/profile.jsp"
                   class="patient-info">


                    <div class="patient-avatar">

                        <%= firstLetter %>

                    </div>


                    <div class="patient-details">

                        <strong>
                            <%= patientName %>
                        </strong>

                        <span>
                            Patient #<%= patient.getPatientId() %>
                        </span>

                    </div>


                </a>


            </div>


        </header>



        <!-- =====================================================
             CONTENT
             ===================================================== -->

        <section class="content">


            <!-- =================================================
                 WELCOME CARD
                 ================================================= -->

            <div class="welcome-card">


                <div class="welcome-text">

                    <span class="welcome-label">
                        PATIENT PORTAL
                    </span>


                    <h2>

                        Hello,
                        <%= patientName %>!

                    </h2>


                    <p>
                        Manage your appointments, medical records,
                        prescriptions and payments from one place.
                    </p>


                </div>


                <div class="welcome-icon">
                    ♥+
                </div>


            </div>



            <!-- =================================================
                 PATIENT SUMMARY
                 ================================================= -->

            <div class="summary-grid">


                <!-- PATIENT ID -->

                <div class="summary-card">

                    <div class="summary-icon blue">
                        👤
                    </div>


                    <div>

                        <span>
                            PATIENT ID
                        </span>

                        <strong>
                            #<%= patientId %>
                        </strong>

                    </div>

                </div>


                <!-- BLOOD GROUP -->

                <div class="summary-card">

                    <div class="summary-icon red">
                        ♥
                    </div>


                    <div>

                        <span>
                            BLOOD GROUP
                        </span>

                        <strong>

                            <%= patient.getBloodGroup() != null
                                    ? patient.getBloodGroup()
                                    : "Not Available" %>

                        </strong>

                    </div>

                </div>


                <!-- COMPLETED -->

                <div class="summary-card">

                    <div class="summary-icon green">
                        ✓
                    </div>


                    <div>

                        <span>
                            COMPLETED
                        </span>

                        <strong>
                            <%= completedAppointments %>
                        </strong>

                    </div>

                </div>


                <!-- UPCOMING -->

                <div class="summary-card">

                    <div class="summary-icon orange">
                        ◷
                    </div>


                    <div>

                        <span>
                            UPCOMING
                        </span>

                        <strong>
                            <%= upcomingAppointments %>
                        </strong>

                    </div>

                </div>


            </div>



            <!-- =================================================
                 NEXT APPOINTMENT
                 ================================================= -->

            <% if (nextAppointment != null) { %>


                <div class="next-appointment-card">


                    <div class="next-appointment-icon">
                        📅
                    </div>


                    <div class="next-appointment-content">


                        <span class="next-appointment-label">
                            NEXT APPOINTMENT
                        </span>


                        <h2>
                            <%= nextAppointment.getDoctorName() %>
                        </h2>


                        <p class="next-appointment-department">
                            <%= nextAppointment.getDepartmentName() %>
                        </p>


                        <div class="next-appointment-details">


                            <div class="appointment-detail">

                                <span>
                                    DATE
                                </span>

                                <strong>
                                    <%= nextAppointment.getAppointmentDate() %>
                                </strong>

                            </div>


                            <div class="appointment-detail">

                                <span>
                                    TIME
                                </span>

                                <strong>
                                    <%= nextAppointment.getAppointmentTime() %>
                                </strong>

                            </div>


                            <div class="appointment-detail">

                                <span>
                                    REASON
                                </span>

                                <strong>
                                    <%= nextAppointment.getReason() %>
                                </strong>

                            </div>


                        </div>


                    </div>


                    <div class="next-appointment-status">


                        <span class="next-status-badge">

                            <%= nextAppointment.getStatus() %>

                        </span>


                        <a href="<%= request.getContextPath() %>/patient/appointments.jsp"
                           class="view-appointment-btn">

                            View Appointment

                        </a>


                    </div>


                </div>


            <% } else { %>


                <div class="next-appointment-card no-next-appointment">


                    <div class="next-appointment-icon">
                        ✓
                    </div>


                    <div class="next-appointment-content">


                        <span class="next-appointment-label">
                            APPOINTMENTS
                        </span>


                        <h2>
                            No Upcoming Appointments
                        </h2>


                        <p>
                            You currently have no pending or confirmed appointments.
                        </p>


                    </div>


                </div>


            <% } %>



            <!-- =====================================================
                 NOTIFICATIONS
                 ===================================================== -->

            <div class="notifications-section"
                 id="notifications">


                <div class="section-header">


                    <div>

                        <h2>
                            Notifications
                        </h2>


                        <p>
                            Important updates about your appointments
                        </p>

                    </div>


                    <div class="notification-total">

                        <span>
                            🔔
                        </span>

                        <strong>
                            <%= notificationCount %>
                        </strong>

                    </div>


                </div>



                <div class="notifications-card">


                    <%
                        int displayedNotifications = 0;

                        if (appointments != null) {

                            for (AppointmentDetails appointment : appointments) {


                                if (displayedNotifications >= 4) {
                                    break;
                                }


                                String status =
                                        appointment.getStatus();


                                if (status == null) {
                                    continue;
                                }


                                /*
                                 * UPCOMING APPOINTMENT
                                 */

                                if (appointment.getAppointmentDate() != null
                                        && !appointment.getAppointmentDate().before(today)
                                        && ("PENDING".equalsIgnoreCase(status)
                                        || "CONFIRMED".equalsIgnoreCase(status))) {

                    %>


                    <div class="notification-item">


                        <div class="notification-item-icon appointment-notification">
                            📅
                        </div>


                        <div class="notification-content">


                            <strong>
                                Upcoming appointment
                            </strong>


                            <p>

                                Your appointment with

                                <strong>
                                    <%= appointment.getDoctorName() %>
                                </strong>

                                is scheduled for

                                <%= appointment.getAppointmentDate() %>

                                at

                                <%= appointment.getAppointmentTime() %>.

                            </p>


                        </div>


                        <span class="notification-status <%= status.toLowerCase() %>">

                            <%= status %>

                        </span>


                    </div>


                    <%

                                    displayedNotifications++;
                                }


                                /*
                                 * CANCELLED APPOINTMENT
                                 */

                                else if ("CANCELLED".equalsIgnoreCase(status)) {

                    %>


                    <div class="notification-item">


                        <div class="notification-item-icon cancelled-notification">
                            !
                        </div>


                        <div class="notification-content">


                            <strong>
                                Appointment cancelled
                            </strong>


                            <p>

                                Your appointment with

                                <strong>
                                    <%= appointment.getDoctorName() %>
                                </strong>

                                on

                                <%= appointment.getAppointmentDate() %>

                                has been cancelled.

                            </p>


                        </div>


                        <span class="notification-status cancelled">

                            CANCELLED

                        </span>


                    </div>


                    <%

                                    displayedNotifications++;
                                }

                            }

                        }


                        /*
                         * NO NOTIFICATIONS
                         */

                        if (displayedNotifications == 0) {

                    %>


                    <div class="no-notifications">


                        <div class="no-notification-icon">
                            ✓
                        </div>


                        <div>

                            <strong>
                                You're all caught up
                            </strong>


                            <p>
                                You don't have any new appointment notifications.
                            </p>

                        </div>


                    </div>


                    <%

                        }

                    %>


                </div>


            </div>



            <!-- =================================================
                 APPOINTMENT OVERVIEW
                 ================================================= -->

            <div class="section-header">


                <div>

                    <h2>
                        Appointment Overview
                    </h2>


                    <p>
                        Your recent and upcoming appointments
                    </p>

                </div>


                <div class="total-badge">

                    Total:

                    <strong>
                        <%= totalAppointments %>
                    </strong>

                </div>


            </div>



            <!-- =================================================
                 APPOINTMENT TABLE
                 ================================================= -->

            <div class="table-card">


                <div class="table-wrapper">


                    <table>


                        <thead>

                            <tr>

                                <th>
                                    ID
                                </th>

                                <th>
                                    DOCTOR
                                </th>

                                <th>
                                    DEPARTMENT
                                </th>

                                <th>
                                    DATE
                                </th>

                                <th>
                                    TIME
                                </th>

                                <th>
                                    REASON
                                </th>

                                <th>
                                    STATUS
                                </th>

                            </tr>

                        </thead>


                        <tbody>


                            <%
                                int appointmentCount = 0;


                                if (appointments != null
                                        && !appointments.isEmpty()) {


                                    for (AppointmentDetails appointment
                                            : appointments) {


                                        if (appointmentCount >= 5) {
                                            break;
                                        }


                                        String status =
                                                appointment.getStatus();


                                        String statusClass =
                                                status != null
                                                        ? status.toLowerCase()
                                                        : "pending";

                            %>


                            <tr>


                                <td>
                                    #<%= appointment.getAppointmentId() %>
                                </td>


                                <td>

                                    <strong>
                                        <%= appointment.getDoctorName() %>
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

                                        <%= status %>

                                    </span>

                                </td>


                            </tr>


                            <%

                                        appointmentCount++;

                                    }


                                } else {

                            %>


                            <tr>

                                <td colspan="7"
                                    class="no-data">

                                    No appointments found.

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

            <footer>

                © 2026 CareWell Hospital.
                Professional care, better health.

            </footer>


        </section>


    </main>


</div>


</body>

</html>