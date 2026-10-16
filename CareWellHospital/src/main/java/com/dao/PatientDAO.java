package com.dao;

import java.util.List;

import com.model.Patient;

public interface PatientDAO {

    boolean addPatient(Patient patient);

    Patient getPatientById(int patientId);

    Patient getPatientByUserId(int userId);

    List<Patient> getAllPatients();

    boolean updatePatient(Patient patient);

    boolean deletePatient(int patientId);
}