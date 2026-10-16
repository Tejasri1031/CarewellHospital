package com.dao;

import java.sql.Date;
import java.sql.Time;
import java.util.List;

import com.model.Appointment;

public interface AppointmentDAO {

    boolean addAppointment(Appointment appointment);

    int addAppointmentAndGetId(Appointment appointment);

    Appointment getAppointmentById(int appointmentId);

    List<Appointment> getAllAppointments();

    List<Appointment> getAppointmentsByPatient(int patientId);

    List<Appointment> getAppointmentsByDoctor(int doctorId);

    List<Appointment> getAppointmentsByDate(Date appointmentDate);

    List<Appointment> getAppointmentsByDoctorAndDate(
            int doctorId,
            Date appointmentDate);

    List<Appointment> getAppointmentsByDoctorAndStatus(
            int doctorId,
            String status);
    
    boolean isSlotAvailable(
            int doctorId,
            Date appointmentDate,
            Time appointmentTime);

    boolean updateAppointment(Appointment appointment);

    boolean deleteAppointment(int appointmentId);
}