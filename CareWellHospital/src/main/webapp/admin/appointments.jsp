
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.model.Appointment" %>
<%@ page import="com.model.User" %>

<%
    User admin = (User) session.getAttribute("user");

    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (!"ADMIN".equalsIgnoreCase(admin.getRole())) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN,
                "Admin access required.");
        return;
    }

    List<Appointment> appointments =
            (List<Appointment>) request.getAttribute("appointments");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Appointments | CareWell Hospital</title>

<link rel="stylesheet"
    href="<%=request.getContextPath()%>/css/admin.css">
</head>

<body>

<div class="admin-container">

    <aside class="admin-sidebar">

        <div class="admin-brand">
            <h2>CareWell</h2>
            <span>HOSPITAL ADMIN</span>
        </div>

        <nav class="admin-navigation">

            <a href="<%=request.getContextPath()%>/AdminDashboardController"
                class="admin-nav-item">Dashboard</a>

            <a href="<%=request.getContextPath()%>/AdminDoctorController"
                class="admin-nav-item">Doctors</a>

            <a href="<%=request.getContextPath()%>/AdminPatientController"
                class="admin-nav-item">Patients</a>

            <a href="<%=request.getContextPath()%>/AdminAppointmentController"
                class="admin-nav-item active">Appointments</a>

           <a href="<%=request.getContextPath()%>/departments?action=list"
   class="admin-nav-item">
    Departments
</a>

            <a href="<%=request.getContextPath()%>/AdminBillingController"
   class="admin-nav-item">
    Billing & Payments
</a>

          <a href="<%=request.getContextPath()%>/AdminReportsController"
					class="admin-nav-item">Reports & Analytics</a>

        </nav>

        <div class="admin-logout">
            <a href="<%=request.getContextPath()%>/LogoutController">
                Logout
            </a>
        </div>

    </aside>

    <main class="admin-main">

        <header class="admin-header">

            <div>
                <h1>Appointment Management</h1>
                <p>View and monitor hospital appointments</p>
            </div>

            <div class="admin-welcome">
                Welcome, <strong><%=admin.getFullName()%></strong>
            </div>

        </header>

        <section class="dashboard-overview">

            <h2>All Appointments</h2>

            <p>
                Total Appointments:
                <strong><%=appointments == null ? 0 : appointments.size()%></strong>
            </p>

            <div class="doctor-filter-section">

                <input type="text"
                    id="appointmentSearch"
                    placeholder="Search by patient, doctor or department">

                <select id="statusFilter">
                    <option value="">All Statuses</option>
                    <option value="PENDING">Pending</option>
                    <option value="CONFIRMED">Confirmed</option>
                    <option value="COMPLETED">Completed</option>
                    <option value="CANCELLED">Cancelled</option>
                </select>

            </div>

            <div class="doctor-table-container">

                <table class="doctor-table">

                    <thead>
                        <tr>
                            <th>Appointment ID</th>
                            <th>Patient Name</th>
                            <th>Doctor Name</th>
                            <th>Department</th>
                            <th>Appointment Date</th>
                            <th>Time</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>

                    <tbody>

                        <% if (appointments != null && !appointments.isEmpty()) {
                            for (Appointment appointment : appointments) { %>

                        <tr>

                            <td><%=appointment.getAppointmentId()%></td>

                            <td><%=appointment.getPatientName()%></td>

                            <td><%=appointment.getDoctorName()%></td>

                            <td><%=appointment.getDepartmentName()%></td>

                            <td><%=appointment.getAppointmentDate()%></td>

                            <td><%=appointment.getAppointmentTime()%></td>

                            <td><%=appointment.getStatus()%></td>

                          <td>
    <a href="<%=request.getContextPath()%>/AdminAppointmentDetailsController?appointmentId=<%=appointment.getAppointmentId()%>"
       class="doctor-view-button">
        View Details
    </a>
</td>

                        </tr>

                        <% }
                        } else { %>

                        <tr>
                            <td colspan="8">No appointments found.</td>
                        </tr>

                        <% } %>

                    </tbody>

                </table>

            </div>

        </section>

    </main>

</div>

<script>

    const searchInput = document.getElementById("appointmentSearch");
    const statusFilter = document.getElementById("statusFilter");

    const appointmentRows =
        document.querySelectorAll(".doctor-table tbody tr");

    function filterAppointments() {

        const searchValue = searchInput.value.toLowerCase().trim();
        const selectedStatus = statusFilter.value.toLowerCase();

        appointmentRows.forEach(row => {

            const patientName =
                row.cells[1]?.textContent.toLowerCase() || "";

            const doctorName =
                row.cells[2]?.textContent.toLowerCase() || "";

            const department =
                row.cells[3]?.textContent.toLowerCase() || "";

            const status =
                row.cells[6]?.textContent.toLowerCase().trim() || "";

            const matchesSearch =
                patientName.includes(searchValue) ||
                doctorName.includes(searchValue) ||
                department.includes(searchValue);

            const matchesStatus =
                selectedStatus === "" || status === selectedStatus;

            row.style.display =
                matchesSearch && matchesStatus ? "" : "none";

        });
    }

    searchInput.addEventListener("input", filterAppointments);
    statusFilter.addEventListener("change", filterAppointments);

</script>

</body>
</html>
