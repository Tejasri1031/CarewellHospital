<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.dao.PatientDAO" %>
<%@ page import="com.dao.DoctorDAO" %>
<%@ page import="com.dao.AppointmentDAO" %>
<%@ page import="com.dao.BillDAO" %>
<%@ page import="com.daoimpl.PatientDAOImpl" %>
<%@ page import="com.daoimpl.DoctorDAOImpl" %>
<%@ page import="com.daoimpl.AppointmentDAOImpl" %>
<%@ page import="com.daoimpl.BillDAOImpl" %>
<%@ page import="com.model.Patient" %>
<%@ page import="com.model.Doctor" %>
<%@ page import="com.model.Appointment" %>
<%@ page import="com.model.Bill" %>

<%
    /* =====================================================
       LOGIN CHECK
       ===================================================== */

    if (session.getAttribute("user") == null) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );
        return;
    }

    String role = (String) session.getAttribute("role");

    if (role == null || !"ADMIN".equalsIgnoreCase(role)) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp?error=invalidRole"
        );
        return;
    }


    /* =====================================================
       LOAD DASHBOARD DATA
       ===================================================== */

    PatientDAO patientDAO = new PatientDAOImpl();
    DoctorDAO doctorDAO = new DoctorDAOImpl();
    AppointmentDAO appointmentDAO = new AppointmentDAOImpl();
    BillDAO billDAO = new BillDAOImpl();

    List<Patient> patients = patientDAO.getAllPatients();
    List<Doctor> doctors = doctorDAO.getAllDoctors();
    List<Appointment> appointments =
            appointmentDAO.getAllAppointments();
    List<Bill> bills = billDAO.getAllBills();


    int totalPatients = patients.size();
    int totalDoctors = doctors.size();
    int totalAppointments = appointments.size();

    int pendingAppointments = 0;
    int confirmedAppointments = 0;
    int completedAppointments = 0;

    double totalRevenue = 0;


    for (Appointment appointment : appointments) {

        if ("PENDING".equalsIgnoreCase(
                appointment.getStatus())) {

            pendingAppointments++;

        } else if ("CONFIRMED".equalsIgnoreCase(
                appointment.getStatus())) {

            confirmedAppointments++;

        } else if ("COMPLETED".equalsIgnoreCase(
                appointment.getStatus())) {

            completedAppointments++;
        }
    }


    for (Bill bill : bills) {

        if ("PAID".equalsIgnoreCase(
                bill.getPaymentStatus())) {

            totalRevenue += bill.getTotalAmount();
        }
    }


    String adminName = "Administrator";

    if (session.getAttribute("user") != null) {

        com.model.User loggedUser =
                (com.model.User) session.getAttribute("user");

        if (loggedUser.getFullName() != null) {
            adminName = loggedUser.getFullName();
        }
    }
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Admin Dashboard | CareWell Hospital</title>


    <!-- Font Awesome -->

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


    <!-- Main CSS -->

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

</head>


<body>


<!-- =====================================================
     SIDEBAR
     ===================================================== -->

<aside class="sidebar">


    <!-- Logo -->

    <div class="sidebar-logo">

        <div class="logo-icon">
            <i class="fa-solid fa-heart-pulse"></i>
        </div>

        <div class="logo-text">

            <h2>CareWell</h2>

            <span>Hospital</span>

        </div>

    </div>


    <!-- Navigation -->

    <nav class="sidebar-nav">


        <div class="nav-section-title">
            Main Menu
        </div>


        <a href="${pageContext.request.contextPath}/admin/dashboard.jsp"
           class="nav-item active">

            <i class="fa-solid fa-chart-pie"></i>

            Dashboard

        </a>


        <a href="${pageContext.request.contextPath}/doctors?action=list"
           class="nav-item">

            <i class="fa-solid fa-user-doctor"></i>

            Doctors

        </a>


        <a href="${pageContext.request.contextPath}/patients?action=list"
           class="nav-item">

            <i class="fa-solid fa-hospital-user"></i>

            Patients

        </a>


        <a href="${pageContext.request.contextPath}/departments?action=list"
           class="nav-item">

            <i class="fa-solid fa-building"></i>

            Departments

        </a>


        <a href="${pageContext.request.contextPath}/appointments?action=list"
           class="nav-item">

            <i class="fa-solid fa-calendar-check"></i>

            Appointments

        </a>


        <div class="nav-section-title">
            Medical
        </div>


        <a href="${pageContext.request.contextPath}/medical-records?action=list"
           class="nav-item">

            <i class="fa-solid fa-file-medical"></i>

            Medical Records

        </a>


        <a href="${pageContext.request.contextPath}/prescriptions?action=list"
           class="nav-item">

            <i class="fa-solid fa-prescription-bottle-medical"></i>

            Prescriptions

        </a>


        <a href="${pageContext.request.contextPath}/medicines?action=list"
           class="nav-item">

            <i class="fa-solid fa-pills"></i>

            Medicines

        </a>


        <div class="nav-section-title">
            Finance
        </div>


        <a href="${pageContext.request.contextPath}/bills?action=list"
           class="nav-item">

            <i class="fa-solid fa-file-invoice-dollar"></i>

            Billing

        </a>


        <a href="${pageContext.request.contextPath}/payments?action=list"
           class="nav-item">

            <i class="fa-solid fa-credit-card"></i>

            Payments

        </a>

    </nav>


    <!-- Bottom -->

    <div class="sidebar-bottom">

        <a href="${pageContext.request.contextPath}/logout"
           class="nav-item">

            <i class="fa-solid fa-right-from-bracket"></i>

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

            <div style="display:flex; align-items:center; gap:12px;">

                <button class="mobile-menu-btn">

                    <i class="fa-solid fa-bars"></i>

                </button>


                <div>

                    <h1>Dashboard</h1>

                    <p>
                        Hospital overview and management
                    </p>

                </div>

            </div>

        </div>


        <div class="topbar-right">


            <!-- Notification -->

            <a href="#"
               class="notification">

                <i class="fa-regular fa-bell"></i>

                <% if (pendingAppointments > 0) { %>

                    <span class="notification-badge">
                        <%= pendingAppointments %>
                    </span>

                <% } %>

            </a>


            <!-- User -->

            <div class="user-profile">

                <div class="avatar">

                    <%= adminName.substring(0, 1).toUpperCase() %>

                </div>

                <div class="user-info">

                    <strong>
                        <%= adminName %>
                    </strong>

                    <span>
                        Administrator
                    </span>

                </div>

            </div>

        </div>

    </header>



    <!-- PAGE CONTENT -->

    <section class="page-content">


        <!-- Welcome -->

        <div class="page-header">

            <div class="page-title">

                <h2>
                    Good Morning, <%= adminName %> 👋
                </h2>

                <p>
                    Here's what's happening at CareWell Hospital today.
                </p>

            </div>


            <a href="${pageContext.request.contextPath}/appointments?action=list"
               class="btn btn-primary">

                <i class="fa-solid fa-calendar-plus"></i>

                View Appointments

            </a>

        </div>



        <!-- =================================================
             STATISTICS
             ================================================= -->

        <div class="stats-grid">


            <!-- Patients -->

            <div class="stat-card">

                <div class="stat-top">

                    <div>

                        <div class="stat-label">
                            Total Patients
                        </div>

                    </div>

                    <div class="stat-icon blue">

                        <i class="fa-solid fa-hospital-user"></i>

                    </div>

                </div>


                <div class="stat-number">

                    <%= totalPatients %>

                </div>

                <div class="stat-change positive">

                    <i class="fa-solid fa-arrow-up"></i>

                    Registered patients

                </div>

            </div>



            <!-- Doctors -->

            <div class="stat-card">

                <div class="stat-top">

                    <div>

                        <div class="stat-label">
                            Medical Doctors
                        </div>

                    </div>

                    <div class="stat-icon teal">

                        <i class="fa-solid fa-user-doctor"></i>

                    </div>

                </div>


                <div class="stat-number">

                    <%= totalDoctors %>

                </div>

                <div class="stat-change positive">

                    <i class="fa-solid fa-circle-check"></i>

                    Active medical team

                </div>

            </div>



            <!-- Appointments -->

            <div class="stat-card">

                <div class="stat-top">

                    <div>

                        <div class="stat-label">
                            Appointments
                        </div>

                    </div>

                    <div class="stat-icon orange">

                        <i class="fa-solid fa-calendar-check"></i>

                    </div>

                </div>


                <div class="stat-number">

                    <%= totalAppointments %>

                </div>

                <div class="stat-change positive">

                    <i class="fa-solid fa-clock"></i>

                    <%= pendingAppointments %> pending

                </div>

            </div>



            <!-- Revenue -->

            <div class="stat-card">

                <div class="stat-top">

                    <div>

                        <div class="stat-label">
                            Total Revenue
                        </div>

                    </div>

                    <div class="stat-icon green">

                        <i class="fa-solid fa-indian-rupee-sign"></i>

                    </div>

                </div>


                <div class="stat-number"
                     style="font-size:22px;">

                    ₹<%= String.format("%.2f", totalRevenue) %>

                </div>

                <div class="stat-change positive">

                    <i class="fa-solid fa-circle-check"></i>

                    Paid bills

                </div>

            </div>

        </div>



        <!-- =================================================
             DASHBOARD GRID
             ================================================= -->

        <div class="dashboard-grid">


            <!-- Appointment Overview -->

            <div class="card">

                <div class="card-header">

                    <div>

                        <div class="card-title">
                            Appointment Overview
                        </div>

                        <div class="card-subtitle">
                            Current appointment status
                        </div>

                    </div>

                    <i class="fa-solid fa-chart-column"
                       style="color:#2563eb;">
                    </i>

                </div>


                <div class="card-body">


                    <!-- Completed -->

                    <div style="margin-bottom:20px;">

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
                                    (completedAppointments * 100 / totalAppointments) %>%;
                                background:#16a34a;
                                border-radius:20px;
                            ">
                            </div>

                        </div>

                    </div>



                    <!-- Confirmed -->

                    <div style="margin-bottom:20px;">

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
                                    (confirmedAppointments * 100 / totalAppointments) %>%;
                                background:#0284c7;
                                border-radius:20px;
                            ">
                            </div>

                        </div>

                    </div>



                    <!-- Pending -->

                    <div>

                        <div style="
                            display:flex;
                            justify-content:space-between;
                            font-size:12px;
                            margin-bottom:7px;
                        ">

                            <strong>
                                Pending
                            </strong>

                            <span>
                                <%= pendingAppointments %>
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
                                    (pendingAppointments * 100 / totalAppointments) %>%;
                                background:#f59e0b;
                                border-radius:20px;
                            ">
                            </div>

                        </div>

                    </div>

                </div>

            </div>



            <!-- Quick Actions -->

            <div class="card">

                <div class="card-header">

                    <div>

                        <div class="card-title">
                            Quick Actions
                        </div>

                        <div class="card-subtitle">
                            Manage hospital services
                        </div>

                    </div>

                    <i class="fa-solid fa-bolt"
                       style="color:#f59e0b;">
                    </i>

                </div>


                <div class="card-body">

                    <div class="quick-actions">


                        <a href="${pageContext.request.contextPath}/patients?action=list"
                           class="quick-action">

                            <div class="quick-action-icon">

                                <i class="fa-solid fa-user-plus"></i>

                            </div>

                            <span>
                                Patients
                            </span>

                        </a>


                        <a href="${pageContext.request.contextPath}/doctors?action=list"
                           class="quick-action">

                            <div class="quick-action-icon">

                                <i class="fa-solid fa-user-doctor"></i>

                            </div>

                            <span>
                                Doctors
                            </span>

                        </a>


                        <a href="${pageContext.request.contextPath}/appointments?action=list"
                           class="quick-action">

                            <div class="quick-action-icon">

                                <i class="fa-solid fa-calendar-plus"></i>

                            </div>

                            <span>
                                Appointments
                            </span>

                        </a>


                        <a href="${pageContext.request.contextPath}/medicines?action=list"
                           class="quick-action">

                            <div class="quick-action-icon">

                                <i class="fa-solid fa-pills"></i>

                            </div>

                            <span>
                                Medicines
                            </span>

                        </a>


                        <a href="${pageContext.request.contextPath}/bills?action=list"
                           class="quick-action">

                            <div class="quick-action-icon">

                                <i class="fa-solid fa-file-invoice"></i>

                            </div>

                            <span>
                                Billing
                            </span>

                        </a>


                        <a href="${pageContext.request.contextPath}/payments?action=list"
                           class="quick-action">

                            <div class="quick-action-icon">

                                <i class="fa-solid fa-credit-card"></i>

                            </div>

                            <span>
                                Payments
                            </span>

                        </a>

                    </div>

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
                        Recent Appointments
                    </div>

                    <div class="card-subtitle">
                        Latest appointments in the hospital
                    </div>

                </div>


                <a href="${pageContext.request.contextPath}/appointments?action=list"
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

                            <th>Patient ID</th>

                            <th>Doctor ID</th>

                            <th>Date</th>

                            <th>Time</th>

                            <th>Reason</th>

                            <th>Status</th>

                        </tr>

                    </thead>


                    <tbody>

                    <%
                        int displayCount = 0;

                        for (Appointment appointment : appointments) {

                            if (displayCount >= 5) {
                                break;
                            }

                            String statusClass = "status-neutral";

                            if ("COMPLETED".equalsIgnoreCase(
                                    appointment.getStatus())) {

                                statusClass = "status-success";

                            } else if ("CONFIRMED".equalsIgnoreCase(
                                    appointment.getStatus())) {

                                statusClass = "status-info";

                            } else if ("PENDING".equalsIgnoreCase(
                                    appointment.getStatus())) {

                                statusClass = "status-warning";

                            } else if ("CANCELLED".equalsIgnoreCase(
                                    appointment.getStatus())) {

                                statusClass = "status-danger";
                            }
                    %>

                        <tr>

                            <td>
                                #<%= appointment.getAppointmentId() %>
                            </td>

                            <td>
                                Patient #<%= appointment.getPatientId() %>
                            </td>

                            <td>
                                Doctor #<%= appointment.getDoctorId() %>
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
                                        There are no appointments to display.
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
            All rights reserved.

        </div>

    </section>

</main>


</body>

</html>