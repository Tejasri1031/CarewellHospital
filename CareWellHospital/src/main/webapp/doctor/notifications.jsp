<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.dao.NotificationDAO" %>
<%@ page import="com.daoimpl.NotificationDAOImpl" %>
<%@ page import="com.model.Notification" %>
<%@ page import ="com.model.User" %>

<%@ page import="com.dao.DoctorDAO" %>
<%@ page import="com.daoimpl.DoctorDAOImpl" %>
<%@ page import="com.model.Doctor" %>

<%
    // LOGIN CHECK
    User user = (User) session.getAttribute("user");


    if (user == null || !"DOCTOR".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );
        return;
    }

    int userId = user.getUserId();

    Doctor doctor = null;

    DoctorDAO doctorDAO = new DoctorDAOImpl();
    List<Doctor> doctors = doctorDAO.getAllDoctors();

    if (doctors != null) {
        for (Doctor item : doctors) {
            if (item.getUserId() == userId) {
                doctor = item;
                break;
            }
        }
    }
    
    NotificationDAO notificationDAO =
            new NotificationDAOImpl();

    // Mark this doctor's notifications as read.
    notificationDAO.markAllAsRead(userId);

    // Load notifications after marking them as read.
    List<Notification> notifications =
            notificationDAO.getNotificationsByUser(userId);

    int unreadCount =
            notificationDAO.getUnreadNotificationCount(userId);
%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Notifications | CareWell Hospital</title>



<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css">

<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/doctor-common.css">

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/doctor-notification.css">

<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/doctor-dashboard.css">

    
</head>


<body>


<div class="page-container">


    <!-- =========================
         SIDEBAR
         ========================= -->

    <aside class="sidebar">


        <!-- BRAND -->

        <div class="brand">

            <div class="brand-icon">
                ♥
            </div>

            <div>

                <h2>CareWell</h2>

                <span>HOSPITAL</span>

            </div>

        </div>


        <!-- DOCTOR PORTAL -->

        <div class="sidebar-section">

            <p class="section-title">
                DOCTOR PORTAL
            </p>


            <a href="<%= request.getContextPath() %>/doctor/dashboard.jsp"
               class="sidebar-link">

                <span>🏠</span>

                Dashboard

            </a>


            <a href="<%= request.getContextPath() %>/doctor/appointments.jsp"
               class="sidebar-link">

                <span>📅</span>

                My Appointments

            </a>

        </div>


        <!-- PATIENT CARE -->

        <div class="sidebar-section">

            <p class="section-title">
                PATIENT CARE
            </p>


            <a href="<%= request.getContextPath() %>/doctor/medical-records.jsp"
               class="sidebar-link">

                <span>🏥</span>

                Medical Records

            </a>


            <a href="<%= request.getContextPath() %>/doctor/prescriptions.jsp"
               class="sidebar-link">

                <span>℞</span>

                Prescriptions

            </a>
            
            <a href="<%= request.getContextPath() %>/doctor/add-prescriptions.jsp"
               class="sidebar-link">

                <span>📝</span>

               Add Prescriptions

            </a>

        </div>


        <!-- ACCOUNT -->

        <div class="sidebar-section">

            <p class="section-title">
                ACCOUNT
            </p>


            <a href="<%= request.getContextPath() %>/doctor/profile.jsp"
               class="sidebar-link">

                <span>👤</span>

                My Profile

            </a>

        </div>


        <!-- LOGOUT -->

        <div class="sidebar-bottom">

            <a href="<%= request.getContextPath() %>/LogoutController"
               class="sidebar-link">

                <span>🏃🚪</span>

                Logout

            </a>

        </div>


    </aside>


    <!-- =========================
         MAIN CONTENT
         ========================= -->

    <main class="main-content">


        <!-- TOP HEADER -->

        <header class="top-header">


            <div>

                <h1>
                    Notifications
                </h1>

                <p>
                    Stay updated with your patient care activities
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
           href="<%= request.getContextPath() %>/doctor/profile.jsp">
            ✏️ <span>Update Details</span>
        </a>

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


        <!-- =========================
             CONTENT
             ========================= -->

        <section class="content-area">


            <div class="page-title">

                <div>

                    <h2>
                        Notifications
                    </h2>

                    <p>
                        Important updates related to your patients
                    </p>

                </div>


                <div class="notification-count">
    <strong><%= unreadCount %></strong>
    <span>Unread Notifications</span>
</div>


            </div>


 		
<!-- NOTIFICATIONS -->

<% if (notifications == null || notifications.isEmpty()) { %>

    <div class="notification-empty">
        <div class="notification-icon" style="margin: 0 auto 16px;">
            ✓
        </div>

        <h3>You're all caught up</h3>

        <p>You don't have any notifications right now.</p>

        <div class="notification-actions"
             style="justify-content: center;">
            <a href="<%= request.getContextPath() %>/doctor/appointments.jsp"
               class="view-button">
                View Appointments
            </a>
        </div>
    </div>

<% } else {
       for (Notification notification : notifications) { %>

    <div class="notification-card">

        <div class="notification-icon">!</div>

        <div class="notification-content">

            <h3><%= notification.getTitle() %></h3>

            <p><%= notification.getMessage() %></p>

            <span class="notification-time">
                <%= notification.getCreatedAt() != null
                        ? notification.getCreatedAt()
                        : "" %>
            </span>

            <div class="notification-actions">
                <a href="<%= request.getContextPath() %>/doctor/appointments.jsp"
                   class="view-button">
                    View Appointments
                </a>
            </div>

        </div>

    </div>

<%   }
   } %>
</section>
 		






        <!-- FOOTER -->

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
