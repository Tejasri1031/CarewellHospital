package com.daoimpl;

import com.dao.AdminBillingDAO;

import java.util.ArrayList;
import java.util.List;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.model.Bill;
import com.util.DBConnection;
import com.model.Payment;

public class AdminBillingDAOImpl implements AdminBillingDAO {

	@Override
	public double getTotalRevenue() {

	    double revenue = 0.0;

	    String sql = "SELECT COALESCE(SUM(payment_amount), 0) "
	               + "FROM payments "
	               + "WHERE UPPER(TRIM(payment_status)) = 'SUCCESS'";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            revenue = rs.getDouble(1);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return revenue;
	}

	@Override
	public int getTotalBills() {

	    int count = 0;

	    String sql = "SELECT COUNT(*) FROM bills";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            count = rs.getInt(1);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return count;
	}

	@Override
	public int getPaidBills() {

	    int count = 0;

	    String sql = "SELECT COUNT(*) FROM bills b "
	               + "WHERE b.total_amount <= ("
	               + "SELECT COALESCE(SUM(p.payment_amount), 0) "
	               + "FROM payments p "
	               + "WHERE p.bill_id = b.bill_id "
	               + "AND UPPER(TRIM(p.payment_status)) = 'SUCCESS'"
	               + ")";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            count = rs.getInt(1);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return count;
	}

	@Override
	public int getPendingBills() {

	    int count = 0;

	    String sql = "SELECT COUNT(*) FROM bills b "
	               + "WHERE b.total_amount > ("
	               + "SELECT COALESCE(SUM(p.payment_amount), 0) "
	               + "FROM payments p "
	               + "WHERE p.bill_id = b.bill_id "
	               + "AND UPPER(TRIM(p.payment_status)) = 'SUCCESS'"
	               + ")";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        if (rs.next()) {
	            count = rs.getInt(1);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return count;
	}
	
	@Override
	public List<Bill> getAllBillsWithPatientName() {

	    List<Bill> bills = new ArrayList<>();

	    String sql = "SELECT b.*, u.full_name AS patient_name "
	               + "FROM bills b "
	               + "INNER JOIN patients p ON b.patient_id = p.patient_id "
	               + "INNER JOIN users u ON p.user_id = u.user_id "
	               + "ORDER BY b.bill_date DESC, b.bill_id DESC";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        while (rs.next()) {

	            Bill bill = new Bill();

	            bill.setBillId(rs.getInt("bill_id"));
	            bill.setPatientId(rs.getInt("patient_id"));
	            bill.setAppointmentId(rs.getInt("appointment_id"));
	            bill.setBillDate(rs.getDate("bill_date"));

	            bill.setConsultationFee(rs.getDouble("consultation_fee"));
	            bill.setMedicineCharge(rs.getDouble("medicine_charge"));
	            bill.setTestCharge(rs.getDouble("test_charge"));
	            bill.setOtherCharge(rs.getDouble("other_charge"));

	            bill.setTotalAmount(rs.getDouble("total_amount"));
	            bill.setPaymentStatus(rs.getString("payment_status"));
	            bill.setPaymentMethod(rs.getString("payment_method"));
	            bill.setNotes(rs.getString("notes"));
	            bill.setCreatedAt(rs.getTimestamp("created_at"));

	            bill.setPatientName(rs.getString("patient_name"));

	            bills.add(bill);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return bills;
	}
	
	@Override
	public List<Payment> getAllPaymentsWithPatientName() {

	    List<Payment> payments = new ArrayList<>();

	    String sql = "SELECT p.*, u.full_name AS patient_name "
	               + "FROM payments p "
	               + "INNER JOIN patients pt ON p.patient_id = pt.patient_id "
	               + "INNER JOIN users u ON pt.user_id = u.user_id "
	               + "ORDER BY p.payment_date DESC, p.payment_id DESC";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        while (rs.next()) {

	            Payment payment = new Payment();

	            payment.setPaymentId(rs.getInt("payment_id"));
	            payment.setBillId(rs.getInt("bill_id"));
	            payment.setPatientId(rs.getInt("patient_id"));
	            payment.setPaymentAmount(rs.getDouble("payment_amount"));
	            payment.setPaymentMethod(rs.getString("payment_method"));
	            payment.setTransactionReference(
	                    rs.getString("transaction_reference"));
	            payment.setPaymentStatus(rs.getString("payment_status"));
	            payment.setPaymentDate(rs.getDate("payment_date"));

	            payment.setPatientName(rs.getString("patient_name"));

	            payments.add(payment);
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return payments;
	}
}