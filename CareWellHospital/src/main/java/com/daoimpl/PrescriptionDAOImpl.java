package com.daoimpl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dao.PrescriptionDAO;
import com.model.Prescription;
import com.util.DBConnection;

public class PrescriptionDAOImpl implements PrescriptionDAO {

	@Override
	public int addPrescription(Prescription prescription) {

	    try (Connection connection = DBConnection.getConnection()) {
	        return addPrescription(connection, prescription);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return -1;
	}

	@Override
	public int addPrescription(
	        Connection connection,
	        Prescription prescription) throws Exception {

	    String sql = "INSERT INTO prescriptions "
	            + "(patient_id, doctor_id, appointment_id, "
	            + "prescription_date, instructions) "
	            + "VALUES (?, ?, ?, ?, ?)";

	    try (PreparedStatement statement = connection.prepareStatement(
	            sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {

	        statement.setInt(1, prescription.getPatientId());
	        statement.setInt(2, prescription.getDoctorId());
	        statement.setInt(3, prescription.getAppointmentId());
	        statement.setDate(4, prescription.getPrescriptionDate());
	        statement.setString(5, prescription.getInstructions());

	        int rowsInserted = statement.executeUpdate();

	        if (rowsInserted == 0) {
	            throw new java.sql.SQLException(
	                    "Prescription could not be inserted.");
	        }

	        try (ResultSet resultSet = statement.getGeneratedKeys()) {
	            if (resultSet.next()) {
	                return resultSet.getInt(1);
	            }
	        }

	        throw new java.sql.SQLException(
	                "Generated prescription ID was not returned.");
	    }
	}
    @Override
    public Prescription getPrescriptionById(int prescriptionId) {

        String sql = "SELECT * FROM prescriptions "
                + "WHERE prescription_id = ?";

        Prescription prescription = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, prescriptionId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                prescription = mapPrescription(resultSet);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return prescription;
    }

    @Override
    public List<Prescription> getAllPrescriptions() {

        String sql = "SELECT * FROM prescriptions";

        List<Prescription> prescriptions = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                prescriptions.add(mapPrescription(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return prescriptions;
    }

    @Override
    public List<Prescription> getPrescriptionsByPatient(int patientId) {

        String sql = "SELECT * FROM prescriptions "
                + "WHERE patient_id = ?";

        List<Prescription> prescriptions = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, patientId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                prescriptions.add(mapPrescription(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return prescriptions;
    }

    @Override
    public List<Prescription> getPrescriptionsByDoctor(int doctorId) {

        String sql = "SELECT * FROM prescriptions "
                + "WHERE doctor_id = ?";

        List<Prescription> prescriptions = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, doctorId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                prescriptions.add(mapPrescription(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return prescriptions;
    }

    @Override
    public List<Prescription> getPrescriptionsByDate(Date prescriptionDate) {

        String sql = "SELECT * FROM prescriptions "
                + "WHERE prescription_date = ?";

        List<Prescription> prescriptions = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setDate(1, prescriptionDate);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                prescriptions.add(mapPrescription(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return prescriptions;
    }

    @Override
    public boolean updatePrescription(Prescription prescription) {

        String sql = "UPDATE prescriptions SET "
                + "patient_id = ?, doctor_id = ?, appointment_id = ?, "
                + "prescription_date = ?, instructions = ? "
                + "WHERE prescription_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, prescription.getPatientId());
            statement.setInt(2, prescription.getDoctorId());
            statement.setInt(3, prescription.getAppointmentId());
            statement.setDate(4, prescription.getPrescriptionDate());
            statement.setString(5, prescription.getInstructions());
            statement.setInt(6, prescription.getPrescriptionId());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean deletePrescription(int prescriptionId) {

        String sql = "DELETE FROM prescriptions "
                + "WHERE prescription_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, prescriptionId);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private Prescription mapPrescription(ResultSet resultSet)
            throws Exception {

        Prescription prescription = new Prescription();

        prescription.setPrescriptionId(
                resultSet.getInt("prescription_id"));

        prescription.setPatientId(
                resultSet.getInt("patient_id"));

        prescription.setDoctorId(
                resultSet.getInt("doctor_id"));

        prescription.setAppointmentId(
                resultSet.getInt("appointment_id"));

        prescription.setPrescriptionDate(
                resultSet.getDate("prescription_date"));

        prescription.setInstructions(
                resultSet.getString("instructions"));

        prescription.setCreatedAt(
                resultSet.getTimestamp("created_at"));

        return prescription;
    }
}