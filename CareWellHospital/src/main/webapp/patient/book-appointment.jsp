<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>

<%@ page import="com.dao.DepartmentDAO" %>
<%@ page import="com.dao.DoctorDAO" %>
<%@ page import="com.dao.PatientDAO" %>

<%@ page import="com.daoimpl.DepartmentDAOImpl" %>
<%@ page import="com.daoimpl.DoctorDAOImpl" %>
<%@ page import="com.daoimpl.PatientDAOImpl" %>

<%@ page import="com.model.User" %>
<%@ page import="com.model.Patient" %>
<%@ page import="com.model.Department" %>
<%@ page import="com.model.Doctor" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || !"PATIENT".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );
        return;
    }

    int userId = user.getUserId();

    PatientDAO patientDAO = new PatientDAOImpl();

    Patient patient = patientDAO.getPatientByUserId(userId);

    if (patient == null) {
        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );
        return;
    }

    int patientId = patient.getPatientId();

    DepartmentDAO departmentDAO =
            new DepartmentDAOImpl();

    DoctorDAO doctorDAO =
            new DoctorDAOImpl();

    List<Department> departments =
            departmentDAO.getAllDepartments();

    List<Doctor> doctors =
            doctorDAO.getAllDoctors();

    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Book Appointment - CareWell Hospital</title>

   <link rel="stylesheet" href="<%= request.getContextPath() %>/css/patient-common.css?v=2">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/patient-book-appointment.css?v=2">
   
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
           class="nav-item">

            <span class="nav-icon">📅</span>
            <span>My Appointments</span>

        </a>


        <!-- BOOK APPOINTMENT -->
        <a href="<%= request.getContextPath() %>/patient/book-appointment.jsp"
           class="nav-item active">

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


    <!-- =========================
         MAIN CONTENT
         ========================= -->

    <main class="main-content">


        <!-- HEADER -->

        <header class="top-header">

            <div class="header-left">

                <h1>
                    Book Appointment
                </h1>

                <p>
                    Schedule an appointment with our doctors
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


        <!-- =========================
             BOOKING CONTENT
             ========================= -->

        <section class="booking-section">


            <div class="booking-intro">

                <div class="booking-icon">
                    📅
                </div>

                <div>

                    <h2>
                        Schedule Your Appointment
                    </h2>

                    <p>
                        Please provide the details below to book
                        an appointment with one of our doctors.
                    </p>

                </div>

            </div>


			<% if ("booked".equals(request.getParameter("success"))) { %>

    <div class="success-message">

        <div class="success-icon">
            ✓
        </div>

        <div class="success-content">

            <strong>
                Appointment Booked Successfully!
            </strong>

            <p>
                Your appointment request has been submitted successfully
                and is currently pending confirmation.
            </p>

            <a href="<%= request.getContextPath() %>/patient/appointments.jsp"
               class="success-link">

                View My Appointments

            </a>

        </div>

    </div>

<% } %>


<% if ("slotUnavailable".equals(error)) { %>

    <div class="warning-message">

        <div class="warning-icon">
            !
        </div>

        <div class="warning-content">

            <strong>
                Appointment Slot Unavailable
            </strong>

            <p>
                This doctor already has an appointment at the selected
                date and time. Please choose another time.
            </p>

        </div>

    </div>

<% } %>


<% if ("bookingFailed".equals(error)) { %>

    <div class="error-message">

        Unable to book the appointment.
        Please try again.

    </div>

<% } %>


<% if ("invalidData".equals(error)) { %>

    <div class="error-message">

        Please enter valid appointment details.

    </div>

<% } %>


            <!-- BOOKING FORM -->

            <form action="<%= request.getContextPath() %>/appointments"
                  method="post"
                  class="booking-form">


                <input type="hidden"
                       name="action"
                       value="add">


                <!-- Patient ID comes from logged-in patient -->

                <input type="hidden"
                       name="patientId"
                       value="<%= patientId %>">


                <!-- =========================
                     DOCTOR & DEPARTMENT
                     ========================= -->

                <div class="form-section">

                    <h3>
                        Doctor & Department
                    </h3>


                    <div class="form-row">


                        <!-- DEPARTMENT -->

                        <div class="form-group">

                            <label for="departmentId">

                                Department

                                <span>
                                    *
                                </span>

                            </label>


                            <select id="departmentId"
                                    name="departmentId"
                                    required>

                                <option value="">
                                    Select Department
                                </option>


                                <% for (Department department : departments) { %>

                                    <option value="<%= department.getDepartmentId() %>">

                                        <%= department.getDepartmentName() %>

                                    </option>

                                <% } %>

                            </select>

                        </div>


                        <!-- DOCTOR -->

                        <div class="form-group">

                            <label for="doctorId">

                                Doctor

                                <span>
                                    *
                                </span>

                            </label>


                            <select id="doctorId"
                                    name="doctorId"
                                    required>

                                <option value="">
                                    Select Doctor
                                </option>


                                <%
                                    com.dao.UserDAO userDAO =
                                            new com.daoimpl.UserDAOImpl();

                                    for (Doctor doctor : doctors) {

                                        User doctorUser =
                                                userDAO.getUserById(
                                                        doctor.getUserId()
                                                );

                                        if (doctorUser != null) {
                                %>

                                    <option value="<%= doctor.getDoctorId() %>">

                                        Dr. <%= doctorUser.getFullName() %>
                                        -
                                        <%= doctor.getSpecialization() %>

                                    </option>

                                <%
                                        }
                                    }
                                %>

                            </select>

                        </div>

                    </div>

                </div>


                <!-- =========================
                     APPOINTMENT DETAILS
                     ========================= -->

                <div class="form-section">

                    <h3>
                        Appointment Details
                    </h3>


                    <div class="form-row">


                        <!-- DATE -->

                        <div class="form-group">

                            <label for="appointmentDate">

                                Appointment Date

                                <span>
                                    *
                                </span>

                            </label>


                            <input type="date"
                                   id="appointmentDate"
                                   name="appointmentDate"
                                   required>

                        </div>


                        <!-- TIME -->

                        <div class="form-group">

                            <label for="appointmentTime">

                                Appointment Time

                                <span>
                                    *
                                </span>

                            </label>


                            <input type="time"
                                   id="appointmentTime"
                                   name="appointmentTime"
                                   required>

                        </div>

                    </div>


                    <!-- REASON -->

                    <div class="form-group full-width">

                        <label for="reason">

                            Reason for Visit

                            <span>
                                *
                            </span>

                        </label>


                        <textarea id="reason"
                                  name="reason"
                                  rows="4"
                                  placeholder="Briefly describe the reason for your visit..."
                                  required></textarea>

                    </div>


                    <!-- NOTES -->

                    <div class="form-group full-width">

                        <label for="notes">

                            Additional Notes

                            <span class="optional">
                                Optional
                            </span>

                        </label>


                        <textarea id="notes"
                                  name="notes"
                                  rows="3"
                                  placeholder="Any additional information you want the doctor to know..."></textarea>

                    </div>

                </div>


                <!-- =========================
                     CONFIRMATION INFORMATION
                     ========================= -->

                <div class="booking-info">

                    <div class="info-icon">
                        ℹ
                    </div>


                    <div>

                        <strong>
                            Appointment Confirmation
                        </strong>


                        <p>

                            Your appointment will initially be marked
                            as <b>Pending</b>. The hospital will confirm
                            your appointment after reviewing the request.

                        </p>

                    </div>

                </div>


                <!-- =========================
                     BUTTONS
                     ========================= -->

                <div class="form-actions">


                    <a href="<%= request.getContextPath() %>/patient/dashboard.jsp"
                       class="cancel-button">

                        Cancel

                    </a>


                    <button type="submit"
                            class="book-button">

                        Book Appointment

                    </button>

                </div>


            </form>

        </section>


        <!-- FOOTER -->

        <footer>

            <p>
                © 2026 CareWell Hospital. All rights reserved.
            </p>

        </footer>


    </main>

</div>

</body>

</html>