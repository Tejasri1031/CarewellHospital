
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.model.Patient" %>
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

    List<Patient> patients =
            (List<Patient>) request.getAttribute("patients");
%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Manage Patients | CareWell Hospital</title>

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
                class="admin-nav-item active">Patients</a>

           <a href="<%=request.getContextPath()%>/AdminAppointmentController"
   class="admin-nav-item">Appointments</a>

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
                <h1>Patient Management</h1>
                <p>View and manage registered hospital patients</p>
            </div>

            <div class="admin-welcome">
                Welcome, <strong><%=admin.getFullName()%></strong>
            </div>

        </header>

        <section class="dashboard-overview">

            <h2>Registered Patients</h2>

            <p>
                Total Patients:
                <strong><%=patients == null ? 0 : patients.size()%></strong>
            </p>

            <div class="doctor-filter-section">

                <input type="text"
                    id="patientSearch"
                    placeholder="Search by patient name, email or phone">

            </div>

            <div class="doctor-table-container">

                <table class="doctor-table">

                    <thead>

                        <tr>
                            <th>Patient ID</th>
                            <th>Patient Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Date of Birth</th>
                            <th>Gender</th>
                            <th>Blood Group</th>
                            <th>Actions</th>
                        </tr>

                    </thead>

                    <tbody>

                        <% if (patients != null && !patients.isEmpty()) {
                            for (Patient patient : patients) { %>

                        <tr>

                            <td><%=patient.getPatientId()%></td>

                            <td><%=patient.getFullName()%></td>

                            <td><%=patient.getEmail()%></td>

                            <td><%=patient.getPhone()%></td>

                            <td>
                                <%=patient.getDateOfBirth() == null
                                    ? "Not provided"
                                    : patient.getDateOfBirth()%>
                            </td>

                            <td><%=patient.getGender()%></td>

                            <td><%=patient.getBloodGroup()%></td>

                            <td><%=patient.getUserStatus()%></td>
                            <td>
    <a href="<%=request.getContextPath()%>/AdminPatientDetailsController?patientId=<%=patient.getPatientId()%>"
       class="doctor-view-button">
        View
    </a>
</td>

                        </tr>

                        <% }
                        } else { %>

                        <tr>
                            <td colspan="9">No patients found.</td>
                        </tr>

                        <% } %>

                    </tbody>

                </table>

            </div>

        </section>

    </main>

</div>

<script>

    const searchInput = document.getElementById("patientSearch");

    const patientRows =
        document.querySelectorAll(".doctor-table tbody tr");

    function filterPatients() {

        const searchValue =
            searchInput.value.toLowerCase().trim();

        patientRows.forEach(row => {

            const patientName =
                row.cells[1]?.textContent.toLowerCase() || "";

            const email =
                row.cells[2]?.textContent.toLowerCase() || "";

            const phone =
                row.cells[3]?.textContent.toLowerCase() || "";

            const matchesSearch =
                patientName.includes(searchValue) ||
                email.includes(searchValue) ||
                phone.includes(searchValue);

            row.style.display = matchesSearch ? "" : "none";

        });
    }

    searchInput.addEventListener("input", filterPatients);

</script>

</body>
</html>
