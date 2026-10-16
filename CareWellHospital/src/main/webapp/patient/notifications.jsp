<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.dao.NotificationDAO"%>
<%@ page import="com.daoimpl.NotificationDAOImpl"%>
<%@ page import="com.model.Notification"%>
<%@ page import="com.model.User"%>

<%
    /* =====================================================
       LOGIN CHECK
       ===================================================== */

    HttpSession userSession = request.getSession(false);

    if (userSession == null ||
        userSession.getAttribute("user") == null) {

        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );

        return;
    }


    User user =
            (User) userSession.getAttribute("user");


    if (!"PATIENT".equalsIgnoreCase(user.getRole())) {

        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );

        return;
    }


    /* =====================================================
       LOAD NOTIFICATIONS
       ===================================================== */

    int userId =
            user.getUserId();


    NotificationDAO notificationDAO =
            new NotificationDAOImpl();


 // Mark this patient's notifications as read.
    notificationDAO.markAllAsRead(userId);

    // Load notifications after updating their read status.
    List<Notification> notifications =
            notificationDAO.getNotificationsByUser(userId);

    int unreadCount =
            notificationDAO.getUnreadNotificationCount(userId);

%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Notifications | CareWell Hospital
    </title>


    <link rel="stylesheet"
      type="text/css"
      href="<%= request.getContextPath() %>/css/patient-notifications.css?v=20">

</head>


<body>


<div class="notification-page">


    <!-- =====================================================
         TOP HEADER
         ===================================================== -->

    <header class="notification-header">


        <div class="header-brand">


            <div class="brand-icon">
                ♥
            </div>


            <div class="brand-text">

                <h1>
                    CareWell
                </h1>

                <span>
                    HOSPITAL
                </span>

            </div>


        </div>



        <div class="header-patient">

            <span>
                Welcome,
            </span>

            <strong>
                <%= user.getFullName() %>
            </strong>

        </div>


    </header>



    <!-- =====================================================
         MAIN
         ===================================================== -->

    <main class="notification-main">


        <!-- =================================================
             PAGE TOP
             ================================================= -->

        <div class="page-top">


            <div class="page-heading">


                <div class="heading-icon">
                    🔔
                </div>


                <div>

                    <h2>
                        Notifications
                    </h2>

                    <p>
                        Stay updated with your appointments
                        and hospital activities.
                    </p>

                </div>


            </div>



            <a href="<%= request.getContextPath() %>/patient/dashboard.jsp"
               class="back-dashboard-btn">

                <span>
                    ←
                </span>

                Back to Dashboard

            </a>


        </div>



        <!-- =================================================
             SUMMARY
             ================================================= -->

        <div class="notification-summary">


            <div class="summary-left">


                <span class="summary-icon">
                    🔔
                </span>


                <div>

                    <strong>
                        Your Notifications
                    </strong>

                    <span>
                        Keep track of important updates
                    </span>

                </div>


            </div>



            <div class="summary-right">


                <div class="summary-number">

                    <strong>
                        <%= notifications != null
                                ? notifications.size()
                                : 0 %>
                    </strong>

                    <span>
                        Total
                    </span>

                </div>



                <div class="summary-number unread">

                    <strong>
                        <%= unreadCount %>
                    </strong>

                    <span>
                        Unread
                    </span>

                </div>


            </div>


        </div>



        <!-- =================================================
             NOTIFICATIONS
             ================================================= -->

        <section class="notifications-card">


            <% if (notifications == null ||
                   notifications.isEmpty()) { %>


                <!-- EMPTY STATE -->

                <div class="empty-state">


                    <div class="empty-icon">
                        ✓
                    </div>


                    <h3>
                        You're all caught up
                    </h3>


                    <p>
                        You don't have any notifications right now.
                    </p>


                    <a href="<%= request.getContextPath() %>/patient/dashboard.jsp"
                       class="empty-dashboard-btn">

                        ← Back to Dashboard

                    </a>


                </div>


            <% } else { %>


                <!-- NOTIFICATION LIST -->

                <div class="notification-list">


                    <% for (Notification notification :
                           notifications) { %>


                        <%

                            String notificationType =
                                    notification.getNotificationType();


                            String title =
                                    notification.getTitle();


                            String message =
                                    notification.getMessage();


                            boolean isRead =
                                    notification.isRead();


                            String icon =
                                    "🔔";


                            String typeClass =
                                    "general";


                            String statusText =
                                    "";


                            if ("APPOINTMENT_CONFIRMED"
                                    .equalsIgnoreCase(notificationType)) {

                                icon = "✓";

                                typeClass =
                                        "confirmed";

                                statusText =
                                        "CONFIRMED";

                            }

                            else if ("APPOINTMENT_CANCELLED"
                                    .equalsIgnoreCase(notificationType)) {

                                icon = "✕";

                                typeClass =
                                        "cancelled";

                                statusText =
                                        "CANCELLED";

                            }

                            else if ("APPOINTMENT_REQUEST"
                                    .equalsIgnoreCase(notificationType)) {

                                icon = "📅";

                                typeClass =
                                        "pending";

                                statusText =
                                        "PENDING";
                            }

                        %>


                        <article class="notification-item
                                        <%= typeClass %>
                                        <%= isRead ? "read" : "unread" %>">


                            <!-- ICON -->

                            <div class="notification-icon">

                                <span>
                                    <%= icon %>
                                </span>

                            </div>



                            <!-- CONTENT -->

                            <div class="notification-body">


                                <div class="notification-title-row">


                                    <h3>
                                        <%= title %>
                                    </h3>


                                    <% if (!isRead) { %>

                                        <span class="new-badge">
                                            NEW
                                        </span>

                                    <% } %>


                                </div>



                                <p class="notification-message">
                                    <%= message %>
                                </p>



                                <div class="notification-footer">


                                    <span class="notification-time">

                                        <span>
                                            🕐
                                        </span>

                                        <%= notification.getCreatedAt() %>

                                    </span>



                                    <% if (!statusText.isEmpty()) { %>

                                        <span class="notification-status">

                                            <%= statusText %>

                                        </span>

                                    <% } %>


                                </div>


                            </div>


                        </article>


                    <% } %>


                </div>


            <% } %>


        </section>



        <!-- =================================================
             FOOTER
             ================================================= -->

        <footer class="notification-footer-page">

            <span>
                © 2026 CareWell Hospital
            </span>

            <span>
                Professional care, better health.
            </span>

        </footer>


    </main>


</div>


</body>

</html>