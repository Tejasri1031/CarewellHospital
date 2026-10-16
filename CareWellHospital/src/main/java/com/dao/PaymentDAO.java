package com.dao;

import java.sql.Date;
import java.util.List;

import com.model.Payment;

public interface PaymentDAO {

    boolean addPayment(Payment payment);

    Payment getPaymentById(int paymentId);

    List<Payment> getAllPayments();

    List<Payment> getPaymentsByBill(int billId);

    List<Payment> getPaymentsByPatient(int patientId);

    List<Payment> getPaymentsByDate(Date paymentDate);

    List<Payment> getSuccessfulPayments();

    boolean updatePayment(Payment payment);

    boolean deletePayment(int paymentId);
}