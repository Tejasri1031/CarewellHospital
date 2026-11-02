package com.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Map;
import java.util.LinkedHashMap;
import java.sql.Date;

import com.dao.AdminReportsDAO;
import com.util.DBConnection;

public class AdminReportsDAOImpl implements AdminReportsDAO {
	
	@Override
	public int getTotalPatients() {

	    String sql = "SELECT COUNT(*) FROM patients";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	
	@Override
	public int getTotalDoctors() {

	    String sql = "SELECT COUNT(*) FROM doctors";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	
	@Override
	public int getActiveDoctors() {

	    String sql = "SELECT COUNT(*) "
	               + "FROM doctors d "
	               + "INNER JOIN users u ON d.user_id = u.user_id "
	               + "WHERE UPPER(TRIM(u.status)) = 'ACTIVE'";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	
	@Override
	public int getInactiveDoctors() {

	    String sql = "SELECT COUNT(*) "
	               + "FROM doctors d "
	               + "INNER JOIN users u ON d.user_id = u.user_id "
	               + "WHERE UPPER(TRIM(u.status)) = 'INACTIVE'";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	
	@Override
	public int getTotalAppointments() {

	    String sql = "SELECT COUNT(*) FROM appointments";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	
	@Override
	public double getTotalRevenue() {

	    String sql = "SELECT COALESCE(SUM(payment_amount), 0) "
	               + "FROM payments "
	               + "WHERE UPPER(TRIM(payment_status)) = 'SUCCESS'";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getDouble(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0.0;
	}
	
	@Override
	public Map<String, Double> getDailyRevenue() {

	    Map<String, Double> revenueMap = new LinkedHashMap<>();

	    String sql = "SELECT payment_date, "
	               + "SUM(payment_amount) AS daily_revenue "
	               + "FROM payments "
	               + "WHERE UPPER(TRIM(payment_status)) = 'SUCCESS' "
	               + "GROUP BY payment_date "
	               + "ORDER BY payment_date ASC";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        while (rs.next()) {

	            String paymentDate = rs.getDate("payment_date").toString();

	            double dailyRevenue = rs.getDouble("daily_revenue");

	            revenueMap.put(paymentDate, dailyRevenue);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return revenueMap;
	}
	
	@Override
	public Map<String, Integer> getAppointmentStatusByDateRange(
	        Date startDate, Date endDate) {

	    Map<String, Integer> statusMap = new LinkedHashMap<>();

	    statusMap.put("PENDING", 0);
	    statusMap.put("CONFIRMED", 0);
	    statusMap.put("COMPLETED", 0);
	    statusMap.put("CANCELLED", 0);

	    String sql = "SELECT status, COUNT(*) AS total "
	               + "FROM appointments "
	               + "WHERE appointment_date BETWEEN ? AND ? "
	               + "GROUP BY status";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setDate(1, startDate);
	        ps.setDate(2, endDate);

	        try (ResultSet rs = ps.executeQuery()) {

	            while (rs.next()) {
	                String status = rs.getString("status");

	                statusMap.put(status, rs.getInt("total"));
	            }
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return statusMap;
	}
	
	@Override
	public Map<String, Double> getRevenueByDateRange(
	        Date startDate, Date endDate) {

	    Map<String, Double> revenueMap = new LinkedHashMap<>();

	    String sql = "SELECT DATE(payment_date) AS payment_date, "
	            + "SUM(payment_amount) AS daily_revenue "
	            + "FROM payments "
	            + "WHERE UPPER(TRIM(payment_status)) = 'SUCCESS' "
	            + "AND payment_date >= ? "
	            + "AND payment_date < DATE_ADD(?, INTERVAL 1 DAY) "
	            + "GROUP BY DATE(payment_date) "
	            + "ORDER BY DATE(payment_date) ASC";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setDate(1, startDate);
	        ps.setDate(2, endDate);

	        try (ResultSet rs = ps.executeQuery()) {

	            while (rs.next()) {
	                String paymentDate =
	                        rs.getDate("payment_date").toString();

	                double dailyRevenue =
	                        rs.getDouble("daily_revenue");

	                revenueMap.put(paymentDate, dailyRevenue);
	            }
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return revenueMap;
	}
	
	@Override
	public int getPendingAppointments() {

	    String sql = "SELECT COUNT(*) FROM appointments "
	               + "WHERE UPPER(TRIM(status)) = 'PENDING'";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	
	@Override
	public int getConfirmedAppointments() {

	    String sql = "SELECT COUNT(*) FROM appointments "
	               + "WHERE UPPER(TRIM(status)) = 'CONFIRMED'";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	
	@Override
	public int getCompletedAppointments() {

	    String sql = "SELECT COUNT(*) FROM appointments "
	               + "WHERE UPPER(TRIM(status)) = 'COMPLETED'";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	@Override
	public int getCancelledAppointments() {

	    String sql = "SELECT COUNT(*) FROM appointments "
	               + "WHERE UPPER(TRIM(status)) = 'CANCELLED'";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	@Override
	public int getMalePatients() {

	    String sql = "SELECT COUNT(*) FROM patients "
	               + "WHERE UPPER(TRIM(gender)) = 'MALE'";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	
	@Override
	public int getFemalePatients() {

	    String sql = "SELECT COUNT(*) FROM patients "
	               + "WHERE UPPER(TRIM(gender)) = 'FEMALE'";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	
	@Override
	public int getOtherGenderPatients() {

	    String sql = "SELECT COUNT(*) FROM patients "
	               + "WHERE UPPER(TRIM(gender)) = 'OTHER'";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	
	@Override
	public int getAvailableDoctors() {

	    String sql = "SELECT COUNT(*) FROM doctors "
	               + "WHERE UPPER(TRIM(availability_status)) = 'AVAILABLE'";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	
	@Override
	public int getUnavailableDoctors() {

	    String sql = "SELECT COUNT(*) FROM doctors "
	               + "WHERE UPPER(TRIM(availability_status)) = 'UNAVAILABLE'";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	@Override
	public int getTotalDepartments() {

	    String sql = "SELECT COUNT(*) FROM departments";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	
	@Override
	public int getActiveDepartments() {

	    String sql = "SELECT COUNT(*) FROM departments "
	               + "WHERE UPPER(TRIM(status)) = 'ACTIVE'";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	@Override
	public int getNewPatientsThisMonth() {

	    String sql = "SELECT COUNT(*) FROM patients "
	               + "WHERE MONTH(created_at) = MONTH(CURRENT_DATE()) "
	               + "AND YEAR(created_at) = YEAR(CURRENT_DATE())";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
	
	@Override
	public int getNewDoctorsThisMonth() {

	    String sql = "SELECT COUNT(*) FROM doctors "
	               + "WHERE MONTH(created_at) = MONTH(CURRENT_DATE()) "
	               + "AND YEAR(created_at) = YEAR(CURRENT_DATE())";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            return rs.getInt(1);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return 0;
	}
}