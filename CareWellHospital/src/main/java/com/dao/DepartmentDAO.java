package com.dao;

import java.util.List;

import com.model.Department;

public interface DepartmentDAO {

    boolean addDepartment(Department department);

    Department getDepartmentById(int departmentId);

    List<Department> getAllDepartments();

    boolean updateDepartment(Department department);

    boolean deleteDepartment(int departmentId);
}