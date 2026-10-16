
package com.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dao.FeaturedDoctorDAO;
import com.model.FeaturedDoctor;
import com.util.DBConnection;

public class FeaturedDoctorDAOImpl implements FeaturedDoctorDAO {


@Override
public List<FeaturedDoctor> getFeaturedDoctors() {

    List<FeaturedDoctor> doctors = new ArrayList<>();

    String sql =
        "SELECT d.doctor_id, u.full_name, d.specialization, " +
        "d.qualification, d.experience_years, d.consultation_fee, " +
        "d.profile_image, d.availability_status, d.bio " +
        "FROM doctors d " +
        "INNER JOIN users u ON d.user_id = u.user_id " +
        "WHERE u.role = 'DOCTOR' AND u.status = 'ACTIVE' " +
        "ORDER BY d.doctor_id ASC";

    try (Connection connection = DBConnection.getConnection();
         PreparedStatement statement =
             connection.prepareStatement(sql);
         ResultSet resultSet = statement.executeQuery()) {

        while (resultSet.next()) {

            FeaturedDoctor doctor = new FeaturedDoctor();

            doctor.setDoctorId(resultSet.getInt("doctor_id"));
            doctor.setFullName(resultSet.getString("full_name"));
            doctor.setSpecialization(
                resultSet.getString("specialization"));
            doctor.setQualification(
                resultSet.getString("qualification"));
            doctor.setExperienceYears(
                resultSet.getInt("experience_years"));
            doctor.setConsultationFee(
                resultSet.getDouble("consultation_fee"));
            doctor.setProfileImage(
                resultSet.getString("profile_image"));
            doctor.setAvailabilityStatus(
                resultSet.getString("availability_status"));
            doctor.setBio(resultSet.getString("bio"));

            doctors.add(doctor);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return doctors;
}

}
