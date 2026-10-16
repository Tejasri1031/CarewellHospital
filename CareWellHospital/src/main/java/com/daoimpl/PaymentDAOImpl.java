package com.daoimpl;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dao.PaymentDAO;
import com.model.Payment;
import com.util.DBConnection;

public class PaymentDAOImpl implements PaymentDAO {

    @Override
    public boolean addPayment(Payment payment) {

        String sql = "INSERT INTO payments "
                + "(bill_id, patient_id, payment_amount, payment_method, "
                + "transaction_reference, payment_status, payment_date) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, payment.getBillId());
            statement.setInt(2, payment.getPatientId());
            statement.setDouble(3, payment.getPaymentAmount());
            statement.setString(4, payment.getPaymentMethod());
            statement.setString(5, payment.getTransactionReference());
            statement.setString(6, payment.getPaymentStatus());
            statement.setDate(7, payment.getPaymentDate());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public Payment getPaymentById(int paymentId) {

        String sql = "SELECT * FROM payments WHERE payment_id = ?";
        Payment payment = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, paymentId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                payment = mapPayment(resultSet);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return payment;
    }

    @Override
    public List<Payment> getAllPayments() {

        String sql = "SELECT * FROM payments";

        List<Payment> payments = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                payments.add(mapPayment(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return payments;
    }

    @Override
    public List<Payment> getPaymentsByBill(int billId) {

        String sql = "SELECT * FROM payments WHERE bill_id = ?";

        List<Payment> payments = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, billId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                payments.add(mapPayment(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return payments;
    }

    @Override
    public List<Payment> getPaymentsByPatient(int patientId) {

        String sql = "SELECT * FROM payments WHERE patient_id = ?";

        List<Payment> payments = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, patientId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                payments.add(mapPayment(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return payments;
    }

    @Override
    public List<Payment> getPaymentsByDate(Date paymentDate) {

        String sql = "SELECT * FROM payments WHERE payment_date = ?";

        List<Payment> payments = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setDate(1, paymentDate);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                payments.add(mapPayment(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return payments;
    }

    @Override
    public List<Payment> getSuccessfulPayments() {

        String sql = "SELECT * FROM payments "
                + "WHERE payment_status = 'SUCCESS'";

        List<Payment> payments = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                payments.add(mapPayment(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return payments;
    }

    @Override
    public boolean updatePayment(Payment payment) {

        String sql = "UPDATE payments SET "
                + "bill_id = ?, patient_id = ?, payment_amount = ?, "
                + "payment_method = ?, transaction_reference = ?, "
                + "payment_status = ?, payment_date = ? "
                + "WHERE payment_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, payment.getBillId());
            statement.setInt(2, payment.getPatientId());
            statement.setDouble(3, payment.getPaymentAmount());
            statement.setString(4, payment.getPaymentMethod());
            statement.setString(5, payment.getTransactionReference());
            statement.setString(6, payment.getPaymentStatus());
            statement.setDate(7, payment.getPaymentDate());
            statement.setInt(8, payment.getPaymentId());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean deletePayment(int paymentId) {

        String sql = "DELETE FROM payments WHERE payment_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, paymentId);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private Payment mapPayment(ResultSet resultSet) throws Exception {

        Payment payment = new Payment();

        payment.setPaymentId(
                resultSet.getInt("payment_id"));

        payment.setBillId(
                resultSet.getInt("bill_id"));

        payment.setPatientId(
                resultSet.getInt("patient_id"));

        payment.setPaymentAmount(
                resultSet.getDouble("payment_amount"));

        payment.setPaymentMethod(
                resultSet.getString("payment_method"));

        payment.setTransactionReference(
                resultSet.getString("transaction_reference"));

        payment.setPaymentStatus(
                resultSet.getString("payment_status"));

        payment.setPaymentDate(
                resultSet.getDate("payment_date"));

        return payment;
    }
}