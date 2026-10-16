package com.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.dao.DepartmentDAO;
import com.model.Department;
import com.util.DBConnection;

public class DepartmentDAOImpl implements DepartmentDAO {

    @Override
    public boolean addDepartment(Department department) {

        String sql = "INSERT INTO departments "
                + "(department_name, description, status) "
                + "VALUES (?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, department.getDepartmentName());
            statement.setString(2, department.getDescription());
            statement.setString(3, department.getStatus());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public Department getDepartmentById(int departmentId) {

        String sql = "SELECT * FROM departments WHERE department_id = ?";
        Department department = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, departmentId);

            ResultSet resultSet = statement.executeQuery();

            if (resultSet.next()) {

                department = new Department();

                department.setDepartmentId(
                        resultSet.getInt("department_id"));

                department.setDepartmentName(
                        resultSet.getString("department_name"));

                department.setDescription(
                        resultSet.getString("description"));

                department.setStatus(
                        resultSet.getString("status"));

                department.setCreatedAt(
                        resultSet.getTimestamp("created_at"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return department;
    }

    @Override
    public List<Department> getAllDepartments() {

        String sql = "SELECT * FROM departments";

        List<Department> departments = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {

                Department department = new Department();

                department.setDepartmentId(
                        resultSet.getInt("department_id"));

                department.setDepartmentName(
                        resultSet.getString("department_name"));

                department.setDescription(
                        resultSet.getString("description"));

                department.setStatus(
                        resultSet.getString("status"));

                department.setCreatedAt(
                        resultSet.getTimestamp("created_at"));

                departments.add(department);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return departments;
    }

    @Override
    public boolean updateDepartment(Department department) {

        String sql = "UPDATE departments SET "
                + "department_name = ?, description = ?, status = ? "
                + "WHERE department_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, department.getDepartmentName());
            statement.setString(2, department.getDescription());
            statement.setString(3, department.getStatus());
            statement.setInt(4, department.getDepartmentId());

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean deleteDepartment(int departmentId) {

        String sql = "DELETE FROM departments WHERE department_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, departmentId);

            return statement.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}