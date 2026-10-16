<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.dao.PatientDAO" %>
<%@ page import="com.daoimpl.PatientDAOImpl" %>
<%@ page import="com.model.User" %>
<%@ page import="com.model.Patient" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || !"PATIENT".equals(user.getRole())) {
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
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>My Profile | CareWell Hospital</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/patient-common.css?v=2">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/patient-profile.css?v=2">
</head>

<body>

<div class="layout">

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
           class="nav-item active">

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
    <!-- =========================
         MAIN CONTENT
         ========================= -->

    <main class="main-content">


        <!-- HEADER -->

        <header class="top-header">

            <div>

                <h1>My Profile</h1>

                <p>
                    View your personal and emergency contact information
                </p>

            </div>


            <div class="user-profile">

                <div class="user-avatar">

                    <%= user.getFullName()
                            .substring(0, 1)
                            .toUpperCase() %>

                </div>


                <div class="user-info">

                    <strong>
                        <%= user.getFullName() %>
                    </strong>

                    <span>
                        Patient #<%= patient.getPatientId() %>
                    </span>

                </div>

            </div>

        </header>


        <section class="content">


            <!-- =========================
                 PROFILE OVERVIEW
                 ========================= -->

            <div class="profile-overview">

                <div class="large-avatar">

                    <%= user.getFullName()
                            .substring(0, 1)
                            .toUpperCase() %>

                </div>


                <div class="profile-heading">

                    <h2>
                        <%= user.getFullName() %>
                    </h2>

                    <p>
                        Patient #<%= patient.getPatientId() %>
                    </p>

                    <span class="patient-badge">
                        PATIENT
                    </span>

                </div>

            </div>


            <!-- =========================
                 PERSONAL INFORMATION
                 ========================= -->

            <div class="section-header">

                <div>

                    <h2>Personal Information</h2>

                    <p>
                        Your registered personal details
                    </p>

                </div>

            </div>


            <div class="profile-card">

                <div class="details-grid">


                    <div class="detail-item">

                        <span>FULL NAME</span>

                        <strong>
                            <%= user.getFullName() %>
                        </strong>

                    </div>


                    <div class="detail-item">

                        <span>EMAIL ADDRESS</span>

                        <strong>
                            <%= user.getEmail() %>
                        </strong>

                    </div>


                    <div class="detail-item">

                        <span>PHONE NUMBER</span>

                        <strong>
                            <%= user.getPhone() %>
                        </strong>

                    </div>


                    <div class="detail-item">

                        <span>PATIENT ID</span>

                        <strong>
                            #<%= patient.getPatientId() %>
                        </strong>

                    </div>


                    <div class="detail-item">

    <span>DATE OF BIRTH</span>

    <strong>
        <%= patient.getDateOfBirth() %>
    </strong>

</div>

                    <div class="detail-item">

                        <span>GENDER</span>

                        <strong>
                            <%= patient.getGender() %>
                        </strong>

                    </div>


                    <div class="detail-item">

                        <span>BLOOD GROUP</span>

                        <strong class="blood-group">
                            <%= patient.getBloodGroup() %>
                        </strong>

                    </div>


                    <div class="detail-item">

                        <span>ACCOUNT STATUS</span>

                        <strong class="active-status">
                            <%= user.getStatus() %>
                        </strong>

                    </div>


                    <div class="detail-item full-width">

                        <span>ADDRESS</span>

                        <strong>
                            <%= patient.getAddress() %>
                        </strong>

                    </div>

                </div>

            </div>


            <!-- =========================
                 EMERGENCY CONTACT
                 ========================= -->

            <div class="section-header emergency-header">

                <div>

                    <h2>Emergency Contact</h2>

                    <p>
                        Person to contact in case of an emergency
                    </p>

                </div>

            </div>


            <div class="emergency-card">

                <div class="emergency-icon">
                    +
                </div>


               <div class="emergency-details">

    <div>

        <span>CONTACT NAME</span>

        <strong>
            <%= patient.getEmergencyContactName() %>
        </strong>

    </div>


    <div>

        <span>PHONE NUMBER</span>

        <strong>
            <%= patient.getEmergencyContactPhone() %>
        </strong>

    </div>

</div>

            </div>


            <!-- =========================
                 ACCOUNT INFORMATION
                 ========================= -->

            <div class="section-header account-header">

                <div>

                    <h2>Account Information</h2>

                    <p>
                        Information about your CareWell Hospital account
                    </p>

                </div>

            </div>


            <div class="account-card">

                <div class="account-item">

                    <span>USER ID</span>

                    <strong>
                        #<%= user.getUserId() %>
                    </strong>

                </div>


                <div class="account-item">

                    <span>ROLE</span>

                    <strong>
                        <%= user.getRole() %>
                    </strong>

                </div>


                <div class="account-item">

                    <span>ACCOUNT CREATED</span>

                    <strong>
                        <%= user.getCreatedAt() %>
                    </strong>

                </div>


                <div class="account-item">

                    <span>STATUS</span>

                    <strong class="active-status">
                        <%= user.getStatus() %>
                    </strong>

                </div>

            </div>


            <!-- =========================
                 INFORMATION NOTE
                 ========================= -->

            <div class="information-card">

                <div class="information-icon">
                    ℹ
                </div>

                <div>

                    <h3>Profile Information</h3>

                    <p>
                        Your profile information is maintained by
                        CareWell Hospital. Please contact the hospital
                        administration if any of your personal or
                        emergency contact details need to be updated.
                    </p>

                </div>

            </div>


        </section>


        <!-- FOOTER -->

        <footer class="footer">

            <span>
                © 2026 CareWell Hospital
            </span>

            <span>
                Patient Portal
            </span>

        </footer>


    </main>

</div>

</body>

</html>