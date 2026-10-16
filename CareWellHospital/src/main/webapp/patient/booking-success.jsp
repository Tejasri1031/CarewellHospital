<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

 
 <%@ page import="com.model.User" %>
<%
    User user = (User) session.getAttribute("user");

    if (user == null || !"PATIENT".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );
        return;
    }
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Appointment Booked - CareWell Hospital</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/booking-success.css">

</head>

<body>

<div class="success-page">

    <div class="success-card">


        <!-- DOCTOR ANIMATION -->

        <div class="doctor-scene">

            <div class="doctor">

                <div class="doctor-head">

                    <div class="doctor-hair"></div>

                    <div class="doctor-face">

                        <span class="eye left-eye"></span>
                        <span class="eye right-eye"></span>

                        <span class="mouth"></span>

                    </div>

                </div>


                <div class="doctor-body">

                    <div class="doctor-coat">

                        <div class="medical-cross">
                            +
                        </div>

                    </div>

                </div>


                <div class="doctor-arm left-arm"></div>

                <div class="doctor-arm right-arm"></div>


                <!-- MEDICAL BOX -->

                <div class="medical-box">

                    <div class="box-handle"></div>

                    <div class="box-body">

                        <span>
                            +
                        </span>

                    </div>

                </div>


                <div class="doctor-leg left-leg"></div>

                <div class="doctor-leg right-leg"></div>

            </div>

        </div>


        <!-- SUCCESS -->

        <div class="success-content">

            <div class="success-circle">

                <span>
                    ✓
                </span>

            </div>


            <h1>
                Appointment Booked!
            </h1>


            <p class="success-title">
                Successfully Submitted
            </p>


            <p class="success-message">

                Your appointment request has been submitted
                successfully and is waiting for confirmation.

            </p>


            <div class="status-badge">

                <span class="status-dot"></span>

                PENDING CONFIRMATION

            </div>


            <div class="success-divider"></div>


            <p class="thank-you">

                Thank you for choosing
                <strong>CareWell Hospital</strong>.

            </p>


            <div class="success-actions">

                <a href="<%= request.getContextPath() %>/patient/appointments.jsp"
                   class="primary-button">

                    View My Appointments

                </a>


                <a href="<%= request.getContextPath() %>/patient/dashboard.jsp"
                   class="secondary-button">

                    Back to Dashboard

                </a>

            </div>

        </div>

    </div>

</div>

</body>

</html>