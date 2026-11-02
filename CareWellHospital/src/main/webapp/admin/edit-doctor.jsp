<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.model.Doctor" %>
<%@ page import="com.model.Department" %>
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

    Doctor doctor = (Doctor) request.getAttribute("doctor");

    List<Department> departments =
            (List<Department>) request.getAttribute("departments");

    if (doctor == null) {
        response.sendError(HttpServletResponse.SC_NOT_FOUND,
                "Doctor information not found.");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Edit Doctor | CareWell Hospital</title>

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
               class="admin-nav-item active">Doctors</a>

            <a href="#" class="admin-nav-item">Patients</a>
            <a href="#" class="admin-nav-item">Appointments</a>
            <a href="#" class="admin-nav-item">Departments</a>
            <a href="#" class="admin-nav-item">Billing & Payments</a>
            <a href="#" class="admin-nav-item">Reports & Analytics</a>

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
                <h1>Edit Doctor</h1>
                <p>Update registered doctor information</p>
            </div>

            <div class="admin-welcome">
                Welcome, <strong><%=admin.getFullName()%></strong>
            </div>

        </header>

        <section class="edit-doctor-container">

            <h2>Doctor Information</h2>

            <p class="edit-doctor-subtitle">
                Doctor ID: <strong><%=doctor.getDoctorId()%></strong>
            </p>

            <form action="<%=request.getContextPath()%>/AdminEditDoctorController"
                  method="post">

                <input type="hidden" name="doctorId"
                       value="<%=doctor.getDoctorId()%>">

                <input type="hidden" name="userId"
                       value="<%=doctor.getUserId()%>">

                <div class="edit-doctor-grid">

                    <div class="edit-form-group">
                        <label>Doctor Name</label>
                        <input type="text" value="<%=doctor.getFullName()%>"
                               readonly>
                    </div>

                    <div class="edit-form-group">
                        <label>Email Address</label>
                        <input type="email" value="<%=doctor.getEmail()%>"
                               readonly>
                    </div>

                    <div class="edit-form-group">
                        <label>Phone Number</label>
                        <input type="text" value="<%=doctor.getPhone()%>"
                               readonly>
                    </div>

                    <div class="edit-form-group">
                        <label>Department</label>

                        <select name="departmentId" required>

                            <% if (departments != null) {
                                for (Department department : departments) { %>

                                <option
                                    value="<%=department.getDepartmentId()%>"
                                    <%=department.getDepartmentId() == doctor.getDepartmentId()
                                        ? "selected" : ""%>>
                                    <%=department.getDepartmentName()%>
                                </option>

                            <%  }
                               } %>

                        </select>
                    </div>

                    <div class="edit-form-group">
                        <label>Specialization</label>
                        <input type="text" name="specialization"
                               value="<%=doctor.getSpecialization()%>"
                               required maxlength="100">
                    </div>

                    <div class="edit-form-group">
                        <label>Qualification</label>
                        <input type="text" name="qualification"
                               value="<%=doctor.getQualification()%>"
                               required maxlength="150">
                    </div>

                    <div class="edit-form-group">
                        <label>Experience (Years)</label>
                        <input type="number" name="experienceYears"
                               value="<%=doctor.getExperienceYears()%>"
                               min="0" max="100" required>
                    </div>

                    <div class="edit-form-group">
                        <label>Consultation Fee (₹)</label>
                        <input type="number" name="consultationFee"
                               value="<%=doctor.getConsultationFee()%>"
                               min="0" step="0.01" required>
                    </div>

                    <div class="edit-form-group">
                        <label>Availability Status</label>

                        <select name="availabilityStatus" required>

                            <option value="AVAILABLE"
                                <%="AVAILABLE".equals(doctor.getAvailabilityStatus())
                                    ? "selected" : ""%>>
                                AVAILABLE
                            </option>

                            <option value="UNAVAILABLE"
                                <%="UNAVAILABLE".equals(doctor.getAvailabilityStatus())
                                    ? "selected" : ""%>>
                                UNAVAILABLE
                            </option>

                        </select>
                    </div>

                </div>

                <div class="edit-form-group edit-bio-group">
                    <label>Doctor Biography</label>

                    <textarea name="bio" rows="5"
                              maxlength="1000"><%=doctor.getBio() == null ? "" : doctor.getBio()%></textarea>
                </div>

                <div class="edit-doctor-actions">

                    <button type="submit" class="edit-save-button">
                        Save Changes
                    </button>

                    <a href="<%=request.getContextPath()%>/AdminDoctorDetailsController?doctorId=<%=doctor.getDoctorId()%>"
                       class="edit-cancel-button">
                        Cancel
                    </a>

                </div>

            </form>

        </section>

    </main>

</div>

</body>
</html>