package com.controller;

import java.io.IOException;
import java.sql.Date;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.dao.AdminReportsDAO;
import com.daoimpl.AdminReportsDAOImpl;

@WebServlet("/AdminReportsController")
public class AdminReportsController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AdminReportsDAO reportsDAO;

    @Override
    public void init() throws ServletException {
        reportsDAO = new AdminReportsDAOImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getSession(false) == null ||
            request.getSession(false).getAttribute("user") == null) {

            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        com.model.User admin =
                (com.model.User) request.getSession(false).getAttribute("user");

        if (!"ADMIN".equalsIgnoreCase(admin.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        request.setAttribute("totalPatients",
                reportsDAO.getTotalPatients());

        request.setAttribute("totalDoctors",
                reportsDAO.getTotalDoctors());

        request.setAttribute("activeDoctors",
                reportsDAO.getActiveDoctors());

        request.setAttribute("inactiveDoctors",
                reportsDAO.getInactiveDoctors());

        request.setAttribute("totalAppointments",
                reportsDAO.getTotalAppointments());

        request.setAttribute("totalRevenue",
                reportsDAO.getTotalRevenue());
        
        request.setAttribute("pendingAppointments",
                reportsDAO.getPendingAppointments());

        request.setAttribute("confirmedAppointments",
                reportsDAO.getConfirmedAppointments());

        request.setAttribute("completedAppointments",
                reportsDAO.getCompletedAppointments());

        request.setAttribute("cancelledAppointments",
                reportsDAO.getCancelledAppointments());
        
        request.setAttribute("malePatients",
                reportsDAO.getMalePatients());

        request.setAttribute("femalePatients",
                reportsDAO.getFemalePatients());

        request.setAttribute("otherGenderPatients",
                reportsDAO.getOtherGenderPatients());
        
        request.setAttribute("availableDoctors",
                reportsDAO.getAvailableDoctors());

        request.setAttribute("unavailableDoctors",
                reportsDAO.getUnavailableDoctors());
        
        request.setAttribute("totalDepartments",
                reportsDAO.getTotalDepartments());

        request.setAttribute("activeDepartments",
                reportsDAO.getActiveDepartments());
        
        request.setAttribute("newPatientsThisMonth",
                reportsDAO.getNewPatientsThisMonth());

        request.setAttribute("newDoctorsThisMonth",
                reportsDAO.getNewDoctorsThisMonth());
        
        request.setAttribute("dailyRevenue",
                reportsDAO.getDailyRevenue());
        
        String startDateParam = request.getParameter("startDate");
        String endDateParam = request.getParameter("endDate");

        if (startDateParam != null && !startDateParam.isEmpty()
                && endDateParam != null && !endDateParam.isEmpty()) {

            try {
                Date startDate = Date.valueOf(startDateParam);
                Date endDate = Date.valueOf(endDateParam);

                if (startDate.after(endDate)) {
                    throw new IllegalArgumentException(
                            "Start date cannot be after end date.");
                }

                request.setAttribute("selectedStartDate", startDateParam);
                request.setAttribute("selectedEndDate", endDateParam);

                request.setAttribute("filteredAppointments",
                        reportsDAO.getAppointmentStatusByDateRange(
                                startDate, endDate));

                request.setAttribute("filteredRevenue",
                        reportsDAO.getRevenueByDateRange(
                                startDate, endDate));

            } catch (IllegalArgumentException e) {
                request.setAttribute("dateFilterError", e.getMessage());
            }
        }
        request.getRequestDispatcher("/admin/reports.jsp")
        .forward(request, response);
    }
    
 

}