package com.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dao.AppointmentDetailsDAO;
import com.model.AppointmentDetails;
import com.util.DBConnection;

public class AppointmentDetailsDAOImpl
        implements AppointmentDetailsDAO {

    @Override
    public List<AppointmentDetails> getAllAppointmentDetails() {

        List<AppointmentDetails> appointments =
                new ArrayList<>();

        String sql =
                "SELECT " +
                "a.appointment_id, " +
                "a.patient_id, " +
                "pu.full_name AS patient_name, " +
                "a.doctor_id, " +
                "du.full_name AS doctor_name, " +
                "a.department_id, " +
                "d.department_name, " +
                "a.appointment_date, " +
                "a.appointment_time, " +
                "a.reason, " +
                "a.status, " +
                "a.notes " +
                "FROM appointments a " +
                "JOIN patients p " +
                "ON a.patient_id = p.patient_id " +
                "JOIN users pu " +
                "ON p.user_id = pu.user_id " +
                "JOIN doctors dr " +
                "ON a.doctor_id = dr.doctor_id " +
                "JOIN users du " +
                "ON dr.user_id = du.user_id " +
                "JOIN departments d " +
                "ON a.department_id = d.department_id " +
                "ORDER BY a.appointment_date DESC, " +
                "a.appointment_time DESC";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement statement =
                     connection.prepareStatement(sql);

             ResultSet resultSet =
                     statement.executeQuery()) {

            while (resultSet.next()) {

                AppointmentDetails appointment =
                        mapResultSet(resultSet);

                appointments.add(appointment);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return appointments;
    }


    @Override
    public List<AppointmentDetails>
    getAppointmentDetailsByPatient(int patientId) {

        List<AppointmentDetails> appointments =
                new ArrayList<>();

        String sql =
                "SELECT " +
                "a.appointment_id, " +
                "a.patient_id, " +
                "pu.full_name AS patient_name, " +
                "a.doctor_id, " +
                "du.full_name AS doctor_name, " +
                "a.department_id, " +
                "d.department_name, " +
                "a.appointment_date, " +
                "a.appointment_time, " +
                "a.reason, " +
                "a.status, " +
                "a.notes " +
                "FROM appointments a " +
                "JOIN patients p " +
                "ON a.patient_id = p.patient_id " +
                "JOIN users pu " +
                "ON p.user_id = pu.user_id " +
                "JOIN doctors dr " +
                "ON a.doctor_id = dr.doctor_id " +
                "JOIN users du " +
                "ON dr.user_id = du.user_id " +
                "JOIN departments d " +
                "ON a.department_id = d.department_id " +
                "WHERE a.patient_id = ? " +
                "ORDER BY a.appointment_date DESC, " +
                "a.appointment_time DESC";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, patientId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    AppointmentDetails appointment =
                            mapResultSet(resultSet);

                    appointments.add(appointment);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return appointments;
    }


    @Override
    public List<AppointmentDetails>
    getAppointmentDetailsByDoctor(int doctorId) {

        List<AppointmentDetails> appointments =
                new ArrayList<>();

        String sql =
                "SELECT " +
                "a.appointment_id, " +
                "a.patient_id, " +
                "pu.full_name AS patient_name, " +
                "a.doctor_id, " +
                "du.full_name AS doctor_name, " +
                "a.department_id, " +
                "d.department_name, " +
                "a.appointment_date, " +
                "a.appointment_time, " +
                "a.reason, " +
                "a.status, " +
                "a.notes " +
                "FROM appointments a " +
                "JOIN patients p " +
                "ON a.patient_id = p.patient_id " +
                "JOIN users pu " +
                "ON p.user_id = pu.user_id " +
                "JOIN doctors dr " +
                "ON a.doctor_id = dr.doctor_id " +
                "JOIN users du " +
                "ON dr.user_id = du.user_id " +
                "JOIN departments d " +
                "ON a.department_id = d.department_id " +
                "WHERE a.doctor_id = ? " +
                "ORDER BY a.appointment_date DESC, " +
                "a.appointment_time DESC";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, doctorId);

            try (ResultSet resultSet =
                         statement.executeQuery()) {

                while (resultSet.next()) {

                    AppointmentDetails appointment =
                            mapResultSet(resultSet);

                    appointments.add(appointment);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return appointments;
    }
    
 
    @Override
    public List<AppointmentDetails> getAppointmentDetailsByDoctorAndDate(
            int doctorId, java.sql.Date appointmentDate) {

        List<AppointmentDetails> appointments = new ArrayList<>();

        String sql =
                "SELECT a.appointment_id, a.patient_id, " +
                "pu.full_name AS patient_name, a.doctor_id, " +
                "du.full_name AS doctor_name, a.department_id, " +
                "d.department_name, a.appointment_date, " +
                "a.appointment_time, a.reason, a.status, a.notes " +
                "FROM appointments a " +
                "JOIN patients p ON a.patient_id = p.patient_id " +
                "JOIN users pu ON p.user_id = pu.user_id " +
                "JOIN doctors dr ON a.doctor_id = dr.doctor_id " +
                "JOIN users du ON dr.user_id = du.user_id " +
                "JOIN departments d ON a.department_id = d.department_id " +
                "WHERE a.doctor_id = ? AND a.appointment_date = ? " +
                "ORDER BY a.appointment_time ASC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, doctorId);
            statement.setDate(2, appointmentDate);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    appointments.add(mapResultSet(resultSet));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return appointments;
    }


    @Override
    public List<AppointmentDetails> getAppointmentDetailsByDoctorAndStatus(
            int doctorId, String status) {

        List<AppointmentDetails> appointments = new ArrayList<>();

        String sql =
                "SELECT a.appointment_id, a.patient_id, " +
                "pu.full_name AS patient_name, a.doctor_id, " +
                "du.full_name AS doctor_name, a.department_id, " +
                "d.department_name, a.appointment_date, " +
                "a.appointment_time, a.reason, a.status, a.notes " +
                "FROM appointments a " +
                "JOIN patients p ON a.patient_id = p.patient_id " +
                "JOIN users pu ON p.user_id = pu.user_id " +
                "JOIN doctors dr ON a.doctor_id = dr.doctor_id " +
                "JOIN users du ON dr.user_id = du.user_id " +
                "JOIN departments d ON a.department_id = d.department_id " +
                "WHERE a.doctor_id = ? AND a.status = ? " +
                "ORDER BY a.appointment_date DESC, a.appointment_time ASC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, doctorId);
            statement.setString(2, status);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    appointments.add(mapResultSet(resultSet));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return appointments;
    }
 



    /* =====================================================
       RESULT SET → MODEL
       ===================================================== */

    private AppointmentDetails mapResultSet(
            ResultSet resultSet) throws Exception {

        AppointmentDetails appointment =
                new AppointmentDetails();

        appointment.setAppointmentId(
                resultSet.getInt("appointment_id"));

        appointment.setPatientId(
                resultSet.getInt("patient_id"));

        appointment.setPatientName(
                resultSet.getString("patient_name"));

        appointment.setDoctorId(
                resultSet.getInt("doctor_id"));

        appointment.setDoctorName(
                resultSet.getString("doctor_name"));

        appointment.setDepartmentId(
                resultSet.getInt("department_id"));

        appointment.setDepartmentName(
                resultSet.getString("department_name"));

        appointment.setAppointmentDate(
                resultSet.getDate("appointment_date"));

        appointment.setAppointmentTime(
                resultSet.getTime("appointment_time"));

        appointment.setReason(
                resultSet.getString("reason"));

        appointment.setStatus(
                resultSet.getString("status"));

        appointment.setNotes(
                resultSet.getString("notes"));

        return appointment;
    }
}