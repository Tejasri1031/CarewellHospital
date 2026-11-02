package com.controller;

import java.io.IOException;

import com.dao.AdminBillingDAO;
import com.daoimpl.AdminBillingDAOImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminBillingController")
public class AdminBillingController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AdminBillingDAO billingDAO;

    @Override
    public void init() throws ServletException {
        billingDAO = new AdminBillingDAOImpl();
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

        com.model.User user =
                (com.model.User) session.getAttribute("user");

        if (!"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Admin access required.");
            return;
        }

        request.setAttribute("totalRevenue",
                billingDAO.getTotalRevenue());

        request.setAttribute("totalBills",
                billingDAO.getTotalBills());

        request.setAttribute("paidBills",
                billingDAO.getPaidBills());

        request.setAttribute("pendingBills",
                billingDAO.getPendingBills());
        
        request.setAttribute("billList",
                billingDAO.getAllBillsWithPatientName());
        
        request.setAttribute("paymentList",
                billingDAO.getAllPaymentsWithPatientName());

        request.getRequestDispatcher("/admin/billing.jsp")
               .forward(request, response);
    }
}