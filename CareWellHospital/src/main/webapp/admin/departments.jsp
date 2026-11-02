
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
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

    List<Department> departments =
            (List<Department>) request.getAttribute("departments");

    if (departments == null) {
        response.sendRedirect(request.getContextPath()
                + "/departments?action=list");
        return;
    }

    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Department Management | CareWell Hospital</title>

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


    <!-- MAIN CONTENT -->

    <main class="admin-main">

        <header class="admin-header">

            <div>
                <h1>Department Management</h1>
                <p>Manage hospital departments and their information</p>
            </div>

            <div class="admin-welcome">
                Welcome, <strong><%=admin.getFullName()%></strong>
            </div>

        </header>


        <!-- DEPARTMENT OVERVIEW -->

        <section class="dashboard-overview">

            <h2>Hospital Departments</h2>

            <div class="dashboard-cards">

                <div class="dashboard-card">
                	<h3>Total Departments</h3>
                    <p><%=departments.size()%></p>
                </div>

            </div>

        </section>


        <!-- DEPARTMENT TABLE -->

        <section class="dashboard-activity">

            <h2>Department List</h2>

            <% if ("updateFailed".equals(error)) { %>
                <p class="error-message">
                    Unable to update department.
                </p>
            <% } %>

            <div class="department-actions">

               <a href="<%=request.getContextPath()%>/admin/add-department.jsp"
   class="department-add-button">
    + Add Department
</a>

            </div>

            <div class="table-container">

                <table>

                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Department Name</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Created At</th>
                            <th>Actions</th>
                        </tr>
                    </thead>

                    <tbody>

                    <% if (departments.isEmpty()) { %>

                        <tr>
                            <td colspan="6">
                                No departments available.
                            </td>
                        </tr>

                    <% } else { %>

                        <% for (Department department : departments) { %>

                            <tr>

                                <td><%=department.getDepartmentId()%></td>

                                <td><%=department.getDepartmentName()%></td>

                                <td><%=department.getDescription()%></td>

                                <td><%=department.getStatus()%></td>

                                <td><%=department.getCreatedAt()%></td>

                                <td>

                                   
<td>

    <a class="department-edit-button"
       href="<%=request.getContextPath()%>/departments?action=edit&departmentId=<%=department.getDepartmentId()%>">
        Edit
    </a>

    <form action="<%=request.getContextPath()%>/departments"
          method="post"
          style="display:inline;">

        <input type="hidden"
               name="action"
               value="toggleStatus">

        <input type="hidden"
               name="departmentId"
               value="<%=department.getDepartmentId()%>">

        <% if ("ACTIVE".equalsIgnoreCase(department.getStatus())) { %>

            <button type="submit"
                    class="department-deactivate-button"
                    onclick="return confirm('Are you sure you want to deactivate this department?');">
                Deactivate
            </button>

        <% } else { %>

            <button type="submit"
                    class="department-activate-button"
                    onclick="return confirm('Are you sure you want to activate this department?');">
                Activate
            </button>

        <% } %>

    </form>
    
    
<form action="<%=request.getContextPath()%>/departments"
      method="post"
      style="display:inline;">

    <input type="hidden"
           name="action"
           value="delete">

    <input type="hidden"
           name="departmentId"
           value="<%=department.getDepartmentId()%>">

    <button type="submit"
            class="department-delete-button"
            onclick="return confirm('Are you sure you want to permanently delete this department?');">
        Delete
    </button>

</form>
    

</td>
                                   

                                </td>

                            </tr>

                        <% } %>

                    <% } %>

                    </tbody>

                </table>

            </div>

        </section>

    </main>

</div>

</body>
</html>
