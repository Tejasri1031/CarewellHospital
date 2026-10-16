package com.controller;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.dao.MedicalRecordDAO;
import com.daoimpl.MedicalRecordDAOImpl;
import com.model.MedicalRecord;

@WebServlet("/medical-records")
public class MedicalRecordController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private MedicalRecordDAO medicalRecordDAO;

    @Override
    public void init() throws ServletException {
        medicalRecordDAO = new MedicalRecordDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {

            if (action == null || action.equals("list")) {

                List<MedicalRecord> records =
                        medicalRecordDAO.getAllMedicalRecords();

                request.setAttribute("medicalRecords", records);

                request.getRequestDispatcher(
                        "/admin/medical-records.jsp")
                        .forward(request, response);

            } else if (action.equals("patient")) {

                int patientId = Integer.parseInt(
                        request.getParameter("patientId"));

                List<MedicalRecord> records =
                        medicalRecordDAO
                                .getMedicalRecordsByPatient(patientId);

                request.setAttribute("medicalRecords", records);

                request.getRequestDispatcher(
                        "/patient/medical-records.jsp")
                        .forward(request, response);

            } else if (action.equals("doctor")) {

                int doctorId = Integer.parseInt(
                        request.getParameter("doctorId"));

                List<MedicalRecord> records =
                        medicalRecordDAO
                                .getMedicalRecordsByDoctor(doctorId);

                request.setAttribute("medicalRecords", records);

                request.getRequestDispatcher(
                        "/doctor/medical-records.jsp")
                        .forward(request, response);

            } else if (action.equals("date")) {

                Date visitDate = Date.valueOf(
                        request.getParameter("visitDate"));

                List<MedicalRecord> records =
                        medicalRecordDAO
                                .getMedicalRecordsByDate(visitDate);

                request.setAttribute("medicalRecords", records);

                request.getRequestDispatcher(
                        "/admin/medical-records.jsp")
                        .forward(request, response);

            } else if (action.equals("delete")) {

                int recordId = Integer.parseInt(
                        request.getParameter("recordId"));

                medicalRecordDAO.deleteMedicalRecord(recordId);

                response.sendRedirect(
                        request.getContextPath()
                        + "/medical-records?action=list");
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/medical-records?action=list"
                    + "&error=invalidData");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {

            if ("add".equals(action)) {

                MedicalRecord record = new MedicalRecord();

                record.setPatientId(
                        Integer.parseInt(
                                request.getParameter("patientId")));

                record.setDoctorId(
                        Integer.parseInt(
                                request.getParameter("doctorId")));

                record.setAppointmentId(
                        Integer.parseInt(
                                request.getParameter(
                                        "appointmentId")));

                record.setVisitDate(
                        Date.valueOf(
                                request.getParameter("visitDate")));

                record.setSymptoms(
                        request.getParameter("symptoms"));

                record.setDiagnosis(
                        request.getParameter("diagnosis"));

                record.setBloodPressure(
                        request.getParameter("bloodPressure"));

                String temperature =
                        request.getParameter("temperature");

                if (temperature != null
                        && !temperature.isEmpty()) {

                    record.setTemperature(
                            Double.parseDouble(temperature));
                }

                String weight =
                        request.getParameter("weight");

                if (weight != null
                        && !weight.isEmpty()) {

                    record.setWeight(
                            Double.parseDouble(weight));
                }

                record.setDoctorNotes(
                        request.getParameter("doctorNotes"));

                boolean success =
                        medicalRecordDAO
                                .addMedicalRecord(record);

                if (success) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/medical-records?action=list");

                } else {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/doctor/add-medical-record.jsp"
                            + "?error=failed");
                }

            } else if ("update".equals(action)) {

                MedicalRecord record = new MedicalRecord();

                record.setRecordId(
                        Integer.parseInt(
                                request.getParameter("recordId")));

                record.setPatientId(
                        Integer.parseInt(
                                request.getParameter("patientId")));

                record.setDoctorId(
                        Integer.parseInt(
                                request.getParameter("doctorId")));

                record.setAppointmentId(
                        Integer.parseInt(
                                request.getParameter(
                                        "appointmentId")));

                record.setVisitDate(
                        Date.valueOf(
                                request.getParameter("visitDate")));

                record.setSymptoms(
                        request.getParameter("symptoms"));

                record.setDiagnosis(
                        request.getParameter("diagnosis"));

                record.setBloodPressure(
                        request.getParameter("bloodPressure"));

                String temperature =
                        request.getParameter("temperature");

                if (temperature != null
                        && !temperature.isEmpty()) {

                    record.setTemperature(
                            Double.parseDouble(temperature));
                }

                String weight =
                        request.getParameter("weight");

                if (weight != null
                        && !weight.isEmpty()) {

                    record.setWeight(
                            Double.parseDouble(weight));
                }

                record.setDoctorNotes(
                        request.getParameter("doctorNotes"));

                boolean success =
                        medicalRecordDAO
                                .updateMedicalRecord(record);

                if (success) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/medical-records?action=list");

                } else {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/medical-records?action=list"
                            + "&error=updateFailed");
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/medical-records?action=list"
                    + "&error=invalidData");
        }
    }
}