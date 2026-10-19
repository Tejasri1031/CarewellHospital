<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.dao.PatientDAO" %>
<%@ page import="com.dao.BillDAO" %>
<%@ page import="com.dao.PaymentDAO" %>
<%@ page import="com.daoimpl.PatientDAOImpl" %>
<%@ page import="com.daoimpl.BillDAOImpl" %>
<%@ page import="com.daoimpl.PaymentDAOImpl" %>
<%@ page import="com.model.User" %>
<%@ page import="com.model.Patient" %>
<%@ page import="com.model.Bill" %>
<%@ page import="com.model.Payment" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || !"PATIENT".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    int userId = user.getUserId();

    PatientDAO patientDAO = new PatientDAOImpl();

    Patient patient = patientDAO.getPatientByUserId(userId);

    if (patient == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    int patientId = patient.getPatientId();

    BillDAO billDAO = new BillDAOImpl();
    PaymentDAO paymentDAO = new PaymentDAOImpl();

    List<Bill> bills = billDAO.getBillsByPatient(patientId);
    List<Payment> payments = paymentDAO.getPaymentsByPatient(patientId);

    int totalBills = bills.size();

    double totalBilledAmount = 0;
    double totalPaidAmount = 0;

    int paidBills = 0;
    int pendingBills = 0;

    for (Bill bill : bills) {

        totalBilledAmount += bill.getTotalAmount();

        if ("PAID".equalsIgnoreCase(bill.getPaymentStatus())) {
            paidBills++;
        } else {
            pendingBills++;
        }
    }

    for (Payment payment : payments) {

        if ("SUCCESS".equalsIgnoreCase(payment.getPaymentStatus())) {
            totalPaidAmount += payment.getPaymentAmount();
        }
    }
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Bills & Payments | CareWell Hospital</title>

	<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/patient-common.css?v=5">

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/patient-bills.css?v=5">
   
</head>

<body>

<div class="layout">


  <!-- =========================
     PATIENT SIDEBAR
     ========================= -->

<aside class="sidebar">

    <!-- BRAND -->
    <div class="brand">

        <div class="brand-icon">♥︎</div>

        <div>
            <h2>CareWell</h2>
            <span>HOSPITAL</span>
        </div>

    </div>


    <!-- NAVIGATION -->
    <nav class="navigation">

        <!-- PATIENT PORTAL -->
        <div class="nav-section-title">
            PATIENT PORTAL
        </div>


        <!-- DASHBOARD -->
        <a href="<%= request.getContextPath() %>/patient/dashboard.jsp"
           class="nav-item">

            <span class="nav-icon">🏠</span>
            <span>Dashboard</span>

        </a>


        <!-- MY APPOINTMENTS -->
        <a href="<%= request.getContextPath() %>/patient/appointments.jsp"
           class="nav-item">

            <span class="nav-icon">📅</span>
            <span>My Appointments</span>

        </a>


        <!-- BOOK APPOINTMENT -->
        <a href="<%= request.getContextPath() %>/patient/book-appointment.jsp"
           class="nav-item">

            <span class="nav-icon">📝</span>
            <span>Book Appointment</span>

        </a>


        <!-- MY HEALTH -->
        <div class="nav-section-title">
            MY HEALTH
        </div>


        <!-- MEDICAL RECORDS -->
        <a href="<%= request.getContextPath() %>/patient/medical-records.jsp"
           class="nav-item">

            <span class="nav-icon">🏥</span>
            <span>Medical Records</span>

        </a>


        <!-- PRESCRIPTIONS -->
        <a href="<%= request.getContextPath() %>/patient/prescriptions.jsp"
           class="nav-item">

            <span class="nav-icon">℞</span>
            <span>Prescriptions</span>

        </a>


        <!-- BILLS & PAYMENTS -->
        <a href="<%= request.getContextPath() %>/patient/bills.jsp"
           class="nav-item active">

            <span class="nav-icon">💸</span>
            <span>Bills & Payments</span>

        </a>


        <!-- ACCOUNT -->
        <div class="nav-section-title">
            ACCOUNT
        </div>


        <!-- MY PROFILE -->
        <a href="<%= request.getContextPath() %>/patient/profile.jsp"
           class="nav-item">

            <span class="nav-icon">👤</span>
            <span>My Profile</span>

        </a>

    </nav>


    <!-- LOGOUT -->
    <div class="sidebar-bottom">

        <a href="<%= request.getContextPath() %>/LogoutController"
           class="nav-item logout">

            <span class="nav-icon">🏃🚪</span>
            <span>Logout</span>

        </a>

    </div>

</aside>

    <!-- =========================
         MAIN CONTENT
         ========================= -->

    <main class="main-content">


        <!-- HEADER -->

        <header class="top-header">

            <div>

                <h1>Bills & Payments</h1>

                <p>
                    View your hospital bills and payment history
                </p>

            </div>


            <a href="<%= request.getContextPath() %>/patient/profile.jsp"
               class="patient-info">

                <div class="patient-avatar">
                   <%= user.getFullName().substring(0, 1).toUpperCase() %>
                </div>

                <div>

                    <strong>
                      <%= user.getFullName() %>
                    </strong>

                    <span>
                        Patient #<%= patient.getPatientId() %>
                    </span>

                </div>

            </a>
            

        </header>


        <section class="content">


            <!-- =========================
                 SUMMARY CARDS
                 ========================= -->

            <div class="summary-grid">


                <div class="summary-card">

                    <div class="summary-icon blue">
                        💸
                    </div>

                    <div>

                        <span>Total Billed</span>

                        <strong>
                            💸<%= String.format("%.2f",
                                    totalBilledAmount) %>
                        </strong>

                    </div>

                </div>


                <div class="summary-card">

                    <div class="summary-icon green">
                        ✓
                    </div>

                    <div>

                        <span>Total Paid</span>

                        <strong>
                            💸<%= String.format("%.2f",
                                    totalPaidAmount) %>
                        </strong>

                    </div>

                </div>


                <div class="summary-card">

                    <div class="summary-icon purple">
                        #
                    </div>

                    <div>

                        <span>Total Bills</span>

                        <strong>
                            <%= totalBills %>
                        </strong>

                    </div>

                </div>


                <div class="summary-card">

                    <div class="summary-icon orange">
                        !
                    </div>

                    <div>

                        <span>Pending Bills</span>

                        <strong>
                            <%= pendingBills %>
                        </strong>

                    </div>

                </div>

            </div>


            <!-- =========================
                 SECTION HEADER
                 ========================= -->

            <div class="section-header">

                <div>

                    <h2>Billing History</h2>

                    <p>
                        Your hospital charges and payment details
                    </p>

                </div>


                <div class="total-badge">

                    Bills: <%= totalBills %>

                </div>

            </div>


            <!-- =========================
                 BILL LIST
                 ========================= -->

            <%
                if (bills != null && !bills.isEmpty()) {

                    for (Bill bill : bills) {

                        List<Payment> billPayments =
                                paymentDAO
                                .getPaymentsByBill(bill.getBillId());
            %>


            <div class="bill-card">


                <!-- BILL HEADER -->

                <div class="bill-header">


                    <div class="bill-title">

                        <div class="bill-icon">
                            💸
                        </div>


                        <div>

                            <h3>
                                Bill #<%= bill.getBillId() %>
                            </h3>

                            <p>
                                Bill Date:
                                <%= bill.getBillDate() %>
                            </p>

                        </div>

                    </div>


                    <div class="bill-status-area">

                        <span class="status-label">
                            PAYMENT STATUS
                        </span>


                        <%
                            String statusClass = "";

                            if ("PAID".equalsIgnoreCase(
                                    bill.getPaymentStatus())) {

                                statusClass = "status-paid";

                            } else {

                                statusClass = "status-pending";
                            }
                        %>


                        <span class="payment-status
                                     <%= statusClass %>">

                            <%= bill.getPaymentStatus() %>

                        </span>

                    </div>

                </div>


                <!-- BILL META -->

                <div class="bill-meta">


                    <div>

                        <span>APPOINTMENT</span>

                        <strong>
                            #<%= bill.getAppointmentId() %>
                        </strong>

                    </div>


                    <div>

                        <span>PAYMENT METHOD</span>

                        <strong>
                            <%= bill.getPaymentMethod() %>
                        </strong>

                    </div>


                    <div>

                        <span>PATIENT</span>

                        <strong>
                            <%= patient.getPatientId() %>
                        </strong>

                    </div>

                </div>


                <!-- CHARGES -->

                <div class="charges-section">

                    <div class="section-label">
                        BILL BREAKDOWN
                    </div>


                    <div class="charges-grid">


                        <div class="charge-item">

                            <span>
                                Consultation Fee
                            </span>

                            <strong>
                                💸<%= String.format("%.2f",
                                        bill.getConsultationFee()) %>
                            </strong>

                        </div>


                        <div class="charge-item">

                            <span>
                                Medicine Charges
                            </span>

                            <strong>
                                💸<%= String.format("%.2f",
                                        bill.getMedicineCharge()) %>
                            </strong>

                        </div>


                        <div class="charge-item">

                            <span>
                                Test Charges
                            </span>

                            <strong>
                                💸<%= String.format("%.2f",
                                        bill.getTestCharge()) %>
                            </strong>

                        </div>


                        <div class="charge-item">

                            <span>
                                Other Charges
                            </span>

                            <strong>
                                💸<%= String.format("%.2f",
                                        bill.getOtherCharge()) %>
                            </strong>

                        </div>

                    </div>


                    <div class="total-row">

                        <span>
                            TOTAL AMOUNT
                        </span>

                        <strong>
                            💸<%= String.format("%.2f",
                                    bill.getTotalAmount()) %>
                        </strong>

                    </div>

                </div>


                <!-- PAYMENT DETAILS -->

                <%
                    if (billPayments != null
                            && !billPayments.isEmpty()) {
                %>

                <div class="payment-section">

                    <div class="section-label">
                        PAYMENT DETAILS
                    </div>


                    <%
                        for (Payment payment : billPayments) {
                    %>


                    <div class="payment-row">


                        <div class="payment-info">

                            <span>
                                Payment #<%= payment.getPaymentId() %>
                            </span>

                            <strong>
                                ₹<%= String.format("%.2f",
                                        payment.getPaymentAmount()) %>
                            </strong>

                        </div>


                        <div class="payment-info">

                            <span>
                                Method
                            </span>

                            <strong>
                                <%= payment.getPaymentMethod() %>
                            </strong>

                        </div>


                        <div class="payment-info">

                            <span>
                                Transaction Reference
                            </span>

                            <strong class="transaction-reference">
                                <%= payment.getTransactionReference() %>
                            </strong>

                        </div>


                        <div class="payment-info">

                            <span>
                                Payment Date
                            </span>

                            <strong>
                                <%= payment.getPaymentDate() %>
                            </strong>

                        </div>


                        <div>

                            <span class="success-badge">

                                <%= payment.getPaymentStatus() %>

                            </span>

                        </div>


                    </div>


                    <%
                        }
                    %>


                </div>

                <%
                    }
                %>


                <!-- NOTES -->

                <%
                    if (bill.getNotes() != null
                            && !bill.getNotes().trim().isEmpty()) {
                %>


                <div class="bill-notes">

                    <div class="notes-icon">
                        ℹ
                    </div>


                    <div>

                        <span>
                            BILL NOTES
                        </span>

                        <p>
                            <%= bill.getNotes() %>
                        </p>

                    </div>

                </div>


                <%
                    }
                %>


            </div>


            <%
                    }

                } else {
            %>


            <!-- EMPTY STATE -->

            <div class="empty-state">

                <div class="empty-icon">
                    💸
                </div>

                <h3>
                    No Bills Found
                </h3>

                <p>
                    You currently don't have any hospital bills.
                </p>

            </div>


            <%
                }
            %>


        </section>


        <!-- FOOTER -->

        <footer class="footer">

            <span>
                © 2026 CareWell Hospital
            </span>

            <span>
                Patient Portal
            </span>

        </footer>


    </main>

</div>

</body>

</html>