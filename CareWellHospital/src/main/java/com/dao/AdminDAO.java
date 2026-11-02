package com.dao;

public interface AdminDAO {

    int getTotalPatients();

    int getTotalDoctors();

    int getTotalAppointments();

    int getPendingAppointments();

}