
package com.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dao.MedicalDocumentDAO;
import com.model.MedicalDocument;
import com.util.DBConnection;

public class MedicalDocumentDAOImpl implements MedicalDocumentDAO {

	@Override
	public boolean addDocument(MedicalDocument document) {

	    String sql = "INSERT INTO patient_medical_documents "
	            + "(patient_id, appointment_id, document_type, "
	            + "original_file_name, storage_key, content_type, "
	            + "file_size_bytes, validation_status) "
	            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

	    try (Connection connection = DBConnection.getConnection();
	         PreparedStatement statement = connection.prepareStatement(
	                 sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {

	        statement.setInt(1, document.getPatientId());

	        if (document.getAppointmentId() == null) {
	            statement.setNull(2, java.sql.Types.INTEGER);
	        } else {
	            statement.setInt(2, document.getAppointmentId());
	        }

	        statement.setString(3, document.getDocumentType());
	        statement.setString(4, document.getOriginalFileName());
	        statement.setString(5, document.getStorageKey());
	        statement.setString(6, document.getContentType());
	        statement.setLong(7, document.getFileSizeBytes());
	        statement.setString(8, document.getValidationStatus());

	        int rows = statement.executeUpdate();

	        if (rows > 0) {

	            try (java.sql.ResultSet keys =
	                    statement.getGeneratedKeys()) {

	                if (keys.next()) {
	                    document.setDocumentId(keys.getInt(1));
	                    return true;
	                }
	            }
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return false;
	}

    @Override
    public List<MedicalDocument> getDocumentsByPatient(int patientId) {

        List<MedicalDocument> documents = new ArrayList<>();

        String sql = "SELECT * FROM patient_medical_documents "
                + "WHERE patient_id = ? ORDER BY uploaded_at DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, patientId);

            try (ResultSet resultSet = statement.executeQuery()) {

                while (resultSet.next()) {
                    documents.add(mapDocument(resultSet));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return documents;
    }

    @Override
    public List<MedicalDocument> getDocumentsByAppointment(int appointmentId) {

        List<MedicalDocument> documents = new ArrayList<>();

        String sql = "SELECT * FROM patient_medical_documents "
                + "WHERE appointment_id = ? ORDER BY uploaded_at DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, appointmentId);

            try (ResultSet resultSet = statement.executeQuery()) {

                while (resultSet.next()) {
                    documents.add(mapDocument(resultSet));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return documents;
    }

    @Override
    public boolean updateAppointmentId(int documentId, int appointmentId) {

        String sql = "UPDATE patient_medical_documents "
                + "SET appointment_id = ? "
                + "WHERE document_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, appointmentId);
            statement.setInt(2, documentId);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean updateValidationStatus(int documentId, String status) {

        if (!"PENDING_REVIEW".equals(status)
                && !"VERIFIED".equals(status)
                && !"REJECTED".equals(status)) {
            return false;
        }

        String sql = "UPDATE patient_medical_documents "
                + "SET validation_status = ? WHERE document_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, status);
            statement.setInt(2, documentId);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean deleteDocument(int documentId) {

        String sql = "DELETE FROM patient_medical_documents "
                + "WHERE document_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, documentId);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private MedicalDocument mapDocument(ResultSet resultSet)
            throws Exception {

        MedicalDocument document = new MedicalDocument();

        document.setDocumentId(resultSet.getInt("document_id"));
        document.setPatientId(resultSet.getInt("patient_id"));

        int appointmentId = resultSet.getInt("appointment_id");

        if (resultSet.wasNull()) {
            document.setAppointmentId(null);
        } else {
            document.setAppointmentId(appointmentId);
        }

        document.setDocumentType(resultSet.getString("document_type"));
        document.setOriginalFileName(
                resultSet.getString("original_file_name"));
        document.setStorageKey(resultSet.getString("storage_key"));
        document.setContentType(resultSet.getString("content_type"));
        document.setFileSizeBytes(resultSet.getLong("file_size_bytes"));
        document.setValidationStatus(
                resultSet.getString("validation_status"));
        document.setUploadedAt(resultSet.getTimestamp("uploaded_at"));

        return document;
    }
}
