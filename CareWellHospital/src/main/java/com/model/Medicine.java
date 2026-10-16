package com.model;

import java.sql.Timestamp;

public class Medicine {

    private int medicineId;
    private String medicineName;
    private String medicineType;
    private String description;
    private int stockQuantity;
    private double price;
    private String status;
    private Timestamp createdAt;

    public Medicine() {
    }

    public Medicine(int medicineId, String medicineName,
                    String medicineType, String description,
                    int stockQuantity, double price,
                    String status, Timestamp createdAt) {

        this.medicineId = medicineId;
        this.medicineName = medicineName;
        this.medicineType = medicineType;
        this.description = description;
        this.stockQuantity = stockQuantity;
        this.price = price;
        this.status = status;
        this.createdAt = createdAt;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}