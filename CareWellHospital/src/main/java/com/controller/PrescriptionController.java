
package com.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.dao.AppointmentDAO;
import com.dao.DoctorDAO;
import com.dao.MedicineDAO;
import com.dao.PrescriptionDAO;
import com.dao.PrescriptionItemDAO;
import com.dao.PatientDAO;
import com.dao.UserDAO;

import com.daoimpl.AppointmentDAOImpl;
import com.daoimpl.DoctorDAOImpl;
import com.daoimpl.MedicineDAOImpl;
import com.daoimpl.PrescriptionDAOImpl;
import com.daoimpl.PrescriptionItemDAOImpl;
import com.daoimpl.PatientDAOImpl;
import com.daoimpl.UserDAOImpl;

import com.model.Appointment;
import com.model.Doctor;
import com.model.Medicine;
import com.model.Prescription;
import com.model.PrescriptionItem;
import com.model.Patient;
import com.model.User;

import com.util.DBConnection;
import com.util.EmailService;

@WebServlet("/prescriptions")
public class PrescriptionController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PrescriptionDAO prescriptionDAO;
    private PrescriptionItemDAO prescriptionItemDAO;
    private AppointmentDAO appointmentDAO;
    private DoctorDAO doctorDAO;
    private MedicineDAO medicineDAO;
    private PatientDAO patientDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        prescriptionDAO = new PrescriptionDAOImpl();
        prescriptionItemDAO = new PrescriptionItemDAOImpl();
        appointmentDAO = new AppointmentDAOImpl();
        doctorDAO = new DoctorDAOImpl();
        medicineDAO = new MedicineDAOImpl();
        patientDAO = new PatientDAOImpl();
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if (action == null || action.equals("list")) {

                List<Prescription> prescriptions =
                        prescriptionDAO.getAllPrescriptions();

                request.setAttribute("prescriptions", prescriptions);

                request.getRequestDispatcher(
                        "/admin/prescriptions.jsp")
                        .forward(request, response);

            } else if (action.equals("patient")) {

                int patientId = Integer.parseInt(
                        request.getParameter("patientId"));

                List<Prescription> prescriptions =
                        prescriptionDAO.getPrescriptionsByPatient(patientId);

                request.setAttribute("prescriptions", prescriptions);

                request.getRequestDispatcher(
                        "/patient/prescriptions.jsp")
                        .forward(request, response);

            } else if (action.equals("doctor")) {

                int doctorId = Integer.parseInt(
                        request.getParameter("doctorId"));

                List<Prescription> prescriptions =
                        prescriptionDAO.getPrescriptionsByDoctor(doctorId);

                request.setAttribute("prescriptions", prescriptions);

                request.getRequestDispatcher(
                        "/doctor/prescriptions.jsp")
                        .forward(request, response);

            } else if (action.equals("date")) {

                Date prescriptionDate = Date.valueOf(
                        request.getParameter("prescriptionDate"));

                List<Prescription> prescriptions =
                        prescriptionDAO.getPrescriptionsByDate(
                                prescriptionDate);

                request.setAttribute("prescriptions", prescriptions);

                request.getRequestDispatcher(
                        "/admin/prescriptions.jsp")
                        .forward(request, response);

            } else if (action.equals("delete")) {

                int prescriptionId = Integer.parseInt(
                        request.getParameter("prescriptionId"));

                prescriptionDAO.deletePrescription(prescriptionId);

                response.sendRedirect(
                        request.getContextPath()
                        + "/prescriptions?action=list");
            }

        } catch (Exception e) {
            e.printStackTrace();

            if (!response.isCommitted()) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/prescriptions?action=list&error=invalidData");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            savePrescription(request, response);
            return;
        }

        if ("update".equals(action)) {
            updatePrescription(request, response);
            return;
        }

        response.sendRedirect(
                request.getContextPath()
                + "/prescriptions?action=list&error=invalidAction");
    }

    private void savePrescription(HttpServletRequest request,
                                  HttpServletResponse response)
            throws IOException {

        String redirect = request.getContextPath()
                + "/doctor/add-prescription.jsp";

        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("user") instanceof User)) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        User loggedInUser = (User) session.getAttribute("user");

        if (!"DOCTOR".equalsIgnoreCase(loggedInUser.getRole())) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/doctor/add-prescription.jsp?error=unauthorized");
            return;
        }

        try {
            int appointmentId = Integer.parseInt(
                    request.getParameter("appointmentId"));

            String dateValue = request.getParameter("prescriptionDate");

            if (dateValue == null || dateValue.trim().isEmpty()) {
                throw new IllegalArgumentException(
                        "Prescription date is required.");
            }

            Date prescriptionDate = Date.valueOf(dateValue);

            String[] medicineIds = request.getParameterValues("medicineId");
            String[] dosages = request.getParameterValues("dosage");
            String[] frequencies = request.getParameterValues("frequency");
            String[] durations = request.getParameterValues("duration");
            String[] medicineInstructions =
                    request.getParameterValues("medicineInstructions");

            if (medicineIds == null || medicineIds.length == 0
                    || dosages == null
                    || frequencies == null
                    || durations == null
                    || medicineInstructions == null
                    || medicineIds.length != dosages.length
                    || medicineIds.length != frequencies.length
                    || medicineIds.length != durations.length
                    || medicineIds.length != medicineInstructions.length) {
                throw new IllegalArgumentException(
                        "Please provide complete medicine details.");
            }

            // Find the logged-in doctor's database ID.
            int doctorId = -1;

            List<Doctor> doctors = doctorDAO.getAllDoctors();

            for (Doctor doctor : doctors) {
                if (doctor.getUserId() == loggedInUser.getUserId()) {
                    doctorId = doctor.getDoctorId();
                    break;
                }
            }

            if (doctorId <= 0) {
                throw new IllegalArgumentException(
                        "Doctor profile was not found.");
            }

            // Ensure the selected appointment belongs to this doctor.
            Appointment appointment =
                    appointmentDAO.getAppointmentById(appointmentId);

            if (appointment == null
                    || appointment.getDoctorId() != doctorId) {
                throw new IllegalArgumentException(
                        "Invalid appointment for this doctor.");
            }

            // Validate every medicine before opening the transaction.
            List<Medicine> availableMedicines =
                    medicineDAO.getAvailableMedicines();

            for (int i = 0; i < medicineIds.length; i++) {
                int medicineId = Integer.parseInt(medicineIds[i]);

                if (dosages[i] == null || dosages[i].trim().isEmpty()
                        || frequencies[i] == null
                        || frequencies[i].trim().isEmpty()
                        || durations[i] == null
                        || durations[i].trim().isEmpty()) {
                    throw new IllegalArgumentException(
                            "Dosage, frequency and duration are required.");
                }

                boolean available = false;

                for (Medicine medicine : availableMedicines) {
                    if (medicine.getMedicineId() == medicineId) {
                        available = true;
                        break;
                    }
                }

                if (!available) {
                    throw new IllegalArgumentException(
                            "A selected medicine is unavailable.");
                }
            }

            int savedPrescriptionId = -1;

            try (Connection connection = DBConnection.getConnection()) {

                connection.setAutoCommit(false);

                try {
                    Prescription prescription = new Prescription();

                    prescription.setPatientId(appointment.getPatientId());
                    prescription.setDoctorId(doctorId);
                    prescription.setAppointmentId(appointmentId);
                    prescription.setPrescriptionDate(prescriptionDate);
                    prescription.setInstructions(
                            request.getParameter("instructions"));

                    savedPrescriptionId =
                            prescriptionDAO.addPrescription(
                                    connection, prescription);

                    if (savedPrescriptionId <= 0) {
                        throw new java.sql.SQLException(
                                "Could not save prescription.");
                    }

                    for (int i = 0; i < medicineIds.length; i++) {
                        PrescriptionItem item = new PrescriptionItem();

                        item.setPrescriptionId(savedPrescriptionId);
                        item.setMedicineId(
                                Integer.parseInt(medicineIds[i]));
                        item.setDosage(dosages[i].trim());
                        item.setFrequency(frequencies[i].trim());
                        item.setDuration(durations[i].trim());
                        item.setInstructions(
                                medicineInstructions[i] == null
                                ? ""
                                : medicineInstructions[i].trim());

                        prescriptionItemDAO.addPrescriptionItem(
                                connection, item);
                    }

                    connection.commit();

                } catch (Exception e) {
                    try {
                        connection.rollback();
                    } catch (Exception rollbackError) {
                        e.addSuppressed(rollbackError);
                    }

                    throw e;
                }
            }

            // Notify the patient only after the prescription transaction commits.
            // Email failure must not undo or misreport the saved prescription.
            try {
                Patient patient =
                        patientDAO.getPatientById(appointment.getPatientId());

                if (patient != null) {
                    User patientUser = userDAO.getUserById(patient.getUserId());

                    if (patientUser != null
                            && patientUser.getEmail() != null
                            && !patientUser.getEmail().trim().isEmpty()) {

                        String patientName = patientUser.getFullName();
                        if (patientName == null || patientName.trim().isEmpty()) {
                            patientName = "Patient";
                        }

                        String subject =
                                "CareWell Hospital - New Prescription Available";

                        String body =
                                "Dear " + patientName + ",\n\n"
                              + "A new prescription has been added for your appointment.\n\n"
                              + "Prescription ID: " + savedPrescriptionId + "\n"
                              + "Prescription Date: " + prescriptionDate + "\n\n"
                              + "Please sign in to CareWell Hospital to view your prescription securely.\n\n"
                              + "Regards,\nCareWell Hospital";

                        boolean emailSent = EmailService.sendEmail(
                                patientUser.getEmail().trim(), subject, body);

                        if (emailSent) {
                            System.out.println(
                                    "Prescription notification email sent for prescription ID: "
                                    + savedPrescriptionId);
                        } else {
                            System.err.println(
                                    "Prescription saved, but notification email failed for prescription ID: "
                                    + savedPrescriptionId);
                        }
                    } else {
                        System.err.println(
                                "Prescription saved, but patient email is unavailable. Prescription ID: "
                                + savedPrescriptionId);
                    }
                } else {
                    System.err.println(
                            "Prescription saved, but patient record was not found. Prescription ID: "
                            + savedPrescriptionId);
                }
            } catch (Exception emailException) {
                System.err.println(
                        "Prescription saved, but notification email could not be sent. Prescription ID: "
                        + savedPrescriptionId);
                emailException.printStackTrace();
            }

            response.sendRedirect(
                    redirect + "?success=true");

        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect(
                    redirect + "?error=failed");
        }
    }

    private void updatePrescription(HttpServletRequest request,
                                    HttpServletResponse response)
            throws IOException {

        try {
            Prescription prescription = new Prescription();

            prescription.setPrescriptionId(
                    Integer.parseInt(
                            request.getParameter("prescriptionId")));

            prescription.setPatientId(
                    Integer.parseInt(
                            request.getParameter("patientId")));

            prescription.setDoctorId(
                    Integer.parseInt(
                            request.getParameter("doctorId")));

            prescription.setAppointmentId(
                    Integer.parseInt(
                            request.getParameter("appointmentId")));

            prescription.setPrescriptionDate(
                    Date.valueOf(
                            request.getParameter("prescriptionDate")));

            prescription.setInstructions(
                    request.getParameter("instructions"));

            boolean success =
                    prescriptionDAO.updatePrescription(prescription);

            response.sendRedirect(
                    request.getContextPath()
                    + "/prescriptions?action=list"
                    + (success ? "" : "&error=updateFailed"));

        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/prescriptions?action=list&error=invalidData");
        }
    }
}