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
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/doctor-medical-records.css">
<style>
.content-area{padding-top:24px}
.page-title{display:flex;align-items:center;justify-content:space-between;gap:18px;margin-bottom:22px}
.page-title h2{margin:0 0 6px}.page-title p{margin:0}
.record-count{flex:0 0 auto;min-width:125px;padding:13px 18px}
.records-list{display:grid;grid-template-columns:1fr;gap:16px}
.record-card{background:#fff;border:1px solid #e4eaf2;border-radius:14px;overflow:hidden;box-shadow:0 4px 15px rgba(35,54,85,.045)}
.record-card-header{display:flex;align-items:center;justify-content:space-between;gap:16px;padding:15px 20px;border-bottom:1px solid #e8edf4;background:#fbfcfe}
.record-identity{display:flex;align-items:center;gap:12px;min-width:0}
.record-icon{width:38px;height:38px;flex:0 0 38px;display:flex;align-items:center;justify-content:center;border-radius:10px;background:#eef5ff;color:#176ce5;font-size:19px;font-weight:700}
.record-identity h3{margin:0 0 4px;color:#182238;font-size:15px}
.record-identity p{margin:0;color:#7b89a1;font-size:12px}
.patient-block{text-align:right;min-width:0}.patient-block span{display:block;margin-bottom:4px;color:#8996aa;font-size:10px;font-weight:700;letter-spacing:.7px}.patient-block strong{color:#176ce5;font-size:12px;overflow-wrap:anywhere}
.record-body{padding:17px 20px 19px}
.main-details{display:grid;grid-template-columns:minmax(0,1fr) minmax(0,1fr);gap:12px}
.detail-label{margin:0 0 7px;color:#71819a;font-size:10px;font-weight:700;letter-spacing:.8px;text-transform:uppercase}
.detail-box{padding:11px 13px;background:#f8fafc;border:1px solid #e4eaf2;border-radius:8px;color:#40516d;font-size:13px;line-height:1.5;overflow-wrap:anywhere;min-height:42px}
.diagnosis-box{border-left:3px solid #19a974;background:#eff8f3;color:#14784f;font-weight:600}
.vitals-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:10px;margin-top:12px}
.vital-box{padding:10px 12px;background:#f8fafc;border:1px solid #e4eaf2;border-radius:8px;min-width:0}
.vital-box span{display:block;color:#7b89a1;font-size:11px;margin-bottom:4px}.vital-box strong{color:#182238;font-size:13px;overflow-wrap:anywhere}
.section-heading{display:flex;align-items:center;justify-content:space-between;gap:10px;margin:18px 0 9px}
.section-heading h4{margin:0;color:#71819a;font-size:10px;font-weight:700;letter-spacing:.8px;text-transform:uppercase}
.section-heading span{color:#8996aa;font-size:11px}
.prescriptions-list{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:11px;align-items:start}
.prescription-card{min-width:0;padding:12px;background:#fbfcfe;border:1px solid #e2eaf4;border-radius:9px}
.prescription-card h5{margin:0 0 5px;color:#176ce5;font-size:13px}
.prescription-date{margin:0 0 9px;color:#7b89a1;font-size:11px}
.medicine-list{display:grid;grid-template-columns:1fr;gap:7px}
.medicine-item{padding:9px 10px;background:#fff;border:1px solid #e8edf4;border-radius:7px;min-width:0}
.medicine-item>strong{display:block;margin-bottom:5px;color:#182238;font-size:12px;overflow-wrap:anywhere}
.medicine-item p{margin:3px 0;color:#40516d;font-size:11px;line-height:1.45;overflow-wrap:anywhere}
.general-instructions{margin-top:9px;padding-top:8px;border-top:1px solid #e8edf4;color:#40516d;font-size:11px;line-height:1.5;overflow-wrap:anywhere}
.doctor-notes{display:flex;gap:10px;margin-top:14px;padding:11px 13px;border:1px solid #dbe9ff;border-radius:9px;background:#f2f7ff}
.doctor-notes strong{display:block;margin-bottom:4px;color:#526b8c;font-size:10px;letter-spacing:.7px;text-transform:uppercase}
.doctor-notes p{margin:0;color:#40516d;font-size:12px;line-height:1.5}
.no-prescription{padding:12px;border:1px dashed #d9e1ec;border-radius:8px;color:#8996aa;font-size:12px}
.empty-state{padding:40px 20px;text-align:center;color:#8996aa}
.empty-state strong{display:block;margin-bottom:6px;color:#40516d}
footer{padding:18px 0 4px;text-align:center;color:#8996aa;font-size:11px}
@media(max-width:850px){.main-details{grid-template-columns:1fr}.vitals-grid{grid-template-columns:repeat(3,minmax(0,1fr))}}
@media(max-width:600px){.content-area{padding:15px}.page-title{align-items:flex-start}.record-count{min-width:90px;padding:9px}.record-card-header{align-items:flex-start;padding:13px}.record-body{padding:13px}.vitals-grid{grid-template-columns:1fr}.prescriptions-list{grid-template-columns:1fr}}
</style>
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
    <div class="doctor-info"><div class="doctor-avatar"><%=firstLetter%></div><div><strong><%=doctorName==null?"Doctor":doctorName%></strong><span><%=doctor.getSpecialization()==null?"":doctor.getSpecialization()%></span></div></div>
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
</body>
</html>
