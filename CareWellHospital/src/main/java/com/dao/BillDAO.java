package com.dao;

import java.sql.Date;
import java.util.List;

import com.model.Bill;

public interface BillDAO {

    boolean addBill(Bill bill);

    Bill getBillById(int billId);

    List<Bill> getAllBills();

    List<Bill> getBillsByPatient(int patientId);

    List<Bill> getBillsByDate(Date billDate);

    List<Bill> getPendingBills();

    boolean updateBill(Bill bill);

    boolean deleteBill(int billId);
}