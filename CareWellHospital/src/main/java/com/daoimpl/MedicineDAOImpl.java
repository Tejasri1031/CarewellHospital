package com.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dao.MedicineDAO;
import com.model.Medicine;
import com.util.DBConnection;

public class MedicineDAOImpl implements MedicineDAO {

    @Override
    public boolean addMedicine(Medicine medicine) {

        String sql = "INSERT INTO medicines "
                + "(medicine_name, medicine_type, description, "
                + "stock_quantity, price, status) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, medicine.getMedicineName());
            statement.setString(2, medicine.getMedicineType());
            statement.setString(3, medicine.getDescription());
            statement.setInt(4, medicine.getStockQuantity());
            statement.setDouble(5, medicine.getPrice());
            statement.setString(6, medicine.getStatus());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public Medicine getMedicineById(int medicineId) {

        String sql = "SELECT * FROM medicines WHERE medicine_id = ?";
        Medicine medicine = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, medicineId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {
                medicine = mapMedicine(resultSet);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return medicine;
    }

    @Override
    public List<Medicine> getAllMedicines() {

        String sql = "SELECT * FROM medicines";

        List<Medicine> medicines = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                medicines.add(mapMedicine(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return medicines;
    }

    @Override
    public List<Medicine> getAvailableMedicines() {

        String sql = "SELECT * FROM medicines "
                + "WHERE status = 'AVAILABLE' "
                + "AND stock_quantity > 0";

        List<Medicine> medicines = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                medicines.add(mapMedicine(resultSet));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return medicines;
    }

    @Override
    public boolean updateMedicine(Medicine medicine) {

        String sql = "UPDATE medicines SET "
                + "medicine_name = ?, medicine_type = ?, "
                + "description = ?, stock_quantity = ?, "
                + "price = ?, status = ? "
                + "WHERE medicine_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, medicine.getMedicineName());
            statement.setString(2, medicine.getMedicineType());
            statement.setString(3, medicine.getDescription());
            statement.setInt(4, medicine.getStockQuantity());
            statement.setDouble(5, medicine.getPrice());
            statement.setString(6, medicine.getStatus());
            statement.setInt(7, medicine.getMedicineId());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean deleteMedicine(int medicineId) {

        String sql = "DELETE FROM medicines WHERE medicine_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, medicineId);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private Medicine mapMedicine(ResultSet resultSet) throws Exception {

        Medicine medicine = new Medicine();

        medicine.setMedicineId(
                resultSet.getInt("medicine_id"));

        medicine.setMedicineName(
                resultSet.getString("medicine_name"));

        medicine.setMedicineType(
                resultSet.getString("medicine_type"));

        medicine.setDescription(
                resultSet.getString("description"));

        medicine.setStockQuantity(
                resultSet.getInt("stock_quantity"));

        medicine.setPrice(
                resultSet.getDouble("price"));

        medicine.setStatus(
                resultSet.getString("status"));

        medicine.setCreatedAt(
                resultSet.getTimestamp("created_at"));

        return medicine;
    }
}