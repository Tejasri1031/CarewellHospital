package com.dao;

import java.util.List;

import com.model.Doctor;

public interface DoctorDAO {

    boolean addDoctor(Doctor doctor);

    Doctor getDoctorById(int doctorId);

    List<Doctor> getAllDoctors();

    List<Doctor> getDoctorsByDepartment(int departmentId);
    
    List<Doctor> getAvailableDoctorsByDepartment(int departmentId);

    boolean updateDoctor(Doctor doctor);

    boolean deleteDoctor(int doctorId);
    
    List<Doctor> getFeaturedDoctors();
    
    List<Doctor> getAllDoctorsForAdmin();
    
    Doctor getDoctorDetailsForAdmin(int doctorId);
}