package com.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dao.DoctorDAO;
import com.model.Doctor;
import com.util.DBConnection;

public class DoctorDAOImpl implements DoctorDAO {

    @Override
    public boolean addDoctor(Doctor doctor) {

        String sql = "INSERT INTO doctors "
                + "(user_id, department_id, specialization, qualification, "
                + "experience_years, consultation_fee, bio, profile_image, "
                + "availability_status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, doctor.getUserId());
            statement.setInt(2, doctor.getDepartmentId());
            statement.setString(3, doctor.getSpecialization());
            statement.setString(4, doctor.getQualification());
            statement.setInt(5, doctor.getExperienceYears());
            statement.setDouble(6, doctor.getConsultationFee());
            statement.setString(7, doctor.getBio());
            statement.setString(8, doctor.getProfileImage());
            statement.setString(9, doctor.getAvailabilityStatus());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public Doctor getDoctorById(int doctorId) {

        String sql = "SELECT * FROM doctors WHERE doctor_id = ?";
        Doctor doctor = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, doctorId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                doctor = mapDoctor(resultSet);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return doctor;
    }

    @Override
    public List<Doctor> getAllDoctors() {

        String sql = "SELECT * FROM doctors";
        List<Doctor> doctors = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                doctors.add(mapDoctor(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return doctors;
    }

    @Override
    public List<Doctor> getDoctorsByDepartment(int departmentId) {

        String sql = "SELECT * FROM doctors WHERE department_id = ?";
        List<Doctor> doctors = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, departmentId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                doctors.add(mapDoctor(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return doctors;
    }

    @Override
    public boolean updateDoctor(Doctor doctor) {

        String sql = "UPDATE doctors SET "
                + "user_id = ?, department_id = ?, specialization = ?, "
                + "qualification = ?, experience_years = ?, "
                + "consultation_fee = ?, bio = ?, profile_image = ?, "
                + "availability_status = ? "
                + "WHERE doctor_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, doctor.getUserId());
            statement.setInt(2, doctor.getDepartmentId());
            statement.setString(3, doctor.getSpecialization());
            statement.setString(4, doctor.getQualification());
            statement.setInt(5, doctor.getExperienceYears());
            statement.setDouble(6, doctor.getConsultationFee());
            statement.setString(7, doctor.getBio());
            statement.setString(8, doctor.getProfileImage());
            statement.setString(9, doctor.getAvailabilityStatus());
            statement.setInt(10, doctor.getDoctorId());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    
    @Override
    public List<Doctor> getFeaturedDoctors() {

        List<Doctor> doctors = new ArrayList<>();

        String sql =
            "SELECT d.* FROM doctors d " +
            "INNER JOIN users u ON d.user_id = u.user_id " +
            "ORDER BY d.doctor_id DESC LIMIT 4";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                doctors.add(mapDoctor(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return doctors;
    }

    @Override
    public boolean deleteDoctor(int doctorId) {

        String sql = "DELETE FROM doctors WHERE doctor_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, doctorId);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private Doctor mapDoctor(ResultSet resultSet) throws Exception {

        Doctor doctor = new Doctor();

        doctor.setDoctorId(resultSet.getInt("doctor_id"));
        doctor.setUserId(resultSet.getInt("user_id"));
        doctor.setDepartmentId(resultSet.getInt("department_id"));
        doctor.setSpecialization(resultSet.getString("specialization"));
        doctor.setQualification(resultSet.getString("qualification"));
        doctor.setExperienceYears(resultSet.getInt("experience_years"));
        doctor.setConsultationFee(resultSet.getDouble("consultation_fee"));
        doctor.setBio(resultSet.getString("bio"));
        doctor.setProfileImage(resultSet.getString("profile_image"));
        doctor.setAvailabilityStatus(
                resultSet.getString("availability_status"));
        doctor.setCreatedAt(resultSet.getTimestamp("created_at"));

        return doctor;
    }
}