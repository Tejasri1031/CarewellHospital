package com.dao;

import java.util.List;

import com.model.AppointmentDetails;

public interface AppointmentDetailsDAO {

    List<AppointmentDetails> getAllAppointmentDetails();

    List<AppointmentDetails> getAppointmentDetailsByPatient(
            int patientId);

    List<AppointmentDetails> getAppointmentDetailsByDoctor(
            int doctorId);

    List<AppointmentDetails> getAppointmentDetailsByDoctorAndDate(
            int doctorId,
            java.sql.Date appointmentDate);

    List<AppointmentDetails> getAppointmentDetailsByDoctorAndStatus(
            int doctorId,
            String status);


}