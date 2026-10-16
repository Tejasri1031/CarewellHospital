package com.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dao.PrescriptionItemDAO;
import com.model.PrescriptionItem;
import com.util.DBConnection;

public class PrescriptionItemDAOImpl implements PrescriptionItemDAO {

    @Override
    public boolean addPrescriptionItem(PrescriptionItem prescriptionItem) {

        String sql = "INSERT INTO prescription_items "
                + "(prescription_id, medicine_id, dosage, frequency, "
                + "duration, instructions) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, prescriptionItem.getPrescriptionId());
            statement.setInt(2, prescriptionItem.getMedicineId());
            statement.setString(3, prescriptionItem.getDosage());
            statement.setString(4, prescriptionItem.getFrequency());
            statement.setString(5, prescriptionItem.getDuration());
            statement.setString(6, prescriptionItem.getInstructions());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    
    @Override
    public boolean addPrescriptionItem(
            Connection connection,
            PrescriptionItem prescriptionItem) throws Exception {

        String sql = "INSERT INTO prescription_items "
                + "(prescription_id, medicine_id, dosage, frequency, "
                + "duration, instructions) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement statement =
                connection.prepareStatement(sql)) {

            statement.setInt(1, prescriptionItem.getPrescriptionId());
            statement.setInt(2, prescriptionItem.getMedicineId());
            statement.setString(3, prescriptionItem.getDosage());
            statement.setString(4, prescriptionItem.getFrequency());
            statement.setString(5, prescriptionItem.getDuration());
            statement.setString(6, prescriptionItem.getInstructions());

            int rowsInserted = statement.executeUpdate();

            if (rowsInserted == 0) {
                throw new java.sql.SQLException(
                        "Prescription medicine could not be saved.");
            }

            return true;
        }
    }

    @Override
    public PrescriptionItem getPrescriptionItemById(int prescriptionItemId) {

        String sql = "SELECT * FROM prescription_items "
                + "WHERE prescription_item_id = ?";

        PrescriptionItem prescriptionItem = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, prescriptionItemId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                prescriptionItem = mapPrescriptionItem(resultSet);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return prescriptionItem;
    }

    @Override
    public List<PrescriptionItem> getAllPrescriptionItems() {

        String sql = "SELECT * FROM prescription_items";

        List<PrescriptionItem> prescriptionItems = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                prescriptionItems.add(mapPrescriptionItem(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return prescriptionItems;
    }

    @Override
    public List<PrescriptionItem> getItemsByPrescription(int prescriptionId) {

        String sql = "SELECT * FROM prescription_items "
                + "WHERE prescription_id = ?";

        List<PrescriptionItem> prescriptionItems = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, prescriptionId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                prescriptionItems.add(mapPrescriptionItem(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return prescriptionItems;
    }

    @Override
    public List<PrescriptionItem> getItemsByMedicine(int medicineId) {

        String sql = "SELECT * FROM prescription_items "
                + "WHERE medicine_id = ?";

        List<PrescriptionItem> prescriptionItems = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, medicineId);

            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                prescriptionItems.add(mapPrescriptionItem(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return prescriptionItems;
    }

    @Override
    public boolean updatePrescriptionItem(
            PrescriptionItem prescriptionItem) {

        String sql = "UPDATE prescription_items SET "
                + "prescription_id = ?, medicine_id = ?, dosage = ?, "
                + "frequency = ?, duration = ?, instructions = ? "
                + "WHERE prescription_item_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, prescriptionItem.getPrescriptionId());
            statement.setInt(2, prescriptionItem.getMedicineId());
            statement.setString(3, prescriptionItem.getDosage());
            statement.setString(4, prescriptionItem.getFrequency());
            statement.setString(5, prescriptionItem.getDuration());
            statement.setString(6, prescriptionItem.getInstructions());
            statement.setInt(7, prescriptionItem.getPrescriptionItemId());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean deletePrescriptionItem(int prescriptionItemId) {

        String sql = "DELETE FROM prescription_items "
                + "WHERE prescription_item_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, prescriptionItemId);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private PrescriptionItem mapPrescriptionItem(
            ResultSet resultSet) throws Exception {

        PrescriptionItem prescriptionItem = new PrescriptionItem();

        prescriptionItem.setPrescriptionItemId(
                resultSet.getInt("prescription_item_id"));

        prescriptionItem.setPrescriptionId(
                resultSet.getInt("prescription_id"));

        prescriptionItem.setMedicineId(
                resultSet.getInt("medicine_id"));

        prescriptionItem.setDosage(
                resultSet.getString("dosage"));

        prescriptionItem.setFrequency(
                resultSet.getString("frequency"));

        prescriptionItem.setDuration(
                resultSet.getString("duration"));

        prescriptionItem.setInstructions(
                resultSet.getString("instructions"));

        return prescriptionItem;
    }
}