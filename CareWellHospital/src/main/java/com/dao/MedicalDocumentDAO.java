
package com.dao;

import java.util.List;
import com.model.MedicalDocument;

public interface MedicalDocumentDAO {

    // Save uploaded medical document details
    boolean addDocument(MedicalDocument document);

    // Get all documents uploaded by a patient
    List<MedicalDocument> getDocumentsByPatient(int patientId);

    // Get documents associated with an appointment
    List<MedicalDocument> getDocumentsByAppointment(int appointmentId);

    // Link previously uploaded documents to an appointment
    boolean updateAppointmentId(int documentId, int appointmentId);

    // Update document validation status
    boolean updateValidationStatus(int documentId, String status);

    // Delete a document record
    boolean deleteDocument(int documentId);
}
