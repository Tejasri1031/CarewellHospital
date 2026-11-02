
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="com.model.User"%>
<%@ page import="jakarta.servlet.http.HttpServletResponse"%>

<%
    User admin = (User) session.getAttribute("user");

    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (!"ADMIN".equalsIgnoreCase(admin.getRole())) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN,
                "Access denied. Admin access required.");
        return;
    }

    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Add Department | CareWell Hospital</title>

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
					class="admin-nav-item">Doctors</a> <a
					href="<%=request.getContextPath()%>/AdminPatientController"
					class="admin-nav-item">Patients</a> <a
					href="<%=request.getContextPath()%>/AdminAppointmentController"
					class="admin-nav-item">Appointments</a> <a
					href="<%=request.getContextPath()%>/departments?action=list"
					class="admin-nav-item active">Departments</a> <a href="#"
					class="admin-nav-item">Billing & Payments</a> <a href="#"
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
					<h1>Add Department</h1>
					<p>Create a new hospital department</p>
				</div>

				<div class="admin-welcome">
					Welcome, <strong><%=admin.getFullName()%></strong>
				</div>

			</header>


			<section class="dashboard-activity">

				<h2>Department Information</h2>

				<%
				if ("duplicate".equals(error)) {
				%>
				<p class="error-message">Department name already exists.</p>
				<%
				} else if ("empty".equals(error)) {
				%>
				<p class="error-message">Department name cannot be empty.</p>
				<%
				} else if ("failed".equals(error)) {
				%>
				<p class="error-message">Unable to add department. Please try
					again.</p>
				<%
				}
				%>



				<form action="<%=request.getContextPath()%>/departments"
					method="post">

					<input type="hidden" name="action" value="add">

					<div class="form-group">

						<label for="departmentName"> Department Name </label> <input
							type="text" id="departmentName" name="departmentName"
							placeholder="Enter department name" maxlength="100" required>

					</div>


					<div class="form-group">

						<label for="description"> Description </label>

						<textarea id="description" name="description"
							placeholder="Enter department description" rows="5"
							maxlength="500" required></textarea>

					</div>


					<div class="form-actions">

						<button type="submit">Add Department</button>

						<a href="<%=request.getContextPath()%>/departments?action=list">
							Cancel </a>

					</div>

				</form>

			</section>

		</main>

	</div>

</body>
</html>
