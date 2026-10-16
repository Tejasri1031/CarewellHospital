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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/doctor-common.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/doctor-appointments.css">

    <style>
        .table-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
        }

        .appointment-filters {
            display: flex;
            align-items: end;
            justify-content: flex-end;
            flex-wrap: wrap;
            gap: 12px;
        }

        .filter-field {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .filter-field label {
            color: #52637a;
            font-size: 12px;
            font-weight: 700;
        }

        .filter-field select,
        .filter-field input[type="date"] {
            min-width: 150px;
            min-height: 42px;
            padding: 9px 12px;
            border: 1px solid #dce5f0;
            border-radius: 9px;
            background: #fff;
            color: #263852;
            font: inherit;
            font-size: 13px;
            cursor: pointer;
        }

        .filter-field select:focus,
        .filter-field input[type="date"]:focus {
            outline: 2px solid rgba(18, 102, 232, .18);
            border-color: #1266e8;
        }

        .filter-submit {
            min-height: 42px;
            border: 0;
            border-radius: 9px;
            padding: 0 16px;
            background: #1266e8;
            color: #fff;
            font-weight: 700;
            cursor: pointer;
        }

        .filter-submit:hover { background: #0c54c4; }

        .filter-note {
            color: #718198;
            font-size: 12px;
            margin-top: 8px;
        }

        @media (max-width: 760px) {
            .appointment-filters {
                width: 100%;
                justify-content: flex-start;
            }

            .filter-field {
                flex: 1 1 180px;
            }

            .filter-field select,
            .filter-field input[type="date"] {
                width: 100%;
                min-width: 0;
            }
        }
    </style>
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
            <div class="doctor-info">
                <div class="doctor-avatar"><%= firstLetter %></div>
                <div>
                    <strong><%= doctorName == null ? "Doctor" : doctorName %></strong>
                    <span><%= doctor.getSpecialization() == null ? "" : doctor.getSpecialization() %></span>
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

            <div class="table-card">
                <div class="table-header">
                    <h3>Appointment List</h3>

                    <form class="appointment-filters" method="get"
                          action="<%= request.getContextPath() %>/appointments">
                        <input type="hidden" name="action" value="doctor">

                        <div class="filter-field">
                            <label for="statusFilter">Filter by status</label>
                            <select id="statusFilter" name="status">
                                <option value="ALL" <%= "ALL".equals(selectedStatus) ? "selected" : "" %>>All statuses</option>
                                <option value="PENDING" <%= "PENDING".equals(selectedStatus) ? "selected" : "" %>>Pending</option>
                                <option value="CONFIRMED" <%= "CONFIRMED".equals(selectedStatus) ? "selected" : "" %>>Confirmed</option>
                                <option value="CANCELLED" <%= "CANCELLED".equals(selectedStatus) ? "selected" : "" %>>Cancelled</option>
                                <option value="COMPLETED" <%= "COMPLETED".equals(selectedStatus) ? "selected" : "" %>>Completed</option>
                            </select>
                        </div>

                        <div class="filter-field">
                            <label for="dateFilter">Filter by date</label>
                            <select id="dateFilter" name="dateFilter">
                                <option value="ALL" <%= "ALL".equals(selectedDateFilter) ? "selected" : "" %>>All dates</option>
                                <option value="TODAY" <%= "TODAY".equals(selectedDateFilter) ? "selected" : "" %>>Today</option>
                                <option value="UPCOMING" <%= "UPCOMING".equals(selectedDateFilter) ? "selected" : "" %>>Upcoming</option>
                                <option value="PAST" <%= "PAST".equals(selectedDateFilter) ? "selected" : "" %>>Past</option>
                                <option value="CUSTOM" <%= "CUSTOM".equals(selectedDateFilter) ? "selected" : "" %>>Choose a date</option>
                            </select>
                        </div>

                        <div class="filter-field" id="customDateField">
                            <label for="appointmentDate">Specific date</label>
                            <input type="date" id="appointmentDate" name="appointmentDate"
                                   value="<%= selectedAppointmentDate %>">
                        </div>

                        <button class="filter-submit" type="submit">Apply Filters</button>
                    </form>
                </div>
                <div class="filter-note">You can combine a status and date filter. For example, Pending + Today.</div>

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
                                   String statusClass = appointmentStatus == null ? "" : appointmentStatus.toLowerCase();
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
                        <%     }
                           } else { %>
                        <tr>
                            <td colspan="8" class="no-data">No appointments found for the selected filters.</td>
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
(function () {
    const dateFilter = document.getElementById("dateFilter");
    const dateField = document.getElementById("customDateField");
    const dateInput = document.getElementById("appointmentDate");
    const filterForm = dateFilter.closest("form");

    function updateDateField() {
        const custom = dateFilter.value === "CUSTOM";

        dateField.style.display = custom ? "flex" : "none";
        dateInput.required = custom;
    }

    dateFilter.addEventListener("change", function () {
        updateDateField();

        if (dateFilter.value !== "CUSTOM") {
            filterForm.requestSubmit();
        }
    });

    dateInput.addEventListener("change", function () {
        if (dateFilter.value === "CUSTOM" && dateInput.value) {
            filterForm.requestSubmit();
        }
    });

    updateDateField();
})();
</script>

</body>
</html>
