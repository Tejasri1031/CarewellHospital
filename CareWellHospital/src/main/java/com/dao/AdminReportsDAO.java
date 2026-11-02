package com.dao;

import java.util.Map;
import java.sql.Date;

public interface AdminReportsDAO {
	
	int getTotalPatients();

	int getTotalDoctors();

	int getActiveDoctors();

	int getInactiveDoctors();

	int getTotalAppointments();

	double getTotalRevenue();
	
	int getPendingAppointments();

	int getConfirmedAppointments();

	int getCompletedAppointments();

	int getCancelledAppointments();
	
	int getMalePatients();

	int getFemalePatients();

	int getOtherGenderPatients();
	
	int getAvailableDoctors();

	int getUnavailableDoctors();
	
	int getTotalDepartments();

	int getActiveDepartments();
	
	int getNewPatientsThisMonth();

	int getNewDoctorsThisMonth();
	
	Map<String, Double> getDailyRevenue();
	
	Map<String, Integer> getAppointmentStatusByDateRange(
	        Date startDate, Date endDate);

	Map<String, Double> getRevenueByDateRange(
	        Date startDate, Date endDate);
}
