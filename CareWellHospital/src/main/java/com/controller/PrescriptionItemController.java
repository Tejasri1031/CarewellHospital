package com.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.dao.PrescriptionItemDAO;
import com.daoimpl.PrescriptionItemDAOImpl;
import com.model.PrescriptionItem;

@WebServlet("/prescription-items")
public class PrescriptionItemController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PrescriptionItemDAO prescriptionItemDAO;

    @Override
    public void init() throws ServletException {
        prescriptionItemDAO = new PrescriptionItemDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {

            if (action == null || action.equals("list")) {

                List<PrescriptionItem> items =
                        prescriptionItemDAO
                                .getAllPrescriptionItems();

                request.setAttribute("prescriptionItems", items);

                request.getRequestDispatcher(
                        "/admin/prescription-items.jsp")
                        .forward(request, response);

            } else if (action.equals("prescription")) {

                int prescriptionId = Integer.parseInt(
                        request.getParameter("prescriptionId"));

                List<PrescriptionItem> items =
                        prescriptionItemDAO
                                .getItemsByPrescription(
                                        prescriptionId);

                request.setAttribute("prescriptionItems", items);

                request.getRequestDispatcher(
                        "/admin/prescription-items.jsp")
                        .forward(request, response);

            } else if (action.equals("medicine")) {

                int medicineId = Integer.parseInt(
                        request.getParameter("medicineId"));

                List<PrescriptionItem> items =
                        prescriptionItemDAO
                                .getItemsByMedicine(
                                        medicineId);

                request.setAttribute("prescriptionItems", items);

                request.getRequestDispatcher(
                        "/admin/prescription-items.jsp")
                        .forward(request, response);

            } else if (action.equals("delete")) {

                int prescriptionItemId = Integer.parseInt(
                        request.getParameter(
                                "prescriptionItemId"));

                prescriptionItemDAO.deletePrescriptionItem(
                        prescriptionItemId);

                response.sendRedirect(
                        request.getContextPath()
                        + "/prescription-items?action=list");
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/prescription-items?action=list"
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

                PrescriptionItem item =
                        new PrescriptionItem();

                item.setPrescriptionId(
                        Integer.parseInt(
                                request.getParameter(
                                        "prescriptionId")));

                item.setMedicineId(
                        Integer.parseInt(
                                request.getParameter(
                                        "medicineId")));

                item.setDosage(
                        request.getParameter("dosage"));

                item.setFrequency(
                        request.getParameter("frequency"));

                item.setDuration(
                        request.getParameter("duration"));

                item.setInstructions(
                        request.getParameter("instructions"));

                boolean success =
                        prescriptionItemDAO
                                .addPrescriptionItem(item);

                if (success) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/prescription-items?action=list");

                } else {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/doctor/add-prescription-item.jsp"
                            + "?error=failed");
                }

            } else if ("update".equals(action)) {

                PrescriptionItem item =
                        new PrescriptionItem();

                item.setPrescriptionItemId(
                        Integer.parseInt(
                                request.getParameter(
                                        "prescriptionItemId")));

                item.setPrescriptionId(
                        Integer.parseInt(
                                request.getParameter(
                                        "prescriptionId")));

                item.setMedicineId(
                        Integer.parseInt(
                                request.getParameter(
                                        "medicineId")));

                item.setDosage(
                        request.getParameter("dosage"));

                item.setFrequency(
                        request.getParameter("frequency"));

                item.setDuration(
                        request.getParameter("duration"));

                item.setInstructions(
                        request.getParameter("instructions"));

                boolean success =
                        prescriptionItemDAO
                                .updatePrescriptionItem(item);

                if (success) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/prescription-items?action=list");

                } else {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/prescription-items?action=list"
                            + "&error=updateFailed");
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/prescription-items?action=list"
                    + "&error=invalidData");
        }
    }
}