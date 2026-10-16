package com.dao;

import java.util.List;

import com.model.MedicalRecordDetails;

public interface MedicalRecordDetailsDAO {

    List<MedicalRecordDetails> getAllMedicalRecordDetails();

    List<MedicalRecordDetails> getMedicalRecordDetailsByPatient(
            int patientId);

    List<MedicalRecordDetails> getMedicalRecordDetailsByDoctor(
            int doctorId);
}