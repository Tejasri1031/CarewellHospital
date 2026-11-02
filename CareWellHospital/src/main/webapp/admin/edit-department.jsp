
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.model.Department" %>
<%@ page import="com.model.User" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>

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

    Department department =
            (Department) request.getAttribute("department");

    if (department == null) {
        response.sendRedirect(
                request.getContextPath() + "/departments?action=list");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Edit Department | CareWell Hospital</title>

<link rel="stylesheet"
    href="<%=request.getContextPath()%>/css/admin.css">

</head>

<body>

<div class="admin-container">

    <!-- SIDEBAR -->

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
                class="admin-nav-item">Appointments</a>

            <a href="<%=request.getContextPath()%>/departments?action=list"
                class="admin-nav-item active">Departments</a>

            <a href="#" class="admin-nav-item">Billing & Payments</a>

            <a href="#" class="admin-nav-item">Reports & Analytics</a>

            <a href="#" class="admin-nav-item">Audit Logs</a>

        </nav>

        <div class="admin-logout">
            <a href="<%=request.getContextPath()%>/LogoutController">
                Logout
            </a>
        </div>

    </aside>


    <!-- MAIN CONTENT -->

    <main class="admin-main">

        <header class="admin-header">

            <div>
                <h1>Edit Department</h1>
                <p>Update hospital department information</p>
            </div>

            <div class="admin-welcome">
                Welcome, <strong><%=admin.getFullName()%></strong>
            </div>

        </header>


        <!-- EDIT FORM -->

        <section class="dashboard-activity">

            <h2>Department Information</h2>
            
            <%
String error = request.getParameter("error");

if ("duplicate".equals(error)) {
%>
    <p class="error-message">
        Another department already uses this name.
    </p>
<%
} else if ("empty".equals(error)) {
%>
    <p class="error-message">
        Department name cannot be empty.
    </p>
<%
} else if ("updateFailed".equals(error)) {
%>
    <p class="error-message">
        Unable to update department.
    </p>
<%
}
%>

            <form action="<%=request.getContextPath()%>/departments"
                method="post">

                <input type="hidden" name="action" value="update">

                <input type="hidden"
                    name="departmentId"
                    value="<%=department.getDepartmentId()%>">


                <div class="form-group">

                    <label for="departmentName">
                        Department Name
                    </label>

                    <input type="text"
                        id="departmentName"
                        name="departmentName"
                        value="<%=department.getDepartmentName()%>"
                        maxlength="100"
                        required>

                </div>


                <div class="form-group">

                    <label for="description">
                        Description
                    </label>

                    <textarea id="description"
                        name="description"
                        rows="5"
                        maxlength="500"
                        required><%=department.getDescription()%></textarea>

                </div>


                <div class="form-group">

                    <label for="status">
                        Department Status
                    </label>

                    <select id="status" name="status" required>

                        <option value="ACTIVE"
                            <%= "ACTIVE".equalsIgnoreCase(department.getStatus())
                                ? "selected" : "" %>>
                            Active
                        </option>

                        <option value="INACTIVE"
                            <%= "INACTIVE".equalsIgnoreCase(department.getStatus())
                                ? "selected" : "" %>>
                            Inactive
                        </option>

                    </select>

                </div>


                <div class="form-actions">

                    <button type="submit">
                        Update Department
                    </button>

                    <a href="<%=request.getContextPath()%>/departments?action=list">
                        Cancel
                    </a>

                </div>

            </form>

        </section>

    </main>

</div>

</body>
</html>
