package com.dao;

import java.util.List;

import com.model.PrescriptionDetails;

public interface PrescriptionDetailsDAO {

    List<PrescriptionDetails> getAllPrescriptionDetails();

    List<PrescriptionDetails> getPrescriptionDetailsByPatient(
            int patientId);

    List<PrescriptionDetails> getPrescriptionDetailsByDoctor(
            int doctorId);

    List<PrescriptionDetails> getPrescriptionDetailsByPrescription(
            int prescriptionId);
}