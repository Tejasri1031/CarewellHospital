package com.daoimpl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.Time;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dao.AppointmentDAO;
import com.model.Appointment;
import com.util.DBConnection;

public class AppointmentDAOImpl implements AppointmentDAO {

    @Override
    public boolean addAppointment(Appointment appointment) {

        String sql = "INSERT INTO appointments "
                + "(patient_id, doctor_id, department_id, appointment_date, "
                + "appointment_time, reason, status, notes) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, appointment.getPatientId());
            statement.setInt(2, appointment.getDoctorId());
            statement.setInt(3, appointment.getDepartmentId());
            statement.setDate(4, appointment.getAppointmentDate());
            statement.setTime(5, appointment.getAppointmentTime());
            statement.setString(6, appointment.getReason());
            statement.setString(7, appointment.getStatus());
            statement.setString(8, appointment.getNotes());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    
    @Override
    public int addAppointmentAndGetId(Appointment appointment) {

        String sql = "INSERT INTO appointments "
                + "(patient_id, doctor_id, department_id, appointment_date, "
                + "appointment_time, reason, status, notes) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             sql,
                             java.sql.Statement.RETURN_GENERATED_KEYS)) {

            statement.setInt(
                    1,
                    appointment.getPatientId()
            );

            statement.setInt(
                    2,
                    appointment.getDoctorId()
            );

            statement.setInt(
                    3,
                    appointment.getDepartmentId()
            );

            statement.setDate(
                    4,
                    appointment.getAppointmentDate()
            );

            statement.setTime(
                    5,
                    appointment.getAppointmentTime()
            );

            statement.setString(
                    6,
                    appointment.getReason()
            );

            statement.setString(
                    7,
                    appointment.getStatus()
            );

            statement.setString(
                    8,
                    appointment.getNotes()
            );

            int rowsInserted =
                    statement.executeUpdate();

            if (rowsInserted > 0) {

                try (ResultSet resultSet =
                        statement.getGeneratedKeys()) {

                    if (resultSet.next()) {

                        return resultSet.getInt(1);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }


    @Override
    public Appointment getAppointmentById(int appointmentId) {

        String sql =
                "SELECT * FROM appointments WHERE appointment_id = ?";

        Appointment appointment = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, appointmentId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {

                appointment = mapAppointment(resultSet);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return appointment;
    }


    @Override
    public List<Appointment> getAllAppointments() {

        String sql = "SELECT * FROM appointments";

        List<Appointment> appointments = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql);
             ResultSet resultSet =
                     statement.executeQuery()) {

            while (resultSet.next()) {

                appointments.add(
                        mapAppointment(resultSet)
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return appointments;
    }


    @Override
    public List<Appointment> getAppointmentsByPatient(int patientId) {

        String sql =
                "SELECT * FROM appointments WHERE patient_id = ?";

        List<Appointment> appointments = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, patientId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {

                appointments.add(
                        mapAppointment(resultSet)
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return appointments;
    }


    @Override
    public List<Appointment> getAppointmentsByDoctor(int doctorId) {

        String sql =
                "SELECT * FROM appointments WHERE doctor_id = ?";

        List<Appointment> appointments = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, doctorId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {

                appointments.add(
                        mapAppointment(resultSet)
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return appointments;
    }

    
    @Override
    public List<Appointment> getAppointmentsByDoctorAndDate(
            int doctorId,
            Date appointmentDate) {

        String sql = "SELECT * FROM appointments "
                + "WHERE doctor_id = ? "
                + "AND appointment_date = ? "
                + "ORDER BY appointment_time ASC";

        List<Appointment> appointments = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, doctorId);
            statement.setDate(2, appointmentDate);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    appointments.add(mapAppointment(resultSet));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return appointments;
    }

    @Override
    public List<Appointment> getAppointmentsByDoctorAndStatus(
            int doctorId,
            String status) {

        String sql = "SELECT * FROM appointments "
                + "WHERE doctor_id = ? "
                + "AND status = ? "
                + "ORDER BY appointment_date DESC, appointment_time ASC";

        List<Appointment> appointments = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, doctorId);
            statement.setString(2, status);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    appointments.add(mapAppointment(resultSet));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return appointments;
    }

    @Override
    public List<Appointment> getAppointmentsByDate(
            Date appointmentDate) {

        String sql =
                "SELECT * FROM appointments WHERE appointment_date = ?";

        List<Appointment> appointments = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setDate(1, appointmentDate);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {

                appointments.add(
                        mapAppointment(resultSet)
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return appointments;
    }


    /*
     * Checks whether a doctor already has an appointment
     * at the selected date and time.
     *
     * PENDING and CONFIRMED appointments block the slot.
     * CANCELLED appointments do not block the slot.
     */
    @Override
    public boolean isSlotAvailable(
            int doctorId,
            Date appointmentDate,
            Time appointmentTime) {

        String sql =
                "SELECT COUNT(*) "
                + "FROM appointments "
                + "WHERE doctor_id = ? "
                + "AND appointment_date = ? "
                + "AND appointment_time = ? "
                + "AND status IN ('PENDING', 'CONFIRMED')";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, doctorId);
            statement.setDate(2, appointmentDate);
            statement.setTime(3, appointmentTime);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {

                int count = resultSet.getInt(1);

                return count == 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    @Override
    public boolean updateAppointment(Appointment appointment) {

        String sql =
                "UPDATE appointments SET "
                + "patient_id = ?, "
                + "doctor_id = ?, "
                + "department_id = ?, "
                + "appointment_date = ?, "
                + "appointment_time = ?, "
                + "reason = ?, "
                + "status = ?, "
                + "notes = ? "
                + "WHERE appointment_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(
                    1,
                    appointment.getPatientId()
            );

            statement.setInt(
                    2,
                    appointment.getDoctorId()
            );

            statement.setInt(
                    3,
                    appointment.getDepartmentId()
            );

            statement.setDate(
                    4,
                    appointment.getAppointmentDate()
            );

            statement.setTime(
                    5,
                    appointment.getAppointmentTime()
            );

            statement.setString(
                    6,
                    appointment.getReason()
            );

            statement.setString(
                    7,
                    appointment.getStatus()
            );

            statement.setString(
                    8,
                    appointment.getNotes()
            );

            statement.setInt(
                    9,
                    appointment.getAppointmentId()
            );

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    @Override
    public boolean deleteAppointment(int appointmentId) {

        String sql =
                "DELETE FROM appointments WHERE appointment_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, appointmentId);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    private Appointment mapAppointment(
            ResultSet resultSet) throws Exception {

        Appointment appointment = new Appointment();

        appointment.setAppointmentId(
                resultSet.getInt("appointment_id")
        );

        appointment.setPatientId(
                resultSet.getInt("patient_id")
        );

        appointment.setDoctorId(
                resultSet.getInt("doctor_id")
        );

        appointment.setDepartmentId(
                resultSet.getInt("department_id")
        );

        appointment.setAppointmentDate(
                resultSet.getDate("appointment_date")
        );

        appointment.setAppointmentTime(
                resultSet.getTime("appointment_time")
        );

        appointment.setReason(
                resultSet.getString("reason")
        );

        appointment.setStatus(
                resultSet.getString("status")
        );

        appointment.setNotes(
                resultSet.getString("notes")
        );

        appointment.setCreatedAt(
                resultSet.getTimestamp("created_at")
        );

        return appointment;
    }
}