
package com.dao;

import java.sql.Connection;
import java.sql.Date;
import java.util.List;

import com.model.Prescription;

public interface PrescriptionDAO {

    int addPrescription(Prescription prescription);

    int addPrescription(Connection connection, Prescription prescription)
            throws Exception;

    Prescription getPrescriptionById(int prescriptionId);

    List<Prescription> getAllPrescriptions();

    List<Prescription> getPrescriptionsByPatient(int patientId);

    List<Prescription> getPrescriptionsByDoctor(int doctorId);

    List<Prescription> getPrescriptionsByDate(Date prescriptionDate);

    boolean updatePrescription(Prescription prescription);

    boolean deletePrescription(int prescriptionId);
}
