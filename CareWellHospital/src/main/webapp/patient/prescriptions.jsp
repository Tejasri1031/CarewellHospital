<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.Map" %>

<%@ page import="com.dao.PatientDAO" %>
<%@ page import="com.dao.PrescriptionDetailsDAO" %>

<%@ page import="com.daoimpl.PatientDAOImpl" %>
<%@ page import="com.daoimpl.PrescriptionDetailsDAOImpl" %>

<%@ page import="com.model.User" %>
<%@ page import="com.model.Patient" %>
<%@ page import="com.model.PrescriptionDetails" %>

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

    int patientId = patient.getPatientId();

    PrescriptionDetailsDAO prescriptionDetailsDAO =
            new PrescriptionDetailsDAOImpl();

    List<PrescriptionDetails> prescriptionDetails =
            prescriptionDetailsDAO
                    .getPrescriptionDetailsByPatient(patientId);


    /*
     * Group medicine rows by prescription.
     * One prescription can contain multiple medicines.
     */

    Map<Integer, List<PrescriptionDetails>> groupedPrescriptions =
            new LinkedHashMap<>();

    for (PrescriptionDetails detail : prescriptionDetails) {

        if (!groupedPrescriptions.containsKey(
                detail.getPrescriptionId())) {

            groupedPrescriptions.put(
                    detail.getPrescriptionId(),
                    new java.util.ArrayList<PrescriptionDetails>()
            );
        }

        groupedPrescriptions
                .get(detail.getPrescriptionId())
                .add(detail);
    }

    int totalPrescriptions = groupedPrescriptions.size();
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Prescriptions | CareWell Hospital</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/patient-common.css?v=2">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/patient-prescriptions.css?v=2">
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
           class="nav-item active">

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
    <!-- =========================
         MAIN CONTENT
         ========================= -->

    <main class="main-content">


        <!-- HEADER -->

        <header class="top-header">

            <div>

                <h1>My Prescriptions</h1>

                <p>
                    View your prescribed medicines and instructions
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
                 SUMMARY
                 ========================= -->

            <div class="summary-grid">


                <div class="summary-card">

                    <div class="summary-icon blue">
                        ℞
                    </div>

                    <div>

                        <span>Total Prescriptions</span>

                        <strong>
                            <%= totalPrescriptions %>
                        </strong>

                    </div>

                </div>


                <div class="summary-card">

                    <div class="summary-icon green">
                        +
                    </div>

                    <div>

                        <span>Patient ID</span>

                        <strong>
                            #<%= patient.getPatientId() %>
                        </strong>

                    </div>

                </div>


                <div class="summary-card">

                    <div class="summary-icon purple">
                        💊
                    </div>

                    <div>

                        <span>Medicines</span>

                        <strong>
                            <%= prescriptionDetails.size() %>
                        </strong>

                    </div>

                </div>


                <div class="summary-card">

                    <div class="summary-icon orange">
                        ✓
                    </div>

                    <div>

                        <span>Health Plan</span>

                        <strong>
                            Active
                        </strong>

                    </div>

                </div>

            </div>


            <!-- =========================
                 SECTION HEADER
                 ========================= -->

            <div class="section-header">

                <div>

                    <h2>Prescription History</h2>

                    <p>
                        Medicines prescribed by your doctors
                    </p>

                </div>


                <div class="total-badge">

                    Total: <%= totalPrescriptions %>

                </div>

            </div>


            <!-- =========================
                 PRESCRIPTIONS
                 ========================= -->

            <%

                if (groupedPrescriptions != null
                        && !groupedPrescriptions.isEmpty()) {

                    for (Map.Entry<Integer,
                            List<PrescriptionDetails>> entry
                            : groupedPrescriptions.entrySet()) {

                        List<PrescriptionDetails> medicines =
                                entry.getValue();

                        PrescriptionDetails first =
                                medicines.get(0);

            %>


            <div class="prescription-card">


                <!-- PRESCRIPTION HEADER -->

                <div class="prescription-header">


                    <div class="prescription-title">

                        <div class="prescription-icon">
                            ℞
                        </div>


                        <div>

                            <h3>
                                Prescription #<%= first.getPrescriptionId() %>
                            </h3>

                            <p>
                                Date:
                                <%= first.getPrescriptionDate() %>
                            </p>

                        </div>

                    </div>


                    <div class="doctor-info">

                        <span>PRESCRIBED BY</span>

                        <strong>
                            <%= first.getDoctorName() %>
                        </strong>

                    </div>

                </div>


                <!-- PRESCRIPTION META -->

                <div class="prescription-meta">

                    <div>

                        <span>APPOINTMENT</span>

                        <strong>
                            #<%= first.getAppointmentId() %>
                        </strong>

                    </div>


                    <div>

                        <span>PATIENT</span>

                        <strong>
                            <%= first.getPatientName() %>
                        </strong>

                    </div>

                </div>


                <!-- MEDICINES -->

                <div class="medicine-section">

                    <div class="section-label">
                        PRESCRIBED MEDICINES
                    </div>


                    <div class="medicine-list">


                        <%
                            for (PrescriptionDetails medicine
                                    : medicines) {
                        %>


                        <div class="medicine-item">


                            <div class="medicine-top">

                                <div class="medicine-name">

                                    <strong>
                                        <%= medicine.getMedicineName() %>
                                    </strong>

                                    <span>
                                        <%= medicine.getMedicineType() %>
                                    </span>

                                </div>

                            </div>


                            <div class="medicine-details">


                                <div>

                                    <span>Dosage</span>

                                    <strong>
                                        <%= medicine.getDosage() %>
                                    </strong>

                                </div>


                                <div>

                                    <span>Frequency</span>

                                    <strong>
                                        <%= medicine.getFrequency() %>
                                    </strong>

                                </div>


                                <div>

                                    <span>Duration</span>

                                    <strong>
                                        <%= medicine.getDuration() %>
                                    </strong>

                                </div>


                            </div>


                            <%
                                if (medicine.getMedicineInstructions()
                                        != null
                                        && !medicine
                                        .getMedicineInstructions()
                                        .trim()
                                        .isEmpty()) {
                            %>


                            <div class="medicine-instruction">

                                <strong>
                                    Instructions:
                                </strong>

                                <%= medicine.getMedicineInstructions() %>

                            </div>


                            <%
                                }
                            %>


                        </div>


                        <%
                            }
                        %>


                    </div>

                </div>


                <!-- GENERAL INSTRUCTIONS -->

                <div class="general-instructions">

                    <div class="instruction-icon">
                        ℹ
                    </div>


                    <div>

                        <span>
                            GENERAL INSTRUCTIONS
                        </span>

                        <p>
                            <%= first.getInstructions() %>
                        </p>

                    </div>

                </div>


            </div>


            <%
                    }

                } else {
            %>


            <!-- EMPTY STATE -->

            <div class="empty-state">

                <div class="empty-icon">
                    ℞
                </div>

                <h3>
                    No Prescriptions Found
                </h3>

                <p>
                    You currently don't have any prescriptions.
                </p>

            </div>


            <%
                }
            %>


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