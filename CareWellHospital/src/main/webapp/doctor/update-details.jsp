<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="com.model.User" %>

<%
    HttpSession doctorSession = request.getSession(false);

    if (doctorSession == null
            || doctorSession.getAttribute("userId") == null
            || !"DOCTOR".equalsIgnoreCase(
                    String.valueOf(doctorSession.getAttribute("role")))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    User doctor = (User) doctorSession.getAttribute("user");

    if (doctor == null) {
        response.sendRedirect(request.getContextPath() + "/doctor/dashboard.jsp");
        return;
    }

    String success = request.getParameter("success");
    String error = request.getParameter("error");

    // Escape values before placing them in HTML attributes.
    String fullName = doctor.getFullName() == null ? "" : doctor.getFullName();
    String email = doctor.getEmail() == null ? "" : doctor.getEmail();
    String phone = doctor.getPhone() == null ? "" : doctor.getPhone();

    fullName = fullName.replace("&", "&amp;")
                       .replace("<", "&lt;")
                       .replace(">", "&gt;")
                       .replace("\"", "&quot;")
                       .replace("'", "&#39;");

    email = email.replace("&", "&amp;")
                  .replace("<", "&lt;")
                  .replace(">", "&gt;")
                  .replace("\"", "&quot;")
                  .replace("'", "&#39;");

    phone = phone.replace("&", "&amp;")
                  .replace("<", "&lt;")
                  .replace(">", "&gt;")
                  .replace("\"", "&quot;")
                  .replace("'", "&#39;");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Details | CareWell Hospital</title>
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/doctor-updatedetails.css">
</head>
<body>

    <header class="header">
        <h1><span aria-hidden="true">👤</span> Update Details</h1>
        <p>Keep your doctor account information up to date.</p>
    </header>

    <main class="container">
        <section class="card" aria-labelledby="profile-heading">
            <h2 id="profile-heading">Update Your Profile</h2>
            <p class="description">
                Update your personal and contact information below.
            </p>

            <% if ("1".equals(success)) { %>
                <div class="password-alert password-success" role="status">
                    Your details have been updated successfully.
                </div>
            <% } %>

            <% if ("empty".equals(error)) { %>
                <div class="password-alert password-error" role="alert">
                    Please enter your full name and email address.
                </div>
            <% } else if ("email".equals(error)) { %>
                <div class="password-alert password-error" role="alert">
                    Please enter a valid email address.
                </div>
            <% } else if ("emailExists".equals(error)) { %>
                <div class="password-alert password-error" role="alert">
                    This email address is already registered.
                </div>
            <% } else if ("failed".equals(error)) { %>
                <div class="password-alert password-error" role="alert">
                    Unable to update your details. Please try again.
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/doctor/update-details"
                  method="post">
                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input type="text"
                           id="fullName"
                           name="fullName"
                           value="<%= fullName %>"
                           maxlength="100"
                           autocomplete="name"
                           required>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email"
                           id="email"
                           name="email"
                           value="<%= email %>"
                           maxlength="150"
                           autocomplete="email"
                           required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel"
                           id="phone"
                           name="phone"
                           value="<%= phone %>"
                           maxlength="20"
                           autocomplete="tel">
                </div>

                <div class="buttons">
                    <button class="button button-primary" type="submit">
                        Save Changes
                    </button>
                    <a class="button button-secondary"
                       href="<%= request.getContextPath() %>/doctor/dashboard.jsp">
                        Cancel
                    </a>
                </div>
            </form>
        </section>
        
    </main>
    
     <a class="button button-secondary"
   href="<%= request.getContextPath() %>/doctor/dashboard.jsp">
    ← Back to Dashboard
</a>

    <footer class="footer">
        &copy; 2026 CareWell Hospital. Professional care, better health.
    </footer>

</body>
</html>
