<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="com.model.User" %>
<%@ page import="java.util.Map" %>

<%
    User admin = (User) session.getAttribute("user");

    if (admin == null || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    int totalPatients = (Integer) request.getAttribute("totalPatients");
    int totalDoctors = (Integer) request.getAttribute("totalDoctors");
    int activeDoctors = (Integer) request.getAttribute("activeDoctors");
    int inactiveDoctors = (Integer) request.getAttribute("inactiveDoctors");
    int totalAppointments = (Integer) request.getAttribute("totalAppointments");
    double totalRevenue = (Double) request.getAttribute("totalRevenue");
    
    int pendingAppointments =
            (Integer) request.getAttribute("pendingAppointments");

    int confirmedAppointments =
            (Integer) request.getAttribute("confirmedAppointments");

    int completedAppointments =
            (Integer) request.getAttribute("completedAppointments");

    int cancelledAppointments =
            (Integer) request.getAttribute("cancelledAppointments");
    
    int malePatients =
            (Integer) request.getAttribute("malePatients");

    int femalePatients =
            (Integer) request.getAttribute("femalePatients");

    int otherGenderPatients =
            (Integer) request.getAttribute("otherGenderPatients");
    
    int availableDoctors =
            (Integer) request.getAttribute("availableDoctors");

    int unavailableDoctors =
            (Integer) request.getAttribute("unavailableDoctors");
    
    int totalDepartments =
            (Integer) request.getAttribute("totalDepartments");

    int activeDepartments =
            (Integer) request.getAttribute("activeDepartments");
    
    int newPatientsThisMonth =
            (Integer) request.getAttribute("newPatientsThisMonth");

    int newDoctorsThisMonth =
            (Integer) request.getAttribute("newDoctorsThisMonth");
    
    Map<String, Double> dailyRevenue =
            (Map<String, Double>) request.getAttribute("dailyRevenue");
    
    String selectedStartDate =
            (String) request.getAttribute("selectedStartDate");

    String selectedEndDate =
            (String) request.getAttribute("selectedEndDate");

    Map<String, Integer> filteredAppointments =
            (Map<String, Integer>) request.getAttribute("filteredAppointments");

    Map<String, Double> filteredRevenue =
            (Map<String, Double>) request.getAttribute("filteredRevenue");

    String dateFilterError =
            (String) request.getAttribute("dateFilterError");
%>
   
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reports & Analytics | CareWell Hospital</title>

    <link rel="stylesheet"
          href="<%=request.getContextPath()%>/css/admin.css">
          
          <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
   class="admin-nav-item">
    Billing & Payments
</a>
					 <a href="<%=request.getContextPath()%>/AdminReportsController"
					class="admin-nav-item active">Reports & Analytics</a>
					 

			</nav>

			<div class="admin-logout">
				<a href="<%=request.getContextPath()%>/LogoutController"> Logout
				</a>
			</div>

		</aside>

    <main class="admin-main">

    
    
    <header class="admin-header">
				<div>
					<h1>Reports & Analytics</h1>
					<p>Monitor hospital performance and analyze operational reports.</p>
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
            <p><%=totalPatients%></p>
        </div>

        <div class="dashboard-card">
            <h3>Total Doctors</h3>
            <p><%=totalDoctors%></p>
        </div>

        <div class="dashboard-card">
            <h3>Total Appointments</h3>
            <p><%=totalAppointments%></p>
        </div>

        <div class="dashboard-card">
            <h3>Total Revenue</h3>
            <p>₹ <%=String.format("%.2f", totalRevenue)%></p>
        </div>

    </div>

</section>

<section class="dashboard-activity">

    <h2>Custom Date Range Reports</h2>

    <form action="<%=request.getContextPath()%>/AdminReportsController"
      method="get"
      class="report-filter-form">

    <div class="report-filter-group">
        <label for="startDate">Start Date</label>
        <input type="date"
               id="startDate"
               name="startDate"
               value="<%=selectedStartDate != null ? selectedStartDate : ""%>"
               required>
    </div>

    <div class="report-filter-group">
        <label for="endDate">End Date</label>
        <input type="date"
               id="endDate"
               name="endDate"
               value="<%=selectedEndDate != null ? selectedEndDate : ""%>"
               required>
    </div>

    <button type="submit" class="report-filter-button">
        Generate Report
    </button>
    
    <a href="<%=request.getContextPath()%>/AdminReportsController"
   class="report-clear-button">
    Clear Filters
</a>

</form>

    <% if (dateFilterError != null) { %>
        <p style="color: red;"><%=dateFilterError%></p>
    <% } %>

</section>

<section class="dashboard-overview">

    <h2>Appointment Analytics</h2>
		
		<% if (filteredRevenue != null) { %>

<section class="dashboard-activity">

    <h2>Filtered Revenue Report</h2>

    <p>
        Report Period:
        <strong><%=selectedStartDate%></strong>
        to
        <strong><%=selectedEndDate%></strong>
    </p>

    <table class="admin-table">
        <thead>
            <tr>
                <th>Payment Date</th>
                <th>Successful Revenue</th>
            </tr>
        </thead>

        <tbody>

            <% double filteredTotalRevenue = 0.0; %>

            <% for (Map.Entry<String, Double> entry :
                    filteredRevenue.entrySet()) { %>

                <tr>
                    <td><%=entry.getKey()%></td>
                    <td>₹ <%=String.format("%.2f", entry.getValue())%></td>
                </tr>

                <% filteredTotalRevenue += entry.getValue(); %>

            <% } %>

            <tr>
                <th>Total Revenue</th>
                <th>₹ <%=String.format("%.2f", filteredTotalRevenue)%></th>
            </tr>

            <% if (filteredRevenue.isEmpty()) { %>
                <tr>
                    <td colspan="2">
                        No successful payments found for this period.
                    </td>
                </tr>
            <% } %>

        </tbody>
    </table>

</section>

<% } %>
    <div class="dashboard-cards">

        <div class="dashboard-card">
            <h3>Pending Appointments</h3>
            <p><%=pendingAppointments%></p>
        </div>

        <div class="dashboard-card">
            <h3>Confirmed Appointments</h3>
            <p><%=confirmedAppointments%></p>
        </div>

        <div class="dashboard-card">
            <h3>Completed Appointments</h3>
            <p><%=completedAppointments%></p>
        </div>

        <div class="dashboard-card">
            <h3>Cancelled Appointments</h3>
            <p><%=cancelledAppointments%></p>
        </div>

    </div>

</section>

<section class="dashboard-overview">

    <h2>Patient Analytics</h2>

    <div class="dashboard-cards">

        <div class="dashboard-card">
            <h3>Male Patients</h3>
            <p><%=malePatients%></p>
        </div>

        <div class="dashboard-card">
            <h3>Female Patients</h3>
            <p><%=femalePatients%></p>
        </div>

        <div class="dashboard-card">
            <h3>Other Gender</h3>
            <p><%=otherGenderPatients%></p>
        </div>

        <div class="dashboard-card">
            <h3>New Patients This Month</h3>
            <p><%=newPatientsThisMonth%></p>
        </div>

    </div>

</section>

<section class="dashboard-overview">

    <h2>Doctor Analytics</h2>

    <div class="dashboard-cards">

        <div class="dashboard-card">
            <h3>Active Doctors</h3>
            <p><%=activeDoctors%></p>
        </div>

        <div class="dashboard-card">
            <h3>Inactive Doctors</h3>
            <p><%=inactiveDoctors%></p>
        </div>

        <div class="dashboard-card">
            <h3>Available Doctors</h3>
            <p><%=availableDoctors%></p>
        </div>

        <div class="dashboard-card">
            <h3>Unavailable Doctors</h3>
            <p><%=unavailableDoctors%></p>
        </div>

        <div class="dashboard-card">
            <h3>New Doctors This Month</h3>
            <p><%=newDoctorsThisMonth%></p>
        </div>

    </div>

</section>


<section class="dashboard-overview">

    <h2>Department Analytics</h2>

    <div class="dashboard-cards">

        <div class="dashboard-card">
            <h3>Total Departments</h3>
            <p><%=totalDepartments%></p>
        </div>

        <div class="dashboard-card">
            <h3>Active Departments</h3>
            <p><%=activeDepartments%></p>
        </div>

    </div>
<section class="dashboard-activity">

    <h2>Appointment Status Distribution</h2>

    <div style="width: 100%; max-width: 550px; margin: 20px auto;">
        <canvas id="appointmentChart"></canvas>
    </div>

</section>

<section class="dashboard-activity">

    <h2>Patient Gender Distribution</h2>

    <div style="width: 100%; max-width: 500px; margin: 20px auto;">
        <canvas id="patientGenderChart"></canvas>
    </div>

</section>

<section class="dashboard-activity">

    <h2>Doctor Availability Distribution</h2>

    <div style="width: 100%; max-width: 500px; margin: 20px auto;">
        <canvas id="doctorAvailabilityChart"></canvas>
    </div>

</section>

<section class="dashboard-activity">

    <h2>Hospital Revenue Analytics</h2>

    <div style="width: 100%; max-width: 750px; margin: 20px auto;">
        <canvas id="revenueChart"></canvas>
    </div>

</section>

</section>

</main>
</div>

<script>
const appointmentCtx = document.getElementById('appointmentChart');

new Chart(appointmentCtx, {
    type: 'doughnut',

    data: {
        labels: ['Pending', 'Confirmed', 'Completed', 'Cancelled'],

        datasets: [{
            data: [
                <%=pendingAppointments%>,
                <%=confirmedAppointments%>,
                <%=completedAppointments%>,
                <%=cancelledAppointments%>
            ],
            backgroundColor: [
                '#f59e0b',
                '#3b82f6',
                '#22c55e',
                '#ef4444'
            ],
            borderWidth: 2
        }]
    },

    options: {
        responsive: true,
        plugins: {
            legend: {
                position: 'bottom'
            },
            title: {
                display: true,
                text: 'Appointment Status Distribution'
            }
        }
    }
});

const patientGenderCtx =
    document.getElementById('patientGenderChart');

new Chart(patientGenderCtx, {
    type: 'pie',

    data: {
        labels: ['Male', 'Female', 'Other'],

        datasets: [{
            data: [
                <%=malePatients%>,
                <%=femalePatients%>,
                <%=otherGenderPatients%>
            ],
            backgroundColor: [
                '#3b82f6',
                '#ec4899',
                '#22c55e'
            ],
            borderWidth: 2
        }]
    },

    options: {
        responsive: true,
        plugins: {
            legend: {
                position: 'bottom'
            },
            title: {
                display: true,
                text: 'Patient Gender Distribution'
            }
        }
    }
});

const doctorAvailabilityCtx =
    document.getElementById('doctorAvailabilityChart');

new Chart(doctorAvailabilityCtx, {
    type: 'doughnut',

    data: {
        labels: ['Available', 'Unavailable'],

        datasets: [{
            data: [
                <%=availableDoctors%>,
                <%=unavailableDoctors%>
            ],
            backgroundColor: [
                '#22c55e',
                '#ef4444'
            ],
            borderWidth: 2
        }]
    },

    options: {
        responsive: true,
        plugins: {
            legend: {
                position: 'bottom'
            },
            title: {
                display: true,
                text: 'Doctor Availability Distribution'
            }
        }
    }
});

const revenueCtx = document.getElementById('revenueChart');

new Chart(revenueCtx, {
    type: 'line',

    data: {
        labels: [
            <% 
                for (String date : dailyRevenue.keySet()) {
                    out.print("'" + date + "',");
                }
            %>
        ],

        datasets: [{
            label: 'Daily Revenue (₹)',

            data: [
                <%
                    for (Double amount : dailyRevenue.values()) {
                        out.print(amount + ",");
                    }
                %>
            ],

            borderColor: '#2563eb',
            backgroundColor: 'rgba(37, 99, 235, 0.15)',
            fill: true,
            tension: 0.3
        }]
    },

    options: {
        responsive: true,
        plugins: {
            legend: {
                position: 'top'
            },
            title: {
                display: true,
                text: 'Daily Hospital Revenue'
            }
        },
        scales: {
            y: {
                beginAtZero: true,
                title: {
                    display: true,
                    text: 'Revenue (₹)'
                }
            }
        }
    }
});
</script>
</body>
</html>