package com.daoimpl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dao.BillDAO;
import com.model.Bill;
import com.util.DBConnection;

public class BillDAOImpl implements BillDAO {

    @Override
    public boolean addBill(Bill bill) {

        String sql = "INSERT INTO bills "
                + "(patient_id, appointment_id, bill_date, "
                + "consultation_fee, medicine_charge, test_charge, "
                + "other_charge, total_amount, payment_status, "
                + "payment_method, notes) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, bill.getPatientId());
            statement.setInt(2, bill.getAppointmentId());
            statement.setDate(3, bill.getBillDate());
            statement.setDouble(4, bill.getConsultationFee());
            statement.setDouble(5, bill.getMedicineCharge());
            statement.setDouble(6, bill.getTestCharge());
            statement.setDouble(7, bill.getOtherCharge());
            statement.setDouble(8, bill.getTotalAmount());
            statement.setString(9, bill.getPaymentStatus());
            statement.setString(10, bill.getPaymentMethod());
            statement.setString(11, bill.getNotes());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public Bill getBillById(int billId) {

        String sql = "SELECT * FROM bills WHERE bill_id = ?";
        Bill bill = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, billId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                bill = mapBill(resultSet);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return bill;
    }

    @Override
    public List<Bill> getAllBills() {

        String sql = "SELECT * FROM bills";

        List<Bill> bills = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                bills.add(mapBill(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return bills;
    }

    @Override
    public List<Bill> getBillsByPatient(int patientId) {

        String sql = "SELECT * FROM bills WHERE patient_id = ?";

        List<Bill> bills = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, patientId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                bills.add(mapBill(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return bills;
    }

    @Override
    public List<Bill> getBillsByDate(Date billDate) {

        String sql = "SELECT * FROM bills WHERE bill_date = ?";

        List<Bill> bills = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setDate(1, billDate);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                bills.add(mapBill(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return bills;
    }

    @Override
    public List<Bill> getPendingBills() {

        String sql = "SELECT * FROM bills "
                + "WHERE payment_status = 'PENDING'";

        List<Bill> bills = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                bills.add(mapBill(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return bills;
    }

    @Override
    public boolean updateBill(Bill bill) {

        String sql = "UPDATE bills SET "
                + "patient_id = ?, appointment_id = ?, bill_date = ?, "
                + "consultation_fee = ?, medicine_charge = ?, "
                + "test_charge = ?, other_charge = ?, total_amount = ?, "
                + "payment_status = ?, payment_method = ?, notes = ? "
                + "WHERE bill_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, bill.getPatientId());
            statement.setInt(2, bill.getAppointmentId());
            statement.setDate(3, bill.getBillDate());
            statement.setDouble(4, bill.getConsultationFee());
            statement.setDouble(5, bill.getMedicineCharge());
            statement.setDouble(6, bill.getTestCharge());
            statement.setDouble(7, bill.getOtherCharge());
            statement.setDouble(8, bill.getTotalAmount());
            statement.setString(9, bill.getPaymentStatus());
            statement.setString(10, bill.getPaymentMethod());
            statement.setString(11, bill.getNotes());
            statement.setInt(12, bill.getBillId());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean deleteBill(int billId) {

        String sql = "DELETE FROM bills WHERE bill_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, billId);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private Bill mapBill(ResultSet resultSet) throws Exception {

        Bill bill = new Bill();

        bill.setBillId(
                resultSet.getInt("bill_id"));

        bill.setPatientId(
                resultSet.getInt("patient_id"));

        bill.setAppointmentId(
                resultSet.getInt("appointment_id"));

        bill.setBillDate(
                resultSet.getDate("bill_date"));

        bill.setConsultationFee(
                resultSet.getDouble("consultation_fee"));

        bill.setMedicineCharge(
                resultSet.getDouble("medicine_charge"));

        bill.setTestCharge(
                resultSet.getDouble("test_charge"));

        bill.setOtherCharge(
                resultSet.getDouble("other_charge"));

        bill.setTotalAmount(
                resultSet.getDouble("total_amount"));

        bill.setPaymentStatus(
                resultSet.getString("payment_status"));

        bill.setPaymentMethod(
                resultSet.getString("payment_method"));

        bill.setNotes(
                resultSet.getString("notes"));

        bill.setCreatedAt(
                resultSet.getTimestamp("created_at"));

        return bill;
    }
}