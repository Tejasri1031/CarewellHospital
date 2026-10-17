<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.model.User"%>
<%@ page import="com.model.Doctor"%>
<%@ page import="com.model.Department"%>
<%@ page import="com.dao.DoctorDAO"%>
<%@ page import="com.dao.DepartmentDAO"%>
<%@ page import="com.daoimpl.DoctorDAOImpl"%>
<%@ page import="com.daoimpl.DepartmentDAOImpl"%>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || !"DOCTOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    int userId = user.getUserId();

    DoctorDAO doctorDAO = new DoctorDAOImpl();

    Doctor doctor = null;

    for (Doctor d : doctorDAO.getAllDoctors()) {
        if (d.getUserId() == userId) {
            doctor = d;
            break;
        }
    }

    if (doctor == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Department department = null;

    DepartmentDAO departmentDAO = new DepartmentDAOImpl();

    for (Department d : departmentDAO.getAllDepartments()) {
        if (d.getDepartmentId() == doctor.getDepartmentId()) {
            department = d;
            break;
        }
    }
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>My Profile | CareWell Hospital</title>

   <!-- Shared Doctor Portal CSS -->
<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/doctor-common.css">

<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/doctor-dashboard.css">


<!-- Doctor Profile page -->
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/doctor-profile.css">
   
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

            <a class="sidebar-link active"
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

    <!-- ================= MAIN CONTENT ================= -->

    <main class="main-content">

        <!-- HEADER -->

        <header class="top-header">

            <div>

                <h1>My Profile</h1>

                <p>
                    View your professional and account information
                </p>

            </div>
<div class="doctor-account-menu">

    <button type="button"
            class="user-profile doctor-profile-trigger"
            id="doctorProfileTrigger"
            aria-expanded="false"
            aria-controls="doctorProfileDropdown">

       <div class="avatar">
    <%= (user.getFullName() != null && !user.getFullName().trim().isEmpty())
            ? user.getFullName().trim().substring(0, 1).toUpperCase()
            : "D" %>
</div>

<div class="user-info">
    <strong><%= user.getFullName() != null
            ? user.getFullName() : "Doctor" %></strong>

    <span><%= doctor.getSpecialization() != null
            ? doctor.getSpecialization() : "" %></span>
</div>

        <span class="doctor-chevron" aria-hidden="true">⌄</span>
    </button>

    <div class="doctor-dropdown" id="doctorProfileDropdown" hidden>

        <a class="doctor-dropdown-item"
           href="<%= request.getContextPath() %>/doctor/update-details.jsp" class="doctor-dropdown-item">✏️<span>Update Details</span></a>
   
        <a class="doctor-dropdown-item"
           href="<%= request.getContextPath() %>/doctor/change-password.jsp">
            🔒 <span>Change Password</span>
        </a>

        <div class="doctor-dropdown-divider"></div>

        <a class="doctor-dropdown-item logout-item"
           href="<%= request.getContextPath() %>/LogoutController">
            🚪 <span>Logout</span>
        </a>

    </div>
</div>

        </header>


        <!-- ================= PROFILE ================= -->

        <section class="profile-section">

            <div class="profile-card">

                <div class="profile-header">

                    <div class="large-avatar">
                        D
                    </div>

                    <div>

                        <h2>
                            Dr. <%= user.getFullName() %>
                        </h2>

                        <p>
                            <%= doctor.getSpecialization() %>
                        </p>

                        <span class="availability-badge">
                            <%= doctor.getAvailabilityStatus() %>
                        </span>

                    </div>

                </div>


                <!-- PROFESSIONAL INFORMATION -->

                <div class="information-section">

                    <h3>Professional Information</h3>

                    <div class="information-grid">

                        <div class="information-item">

                            <label>Specialization</label>

                            <p>
                                <%= doctor.getSpecialization() %>
                            </p>

                        </div>


                        <div class="information-item">

                            <label>Department</label>

                            <p>
                                <%= department != null
                                    ? department.getDepartmentName()
                                    : "Not Available" %>
                            </p>

                        </div>


                        <div class="information-item">

                            <label>Qualification</label>

                            <p>
                                <%= doctor.getQualification() %>
                            </p>

                        </div>


                        <div class="information-item">

                            <label>Experience</label>

                            <p>
                                <%= doctor.getExperienceYears() %> years
                            </p>

                        </div>


                        <div class="information-item">

                            <label>Consultation Fee</label>

                            <p>
                                ₹<%= doctor.getConsultationFee() %>
                            </p>

                        </div>


                        <div class="information-item">

                            <label>Availability</label>

                            <p>
                                <%= doctor.getAvailabilityStatus() %>
                            </p>

                        </div>

                    </div>

                </div>


                <!-- ACCOUNT INFORMATION -->

                <div class="information-section">

                    <h3>Account Information</h3>

                    <div class="information-grid">

                        <div class="information-item">

                            <label>Full Name</label>

                            <p>
                                <%= user.getFullName() %>
                            </p>

                        </div>


                        <div class="information-item">

                            <label>Email</label>

                            <p>
                                <%= user.getEmail() %>
                            </p>

                        </div>


                        <div class="information-item">

                            <label>Phone</label>

                            <p>
                                <%= user.getPhone() %>
                            </p>

                        </div>


                        <div class="information-item">

                            <label>Account Status</label>

                            <p>
                                <%= user.getStatus() %>
                            </p>

                        </div>

                    </div>

                </div>


                <!-- BIO -->

                <div class="information-section">

                    <h3>Professional Bio</h3>

                    <div class="bio-box">

                        <%
                            String bio = doctor.getBio();

                            if (bio != null && !bio.trim().isEmpty()) {
                        %>

                            <p>
                                <%= bio %>
                            </p>

                        <%
                            } else {
                        %>

                            <p class="empty-bio">
                                No professional bio has been added yet.
                            </p>

                        <%
                            }
                        %>

                    </div>

                </div>

            </div>

        </section>


        <!-- FOOTER -->

        <footer class="footer">

            © 2026 CareWell Hospital. Professional care, better health.

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
