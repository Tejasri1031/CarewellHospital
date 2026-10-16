package com.model;

import java.sql.Date;

public class PrescriptionDetails {

    private int prescriptionId;

    private int patientId;
    private String patientName;

    private int doctorId;
    private String doctorName;

    private int appointmentId;

    private Date prescriptionDate;

    private String instructions;

    private int medicineId;
    private String medicineName;

    private String medicineType;

    private String dosage;
    private String frequency;
    private String duration;
    private String medicineInstructions;


    public PrescriptionDetails() {
    }


    public PrescriptionDetails(
            int prescriptionId,
            int patientId,
            String patientName,
            int doctorId,
            String doctorName,
            int appointmentId,
            Date prescriptionDate,
            String instructions,
            int medicineId,
            String medicineName,
            String medicineType,
            String dosage,
            String frequency,
            String duration,
            String medicineInstructions) {

        this.prescriptionId = prescriptionId;
        this.patientId = patientId;
        this.patientName = patientName;
        this.doctorId = doctorId;
        this.doctorName = doctorName;
        this.appointmentId = appointmentId;
        this.prescriptionDate = prescriptionDate;
        this.instructions = instructions;
        this.medicineId = medicineId;
        this.medicineName = medicineName;
        this.medicineType = medicineType;
        this.dosage = dosage;
        this.frequency = frequency;
        this.duration = duration;
        this.medicineInstructions = medicineInstructions;
    }


    public int getPrescriptionId() {
        return prescriptionId;
    }

    public void setPrescriptionId(int prescriptionId) {
        this.prescriptionId = prescriptionId;
    }


    public int getPatientId() {
        return patientId;
    }

    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }


    public String getPatientName() {
        return patientName;
    }

    public void setPatientName(String patientName) {
        this.patientName = patientName;
    }


    public int getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }


    public String getDoctorName() {
        return doctorName;
    }

    public void setDoctorName(String doctorName) {
        this.doctorName = doctorName;
    }


    public int getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }


    public Date getPrescriptionDate() {
        return prescriptionDate;
    }

    public void setPrescriptionDate(Date prescriptionDate) {
        this.prescriptionDate = prescriptionDate;
    }


    public String getInstructions() {
        return instructions;
    }

    public void setInstructions(String instructions) {
        this.instructions = instructions;
    }


    public int getMedicineId() {
        return medicineId;
    }

    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
    }


    public String getMedicineName() {
        return medicineName;
    }

    public void setMedicineName(String medicineName) {
        this.medicineName = medicineName;
    }


    public String getMedicineType() {
        return medicineType;
    }

    public void setMedicineType(String medicineType) {
        this.medicineType = medicineType;
    }


    public String getDosage() {
        return dosage;
    }

    public void setDosage(String dosage) {
        this.dosage = dosage;
    }


    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }


    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }


    public String getMedicineInstructions() {
        return medicineInstructions;
    }

    public void setMedicineInstructions(
            String medicineInstructions) {

        this.medicineInstructions = medicineInstructions;
    }
}