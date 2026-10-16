package com.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dao.PrescriptionDetailsDAO;
import com.model.PrescriptionDetails;
import com.util.DBConnection;

public class PrescriptionDetailsDAOImpl
        implements PrescriptionDetailsDAO {

    @Override
    public List<PrescriptionDetails> getAllPrescriptionDetails() {

        List<PrescriptionDetails> prescriptions =
                new ArrayList<>();

        String sql =
                "SELECT p.prescription_id, " +
                "p.patient_id, pu.full_name AS patient_name, " +
                "p.doctor_id, du.full_name AS doctor_name, " +
                "p.appointment_id, " +
                "p.prescription_date, " +
                "p.instructions, " +
                "pi.medicine_id, " +
                "m.medicine_name, " +
                "m.medicine_type, " +
                "pi.dosage, " +
                "pi.frequency, " +
                "pi.duration, " +
                "pi.instructions AS medicine_instructions " +
                "FROM prescriptions p " +
                "JOIN patients pa " +
                "ON p.patient_id = pa.patient_id " +
                "JOIN users pu " +
                "ON pa.user_id = pu.user_id " +
                "JOIN doctors d " +
                "ON p.doctor_id = d.doctor_id " +
                "JOIN users du " +
                "ON d.user_id = du.user_id " +
                "JOIN prescription_items pi " +
                "ON p.prescription_id = pi.prescription_id " +
                "JOIN medicines m " +
                "ON pi.medicine_id = m.medicine_id " +
                "ORDER BY p.prescription_date DESC, " +
                "p.prescription_id DESC";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement statement =
                     connection.prepareStatement(sql);

             ResultSet resultSet =
                     statement.executeQuery()) {

            while (resultSet.next()) {

                prescriptions.add(
                        mapResultSet(resultSet)
                );
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return prescriptions;
    }


    @Override
    public List<PrescriptionDetails>
            getPrescriptionDetailsByPatient(int patientId) {

        List<PrescriptionDetails> prescriptions =
                new ArrayList<>();

        String sql =
                "SELECT p.prescription_id, " +
                "p.patient_id, pu.full_name AS patient_name, " +
                "p.doctor_id, du.full_name AS doctor_name, " +
                "p.appointment_id, " +
                "p.prescription_date, " +
                "p.instructions, " +
                "pi.medicine_id, " +
                "m.medicine_name, " +
                "m.medicine_type, " +
                "pi.dosage, " +
                "pi.frequency, " +
                "pi.duration, " +
                "pi.instructions AS medicine_instructions " +
                "FROM prescriptions p " +
                "JOIN patients pa " +
                "ON p.patient_id = pa.patient_id " +
                "JOIN users pu " +
                "ON pa.user_id = pu.user_id " +
                "JOIN doctors d " +
                "ON p.doctor_id = d.doctor_id " +
                "JOIN users du " +
                "ON d.user_id = du.user_id " +
                "JOIN prescription_items pi " +
                "ON p.prescription_id = pi.prescription_id " +
                "JOIN medicines m " +
                "ON pi.medicine_id = m.medicine_id " +
                "WHERE p.patient_id = ? " +
                "ORDER BY p.prescription_date DESC, " +
                "p.prescription_id DESC";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, patientId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    prescriptions.add(
                            mapResultSet(resultSet)
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return prescriptions;
    }


    @Override
    public List<PrescriptionDetails>
            getPrescriptionDetailsByDoctor(int doctorId) {

        List<PrescriptionDetails> prescriptions =
                new ArrayList<>();

        String sql =
                "SELECT p.prescription_id, " +
                "p.patient_id, pu.full_name AS patient_name, " +
                "p.doctor_id, du.full_name AS doctor_name, " +
                "p.appointment_id, " +
                "p.prescription_date, " +
                "p.instructions, " +
                "pi.medicine_id, " +
                "m.medicine_name, " +
                "m.medicine_type, " +
                "pi.dosage, " +
                "pi.frequency, " +
                "pi.duration, " +
                "pi.instructions AS medicine_instructions " +
                "FROM prescriptions p " +
                "JOIN patients pa " +
                "ON p.patient_id = pa.patient_id " +
                "JOIN users pu " +
                "ON pa.user_id = pu.user_id " +
                "JOIN doctors d " +
                "ON p.doctor_id = d.doctor_id " +
                "JOIN users du " +
                "ON d.user_id = du.user_id " +
                "JOIN prescription_items pi " +
                "ON p.prescription_id = pi.prescription_id " +
                "JOIN medicines m " +
                "ON pi.medicine_id = m.medicine_id " +
                "WHERE p.doctor_id = ? " +
                "ORDER BY p.prescription_date DESC, " +
                "p.prescription_id DESC";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, doctorId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    prescriptions.add(
                            mapResultSet(resultSet)
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return prescriptions;
    }


    @Override
    public List<PrescriptionDetails>
            getPrescriptionDetailsByPrescription(
                    int prescriptionId) {

        List<PrescriptionDetails> prescriptions =
                new ArrayList<>();

        String sql =
                "SELECT p.prescription_id, " +
                "p.patient_id, pu.full_name AS patient_name, " +
                "p.doctor_id, du.full_name AS doctor_name, " +
                "p.appointment_id, " +
                "p.prescription_date, " +
                "p.instructions, " +
                "pi.medicine_id, " +
                "m.medicine_name, " +
                "m.medicine_type, " +
                "pi.dosage, " +
                "pi.frequency, " +
                "pi.duration, " +
                "pi.instructions AS medicine_instructions " +
                "FROM prescriptions p " +
                "JOIN patients pa " +
                "ON p.patient_id = pa.patient_id " +
                "JOIN users pu " +
                "ON pa.user_id = pu.user_id " +
                "JOIN doctors d " +
                "ON p.doctor_id = d.doctor_id " +
                "JOIN users du " +
                "ON d.user_id = du.user_id " +
                "JOIN prescription_items pi " +
                "ON p.prescription_id = pi.prescription_id " +
                "JOIN medicines m " +
                "ON pi.medicine_id = m.medicine_id " +
                "WHERE p.prescription_id = ? " +
                "ORDER BY pi.prescription_item_id";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, prescriptionId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    prescriptions.add(
                            mapResultSet(resultSet)
                    );
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return prescriptions;
    }


    private PrescriptionDetails mapResultSet(
            ResultSet resultSet) throws Exception {

        PrescriptionDetails prescription =
                new PrescriptionDetails();

        prescription.setPrescriptionId(
                resultSet.getInt("prescription_id"));

        prescription.setPatientId(
                resultSet.getInt("patient_id"));

        prescription.setPatientName(
                resultSet.getString("patient_name"));

        prescription.setDoctorId(
                resultSet.getInt("doctor_id"));

        prescription.setDoctorName(
                resultSet.getString("doctor_name"));

        prescription.setAppointmentId(
                resultSet.getInt("appointment_id"));

        prescription.setPrescriptionDate(
                resultSet.getDate("prescription_date"));

        prescription.setInstructions(
                resultSet.getString("instructions"));

        prescription.setMedicineId(
                resultSet.getInt("medicine_id"));

        prescription.setMedicineName(
                resultSet.getString("medicine_name"));

        prescription.setMedicineType(
                resultSet.getString("medicine_type"));

        prescription.setDosage(
                resultSet.getString("dosage"));

        prescription.setFrequency(
                resultSet.getString("frequency"));

        prescription.setDuration(
                resultSet.getString("duration"));

        prescription.setMedicineInstructions(
                resultSet.getString("medicine_instructions"));

        return prescription;
    }
}