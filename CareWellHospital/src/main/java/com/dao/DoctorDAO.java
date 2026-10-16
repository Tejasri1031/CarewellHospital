package com.dao;

import java.util.List;

import com.model.Doctor;

public interface DoctorDAO {

    boolean addDoctor(Doctor doctor);

    Doctor getDoctorById(int doctorId);

    List<Doctor> getAllDoctors();

    List<Doctor> getDoctorsByDepartment(int departmentId);

    boolean updateDoctor(Doctor doctor);

    boolean deleteDoctor(int doctorId);
    
    List<Doctor> getFeaturedDoctors();
}