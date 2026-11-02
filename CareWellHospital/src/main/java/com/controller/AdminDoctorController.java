package com.controller;

import java.io.IOException;
import java.util.List;

import com.dao.DoctorDAO;
import com.daoimpl.DoctorDAOImpl;
import com.model.Doctor;
import com.model.User;
import com.dao.DepartmentDAO;
import com.daoimpl.DepartmentDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminDoctorController")
public class AdminDoctorController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DoctorDAO doctorDAO;
    private DepartmentDAO departmentDAO;

    @Override
    public void init() throws ServletException {
        doctorDAO = new DoctorDAOImpl();
        departmentDAO = new DepartmentDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
                         throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Admin access required.");
            return;
        }

        List<Doctor> doctors = doctorDAO.getAllDoctorsForAdmin();

        request.setAttribute("doctors", doctors);
        
        request.setAttribute("departments",
                departmentDAO.getAllDepartments());

        request.getRequestDispatcher("/admin/doctors.jsp")
               .forward(request, response);
    }
}