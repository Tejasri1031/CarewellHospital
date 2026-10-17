<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List,java.util.Set,java.util.HashSet" %>
<%@ page import="com.dao.DoctorDAO,com.dao.MedicalRecordDetailsDAO,com.dao.PrescriptionDetailsDAO" %>
<%@ page import="com.daoimpl.DoctorDAOImpl,com.daoimpl.MedicalRecordDetailsDAOImpl,com.daoimpl.PrescriptionDetailsDAOImpl" %>
<%@ page import="com.model.User,com.model.Doctor,com.model.MedicalRecordDetails,com.model.PrescriptionDetails" %>
<%
User user = (User) session.getAttribute("user");
if (user == null || !"DOCTOR".equals(user.getRole())) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}
Doctor doctor = null;
List<Doctor> doctors = new DoctorDAOImpl().getAllDoctors();
if (doctors != null) {
    for (Doctor item : doctors) {
        if (item.getUserId() == user.getUserId()) { doctor = item; break; }
    }
}
if (doctor == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}
int doctorId = doctor.getDoctorId();
List<MedicalRecordDetails> medicalRecords =
    new MedicalRecordDetailsDAOImpl().getMedicalRecordDetailsByDoctor(doctorId);
List<PrescriptionDetails> prescriptionDetails =
    new PrescriptionDetailsDAOImpl().getPrescriptionDetailsByDoctor(doctorId);
String doctorName = user.getFullName();
String firstLetter = doctorName != null && !doctorName.isEmpty()
    ? doctorName.substring(0,1).toUpperCase() : "D";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Medical Records | CareWell Hospital</title>

<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/doctor-common.css">

<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/doctor-dashboard.css">
      
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-medical-records.css">

</head>
<body>
<div class="page-container">
<aside class="sidebar">
    <div class="brand"><div class="brand-icon">♥︎</div><div><h2>CareWell</h2><span>HOSPITAL</span></div></div>
    <div class="sidebar-section">
        <p class="section-title">DOCTOR PORTAL</p>
        <a class="sidebar-link" href="<%=request.getContextPath()%>/doctor/dashboard.jsp"><span class="menu-icon">🏠</span> Dashboard</a>
        <a class="sidebar-link" href="<%=request.getContextPath()%>/doctor/appointments.jsp"><span class="menu-icon">📅</span> My Appointments</a>
    </div>
    <div class="sidebar-section">
        <p class="section-title">PATIENT CARE</p>
        <a class="sidebar-link active" href="<%=request.getContextPath()%>/doctor/medical-records.jsp"><span class="menu-icon">🏥</span> Medical Records</a>
        <a class="sidebar-link" href="<%=request.getContextPath()%>/doctor/prescriptions.jsp"><span class="menu-icon">℞</span> Prescriptions</a>
        <a class="sidebar-link" href="<%=request.getContextPath()%>/doctor/add-prescription.jsp"><span class="menu-icon">📝</span> Add Prescription</a>
    </div>
    <div class="sidebar-section">
        <p class="section-title">ACCOUNT</p>
        <a class="sidebar-link" href="<%=request.getContextPath()%>/doctor/profile.jsp"><span class="menu-icon">👤</span> My Profile</a>
    </div>
    <div class="sidebar-bottom"><a class="sidebar-link" href="<%=request.getContextPath()%>/LogoutController"><span class="menu-icon">🏃🚪</span> Logout</a></div>
</aside>

<main class="main-content">
<header class="top-header">
    <div><h1>Medical Records</h1><p>View medical records created by you</p></div>
   
   <div class="doctor-account-menu">
    <button type="button"
            class="user-profile doctor-profile-trigger"
            id="doctorProfileTrigger"
            aria-expanded="false"
            aria-controls="doctorProfileDropdown">

        <div class="avatar"><%= firstLetter %></div>

        <div class="user-info">
            <strong><%= doctorName %></strong>
            <span><%= doctor.getSpecialization() %></span>
        </div>

        <span class="doctor-chevron" aria-hidden="true">⌄</span>
    </button>

    <div class="doctor-dropdown" id="doctorProfileDropdown" hidden>
        <a class="doctor-dropdown-item"
           href="<%= request.getContextPath() %>/doctor/profile.jsp">
            ✏️ <span>Update Details</span>
        </a>

        <a class="doctor-dropdown-item"
           href="<%= request.getContextPath() %>/doctor/change-password.jsp">
            🔒 <span>Change Password</span>
        </a>

        <div class="doctor-dropdown-divider"></div>

        <a class="doctor-dropdown-item logout-item"
           href="<%= request.getContextPath() %>/LogoutController">
            🚪 <span>Logout</span>
        </a>
    </div>
</div>

</header>

<section class="content-area">
    <div class="page-title">
        <div><h2>Medical Records</h2><p>Patient visits, symptoms, diagnosis and prescribed medicines</p></div>
        <div class="record-count"><strong><%=medicalRecords==null?0:medicalRecords.size()%></strong><span>Total Records</span></div>
    </div>

    <div class="records-list">
    <%
    if (medicalRecords != null && !medicalRecords.isEmpty()) {
        for (MedicalRecordDetails record : medicalRecords) {
    %>
        <article class="record-card">
            <div class="record-card-header">
                <div class="record-identity"><div class="record-icon">✚</div><div><h3>Medical Record #<%=record.getRecordId()%></h3><p>Visit Date: <%=record.getVisitDate()==null?"Not recorded":record.getVisitDate()%></p></div></div>
                <div class="patient-block"><span>PATIENT</span><strong><%=record.getPatientName()==null?"Unknown patient":record.getPatientName()%></strong></div>
            </div>
            <div class="record-body">
                <div class="main-details">
                    <div><p class="detail-label">Symptoms</p><div class="detail-box"><%=record.getSymptoms()==null||record.getSymptoms().trim().isEmpty()?"Not recorded":record.getSymptoms()%></div></div>
                    <div><p class="detail-label">Diagnosis</p><div class="detail-box diagnosis-box"><%=record.getDiagnosis()==null||record.getDiagnosis().trim().isEmpty()?"Not recorded":record.getDiagnosis()%></div></div>
                </div>
                <div class="vitals-grid">
                    <div class="vital-box"><span>Blood Pressure</span><strong><%=record.getBloodPressure()==null||record.getBloodPressure().trim().isEmpty()?"Not recorded":record.getBloodPressure()%></strong></div>
                    <div class="vital-box"><span>Temperature</span><strong><%=record.getTemperature()<=0?"Not recorded":record.getTemperature()+" °F"%></strong></div>
                    <div class="vital-box"><span>Weight</span><strong><%=record.getWeight()<=0?"Not recorded":record.getWeight()+" kg"%></strong></div>
                </div>
                <div class="section-heading"><h4>Prescriptions</h4><span>Linked to this appointment</span></div>
                <div class="prescriptions-list">
                <%
                    Set<Integer> displayedPrescriptionIds = new HashSet<Integer>();
                    boolean hasPrescription = false;
                    if (prescriptionDetails != null && record.getAppointmentId() > 0) {
                        for (PrescriptionDetails prescription : prescriptionDetails) {
                            if (prescription.getAppointmentId()==record.getAppointmentId()
                                    && prescription.getPatientId()==record.getPatientId()
                                    && prescription.getDoctorId()==doctorId) {
                                int prescriptionId = prescription.getPrescriptionId();
                                if (displayedPrescriptionIds.add(prescriptionId)) {
                                    hasPrescription = true;
                %>
                    <div class="prescription-card">
                        <h5>Prescription #<%=prescriptionId%></h5>
                        <p class="prescription-date">Date: <%=prescription.getPrescriptionDate()==null?"Not recorded":prescription.getPrescriptionDate()%></p>
                        <div class="medicine-list">
                        <%
                            for (PrescriptionDetails medicine : prescriptionDetails) {
                                if (medicine.getPrescriptionId()==prescriptionId
                                        && medicine.getAppointmentId()==record.getAppointmentId()
                                        && medicine.getPatientId()==record.getPatientId()
                                        && medicine.getDoctorId()==doctorId) {
                        %>
                            <div class="medicine-item">
                                <strong><%=medicine.getMedicineName()==null?"Medicine":medicine.getMedicineName()%></strong>
                                <p><b>Dosage:</b> <%=medicine.getDosage()==null?"Not specified":medicine.getDosage()%></p>
                                <p><b>Frequency:</b> <%=medicine.getFrequency()==null?"Not specified":medicine.getFrequency()%></p>
                                <p><b>Duration:</b> <%=medicine.getDuration()==null?"Not specified":medicine.getDuration()%></p>
                                <% if (medicine.getMedicineInstructions()!=null&&!medicine.getMedicineInstructions().trim().isEmpty()) { %>
                                <p><b>Instructions:</b> <%=medicine.getMedicineInstructions()%></p>
                                <% } %>
                            </div>
                        <%      }
                            }
                        %>
                        </div>
                        <% if (prescription.getInstructions()!=null&&!prescription.getInstructions().trim().isEmpty()) { %>
                        <div class="general-instructions"><b>General instructions:</b> <%=prescription.getInstructions()%></div>
                        <% } %>
                    </div>
                <%
                                }
                            }
                        }
                    }
                    if (!hasPrescription) {
                %>
                    <div class="no-prescription">No prescription linked to this visit.</div>
                <% } %>
                </div>
                <% if (record.getDoctorNotes()!=null&&!record.getDoctorNotes().trim().isEmpty()) { %>
                <div class="doctor-notes"><div class="record-icon">✎</div><div><strong>Doctor's Notes</strong><p><%=record.getDoctorNotes()%></p></div></div>
                <% } %>
            </div>
        </article>
    <%
        }
    } else {
    %>
        <div class="record-card empty-state"><strong>No medical records found.</strong>Records created during your consultations will appear here.</div>
    <% } %>
    </div>
</section>
<footer>© 2026 CareWell Hospital. Professional care, better health.</footer>
</main>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const profileButton = document.getElementById("doctorProfileTrigger");
    const profileDropdown = document.getElementById("doctorProfileDropdown");

    if (!profileButton || !profileDropdown) {
        console.error("Doctor profile dropdown elements were not found.");
        return;
    }

    function openDropdown() {
        profileDropdown.hidden = false;
        profileButton.setAttribute("aria-expanded", "true");
    }

    function closeDropdown() {
        profileDropdown.hidden = true;
        profileButton.setAttribute("aria-expanded", "false");
    }

    profileButton.addEventListener("click", function (event) {
        event.preventDefault();
        event.stopPropagation();

        if (profileDropdown.hidden) {
            openDropdown();
        } else {
            closeDropdown();
        }
    });

    profileDropdown.addEventListener("click", function (event) {
        event.stopPropagation();
    });

    document.addEventListener("click", function (event) {
        if (!profileButton.contains(event.target) &&
            !profileDropdown.contains(event.target)) {
            closeDropdown();
        }
    });

    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape") {
            closeDropdown();
            profileButton.focus();
        }
    });
});
</script>
</body>
</html>
