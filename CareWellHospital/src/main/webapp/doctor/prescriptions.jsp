<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.Map" %>

<%@ page import="com.dao.DoctorDAO" %>
<%@ page import="com.dao.PrescriptionDetailsDAO" %>

<%@ page import="com.daoimpl.DoctorDAOImpl" %>
<%@ page import="com.daoimpl.PrescriptionDetailsDAOImpl" %>

<%@ page import="com.model.User" %>
<%@ page import="com.model.Doctor" %>
<%@ page import="com.model.PrescriptionDetails" %>


<%
    /* =====================================================
       LOGIN CHECK
       ===================================================== */

    User user = (User) session.getAttribute("user");

    if (user == null || !"DOCTOR".equals(user.getRole())) {

        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );

        return;
    }


    /* =====================================================
       FIND LOGGED-IN DOCTOR
       ===================================================== */

    int userId = user.getUserId();

    DoctorDAO doctorDAO = new DoctorDAOImpl();

    Doctor doctor = null;

    List<Doctor> allDoctors =
            doctorDAO.getAllDoctors();

    for (Doctor d : allDoctors) {

        if (d.getUserId() == userId) {

            doctor = d;
            break;
        }
    }


    if (doctor == null) {

        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );

        return;
    }


    int doctorId = doctor.getDoctorId();


    /* =====================================================
       LOAD PRESCRIPTION DETAILS
       ===================================================== */

    PrescriptionDetailsDAO prescriptionDetailsDAO =
            new PrescriptionDetailsDAOImpl();

    List<PrescriptionDetails> prescriptionDetails =
            prescriptionDetailsDAO
                    .getPrescriptionDetailsByDoctor(doctorId);


    /* =====================================================
       GROUP MEDICINES BY PRESCRIPTION
       ===================================================== */

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


    /* =====================================================
       DOCTOR DISPLAY DATA
       ===================================================== */

    String doctorName = user.getFullName();

    String firstLetter =
            doctorName.substring(0, 1).toUpperCase();
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Prescriptions | CareWell Hospital</title>


<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/doctor-common.css">

<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/doctor-dashboard.css">

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/doctor-prescriptions.css">
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

            <a class="sidebar-link"
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
            
            
            <a class="sidebar-link active"
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

            <a class="sidebar-link ""
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


    <!-- =================================================
         MAIN CONTENT
         ================================================= -->

    <main class="main-content">


        <header class="top-header">


            <div>

                <h1>
                    Prescriptions
                </h1>

                <p>
                    Manage prescriptions created for your patients
                </p>

            </div>


            <div class="doctor-account-menu">
                <button type="button"
                        class="user-profile doctor-profile-trigger"
                        id="doctorProfileTrigger"
                        aria-expanded="false"
                        aria-controls="doctorProfileDropdown">
                    <div class="avatar"><%= firstLetter %></div>
                    <div class="user-info">
                        <strong><%= doctorName == null ? "Doctor" : doctorName %></strong>
                        <span><%= doctor.getSpecialization() == null ? "" : doctor.getSpecialization() %></span>
                    </div>
                    <span class="doctor-chevron" aria-hidden="true">⌄</span>
                </button>
                <div class="doctor-dropdown" id="doctorProfileDropdown" hidden>
                    <a class="doctor-dropdown-item"
                       href="<%= request.getContextPath() %>/doctor/profile.jsp">✏️ <span>Update Details</span></a>
                    <a class="doctor-dropdown-item"
                       href="<%= request.getContextPath() %>/doctor/change-password.jsp">🔒 <span>Change Password</span></a>
                    <div class="doctor-dropdown-divider"></div>
                    <a class="doctor-dropdown-item logout-item"
                       href="<%= request.getContextPath() %>/LogoutController">🚪 <span>Logout</span></a>
                </div>
            </div>


        </header>



        <!-- =================================================
             PAGE CONTENT
             ================================================= -->

        <section class="content-area">


            <div class="page-title">


                <div>

                    <h2>
                        Prescriptions
                    </h2>

                    <p>
                        Prescriptions issued during patient consultations
                    </p>

                </div>


                <div class="prescription-count">

                    <strong>
                        <%= groupedPrescriptions.size() %>
                    </strong>

                    <span>
                        Total Prescriptions
                    </span>

                </div>


            </div>



            <!-- =================================================
                 PRESCRIPTION TABLE
                 ================================================= -->

            <div class="table-card">


                <div class="table-header">

                    <div>

                        <h3>
                            Prescription List
                        </h3>

                        <p>
                            Prescriptions and medicines issued by you
                        </p>

                    </div>

                </div>


                <div class="table-container">


                    <table>


                        <thead>

                            <tr>

                                <th>
                                    PRESCRIPTION ID
                                </th>

                                <th>
                                    PATIENT
                                </th>

                                <th>
                                    APPOINTMENT
                                </th>

                                <th>
                                    DATE
                                </th>

                                <th>
                                    MEDICINES
                                </th>

                                <th>
                                    GENERAL INSTRUCTIONS
                                </th>

                            </tr>

                        </thead>


                        <tbody>


                        <%
                            if (!groupedPrescriptions.isEmpty()) {

                                for (
                                    Map.Entry<Integer,
                                    List<PrescriptionDetails>> entry
                                    : groupedPrescriptions.entrySet()
                                ) {

                                    List<PrescriptionDetails> medicines =
                                            entry.getValue();

                                    PrescriptionDetails first =
                                            medicines.get(0);
                        %>


                            <tr>


                                <td>

                                    <strong>
                                        #<%= first.getPrescriptionId() %>
                                    </strong>

                                </td>


                                <td>

                                    <strong>
                                        <%= first.getPatientName() %>
                                    </strong>

                                </td>


                                <td>

                                    #<%= first.getAppointmentId() %>

                                </td>


                                <td>

                                    <%= first.getPrescriptionDate() %>

                                </td>


                                <td>

                                    <div class="medicine-list">


                                    <%
                                        for (PrescriptionDetails medicine
                                                : medicines) {
                                    %>


                                        <div class="medicine-item">


                                            <div class="medicine-name">

                                                <strong>
                                                    <%= medicine.getMedicineName() %>
                                                </strong>

                                                <span>
                                                    <%= medicine.getMedicineType() %>
                                                </span>

                                            </div>


                                            <div class="medicine-details">

                                                <span>
                                                    <b>Dosage:</b>
                                                    <%= medicine.getDosage() %>
                                                </span>

                                                <span>
                                                    <b>Frequency:</b>
                                                    <%= medicine.getFrequency() %>
                                                </span>

                                                <span>
                                                    <b>Duration:</b>
                                                    <%= medicine.getDuration() %>
                                                </span>

                                            </div>


                                            <%
                                                if (medicine
                                                        .getMedicineInstructions()
                                                        != null
                                                        && !medicine
                                                        .getMedicineInstructions()
                                                        .trim()
                                                        .isEmpty()) {
                                            %>

                                                <div class="medicine-instruction">

                                                    <%= medicine
                                                            .getMedicineInstructions() %>

                                                </div>

                                            <%
                                                }
                                            %>


                                        </div>


                                    <%
                                        }
                                    %>


                                    </div>

                                </td>


                                <td>

                                    <div class="general-instructions">

                                        <%= first.getInstructions() %>

                                    </div>

                                </td>


                            </tr>


                        <%
                                }

                            } else {
                        %>


                            <tr>

                                <td colspan="6"
                                    class="no-data">

                                    No prescriptions found.

                                </td>

                            </tr>


                        <%
                            }
                        %>


                        </tbody>


                    </table>


                </div>


            </div>


        </section>



        <footer>

            © 2026 CareWell Hospital.
            Professional care, better health.

        </footer>


    </main>


</div>


<script>
document.addEventListener("DOMContentLoaded", function () {
    const profileButton = document.getElementById("doctorProfileTrigger");
    const profileDropdown = document.getElementById("doctorProfileDropdown");

    if (!profileButton || !profileDropdown) {
        console.error("Doctor profile dropdown elements were not found.");
        return;
    }

    function openDropdown() {
        profileDropdown.hidden = false;
        profileButton.setAttribute("aria-expanded", "true");
    }

    function closeDropdown() {
        profileDropdown.hidden = true;
        profileButton.setAttribute("aria-expanded", "false");
    }

    profileButton.addEventListener("click", function (event) {
        event.preventDefault();
        event.stopPropagation();

        if (profileDropdown.hidden) {
            openDropdown();
        } else {
            closeDropdown();
        }
    });

    profileDropdown.addEventListener("click", function (event) {
        event.stopPropagation();
    });

    document.addEventListener("click", function (event) {
        if (!profileButton.contains(event.target) &&
            !profileDropdown.contains(event.target)) {
            closeDropdown();
        }
    });

    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape") {
            closeDropdown();
            profileButton.focus();
        }
    });
});
</script>
</body>
</html>

