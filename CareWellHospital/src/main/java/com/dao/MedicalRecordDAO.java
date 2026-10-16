package com.dao;

import java.sql.Date;
import java.util.List;

import com.model.MedicalRecord;

public interface MedicalRecordDAO {

    boolean addMedicalRecord(MedicalRecord medicalRecord);

    MedicalRecord getMedicalRecordById(int recordId);

    List<MedicalRecord> getAllMedicalRecords();

    List<MedicalRecord> getMedicalRecordsByPatient(int patientId);

    List<MedicalRecord> getMedicalRecordsByDoctor(int doctorId);

    List<MedicalRecord> getMedicalRecordsByDate(Date visitDate);

    boolean updateMedicalRecord(MedicalRecord medicalRecord);

    boolean deleteMedicalRecord(int recordId);
}