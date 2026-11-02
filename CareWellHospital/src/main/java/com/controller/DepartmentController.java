package com.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.dao.DepartmentDAO;
import com.daoimpl.DepartmentDAOImpl;
import com.model.Department;

@WebServlet("/departments")
public class DepartmentController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DepartmentDAO departmentDAO;

    @Override
    public void init() throws ServletException {
        departmentDAO = new DepartmentDAOImpl();
    }


@Override
protected void doGet(HttpServletRequest request,
                     HttpServletResponse response)
        throws ServletException, IOException {

    String action = request.getParameter("action");

    if (action == null || action.equals("list")) {

        List<Department> departments =
                departmentDAO.getAllDepartmentsIncludingInactive();

        request.setAttribute("departments", departments);

        request.getRequestDispatcher(
                "/admin/departments.jsp")
                .forward(request, response);
    }

    else if ("edit".equals(action)) {

        int departmentId = Integer.parseInt(
                request.getParameter("departmentId"));

        Department department =
                departmentDAO.getDepartmentById(departmentId);

        if (department == null) {
            response.sendRedirect(
                    request.getContextPath() + "/departments?action=list");
            return;
        }

        request.setAttribute("department", department);

        request.getRequestDispatcher(
                "/admin/edit-department.jsp")
                .forward(request, response);
    }

    else {
        response.sendRedirect(
                request.getContextPath() + "/departments?action=list");
    }
}

@Override
protected void doPost(HttpServletRequest request,
                      HttpServletResponse response)
        throws ServletException, IOException {

    String action = request.getParameter("action");

    // ADD DEPARTMENT

if ("add".equals(action)) {

    String departmentName = request.getParameter("departmentName");

    if (departmentName == null || departmentName.trim().isEmpty()) {
        response.sendRedirect(
                request.getContextPath()
                + "/admin/add-department.jsp?error=empty");
        return;
    }

    departmentName = departmentName.trim();

    // Check for duplicate department names
    if (departmentDAO.isDepartmentNameExists(departmentName, 0)) {
        response.sendRedirect(
                request.getContextPath()
                + "/admin/add-department.jsp?error=duplicate");
        return;
    }

    Department department = new Department();

    department.setDepartmentName(departmentName);
    department.setDescription(
            request.getParameter("description"));
    department.setStatus("ACTIVE");

    boolean success = departmentDAO.addDepartment(department);

    if (success) {
        response.sendRedirect(
                request.getContextPath()
                + "/departments?action=list");
    } else {
        response.sendRedirect(
                request.getContextPath()
                + "/admin/add-department.jsp?error=failed");
    }
}


    // UPDATE DEPARTMENT

else if ("update".equals(action)) {

    int departmentId = Integer.parseInt(
            request.getParameter("departmentId"));

    String departmentName = request.getParameter("departmentName");

    if (departmentName == null || departmentName.trim().isEmpty()) {
        response.sendRedirect(
                request.getContextPath()
                + "/departments?action=edit&departmentId="
                + departmentId + "&error=empty");
        return;
    }

    departmentName = departmentName.trim();

    // Exclude the current department while checking duplicates
    if (departmentDAO.isDepartmentNameExists(
            departmentName, departmentId)) {

        response.sendRedirect(
                request.getContextPath()
                + "/departments?action=edit&departmentId="
                + departmentId + "&error=duplicate");
        return;
    }

    Department department = new Department();

    department.setDepartmentId(departmentId);
    department.setDepartmentName(departmentName);
    department.setDescription(
            request.getParameter("description"));
    department.setStatus(
            request.getParameter("status"));

    boolean success = departmentDAO.updateDepartment(department);

    if (success) {
        response.sendRedirect(
                request.getContextPath()
                + "/departments?action=list");
    } else {
        response.sendRedirect(
                request.getContextPath()
                + "/departments?action=edit&departmentId="
                + departmentId + "&error=updateFailed");
    }
}


    // ACTIVATE / DEACTIVATE DEPARTMENT
    else if ("toggleStatus".equals(action)) {

        int departmentId = Integer.parseInt(
                request.getParameter("departmentId"));

        Department department =
                departmentDAO.getDepartmentById(departmentId);

        if (department != null) {

            if ("ACTIVE".equalsIgnoreCase(department.getStatus())) {

                department.setStatus("INACTIVE");

            } else {

                department.setStatus("ACTIVE");
            }

            departmentDAO.updateDepartment(department);
        }

        response.sendRedirect(
                request.getContextPath()
                + "/departments?action=list");
    }
    

    // DELETE DEPARTMENT
    else if ("delete".equals(action)) {

        int departmentId = Integer.parseInt(
                request.getParameter("departmentId"));

        boolean success =
                departmentDAO.deleteDepartment(departmentId);

        if (success) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/departments?action=list&message=deleted");

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/departments?action=list&error=deleteFailed");
        }
    }

}



}