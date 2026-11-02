package com.dao;

import java.util.List;

import com.model.Department;

public interface DepartmentDAO {

    boolean addDepartment(Department department);

    Department getDepartmentById(int departmentId);

    List<Department> getAllDepartments();
    
    List<Department> getActiveDepartments();
    
    List<Department> getAllDepartmentsIncludingInactive();

    boolean updateDepartment(Department department);

    boolean deleteDepartment(int departmentId);
    
    boolean isDepartmentNameExists(
            String departmentName, int excludeDepartmentId);
}