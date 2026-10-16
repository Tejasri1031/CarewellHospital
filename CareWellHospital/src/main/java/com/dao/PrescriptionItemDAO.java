
package com.dao;

import java.sql.Connection;
import java.util.List;

import com.model.PrescriptionItem;

public interface PrescriptionItemDAO {

    boolean addPrescriptionItem(PrescriptionItem prescriptionItem);

    boolean addPrescriptionItem(
            Connection connection,
            PrescriptionItem prescriptionItem) throws Exception;

    PrescriptionItem getPrescriptionItemById(int prescriptionItemId);

    List<PrescriptionItem> getAllPrescriptionItems();

    List<PrescriptionItem> getItemsByPrescription(int prescriptionId);

    List<PrescriptionItem> getItemsByMedicine(int medicineId);

    boolean updatePrescriptionItem(PrescriptionItem prescriptionItem);

    boolean deletePrescriptionItem(int prescriptionItemId);
}
