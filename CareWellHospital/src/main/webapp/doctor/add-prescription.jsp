
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.dao.DoctorDAO" %>
<%@ page import="com.dao.AppointmentDAO" %>
<%@ page import="com.dao.PatientDAO" %>
<%@ page import="com.dao.UserDAO" %>
<%@ page import="com.dao.MedicineDAO" %>
<%@ page import="com.daoimpl.DoctorDAOImpl" %>
<%@ page import="com.daoimpl.AppointmentDAOImpl" %>
<%@ page import="com.daoimpl.PatientDAOImpl" %>
<%@ page import="com.daoimpl.UserDAOImpl" %>
<%@ page import="com.daoimpl.MedicineDAOImpl" %>
<%@ page import="com.model.User" %>
<%@ page import="com.model.Doctor" %>
<%@ page import="com.model.Appointment" %>
<%@ page import="com.model.Patient" %>
<%@ page import="com.model.Medicine" %>

<%
    User loggedInUser = (User) session.getAttribute("user");

    if (loggedInUser == null ||
            !"DOCTOR".equalsIgnoreCase(loggedInUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    DoctorDAO doctorDAO = new DoctorDAOImpl();
    AppointmentDAO appointmentDAO = new AppointmentDAOImpl();
    PatientDAO patientDAO = new PatientDAOImpl();
    UserDAO userDAO = new UserDAOImpl();
    MedicineDAO medicineDAO = new MedicineDAOImpl();

    Doctor loggedInDoctor = null;

    for (Doctor d : doctorDAO.getAllDoctors()) {
        if (d.getUserId() == loggedInUser.getUserId()) {
            loggedInDoctor = d;
            break;
        }
    }

    if (loggedInDoctor == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Appointment> appointments =
            appointmentDAO.getAppointmentsByDoctor(
                    loggedInDoctor.getDoctorId());

    List<Medicine> medicines = medicineDAO.getAvailableMedicines();

    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Write Prescription | CareWell Hospital</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/doctor-add-prescription.css">
</head>

<body>
<div class="page-container">

    <aside class="sidebar">
        <div class="brand">
            <div class="brand-icon">♥︎</div>
            <div>
                <h2>CareWell</h2>
                <span>HOSPITAL</span>
            </div>
        </div>

        <div class="sidebar-section">
            <p class="section-title">DOCTOR PORTAL</p>
            <a class="sidebar-link"
               href="<%= request.getContextPath() %>/doctor/dashboard.jsp">
                ◉ &nbsp; Dashboard
            </a>
            <a class="sidebar-link"
               href="<%= request.getContextPath() %>/doctor/appointments.jsp">
                ▣ &nbsp; My Appointments
            </a>
        </div>

        <div class="sidebar-section">
            <p class="section-title">PATIENT CARE</p>
            <a class="sidebar-link"
               href="<%= request.getContextPath() %>/doctor/medical-records.jsp">
                ▤ &nbsp; Medical Records
            </a>
            <a class="sidebar-link active"
               href="<%= request.getContextPath() %>/doctor/prescriptions.jsp">
                ▣ &nbsp; Prescriptions
            </a>
        </div>

        <div class="sidebar-section">
            <p class="section-title">ACCOUNT</p>
            <a class="sidebar-link"
               href="<%= request.getContextPath() %>/doctor/profile.jsp">
                ● &nbsp; My Profile
            </a>
        </div>

        <div class="sidebar-bottom">
            <a class="sidebar-link"
               href="<%= request.getContextPath() %>/LogoutController">
                ↪ &nbsp; Logout
            </a>
        </div>
    </aside>

    <main class="main-content">

        <header class="top-header">
            <div>
                <h1>Write Prescription</h1>
                <p>Create a prescription for your patient</p>
            </div>

            <div class="doctor-info">
                <div class="doctor-avatar">
                    <%= loggedInUser.getFullName().substring(0, 1).toUpperCase() %>
                </div>
                <div>
                    <strong><%= loggedInUser.getFullName() %></strong>
                    <span><%= loggedInDoctor.getSpecialization() %></span>
                </div>
            </div>
        </header>

        <section class="content-area">

            <div class="page-title">
                <h2>New Prescription</h2>
                <p>Select an appointment and enter the prescribed medicines.</p>
            </div>

            <% if ("failed".equals(error) ||
                   "invalidData".equals(error)) { %>
                <div class="error-message">
                    The prescription could not be saved. Please check the details and try again.
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/prescriptions"
                  method="post" id="prescriptionForm">

                <input type="hidden" name="action" value="add">

                <section class="form-card">
                    <h3>Patient & Appointment</h3>

                    <div class="form-group">
                        <label for="appointmentId">Select Appointment</label>

                        <select id="appointmentId" name="appointmentId" required>
                            <option value="">Choose an appointment</option>

                            <% for (Appointment appointment : appointments) {
                                Patient patient = patientDAO.getPatientById(
                                        appointment.getPatientId());

                                User patientUser = patient == null
                                        ? null
                                        : userDAO.getUserById(patient.getUserId());

                                if (patientUser != null) {
                            %>
                                <option value="<%= appointment.getAppointmentId() %>"
                                        data-patient="<%= patient.getPatientId() %>">
                                    Appointment #<%= appointment.getAppointmentId() %>
                                    — <%= patientUser.getFullName() %>
                                    — <%= appointment.getAppointmentDate() %>
                                    <%= appointment.getAppointmentTime() %>
                                    — <%= appointment.getStatus() %>
                                </option>
                            <%  }
                               } %>
                        </select>

                        <p class="field-note">
                            Only appointments assigned to your doctor account are listed.
                        </p>
                    </div>

                    <div class="form-group">
                        <label for="prescriptionDate">Prescription Date</label>
                        <input type="date" id="prescriptionDate"
                               name="prescriptionDate" required>
                    </div>

                    <div class="form-group">
                        <label for="instructions">General Instructions</label>
                        <textarea id="instructions" name="instructions"
                                  rows="3"
                                  placeholder="Enter general instructions for the patient"></textarea>
                    </div>
                </section>

                <section class="form-card">
                    <div class="section-heading">
                        <div>
                            <h3>Prescribed Medicines</h3>
                            <p>Add one or more medicines below.</p>
                        </div>

                        <button type="button" id="addMedicineButton"
                                class="secondary-button">
                            + Add Medicine
                        </button>
                    </div>

                    <div id="medicineContainer">

                        <div class="medicine-entry">
                            <div class="medicine-entry-header">
                                <h4>Medicine 1</h4>
                                <button type="button"
                                        class="remove-medicine"
                                        hidden>Remove</button>
                            </div>

                            <div class="form-group">
                                <label>Medicine</label>
                                <select name="medicineId" required>
                                    <option value="">Select medicine</option>
                                    <% for (Medicine medicine : medicines) { %>
                                        <option value="<%= medicine.getMedicineId() %>">
                                            <%= medicine.getMedicineName() %>
                                            — <%= medicine.getMedicineType() %>
                                        </option>
                                    <% } %>
                                </select>
                            </div>

                            <div class="form-grid">
                                <div class="form-group">
                                    <label>Dosage</label>
                                    <input type="text" name="dosage"
                                           placeholder="e.g. 1 tablet"
                                           maxlength="100" required>
                                </div>

                                <div class="form-group">
                                    <label>Frequency</label>
                                    <input type="text" name="frequency"
                                           placeholder="e.g. twice daily"
                                           maxlength="100" required>
                                </div>

                                <div class="form-group">
                                    <label>Duration</label>
                                    <input type="text" name="duration"
                                           placeholder="e.g. 5 days"
                                           maxlength="100" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Medicine Instructions</label>
                                <textarea name="medicineInstructions"
                                          rows="2" maxlength="500"
                                          placeholder="e.g. Take after meals"></textarea>
                            </div>
                        </div>

                    </div>
                </section>

                <div class="form-actions">
                    <a class="cancel-button"
                       href="<%= request.getContextPath() %>/doctor/prescriptions.jsp">
                        Cancel
                    </a>
                    <button type="submit" class="primary-button">
                        Save Prescription
                    </button>
                </div>

            </form>
        </section>

        <footer>
            © 2026 CareWell Hospital. Professional care, better health.
        </footer>

    </main>
</div>

<script>
    const container = document.getElementById("medicineContainer");
    const addButton = document.getElementById("addMedicineButton");

    function updateMedicineEntries() {
        const entries = container.querySelectorAll(".medicine-entry");

        entries.forEach((entry, index) => {
            entry.querySelector("h4").textContent = "Medicine " + (index + 1);
            entry.querySelector(".remove-medicine").hidden = entries.length === 1;
        });
    }

    addButton.addEventListener("click", function () {
        const firstEntry = container.querySelector(".medicine-entry");
        const newEntry = firstEntry.cloneNode(true);

        newEntry.querySelectorAll("input, textarea").forEach(field => {
            field.value = "";
        });

        newEntry.querySelectorAll("select").forEach(field => {
            field.selectedIndex = 0;
        });

        container.appendChild(newEntry);
        updateMedicineEntries();
    });

    container.addEventListener("click", function (event) {
        if (event.target.classList.contains("remove-medicine")) {
            event.target.closest(".medicine-entry").remove();
            updateMedicineEntries();
        }
    });

    document.getElementById("prescriptionDate").value =
        new Date().toLocaleDateString("en-CA");
</script>
</body>
</html>
