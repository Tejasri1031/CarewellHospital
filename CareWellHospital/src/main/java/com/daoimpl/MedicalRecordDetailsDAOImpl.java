package com.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dao.MedicalRecordDetailsDAO;
import com.model.MedicalRecordDetails;
import com.util.DBConnection;

public class MedicalRecordDetailsDAOImpl
        implements MedicalRecordDetailsDAO {

    @Override
    public List<MedicalRecordDetails> getAllMedicalRecordDetails() {

        List<MedicalRecordDetails> records = new ArrayList<>();

        String sql =
                "SELECT mr.record_id, " +
                "mr.patient_id, pu.full_name AS patient_name, " +
                "mr.doctor_id, du.full_name AS doctor_name, " +
                "mr.appointment_id, mr.visit_date, " +
                "mr.symptoms, mr.diagnosis, " +
                "mr.blood_pressure, mr.temperature, " +
                "mr.weight, mr.doctor_notes " +
                "FROM medical_records mr " +
                "JOIN patients p ON mr.patient_id = p.patient_id " +
                "JOIN users pu ON p.user_id = pu.user_id " +
                "JOIN doctors d ON mr.doctor_id = d.doctor_id " +
                "JOIN users du ON d.user_id = du.user_id " +
                "ORDER BY mr.visit_date DESC, mr.record_id DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                records.add(mapResultSet(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return records;
    }

    @Override
    public List<MedicalRecordDetails> getMedicalRecordDetailsByPatient(
            int patientId) {

        List<MedicalRecordDetails> records = new ArrayList<>();

        String sql =
                "SELECT mr.record_id, " +
                "mr.patient_id, pu.full_name AS patient_name, " +
                "mr.doctor_id, du.full_name AS doctor_name, " +
                "mr.appointment_id, mr.visit_date, " +
                "mr.symptoms, mr.diagnosis, " +
                "mr.blood_pressure, mr.temperature, " +
                "mr.weight, mr.doctor_notes " +
                "FROM medical_records mr " +
                "JOIN patients p ON mr.patient_id = p.patient_id " +
                "JOIN users pu ON p.user_id = pu.user_id " +
                "JOIN doctors d ON mr.doctor_id = d.doctor_id " +
                "JOIN users du ON d.user_id = du.user_id " +
                "WHERE mr.patient_id = ? " +
                "ORDER BY mr.visit_date DESC, mr.record_id DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, patientId);

            try (ResultSet resultSet = statement.executeQuery()) {

                while (resultSet.next()) {
                    records.add(mapResultSet(resultSet));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return records;
    }

    @Override
    public List<MedicalRecordDetails> getMedicalRecordDetailsByDoctor(
            int doctorId) {

        List<MedicalRecordDetails> records = new ArrayList<>();

        String sql =
                "SELECT mr.record_id, " +
                "mr.patient_id, pu.full_name AS patient_name, " +
                "mr.doctor_id, du.full_name AS doctor_name, " +
                "mr.appointment_id, mr.visit_date, " +
                "mr.symptoms, mr.diagnosis, " +
                "mr.blood_pressure, mr.temperature, " +
                "mr.weight, mr.doctor_notes " +
                "FROM medical_records mr " +
                "JOIN patients p ON mr.patient_id = p.patient_id " +
                "JOIN users pu ON p.user_id = pu.user_id " +
                "JOIN doctors d ON mr.doctor_id = d.doctor_id " +
                "JOIN users du ON d.user_id = du.user_id " +
                "WHERE mr.doctor_id = ? " +
                "ORDER BY mr.visit_date DESC, mr.record_id DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, doctorId);

            try (ResultSet resultSet = statement.executeQuery()) {

                while (resultSet.next()) {
                    records.add(mapResultSet(resultSet));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return records;
    }

    private MedicalRecordDetails mapResultSet(
            ResultSet resultSet) throws Exception {

        MedicalRecordDetails record =
                new MedicalRecordDetails();

        record.setRecordId(
                resultSet.getInt("record_id"));

        record.setPatientId(
                resultSet.getInt("patient_id"));

        record.setPatientName(
                resultSet.getString("patient_name"));

        record.setDoctorId(
                resultSet.getInt("doctor_id"));

        record.setDoctorName(
                resultSet.getString("doctor_name"));

        record.setAppointmentId(
                resultSet.getInt("appointment_id"));

        record.setVisitDate(
                resultSet.getDate("visit_date"));

        record.setSymptoms(
                resultSet.getString("symptoms"));

        record.setDiagnosis(
                resultSet.getString("diagnosis"));

        record.setBloodPressure(
                resultSet.getString("blood_pressure"));

        record.setTemperature(
                resultSet.getDouble("temperature"));

        record.setWeight(
                resultSet.getDouble("weight"));

        record.setDoctorNotes(
                resultSet.getString("doctor_notes"));

        return record;
    }
}