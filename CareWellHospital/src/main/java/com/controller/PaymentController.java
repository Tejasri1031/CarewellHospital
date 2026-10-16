package com.controller;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.dao.PaymentDAO;
import com.daoimpl.PaymentDAOImpl;
import com.model.Payment;

@WebServlet("/payments")
public class PaymentController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PaymentDAO paymentDAO;

    @Override
    public void init() throws ServletException {
        paymentDAO = new PaymentDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {

            if (action == null || action.equals("list")) {

                List<Payment> payments =
                        paymentDAO.getAllPayments();

                request.setAttribute("payments", payments);

                request.getRequestDispatcher(
                        "/admin/payments.jsp")
                        .forward(request, response);

            } else if (action.equals("bill")) {

                int billId = Integer.parseInt(
                        request.getParameter("billId"));

                List<Payment> payments =
                        paymentDAO.getPaymentsByBill(billId);

                request.setAttribute("payments", payments);

                request.getRequestDispatcher(
                        "/admin/payments.jsp")
                        .forward(request, response);

            } else if (action.equals("patient")) {

                int patientId = Integer.parseInt(
                        request.getParameter("patientId"));

                List<Payment> payments =
                        paymentDAO.getPaymentsByPatient(patientId);

                request.setAttribute("payments", payments);

                request.getRequestDispatcher(
                        "/patient/payments.jsp")
                        .forward(request, response);

            } else if (action.equals("date")) {

                Date paymentDate = Date.valueOf(
                        request.getParameter("paymentDate"));

                List<Payment> payments =
                        paymentDAO.getPaymentsByDate(
                                paymentDate);

                request.setAttribute("payments", payments);

                request.getRequestDispatcher(
                        "/admin/payments.jsp")
                        .forward(request, response);

            } else if (action.equals("successful")) {

                List<Payment> payments =
                        paymentDAO.getSuccessfulPayments();

                request.setAttribute("payments", payments);

                request.getRequestDispatcher(
                        "/admin/payments.jsp")
                        .forward(request, response);

            } else if (action.equals("delete")) {

                int paymentId = Integer.parseInt(
                        request.getParameter("paymentId"));

                paymentDAO.deletePayment(paymentId);

                response.sendRedirect(
                        request.getContextPath()
                        + "/payments?action=list");
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/payments?action=list"
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

                Payment payment = new Payment();

                payment.setBillId(
                        Integer.parseInt(
                                request.getParameter("billId")));

                payment.setPatientId(
                        Integer.parseInt(
                                request.getParameter("patientId")));

                payment.setPaymentAmount(
                        Double.parseDouble(
                                request.getParameter(
                                        "paymentAmount")));

                payment.setPaymentMethod(
                        request.getParameter(
                                "paymentMethod"));

                payment.setTransactionReference(
                        request.getParameter(
                                "transactionReference"));

                payment.setPaymentStatus(
                        request.getParameter(
                                "paymentStatus"));

                payment.setPaymentDate(
                        Date.valueOf(
                                request.getParameter(
                                        "paymentDate")));

                boolean success =
                        paymentDAO.addPayment(payment);

                if (success) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/payments?action=list");

                } else {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/admin/add-payment.jsp"
                            + "?error=failed");
                }

            } else if ("update".equals(action)) {

                Payment payment = new Payment();

                payment.setPaymentId(
                        Integer.parseInt(
                                request.getParameter(
                                        "paymentId")));

                payment.setBillId(
                        Integer.parseInt(
                                request.getParameter("billId")));

                payment.setPatientId(
                        Integer.parseInt(
                                request.getParameter(
                                        "patientId")));

                payment.setPaymentAmount(
                        Double.parseDouble(
                                request.getParameter(
                                        "paymentAmount")));

                payment.setPaymentMethod(
                        request.getParameter(
                                "paymentMethod"));

                payment.setTransactionReference(
                        request.getParameter(
                                "transactionReference"));

                payment.setPaymentStatus(
                        request.getParameter(
                                "paymentStatus"));

                payment.setPaymentDate(
                        Date.valueOf(
                                request.getParameter(
                                        "paymentDate")));

                boolean success =
                        paymentDAO.updatePayment(payment);

                if (success) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/payments?action=list");

                } else {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/payments?action=list"
                            + "&error=updateFailed");
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/payments?action=list"
                    + "&error=invalidData");
        }
    }
}