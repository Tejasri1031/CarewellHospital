<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>CareWell Hospital | Login</title>

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

    <!-- CareWell CSS -->
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

</head>

<body>

<div class="auth-page">

    <div class="auth-container">

        <!-- =================================================
             LEFT BRAND SECTION
             ================================================= -->

        <div class="auth-brand">

            <div class="auth-logo">

                <div class="auth-logo-icon">
                    <i class="fa-solid fa-heart-pulse"></i>
                </div>

                <div>
                    <h2>CareWell</h2>
                    <span>Hospital</span>
                </div>

            </div>


            <h1>
                Your Health.<br>
                Our Priority.
            </h1>

            <p>
                Welcome to CareWell Hospital Management System.
                Manage appointments, doctors, medical records,
                prescriptions and healthcare services in one place.
            </p>


            <div class="auth-features">

                <div class="auth-feature">

                    <i class="fa-solid fa-user-doctor"></i>

                    <span>
                        Experienced & Trusted Doctors
                    </span>

                </div>


                <div class="auth-feature">

                    <i class="fa-solid fa-calendar-check"></i>

                    <span>
                        Easy Appointment Management
                    </span>

                </div>


                <div class="auth-feature">

                    <i class="fa-solid fa-shield-heart"></i>

                    <span>
                        Secure Patient Records
                    </span>

                </div>


                <div class="auth-feature">

                    <i class="fa-solid fa-clock"></i>

                    <span>
                        Quality Healthcare, Anytime
                    </span>

                </div>

            </div>

        </div>


        <!-- =================================================
             LOGIN FORM
             ================================================= -->

        <div class="auth-form">

            <h2>Welcome Back 👋</h2>

            <p>
                Sign in to continue to your CareWell account.
            </p>


            <!-- Success Message -->

            <%
                String registered = request.getParameter("registered");

                if ("success".equals(registered)) {
            %>

                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    Registration successful. Please login.
                </div>

            <%
                }
            %>


            <!-- Logout Message -->

            <%
                String logout = request.getParameter("logout");

                if ("success".equals(logout)) {
            %>

                <div class="alert alert-success">
                    <i class="fa-solid fa-circle-check"></i>
                    You have been logged out successfully.
                </div>

            <%
                }
            %>


            <!-- Error Message -->

            <%
                String error = request.getParameter("error");

                if ("invalid".equals(error)) {
            %>

                <div class="alert alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    Invalid email or password.
                </div>

            <%
                } else if ("invalidRole".equals(error)) {
            %>

                <div class="alert alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    Invalid user role.
                </div>

            <%
                }
            %>


            <!-- Login Form -->

            <form action="${pageContext.request.contextPath}/login"
                  method="post">


                <!-- Email -->

                <div class="form-group">

                    <label for="email">
                        <i class="fa-regular fa-envelope"></i>
                        Email Address
                    </label>

                    <input
                        type="email"
                        id="email"
                        name="email"
                        class="form-control"
                        placeholder="Enter your email address"
                        required>

                </div>


                <!-- Password -->

                <div class="form-group">

                    <label for="password">
                        <i class="fa-solid fa-lock"></i>
                        Password
                    </label>

                    <input
                        type="password"
                        id="password"
                        name="password"
                        class="form-control"
                        placeholder="Enter your password"
                        required>

                </div>


                <!-- Remember / Forgot -->

                <div style="
                    display:flex;
                    justify-content:space-between;
                    align-items:center;
                    margin-bottom:18px;
                    font-size:11px;
                ">

                    <label style="
                        display:flex;
                        align-items:center;
                        gap:6px;
                        color:#64748b;
                    ">

                        <input type="checkbox">

                        Remember me

                    </label>


                    <a href="#"
                       style="
                       color:#2563eb;
                       font-weight:600;
                       ">

                        Forgot Password?

                    </a>

                </div>


                <!-- Login Button -->

                <button type="submit"
                        class="btn btn-primary">

                    <i class="fa-solid fa-right-to-bracket"></i>

                    Sign In

                </button>

            </form>


            <!-- Register -->

            <div class="auth-footer">

                Don't have an account?

                <a href="${pageContext.request.contextPath}/register.jsp">
                    Create an account
                </a>

            </div>

        </div>

    </div>

</div>

</body>

</html>