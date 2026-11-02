<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="com.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.model.Bill" %>
<%@ page import="com.model.Payment" %>
<%
    User admin = (User) session.getAttribute("user");

    if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    double totalRevenue = (Double) request.getAttribute("totalRevenue");
    int totalBills = (Integer) request.getAttribute("totalBills");
    int paidBills = (Integer) request.getAttribute("paidBills");
    int pendingBills = (Integer) request.getAttribute("pendingBills");
    List<Bill> billList = (List<Bill>) request.getAttribute("billList");
    List<Payment> paymentList =
            (List<Payment>) request.getAttribute("paymentList");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Billing & Payments | CareWell Hospital</title>

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
   class="admin-nav-item active">
    Billing & Payments
</a>
					<a href="<%=request.getContextPath()%>/AdminReportsController"
					class="admin-nav-item ">Reports & Analytics</a>
					 

			</nav>

			<div class="admin-logout">
				<a href="<%=request.getContextPath()%>/LogoutController"> Logout
				</a>
			</div>

		</aside>
		
		<main class="admin-main">
		
		<header class="admin-header">
    <div>
        <h1>Billing & Payments</h1>
        <p>Manage hospital bills and monitor payment activities</p>
    </div>

    <div class="admin-welcome">
        Welcome, <strong><%=admin.getFullName()%></strong>
    </div>
</header>

<section class="dashboard-overview">

    <h2>Billing Overview</h2>

    <div class="dashboard-cards">

        <div class="dashboard-card">
            <h3>Total Revenue</h3>
            <p>₹ <%=String.format("%.2f", totalRevenue)%></p>
        </div>

        <div class="dashboard-card">
            <h3>Total Bills</h3>
            <p><%=totalBills%></p>
        </div>

        <div class="dashboard-card">
            <h3>Paid Bills</h3>
            <p><%=paidBills%></p>
        </div>

        <div class="dashboard-card">
            <h3>Pending Bills</h3>
            <p><%=pendingBills%></p>
        </div>

    </div>

</section>
<section class="dashboard-activity billing-table-section">

    <h2>All Bills</h2>

   <table class="admin-table">
        <thead>
            <tr>
                <th>Bill ID</th>
                <th>Patient Name</th>
                <th>Bill Date</th>
                <th>Total Amount</th>
                <th>Payment Status</th>
                <th>Payment Method</th>
            </tr>
        </thead>

        <tbody>

            <% if (billList != null && !billList.isEmpty()) {
                for (Bill bill : billList) { %>

                <tr>
                    <td><%=bill.getBillId()%></td>
                    <td><%=bill.getPatientName()%></td>
                    <td><%=bill.getBillDate()%></td>
                    <td>₹ <%=String.format("%.2f", bill.getTotalAmount())%></td>
                    <td><%=bill.getPaymentStatus()%></td>
                    <td><%=bill.getPaymentMethod()%></td>
                </tr>

            <%  }
            } else { %>

                <tr>
                    <td colspan="6">No bills found.</td>
                </tr>

            <% } %>

        </tbody>
    </table>

</section>

<section class="dashboard-activity billing-table-section">

    <h2>Payment Transactions</h2>

    <table class="admin-table">

        <thead>
            <tr>
                <th>Payment ID</th>
                <th>Bill ID</th>
                <th>Patient Name</th>
                <th>Payment Amount</th>
                <th>Payment Method</th>
                <th>Transaction Reference</th>
                <th>Payment Status</th>
                <th>Payment Date</th>
            </tr>
        </thead>

        <tbody>

            <% if (paymentList != null && !paymentList.isEmpty()) {
                for (Payment payment : paymentList) { %>

                <tr>
                    <td><%=payment.getPaymentId()%></td>
                    <td><%=payment.getBillId()%></td>
                    <td><%=payment.getPatientName()%></td>
                    <td>₹ <%=String.format("%.2f", payment.getPaymentAmount())%></td>
                    <td><%=payment.getPaymentMethod()%></td>
                    <td><%=payment.getTransactionReference() != null
                            ? payment.getTransactionReference() : "N/A"%></td>
                    <td><%=payment.getPaymentStatus()%></td>
                    <td><%=payment.getPaymentDate()%></td>
                </tr>

            <%  }
            } else { %>

                <tr>
                    <td colspan="8">No payment transactions found.</td>
                </tr>

            <% } %>

        </tbody>

    </table>

</section>

</body>
</html>