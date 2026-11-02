package com.daoimpl;

import com.dao.AdminDAO;

public class AdminDAOImpl implements AdminDAO {
	
	@Override
	public int getTotalPatients() {

	    int count = 0;

	    String sql = "SELECT COUNT(*) FROM patients";

	    try (java.sql.Connection con = com.util.DBConnection.getConnection();
	         java.sql.PreparedStatement ps = con.prepareStatement(sql);
	         java.sql.ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            count = rs.getInt(1);
	        }

	    } catch (java.sql.SQLException e) {
	        e.printStackTrace();
	    }

	    return count;
	}
	
	@Override
	public int getTotalDoctors() {

	    int count = 0;

	    String sql = "SELECT COUNT(*) FROM doctors";

	    try (java.sql.Connection con = com.util.DBConnection.getConnection();
	         java.sql.PreparedStatement ps = con.prepareStatement(sql);
	         java.sql.ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            count = rs.getInt(1);
	        }

	    } catch (java.sql.SQLException e) {
	        e.printStackTrace();
	    }

	    return count;
	}
	
	@Override
	public int getTotalAppointments() {

	    int count = 0;

	    String sql = "SELECT COUNT(*) FROM appointments";

	    try (java.sql.Connection con = com.util.DBConnection.getConnection();
	         java.sql.PreparedStatement ps = con.prepareStatement(sql);
	         java.sql.ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            count = rs.getInt(1);
	        }

	    } catch (java.sql.SQLException e) {
	        e.printStackTrace();
	    }

	    return count;
	}
	
	@Override
	public int getPendingAppointments() {

	    int count = 0;

	    String sql = "SELECT COUNT(*) FROM appointments WHERE status = 'PENDING'";

	    try (java.sql.Connection con = com.util.DBConnection.getConnection();
	         java.sql.PreparedStatement ps = con.prepareStatement(sql);
	         java.sql.ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            count = rs.getInt(1);
	        }

	    } catch (java.sql.SQLException e) {
	        e.printStackTrace();
	    }

	    return count;
	}

}