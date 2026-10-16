package com.controller;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.dao.BillDAO;
import com.daoimpl.BillDAOImpl;
import com.model.Bill;

@WebServlet("/bills")
public class BillController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BillDAO billDAO;

    @Override
    public void init() throws ServletException {
        billDAO = new BillDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {

            if (action == null || action.equals("list")) {

                List<Bill> bills =
                        billDAO.getAllBills();

                request.setAttribute("bills", bills);

                request.getRequestDispatcher(
                        "/admin/bills.jsp")
                        .forward(request, response);

            } else if (action.equals("patient")) {

                int patientId = Integer.parseInt(
                        request.getParameter("patientId"));

                List<Bill> bills =
                        billDAO.getBillsByPatient(patientId);

                request.setAttribute("bills", bills);

                request.getRequestDispatcher(
                        "/patient/bills.jsp")
                        .forward(request, response);

            } else if (action.equals("date")) {

                Date billDate = Date.valueOf(
                        request.getParameter("billDate"));

                List<Bill> bills =
                        billDAO.getBillsByDate(billDate);

                request.setAttribute("bills", bills);

                request.getRequestDispatcher(
                        "/admin/bills.jsp")
                        .forward(request, response);

            } else if (action.equals("pending")) {

                List<Bill> bills =
                        billDAO.getPendingBills();

                request.setAttribute("bills", bills);

                request.getRequestDispatcher(
                        "/admin/bills.jsp")
                        .forward(request, response);

            } else if (action.equals("delete")) {

                int billId = Integer.parseInt(
                        request.getParameter("billId"));

                billDAO.deleteBill(billId);

                response.sendRedirect(
                        request.getContextPath()
                        + "/bills?action=list");
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/bills?action=list"
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

                Bill bill = new Bill();

                bill.setPatientId(
                        Integer.parseInt(
                                request.getParameter("patientId")));

                String appointmentId =
                        request.getParameter("appointmentId");

                if (appointmentId != null
                        && !appointmentId.isEmpty()) {

                    bill.setAppointmentId(
                            Integer.parseInt(appointmentId));
                }

                bill.setBillDate(
                        Date.valueOf(
                                request.getParameter("billDate")));

                bill.setConsultationFee(
                        Double.parseDouble(
                                request.getParameter(
                                        "consultationFee")));

                bill.setMedicineCharge(
                        Double.parseDouble(
                                request.getParameter(
                                        "medicineCharge")));

                bill.setTestCharge(
                        Double.parseDouble(
                                request.getParameter(
                                        "testCharge")));

                bill.setOtherCharge(
                        Double.parseDouble(
                                request.getParameter(
                                        "otherCharge")));

                bill.setTotalAmount(
                        Double.parseDouble(
                                request.getParameter(
                                        "totalAmount")));

                bill.setPaymentStatus(
                        request.getParameter(
                                "paymentStatus"));

                bill.setPaymentMethod(
                        request.getParameter(
                                "paymentMethod"));

                bill.setNotes(
                        request.getParameter("notes"));

                boolean success =
                        billDAO.addBill(bill);

                if (success) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/bills?action=list");

                } else {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/admin/add-bill.jsp"
                            + "?error=failed");
                }

            } else if ("update".equals(action)) {

                Bill bill = new Bill();

                bill.setBillId(
                        Integer.parseInt(
                                request.getParameter("billId")));

                bill.setPatientId(
                        Integer.parseInt(
                                request.getParameter("patientId")));

                String appointmentId =
                        request.getParameter("appointmentId");

                if (appointmentId != null
                        && !appointmentId.isEmpty()) {

                    bill.setAppointmentId(
                            Integer.parseInt(appointmentId));
                }

                bill.setBillDate(
                        Date.valueOf(
                                request.getParameter("billDate")));

                bill.setConsultationFee(
                        Double.parseDouble(
                                request.getParameter(
                                        "consultationFee")));

                bill.setMedicineCharge(
                        Double.parseDouble(
                                request.getParameter(
                                        "medicineCharge")));

                bill.setTestCharge(
                        Double.parseDouble(
                                request.getParameter(
                                        "testCharge")));

                bill.setOtherCharge(
                        Double.parseDouble(
                                request.getParameter(
                                        "otherCharge")));

                bill.setTotalAmount(
                        Double.parseDouble(
                                request.getParameter(
                                        "totalAmount")));

                bill.setPaymentStatus(
                        request.getParameter(
                                "paymentStatus"));

                bill.setPaymentMethod(
                        request.getParameter(
                                "paymentMethod"));

                bill.setNotes(
                        request.getParameter("notes"));

                boolean success =
                        billDAO.updateBill(bill);

                if (success) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/bills?action=list");

                } else {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/bills?action=list"
                            + "&error=updateFailed");
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/bills?action=list"
                    + "&error=invalidData");
        }
    }
}