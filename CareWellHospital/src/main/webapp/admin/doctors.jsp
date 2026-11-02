<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.model.Doctor"%>
<%@ page import="com.model.User"%>
<%@ page import="com.model.Department"%>

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

    List<Doctor> doctors =
            (List<Doctor>) request.getAttribute("doctors");
    
    List<Department> departments =
            (List<Department>) request.getAttribute("departments");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manage Doctors | CareWell Hospital</title>

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
					class="admin-nav-item">Dashboard</a> <a
					href="<%=request.getContextPath()%>/AdminDoctorController"
					class="admin-nav-item active">Doctors
					<a href="<%=request.getContextPath()%>/AdminPatientController"
   class="admin-nav-item">Patients</a>
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
				<a href="<%=request.getContextPath()%>/LogoutController"> Logout
				</a>
			</div>

		</aside>

		<main class="admin-main">

			<header class="admin-header">
				<div>
					<h1>Doctor Management</h1>
					<p>View and manage registered hospital doctors</p>
				</div>

				<div class="admin-welcome">
					Welcome, <strong><%=admin.getFullName()%></strong>
				</div>
			</header>

			<section class="dashboard-overview">

				<h2>Registered Doctors</h2>

				<p>
					Total Doctors: <strong><%=doctors == null ? 0 : doctors.size()%></strong>
				</p>

				<div class="doctor-filter-section">

					<input type="text" id="doctorSearch"
						placeholder="Search by name, email or specialization"> <select
						id="departmentFilter">
						<option value="">All Departments</option>

						<% if (departments != null) {
            for (Department department : departments) { %>

						<option value="<%=department.getDepartmentName()%>">
							<%=department.getDepartmentName()%>
						</option>

						<%  }
           } %>
					</select>

				</div>

				<div class="doctor-table-container">

					<table class="doctor-table">

						<thead>
							<tr>
								<th>ID</th>
								<th>Doctor Name</th>
								<th>Email</th>
								<th>Phone</th>
								<th>Department</th>
								<th>Specialization</th>
								<th>Experience</th>
								<th>Consultation Fee</th>
								<th>Availability</th>
								<th>Actions</th>
							</tr>
						</thead>

						<tbody>

							<% if (doctors != null && !doctors.isEmpty()) {
                                for (Doctor doctor : doctors) { %>

							<tr>
								<td><%=doctor.getDoctorId()%></td>
								<td><%=doctor.getFullName()%></td>
								<td><%=doctor.getEmail()%></td>
								<td><%=doctor.getPhone()%></td>
								<td><%=doctor.getDepartmentName()%></td>
								<td><%=doctor.getSpecialization()%></td>
								<td><%=doctor.getExperienceYears()%> years</td>
								<td>₹<%=doctor.getConsultationFee()%></td>
								<td><%=doctor.getAvailabilityStatus()%></td>
								<td><%=doctor.getUserStatus()%></td>
								<td><a
									href="<%=request.getContextPath()%>/AdminDoctorDetailsController?doctorId=<%=doctor.getDoctorId()%>"
									class="doctor-view-button"> View </a></td>
							</tr>

							<%  }
                               } else { %>

							<tr>
								<td colspan="10">No doctors found.</td>
							</tr>

							<% } %>

						</tbody>

					</table>

				</div>

			</section>

		</main>

	</div>

	<script>
    const searchInput = document.getElementById("doctorSearch");
    const departmentFilter = document.getElementById("departmentFilter");
    const doctorRows = document.querySelectorAll(".doctor-table tbody tr");

    function filterDoctors() {

        const searchValue = searchInput.value.toLowerCase().trim();
        const selectedDepartment = departmentFilter.value.toLowerCase();

        doctorRows.forEach(row => {

            const doctorName = row.cells[1]?.textContent.toLowerCase() || "";
            const email = row.cells[2]?.textContent.toLowerCase() || "";
            const specialization = row.cells[5]?.textContent.toLowerCase() || "";
            const department = row.cells[4]?.textContent.toLowerCase() || "";

            const matchesSearch =
                doctorName.includes(searchValue) ||
                email.includes(searchValue) ||
                specialization.includes(searchValue);

            const matchesDepartment =
                selectedDepartment === "" ||
                department === selectedDepartment;

            row.style.display =
                matchesSearch && matchesDepartment ? "" : "none";
        });
    }

    searchInput.addEventListener("input", filterDoctors);
    departmentFilter.addEventListener("change", filterDoctors);
</script>
</body>
</html>