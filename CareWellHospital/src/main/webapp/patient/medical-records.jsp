<%@ page language="java" contentType="text/html; charset=UTF-8"

    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="com.dao.PrescriptionDetailsDAO" %>
<%@ page import="com.daoimpl.PrescriptionDetailsDAOImpl" %>
<%@ page import="com.model.PrescriptionDetails" %>

<%@ page import="com.dao.PatientDAO" %>

<%@ page import="com.dao.MedicalRecordDetailsDAO" %>

<%@ page import="com.daoimpl.PatientDAOImpl" %>

<%@ page import="com.daoimpl.MedicalRecordDetailsDAOImpl" %>

<%@ page import="com.model.User" %>

<%@ page import="com.model.Patient" %>

<%@ page import="com.model.MedicalRecordDetails" %>

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

    MedicalRecordDetailsDAO medicalRecordDetailsDAO =

            new MedicalRecordDetailsDAOImpl();

    List<MedicalRecordDetails> records =

            medicalRecordDetailsDAO

                    .getMedicalRecordDetailsByPatient(patientId);

    PrescriptionDetailsDAO prescriptionDetailsDAO =
            new PrescriptionDetailsDAOImpl();
    List<PrescriptionDetails> prescriptionDetails =
            prescriptionDetailsDAO.getPrescriptionDetailsByPatient(patientId);

    /* SHOW NEWEST PRESCRIPTIONS FIRST */
    if (prescriptionDetails != null) {
        Collections.sort(prescriptionDetails,
            new Comparator<PrescriptionDetails>() {
                @Override
                public int compare(PrescriptionDetails first,
                                   PrescriptionDetails second) {
                    java.sql.Date firstDate = first.getPrescriptionDate();
                    java.sql.Date secondDate = second.getPrescriptionDate();

                    if (firstDate == null && secondDate == null) {
                        return Integer.compare(
                            second.getPrescriptionId(),
                            first.getPrescriptionId());
                    }
                    if (firstDate == null) {
                        return 1;
                    }
                    if (secondDate == null) {
                        return -1;
                    }

                    int dateOrder = secondDate.compareTo(firstDate);
                    if (dateOrder != 0) {
                        return dateOrder;
                    }

                    return Integer.compare(
                        second.getPrescriptionId(),
                        first.getPrescriptionId());
                }
            });
    }

    int totalRecords = records == null ? 0 : records.size();

%>

<!DOCTYPE html>

<html>

   <head>

    <meta charset="UTF-8">

    <title>Medical Records - CareWell Hospital</title>

	
<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/patient-common.css?v=3">

<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/patient-medical-records.css?v=3">
	
   
</head>

<body>

<div class="layout">

 <!-- =========================

     PATIENT SIDEBAR

     \========================= -->

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

           class="nav-item active">

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

    <!-- =========================

         MAIN CONTENT

         \========================= -->

    <main class="main-content">

        <!-- HEADER -->

        <header class="top-header">

            <div>

                <h1>Medical Records</h1>

                <p>

                    View your medical history and doctor's records

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

        <section class="content">

            <!-- =========================

                 SUMMARY

                 \========================= -->

            <div class="summary-grid">

                <div class="summary-card">

                    <div class="summary-icon blue">

                        ▤

                    </div>

                    <div>

                        <span>Total Records</span>

                        <strong>

                            <%= totalRecords %>

                        </strong>

                    </div>

                </div>

                <div class="summary-card">

                    <div class="summary-icon green">

                        ✓

                    </div>

                    <div>

                        <span>Patient ID</span>

                        <strong>

                            \#<%= patient.getPatientId() %>

                        </strong>

                    </div>

                </div>

                <div class="summary-card">

                    <div class="summary-icon red">

                        ♥

                    </div>

                    <div>

                        <span>Blood Group</span>

                        <strong>

                            <%= patient.getBloodGroup() %>

                        </strong>

                    </div>

                </div>

                <div class="summary-card">

                    <div class="summary-icon purple">

                        \+

                    </div>

                    <div>

                        <span>Health Records</span>

                        <strong>

                            <%= totalRecords %>

                        </strong>

                    </div>

                </div>

            </div>

            <!-- =========================

                 SECTION HEADER

                 \========================= -->

            <div class="section-header">

                <div>

                    <h2>Medical Records</h2>

                    <p>

                        Your previous consultations and medical records

                    </p>

                </div>

                <div class="total-badge">

                    Total: <%= totalRecords %>

                </div>

            </div>

            <!-- =========================

                 RECORDS

                 \========================= -->

            <%

                if (records != null && !records.isEmpty()) {

                    for (MedicalRecordDetails record : records) {

            %>

            <div class="record-card">

                <!-- RECORD HEADER -->

                <div class="record-header">

                    <div class="record-title">

                        <div class="record-icon">

                            \+

                        </div>

                        <div>

                            <h3>

                                Medical Record #<%= record.getRecordId() %>

                            </h3>

                            <p>

                                Visit Date:

                                <%= record.getVisitDate() %>

                            </p>

                        </div>

                    </div>

                    <div class="doctor-info">

                        <span>CONSULTED DOCTOR</span>

                        <strong>

                            <%= record.getDoctorName() %>

                        </strong>

                    </div>

                </div>

                <!-- RECORD BODY -->

                <div class="record-body">

                    <div class="medical-section">

                        <div class="section-label">

                            SYMPTOMS

                        </div>

                        <div class="section-value">

                            <%= record.getSymptoms() %>

                        </div>

                    </div>

                    <div class="medical-section diagnosis-section">

                        <div class="section-label">

                            DIAGNOSIS

                        </div>

                        <div class="diagnosis-value">

                            <%= record.getDiagnosis() %>

                        </div>

                    </div>

                    <div class="vitals-grid">

                        <div class="vital-card">

                            <span>Blood Pressure</span>

                            <strong>

                                <%= record.getBloodPressure() %>

                            </strong>

                        </div>

                        <div class="vital-card">

                            <span>Temperature</span>

                            <strong>

                                <%= record.getTemperature() %>

                                °F

                            </strong>

                        </div>

                        <div class="vital-card">

                            <span>Weight</span>

                            <strong>

                                <%= record.getWeight() %>

                                kg

                            </strong>

                        </div>

                        <div class="vital-card">

                            <span>Appointment</span>

                            <strong>

                                \#<%= record.getAppointmentId() %>

                            </strong>

                        </div>

                    </div>

                    <!-- PRESCRIPTIONS LINKED TO THIS VISIT -->
                    <div class="medical-section prescription-section">
                        <div class="section-label">PRESCRIPTIONS</div>
                        <div class="prescription-list">
                            <%
                                Set<Integer> displayedPrescriptionIds = new HashSet<Integer>();
                                boolean hasPrescription = false;
                                if (prescriptionDetails != null && record.getAppointmentId() > 0) {
                                    for (PrescriptionDetails prescription : prescriptionDetails) {
                                        if (prescription.getAppointmentId() == record.getAppointmentId()
                                                && prescription.getPatientId() == patientId
                                                && prescription.getDoctorId() == record.getDoctorId()) {
                                            int prescriptionId = prescription.getPrescriptionId();
                                            if (displayedPrescriptionIds.add(prescriptionId)) {
                                                hasPrescription = true;
                            %>
                            <div class="patient-prescription-card">
                                <h4>Prescription #<%= prescriptionId %></h4>
                                <p class="prescription-date">Date: <%= prescription.getPrescriptionDate() %></p>
                                <div class="prescription-medicines">
                                    <%
                                        for (PrescriptionDetails medicine : prescriptionDetails) {
                                            if (medicine.getPrescriptionId() == prescriptionId
                                                    && medicine.getAppointmentId() == record.getAppointmentId()
                                                    && medicine.getPatientId() == patientId
                                                    && medicine.getDoctorId() == record.getDoctorId()) {
                                    %>
                                    <div class="patient-medicine">
                                        <strong><%= medicine.getMedicineName() == null ? "Medicine" : medicine.getMedicineName() %></strong>
                                        <p><b>Dosage:</b> <%= medicine.getDosage() == null ? "Not specified" : medicine.getDosage() %></p>
                                        <p><b>Frequency:</b> <%= medicine.getFrequency() == null ? "Not specified" : medicine.getFrequency() %></p>
                                        <p><b>Duration:</b> <%= medicine.getDuration() == null ? "Not specified" : medicine.getDuration() %></p>
                                        <% if (medicine.getMedicineInstructions() != null && !medicine.getMedicineInstructions().trim().isEmpty()) { %>
                                        <p><b>Instructions:</b> <%= medicine.getMedicineInstructions() %></p>
                                        <% } %>
                                    </div>
                                    <%
                                            }
                                        }
                                    %>
                                </div>
                                <% if (prescription.getInstructions() != null && !prescription.getInstructions().trim().isEmpty()) { %>
                                <p class="prescription-general"><b>General instructions:</b> <%= prescription.getInstructions() %></p>
                                <% } %>
                            </div>
                            <%
                                            }
                                        }
                                    }
                                }
                                if (!hasPrescription) {
                            %>
                            <p class="no-prescription">No prescription linked to this visit.</p>
                            <% } %>
                        </div>
                    </div>

                    <!-- DOCTOR NOTES -->

                    <div class="doctor-notes">

                        <div class="notes-icon">

                            ✎

                        </div>

                        <div>

                            <span>DOCTOR'S NOTES</span>

                            <p>

                                <%= record.getDoctorNotes() %>

                            </p>

                        </div>

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

                    \+

                </div>

                <h3>

                    No Medical Records Found

                </h3>

                <p>

                    You currently don't have any medical records.

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