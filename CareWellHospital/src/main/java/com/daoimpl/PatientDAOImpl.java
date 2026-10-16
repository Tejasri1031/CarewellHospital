package com.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dao.PatientDAO;
import com.model.Patient;
import com.util.DBConnection;

public class PatientDAOImpl implements PatientDAO {

    @Override
    public boolean addPatient(Patient patient) {

        String sql = "INSERT INTO patients "
                + "(user_id, date_of_birth, gender, blood_group, address, "
                + "emergency_contact_name, emergency_contact_phone) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, patient.getUserId());
            statement.setDate(2, patient.getDateOfBirth());
            statement.setString(3, patient.getGender());
            statement.setString(4, patient.getBloodGroup());
            statement.setString(5, patient.getAddress());
            statement.setString(6, patient.getEmergencyContactName());
            statement.setString(7, patient.getEmergencyContactPhone());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public Patient getPatientById(int patientId) {

        String sql = "SELECT * FROM patients WHERE patient_id = ?";
        Patient patient = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, patientId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                patient = mapPatient(resultSet);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return patient;
    }

    @Override
    public Patient getPatientByUserId(int userId) {

        String sql = "SELECT * FROM patients WHERE user_id = ?";
        Patient patient = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, userId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                patient = mapPatient(resultSet);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return patient;
    }

    @Override
    public List<Patient> getAllPatients() {

        String sql = "SELECT * FROM patients";
        List<Patient> patients = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                patients.add(mapPatient(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return patients;
    }

    @Override
    public boolean updatePatient(Patient patient) {

        String sql = "UPDATE patients SET "
                + "user_id = ?, date_of_birth = ?, gender = ?, "
                + "blood_group = ?, address = ?, "
                + "emergency_contact_name = ?, "
                + "emergency_contact_phone = ? "
                + "WHERE patient_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, patient.getUserId());
            statement.setDate(2, patient.getDateOfBirth());
            statement.setString(3, patient.getGender());
            statement.setString(4, patient.getBloodGroup());
            statement.setString(5, patient.getAddress());
            statement.setString(6, patient.getEmergencyContactName());
            statement.setString(7, patient.getEmergencyContactPhone());
            statement.setInt(8, patient.getPatientId());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean deletePatient(int patientId) {

        String sql = "DELETE FROM patients WHERE patient_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, patientId);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private Patient mapPatient(ResultSet resultSet) throws Exception {

        Patient patient = new Patient();

        patient.setPatientId(
                resultSet.getInt("patient_id"));

        patient.setUserId(
                resultSet.getInt("user_id"));

        patient.setDateOfBirth(
                resultSet.getDate("date_of_birth"));

        patient.setGender(
                resultSet.getString("gender"));

        patient.setBloodGroup(
                resultSet.getString("blood_group"));

        patient.setAddress(
                resultSet.getString("address"));

        patient.setEmergencyContactName(
                resultSet.getString("emergency_contact_name"));

        patient.setEmergencyContactPhone(
                resultSet.getString("emergency_contact_phone"));

        patient.setCreatedAt(
                resultSet.getTimestamp("created_at"));

        return patient;
    }
}