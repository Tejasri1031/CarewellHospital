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
                    departmentDAO.getAllDepartments();

            request.setAttribute("departments", departments);

            request.getRequestDispatcher(
                    "/admin/departments.jsp")
                    .forward(request, response);

        } else if (action.equals("delete")) {

            int departmentId =
                    Integer.parseInt(
                            request.getParameter("departmentId"));

            departmentDAO.deleteDepartment(departmentId);

            response.sendRedirect(
                    request.getContextPath()
                    + "/departments?action=list");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {

            Department department = new Department();

            department.setDepartmentName(
                    request.getParameter("departmentName"));

            department.setDescription(
                    request.getParameter("description"));

            department.setStatus("ACTIVE");

            boolean success =
                    departmentDAO.addDepartment(department);

            if (success) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/departments?action=list");

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/add-department.jsp?error=failed");
            }

        } else if ("update".equals(action)) {

            Department department = new Department();

            department.setDepartmentId(
                    Integer.parseInt(
                            request.getParameter("departmentId")));

            department.setDepartmentName(
                    request.getParameter("departmentName"));

            department.setDescription(
                    request.getParameter("description"));

            department.setStatus(
                    request.getParameter("status"));

            boolean success =
                    departmentDAO.updateDepartment(department);

            if (success) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/departments?action=list");

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/departments?action=list&error=updateFailed");
            }
        }
    }
}