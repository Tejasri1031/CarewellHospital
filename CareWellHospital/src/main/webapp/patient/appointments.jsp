<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>

<%@ page import="com.dao.PatientDAO" %>
<%@ page import="com.dao.AppointmentDetailsDAO" %>

<%@ page import="com.daoimpl.PatientDAOImpl" %>
<%@ page import="com.daoimpl.AppointmentDetailsDAOImpl" %>

<%@ page import="com.model.User" %>
<%@ page import="com.model.Patient" %>
<%@ page import="com.model.AppointmentDetails" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || !"PATIENT".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    int userId = user.getUserId();

    PatientDAO patientDAO = new PatientDAOImpl();
    Patient patient = patientDAO.getPatientByUserId(userId);

    if (patient == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    int patientId = patient.getPatientId();

    AppointmentDetailsDAO appointmentDetailsDAO =
            new AppointmentDetailsDAOImpl();

    List<AppointmentDetails> appointments =
            appointmentDetailsDAO
                    .getAppointmentDetailsByPatient(patientId);

    int totalAppointments = appointments.size();
    int pendingAppointments = 0;
    int confirmedAppointments = 0;
    int completedAppointments = 0;
    int cancelledAppointments = 0;

    for (AppointmentDetails appointment : appointments) {

        String status = appointment.getStatus();

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
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>My Appointments | CareWell Hospital</title>

<link rel="stylesheet" href="<%= request.getContextPath() %>/css/patient-common.css?v=2">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/patient-appointments.css?v=2">
 
</head>

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
           class="nav-item">

            <span class="nav-icon">🏠</span>
            <span>Dashboard</span>

        </a>


        <!-- MY APPOINTMENTS -->
        <a href="<%= request.getContextPath() %>/patient/appointments.jsp"
           class="nav-item active">

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


        <!-- HEADER -->

        <header class="top-header">

            <div>

                <h1>My Appointments</h1>

                <p>
                    View and track all your hospital appointments
                </p>

            </div>


            <a href="<%= request.getContextPath() %>/patient/profile.jsp"
               class="patient-info">

                <div class="patient-avatar">
                   <%= user.getFullName().substring(0, 1).toUpperCase() %>
                </div>

                <div>

                    <strong>
                      <%= user.getFullName() %>
                    </strong>

                    <span>
                        Patient #<%= patient.getPatientId() %>
                    </span>

                </div>

            </a>

        </header>



        <!-- CONTENT -->

        <section class="content">


            <!-- PAGE INTRO -->

            <div class="page-intro">

                <div>

                    <span class="intro-label">
                        PATIENT PORTAL
                    </span>

                    <h2>
                        Your Appointments
                    </h2>

                    <p>
                        Keep track of your upcoming and previous
                        consultations with CareWell Hospital doctors.
                    </p>

                </div>

                <div class="intro-icon">
                    📅
                </div>

            </div>



            <!-- SUMMARY -->

            <div class="summary-grid">


                <div class="summary-card">

                    <div class="summary-icon blue">
                        #
                    </div>

                    <div>

                        <span>
                            TOTAL
                        </span>

                        <strong>
                            <%= totalAppointments %>
                        </strong>

                    </div>

                </div>


                <div class="summary-card">

                    <div class="summary-icon orange">
                        ◷
                    </div>

                    <div>

                        <span>
                            PENDING
                        </span>

                        <strong>
                            <%= pendingAppointments %>
                        </strong>

                    </div>

                </div>


                <div class="summary-card">

                    <div class="summary-icon purple">
                        ✓
                    </div>

                    <div>

                        <span>
                            CONFIRMED
                        </span>

                        <strong>
                            <%= confirmedAppointments %>
                        </strong>

                    </div>

                </div>


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


            </div>



            <!-- APPOINTMENTS -->

            <div class="section-header">

                <div>

                    <h2>
                        Appointment History
                    </h2>

                    <p>
                        All appointments associated with your account
                    </p>

                </div>

                <div class="total-badge">

                    Total:
                    <strong>
                        <%= totalAppointments %>
                    </strong>

                </div>

            </div>



            <div class="table-card">

                <div class="table-wrapper">

                    <table>

                        <thead>

                            <tr>

                                <th>ID</th>

                                <th>DOCTOR</th>

                                <th>DEPARTMENT</th>

                                <th>DATE</th>

                                <th>TIME</th>

                                <th>REASON</th>

                                <th>STATUS</th>

                                <th>NOTES</th>

                            </tr>

                        </thead>


                        <tbody>

                        <% if (appointments.isEmpty()) { %>

                            <tr>

                                <td colspan="8"
                                    class="no-data">

                                    No appointments found.

                                </td>

                            </tr>

                        <% } else { %>


                            <% for (AppointmentDetails appointment : appointments) { %>

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

                                    <span class="reason-text">
                                        <%= appointment.getReason() %>
                                    </span>

                                </td>


                                <td>

                                    <%
                                        String statusClass =
                                                appointment.getStatus()
                                                        .toLowerCase();
                                    %>

                                    <span class="status <%= statusClass %>">

                                        <%= appointment.getStatus() %>

                                    </span>

                                </td>


                                <td>

                                    <% if (appointment.getNotes() != null
                                            && !appointment.getNotes().trim().isEmpty()) { %>

                                        <span class="notes-text">
                                            <%= appointment.getNotes() %>
                                        </span>

                                    <% } else { %>

                                        <span class="no-notes">
                                            —
                                        </span>

                                    <% } %>

                                </td>

                            </tr>

                            <% } %>

                        <% } %>

                        </tbody>

                    </table>

                </div>

            </div>



            <!-- STATUS INFORMATION -->

            <div class="status-info">

                <div class="status-info-item">

                    <span class="status-dot pending-dot"></span>

                    <div>

                        <strong>
                            Pending
                        </strong>

                        <p>
                            Appointment is waiting for confirmation.
                        </p>

                    </div>

                </div>


                <div class="status-info-item">

                    <span class="status-dot confirmed-dot"></span>

                    <div>

                        <strong>
                            Confirmed
                        </strong>

                        <p>
                            Your appointment has been confirmed.
                        </p>

                    </div>

                </div>


                <div class="status-info-item">

                    <span class="status-dot completed-dot"></span>

                    <div>

                        <strong>
                            Completed
                        </strong>

                        <p>
                            Consultation has been completed.
                        </p>

                    </div>

                </div>


                <div class="status-info-item">

                    <span class="status-dot cancelled-dot"></span>

                    <div>

                        <strong>
                            Cancelled
                        </strong>

                        <p>
                            This appointment was cancelled.
                        </p>

                    </div>

                </div>

            </div>


            <footer>

                © 2026 CareWell Hospital.
                Patient healthcare management system.

            </footer>


        </section>

    </main>

</div>

</body>
</html>