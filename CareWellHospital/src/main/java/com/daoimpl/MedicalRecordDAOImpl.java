package com.daoimpl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dao.MedicalRecordDAO;
import com.model.MedicalRecord;
import com.util.DBConnection;

public class MedicalRecordDAOImpl implements MedicalRecordDAO {

    @Override
    public boolean addMedicalRecord(MedicalRecord medicalRecord) {

        String sql = "INSERT INTO medical_records "
                + "(patient_id, doctor_id, appointment_id, visit_date, "
                + "symptoms, diagnosis, blood_pressure, temperature, "
                + "weight, doctor_notes) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, medicalRecord.getPatientId());
            statement.setInt(2, medicalRecord.getDoctorId());
            statement.setInt(3, medicalRecord.getAppointmentId());
            statement.setDate(4, medicalRecord.getVisitDate());
            statement.setString(5, medicalRecord.getSymptoms());
            statement.setString(6, medicalRecord.getDiagnosis());
            statement.setString(7, medicalRecord.getBloodPressure());
            statement.setDouble(8, medicalRecord.getTemperature());
            statement.setDouble(9, medicalRecord.getWeight());
            statement.setString(10, medicalRecord.getDoctorNotes());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public MedicalRecord getMedicalRecordById(int recordId) {

        String sql = "SELECT * FROM medical_records WHERE record_id = ?";
        MedicalRecord medicalRecord = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, recordId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                medicalRecord = mapMedicalRecord(resultSet);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return medicalRecord;
    }

    @Override
    public List<MedicalRecord> getAllMedicalRecords() {

        String sql = "SELECT * FROM medical_records";

        List<MedicalRecord> medicalRecords = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                medicalRecords.add(mapMedicalRecord(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return medicalRecords;
    }

    @Override
    public List<MedicalRecord> getMedicalRecordsByPatient(int patientId) {

        String sql = "SELECT * FROM medical_records WHERE patient_id = ?";

        List<MedicalRecord> medicalRecords = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, patientId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                medicalRecords.add(mapMedicalRecord(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return medicalRecords;
    }

    @Override
    public List<MedicalRecord> getMedicalRecordsByDoctor(int doctorId) {

        String sql = "SELECT * FROM medical_records WHERE doctor_id = ?";

        List<MedicalRecord> medicalRecords = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, doctorId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                medicalRecords.add(mapMedicalRecord(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return medicalRecords;
    }

    @Override
    public List<MedicalRecord> getMedicalRecordsByDate(Date visitDate) {

        String sql = "SELECT * FROM medical_records WHERE visit_date = ?";

        List<MedicalRecord> medicalRecords = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setDate(1, visitDate);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                medicalRecords.add(mapMedicalRecord(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return medicalRecords;
    }

    @Override
    public boolean updateMedicalRecord(MedicalRecord medicalRecord) {

        String sql = "UPDATE medical_records SET "
                + "patient_id = ?, doctor_id = ?, appointment_id = ?, "
                + "visit_date = ?, symptoms = ?, diagnosis = ?, "
                + "blood_pressure = ?, temperature = ?, weight = ?, "
                + "doctor_notes = ? "
                + "WHERE record_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, medicalRecord.getPatientId());
            statement.setInt(2, medicalRecord.getDoctorId());
            statement.setInt(3, medicalRecord.getAppointmentId());
            statement.setDate(4, medicalRecord.getVisitDate());
            statement.setString(5, medicalRecord.getSymptoms());
            statement.setString(6, medicalRecord.getDiagnosis());
            statement.setString(7, medicalRecord.getBloodPressure());
            statement.setDouble(8, medicalRecord.getTemperature());
            statement.setDouble(9, medicalRecord.getWeight());
            statement.setString(10, medicalRecord.getDoctorNotes());
            statement.setInt(11, medicalRecord.getRecordId());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean deleteMedicalRecord(int recordId) {

        String sql = "DELETE FROM medical_records WHERE record_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, recordId);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private MedicalRecord mapMedicalRecord(ResultSet resultSet)
            throws Exception {

        MedicalRecord medicalRecord = new MedicalRecord();

        medicalRecord.setRecordId(
                resultSet.getInt("record_id"));

        medicalRecord.setPatientId(
                resultSet.getInt("patient_id"));

        medicalRecord.setDoctorId(
                resultSet.getInt("doctor_id"));

        medicalRecord.setAppointmentId(
                resultSet.getInt("appointment_id"));

        medicalRecord.setVisitDate(
                resultSet.getDate("visit_date"));

        medicalRecord.setSymptoms(
                resultSet.getString("symptoms"));

        medicalRecord.setDiagnosis(
                resultSet.getString("diagnosis"));

        medicalRecord.setBloodPressure(
                resultSet.getString("blood_pressure"));

        medicalRecord.setTemperature(
                resultSet.getDouble("temperature"));

        medicalRecord.setWeight(
                resultSet.getDouble("weight"));

        medicalRecord.setDoctorNotes(
                resultSet.getString("doctor_notes"));

        medicalRecord.setCreatedAt(
                resultSet.getTimestamp("created_at"));

        return medicalRecord;
    }
}