package com.dao;

import java.util.List;

import com.model.Medicine;

public interface MedicineDAO {

    boolean addMedicine(Medicine medicine);

    Medicine getMedicineById(int medicineId);

    List<Medicine> getAllMedicines();

    List<Medicine> getAvailableMedicines();

    boolean updateMedicine(Medicine medicine);

    boolean deleteMedicine(int medicineId);
}