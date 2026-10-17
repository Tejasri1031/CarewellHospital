<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>

<%@ page import="com.dao.DoctorDAO" %>

<%@ page import="com.daoimpl.DoctorDAOImpl" %>

<%@ page import="com.model.User" %>

<%@ page import="com.model.Doctor" %>

<%@ page import="com.model.AppointmentDetails" %>



<%

    User user = (User) session.getAttribute("user");



    if (user == null || !"DOCTOR".equalsIgnoreCase(user.getRole())) {

        response.sendRedirect(request.getContextPath() + "/login.jsp");

        return;

    }



    DoctorDAO doctorDAO = new DoctorDAOImpl();

    Doctor doctor = null;

    List<Doctor> allDoctors = doctorDAO.getAllDoctors();



    if (allDoctors != null) {

        for (Doctor item : allDoctors) {

            if (item.getUserId() == user.getUserId()) {

                doctor = item;

                break;

            }

        }

    }



    if (doctor == null) {

        response.sendRedirect(request.getContextPath() + "/login.jsp?error=doctorNotFound");

        return;

    }



    String doctorName = user.getFullName();

    String firstLetter = (doctorName != null && !doctorName.trim().isEmpty())

            ? doctorName.trim().substring(0, 1).toUpperCase() : "D";



    String selectedStatus = (String) request.getAttribute("selectedStatus");

    if (selectedStatus == null) selectedStatus = request.getParameter("status");

    if (selectedStatus == null || selectedStatus.trim().isEmpty()) selectedStatus = "ALL";

    selectedStatus = selectedStatus.trim().toUpperCase();



    String selectedDateFilter = (String) request.getAttribute("selectedDateFilter");

    if (selectedDateFilter == null) selectedDateFilter = request.getParameter("dateFilter");

    if ((selectedDateFilter == null || selectedDateFilter.trim().isEmpty())

            && "today".equalsIgnoreCase(request.getParameter("filter"))) {

        selectedDateFilter = "TODAY";

    }

    if (selectedDateFilter == null || selectedDateFilter.trim().isEmpty()) selectedDateFilter = "ALL";

    selectedDateFilter = selectedDateFilter.trim().toUpperCase();



    String selectedAppointmentDate = (String) request.getAttribute("selectedAppointmentDate");

    if (selectedAppointmentDate == null) selectedAppointmentDate = request.getParameter("appointmentDate");

    if (selectedAppointmentDate == null) selectedAppointmentDate = "";



    @SuppressWarnings("unchecked")

    List<AppointmentDetails> appointments =

            (List<AppointmentDetails>) request.getAttribute("appointments");



    // Fallback for direct JSP access. Normal requests should go through /appointments?action=doctor.

    if (appointments == null) {

        response.sendRedirect(request.getContextPath() + "/appointments?action=doctor");

        return;

    }

%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>My Appointments | CareWell Hospital</title>

   
<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/doctor-common.css">

<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/doctor-dashboard.css">

<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/doctor-appointments.css">
   
   
</head>

<body>

<div class="page-container">

    <aside class="sidebar">

        <div class="brand">

            <div class="brand-icon">♥︎</div>

            <div>

                <h2>CareWell</h2>

                <span>HOSPITAL</span>

            </div>

        </div>



        <div class="sidebar-section">

            <p class="section-title">DOCTOR PORTAL</p>

            <a class="sidebar-link" href="<%= request.getContextPath() %>/doctor/dashboard.jsp">

                <span class="menu-icon">🏠</span> Dashboard

            </a>

            <a class="sidebar-link active" href="<%= request.getContextPath() %>/appointments?action=doctor">

                <span class="menu-icon">📅</span> My Appointments

            </a>

        </div>



        <div class="sidebar-section">

            <p class="section-title">PATIENT CARE</p>

            <a class="sidebar-link" href="<%= request.getContextPath() %>/doctor/medical-records.jsp">

                <span class="menu-icon">🏥</span> Medical Records

            </a>

            <a class="sidebar-link" href="<%= request.getContextPath() %>/doctor/prescriptions.jsp">

                <span class="menu-icon">℞</span> Prescriptions

            </a>

            <a class="sidebar-link" href="<%= request.getContextPath() %>/doctor/add-prescription.jsp">

                <span class="menu-icon">📝</span> Add Prescription

            </a>

        </div>



        <div class="sidebar-section">

            <p class="section-title">ACCOUNT</p>

            <a class="sidebar-link" href="<%= request.getContextPath() %>/doctor/profile.jsp">

                <span class="menu-icon">👤</span> My Profile

            </a>

        </div>



        <div class="sidebar-bottom">

            <a class="sidebar-link" href="<%= request.getContextPath() %>/LogoutController">

                <span class="menu-icon">🏃🚪</span> Logout

            </a>

        </div>

    </aside>



    <main class="main-content">

        <header class="top-header">

            <div>

                <h1>My Appointments</h1>

                <p>View and manage your patient appointments</p>

            </div>

            <div class="doctor-account-menu">
    <button type="button"
            class="user-profile doctor-profile-trigger"
            id="doctorProfileTrigger"
            aria-expanded="false"
            aria-controls="doctorProfileDropdown">

        <div class="avatar"><%= firstLetter %></div>

        <div class="user-info">
            <strong><%= doctorName %></strong>
            <span><%= doctor.getSpecialization() %></span>
        </div>

        <span class="doctor-chevron" aria-hidden="true">⌄</span>
    </button>

    <div class="doctor-dropdown" id="doctorProfileDropdown" hidden>
        <a class="doctor-dropdown-item"
           href="<%= request.getContextPath() %>/doctor/update-details.jsp">
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



        <section class="content-area">

            <div class="page-title">

                <div>

                    <h2>Appointments</h2>

                    <p>

                        <% if (!"ALL".equals(selectedStatus) && !"ALL".equals(selectedDateFilter)) { %>

                            Showing <%= selectedStatus.toLowerCase() %> appointments for the selected date range

                        <% } else if (!"ALL".equals(selectedStatus)) { %>

                            Showing <%= selectedStatus.toLowerCase() %> appointments

                        <% } else if (!"ALL".equals(selectedDateFilter)) { %>

                            Showing appointments for the selected date range

                        <% } else { %>

                            All appointments assigned to you

                        <% } %>

                    </p>

                </div>

                <div class="appointment-count">

                    <strong><%= appointments.size() %></strong>

                    <span>Appointments Shown</span>

                </div>

            </div>


<div class="appointments-card">

    <div class="appointments-heading">
        <h3>Appointment List</h3>
    </div>

    <form class="appointment-filters"
          action="<%= request.getContextPath() %>/appointments"
          method="get">

        <input type="hidden" name="action" value="doctor">

        <div class="filter-field">
            <label for="statusFilter">Filter by status</label>
            <select id="statusFilter" name="status">
                <option value="ALL" <%= "ALL".equals(selectedStatus) ? "selected" : "" %>>All statuses</option>
                <option value="PENDING" <%= "PENDING".equals(selectedStatus) ? "selected" : "" %>>Pending</option>
                <option value="CONFIRMED" <%= "CONFIRMED".equals(selectedStatus) ? "selected" : "" %>>Confirmed</option>
                <option value="COMPLETED" <%= "COMPLETED".equals(selectedStatus) ? "selected" : "" %>>Completed</option>
                <option value="CANCELLED" <%= "CANCELLED".equals(selectedStatus) ? "selected" : "" %>>Cancelled</option>
            </select>
        </div>

        <div class="filter-field">
            <label for="dateFilter">Filter by date</label>
            <select id="dateFilter" name="dateFilter">
                <option value="ALL" <%= "ALL".equals(selectedDateFilter) ? "selected" : "" %>>All dates</option>
                <option value="TODAY" <%= "TODAY".equals(selectedDateFilter) ? "selected" : "" %>>Today</option>
                <option value="UPCOMING" <%= "UPCOMING".equals(selectedDateFilter) ? "selected" : "" %>>Upcoming</option>
                <option value="PAST" <%= "PAST".equals(selectedDateFilter) ? "selected" : "" %>>Past</option>
                <option value="CUSTOM" <%= "CUSTOM".equals(selectedDateFilter) ? "selected" : "" %>>Custom date</option>
            </select>
        </div>

        <div class="filter-field custom-date-field"
             id="customDateField"
             style="<%= "CUSTOM".equals(selectedDateFilter) ? "display:flex;" : "display:none;" %>">

            <label for="appointmentDate">Choose date</label>
            <input type="date"
                   id="appointmentDate"
                   name="appointmentDate"
                   value="<%= selectedAppointmentDate %>"
                   <%= "CUSTOM".equals(selectedDateFilter) ? "required" : "" %>>
        </div>

        <button type="submit" class="filter-submit">
            Apply Filters
        </button>
    </form>

    <p class="filter-note">
        Combine a status and date filter to narrow your appointments.
    </p>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Patient</th>
                    <th>Department</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Reason</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>

            <tbody>
                <% if (!appointments.isEmpty()) {
                    for (AppointmentDetails appointment : appointments) {
                        String appointmentStatus = appointment.getStatus();
                        String statusClass = appointmentStatus == null
                                ? ""
                                : appointmentStatus.toLowerCase();
                %>
                <tr>
                    <td>#<%= appointment.getAppointmentId() %></td>
                    <td><strong><%= appointment.getPatientName() == null ? "" : appointment.getPatientName() %></strong></td>
                    <td><%= appointment.getDepartmentName() == null ? "" : appointment.getDepartmentName() %></td>
                    <td><%= appointment.getAppointmentDate() == null ? "" : appointment.getAppointmentDate() %></td>
                    <td><%= appointment.getAppointmentTime() == null ? "" : appointment.getAppointmentTime() %></td>
                    <td><%= appointment.getReason() == null ? "" : appointment.getReason() %></td>
                    <td>
                        <span class="status <%= statusClass %>">
                            <%= appointmentStatus == null ? "UNKNOWN" : appointmentStatus %>
                        </span>
                    </td>
                    <td>
                        <% if ("PENDING".equalsIgnoreCase(appointmentStatus)) { %>
                            <div class="appointment-actions">
                                <form method="post" action="<%= request.getContextPath() %>/appointments">
                                    <input type="hidden" name="action" value="confirm">
                                    <input type="hidden" name="appointmentId" value="<%= appointment.getAppointmentId() %>">
                                    <button type="submit" class="action-btn confirm-btn">✓ Confirm</button>
                                </form>

                                <form method="post" action="<%= request.getContextPath() %>/appointments">
                                    <input type="hidden" name="action" value="cancel">
                                    <input type="hidden" name="appointmentId" value="<%= appointment.getAppointmentId() %>">
                                    <button type="submit" class="action-btn cancel-btn">✕ Cancel</button>
                                </form>
                            </div>
                        <% } else if ("CONFIRMED".equalsIgnoreCase(appointmentStatus)) { %>
                            <span class="action-completed">✓ Confirmed</span>
                        <% } else if ("CANCELLED".equalsIgnoreCase(appointmentStatus)) { %>
                            <span class="action-cancelled">✕ Cancelled</span>
                        <% } else if ("COMPLETED".equalsIgnoreCase(appointmentStatus)) { %>
                            <span class="action-completed">✓ Completed</span>
                        <% } %>
                    </td>
                </tr>
                <% }
                } else { %>
                <tr>
                    <td colspan="8" class="no-data">
                        No appointments found for the selected filters.
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

</div>

        </section>

        <footer>© 2026 CareWell Hospital. Professional care, better health.</footer>

    </main>

</div>



<script>
document.addEventListener("DOMContentLoaded", function () {

    /* Custom date filter */
    const dateFilter = document.getElementById("dateFilter");
    const dateField = document.getElementById("customDateField");
    const dateInput = document.getElementById("appointmentDate");

    if (dateFilter && dateField && dateInput) {
        function updateDateField() {
            const isCustom = dateFilter.value === "CUSTOM";

            dateField.style.display = isCustom ? "flex" : "none";
            dateInput.required = isCustom;

            if (!isCustom) {
                dateInput.value = "";
            }
        }

        dateFilter.addEventListener("change", updateDateField);
        updateDateField();
    }

    /* Doctor profile dropdown */
    const accountMenu = document.querySelector(".doctor-account-menu");
    const profileTrigger = document.getElementById("doctorProfileTrigger");
    const profileDropdown = document.getElementById("doctorProfileDropdown");

    if (!accountMenu || !profileTrigger || !profileDropdown) {
        console.error("Profile dropdown elements were not found.", {
            accountMenu: !!accountMenu,
            profileTrigger: !!profileTrigger,
            profileDropdown: !!profileDropdown
        });
        return;
    }

    function setDropdown(open) {
        profileDropdown.hidden = !open;
        profileTrigger.setAttribute("aria-expanded", String(open));
    }

    profileTrigger.addEventListener("click", function (event) {
        event.preventDefault();
        event.stopPropagation();

        setDropdown(profileDropdown.hidden);
    });

    profileDropdown.addEventListener("click", function (event) {
        event.stopPropagation();
    });

    document.addEventListener("click", function (event) {
        if (!accountMenu.contains(event.target)) {
            setDropdown(false);
        }
    });

    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape") {
            setDropdown(false);
        }
    });

    setDropdown(false);
});
</script>
</body>
</html>
