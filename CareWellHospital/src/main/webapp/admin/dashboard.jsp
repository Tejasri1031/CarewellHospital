
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.model.User"%>

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
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Admin Dashboard | CareWell Hospital</title>

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
					class="admin-nav-item active">Dashboard</a>
					 <a
					href="<%=request.getContextPath()%>/AdminDoctorController"
					class="admin-nav-item">Doctors</a>
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
					<h1>Admin Dashboard</h1>
					<p>Hospital overview and management</p>
				</div>

				<div class="admin-welcome">
					Welcome, <strong><%=admin.getFullName()%></strong>
				</div>
			</header>

			<section class="dashboard-overview">

				<h2>Hospital Overview</h2>

				<div class="dashboard-cards">

					<div class="dashboard-card">
						<h3>Total Patients</h3>
						<p><%=request.getAttribute("totalPatients")%></p>
					</div>

					<div class="dashboard-card">
						<h3>Total Doctors</h3>
						<p><%=request.getAttribute("totalDoctors")%></p>
					</div>

					<div class="dashboard-card">
						<h3>Total Appointments</h3>
						<p><%=request.getAttribute("totalAppointments")%></p>
					</div>

					<div class="dashboard-card">
						<h3>Pending Appointments</h3>
						<p><%=request.getAttribute("pendingAppointments")%></p>
					</div>

				</div>

			</section>

			<section class="dashboard-activity">
				<h2>Recent Hospital Activities</h2>
				<p>Activity information will appear here.</p>
			</section>

		</main>

	</div>

</body>
</html>
