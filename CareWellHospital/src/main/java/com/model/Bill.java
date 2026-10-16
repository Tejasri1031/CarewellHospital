package com.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Bill {

    private int billId;
    private int patientId;
    private int appointmentId;
    private Date billDate;
    private double consultationFee;
    private double medicineCharge;
    private double testCharge;
    private double otherCharge;
    private double totalAmount;
    private String paymentStatus;
    private String paymentMethod;
    private String notes;
    private Timestamp createdAt;

    public Bill() {
    }

    public Bill(int billId, int patientId, int appointmentId,
                Date billDate, double consultationFee,
                double medicineCharge, double testCharge,
                double otherCharge, double totalAmount,
                String paymentStatus, String paymentMethod,
                String notes, Timestamp createdAt) {

        this.billId = billId;
        this.patientId = patientId;
        this.appointmentId = appointmentId;
        this.billDate = billDate;
        this.consultationFee = consultationFee;
        this.medicineCharge = medicineCharge;
        this.testCharge = testCharge;
        this.otherCharge = otherCharge;
        this.totalAmount = totalAmount;
        this.paymentStatus = paymentStatus;
        this.paymentMethod = paymentMethod;
        this.notes = notes;
        this.createdAt = createdAt;
    }

    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
        this.billId = billId;
    }

    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }

    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }

    public Date getBillDate() {
        return billDate;
    }

    public void setBillDate(Date billDate) {
        this.billDate = billDate;
    }

    public double getConsultationFee() {
        return consultationFee;
    }

    public void setConsultationFee(double consultationFee) {
        this.consultationFee = consultationFee;
    }

    public double getMedicineCharge() {
        return medicineCharge;
    }

    public void setMedicineCharge(double medicineCharge) {
        this.medicineCharge = medicineCharge;
    }

    public double getTestCharge() {
        return testCharge;
    }

    public void setTestCharge(double testCharge) {
        this.testCharge = testCharge;
    }

    public double getOtherCharge() {
        return otherCharge;
    }

    public void setOtherCharge(double otherCharge) {
        this.otherCharge = otherCharge;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}