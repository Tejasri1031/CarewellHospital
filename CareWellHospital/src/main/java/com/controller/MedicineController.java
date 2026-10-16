package com.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.dao.MedicineDAO;
import com.daoimpl.MedicineDAOImpl;
import com.model.Medicine;

@WebServlet("/medicines")
public class MedicineController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private MedicineDAO medicineDAO;

    @Override
    public void init() throws ServletException {
        medicineDAO = new MedicineDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {

            if (action == null || action.equals("list")) {

                List<Medicine> medicines =
                        medicineDAO.getAllMedicines();

                request.setAttribute("medicines", medicines);

                request.getRequestDispatcher(
                        "/admin/medicines.jsp")
                        .forward(request, response);

            } else if (action.equals("available")) {

                List<Medicine> medicines =
                        medicineDAO.getAvailableMedicines();

                request.setAttribute("medicines", medicines);

                request.getRequestDispatcher(
                        "/admin/medicines.jsp")
                        .forward(request, response);

            } else if (action.equals("delete")) {

                int medicineId = Integer.parseInt(
                        request.getParameter("medicineId"));

                medicineDAO.deleteMedicine(medicineId);

                response.sendRedirect(
                        request.getContextPath()
                        + "/medicines?action=list");
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/medicines?action=list"
                    + "&error=invalidData");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {

            if ("add".equals(action)) {

                Medicine medicine = new Medicine();

                medicine.setMedicineName(
                        request.getParameter("medicineName"));

                medicine.setMedicineType(
                        request.getParameter("medicineType"));

                medicine.setDescription(
                        request.getParameter("description"));

                String stockQuantity =
                        request.getParameter("stockQuantity");

                if (stockQuantity != null
                        && !stockQuantity.isEmpty()) {

                    medicine.setStockQuantity(
                            Integer.parseInt(stockQuantity));
                }

                String price =
                        request.getParameter("price");

                if (price != null
                        && !price.isEmpty()) {

                    medicine.setPrice(
                            Double.parseDouble(price));
                }

                medicine.setStatus("AVAILABLE");

                boolean success =
                        medicineDAO.addMedicine(medicine);

                if (success) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/medicines?action=list");

                } else {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/admin/add-medicine.jsp"
                            + "?error=failed");
                }

            } else if ("update".equals(action)) {

                Medicine medicine = new Medicine();

                medicine.setMedicineId(
                        Integer.parseInt(
                                request.getParameter("medicineId")));

                medicine.setMedicineName(
                        request.getParameter("medicineName"));

                medicine.setMedicineType(
                        request.getParameter("medicineType"));

                medicine.setDescription(
                        request.getParameter("description"));

                String stockQuantity =
                        request.getParameter("stockQuantity");

                if (stockQuantity != null
                        && !stockQuantity.isEmpty()) {

                    medicine.setStockQuantity(
                            Integer.parseInt(stockQuantity));
                }

                String price =
                        request.getParameter("price");

                if (price != null
                        && !price.isEmpty()) {

                    medicine.setPrice(
                            Double.parseDouble(price));
                }

                medicine.setStatus(
                        request.getParameter("status"));

                boolean success =
                        medicineDAO.updateMedicine(medicine);

                if (success) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/medicines?action=list");

                } else {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/medicines?action=list"
                            + "&error=updateFailed");
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/medicines?action=list"
                    + "&error=invalidData");
        }
    }
}