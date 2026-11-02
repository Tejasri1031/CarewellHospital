package com.dao;

import java.util.List;
import com.model.Bill;
import com.model.Payment;

public interface AdminBillingDAO {

    double getTotalRevenue();

    int getTotalBills();

    int getPaidBills();

    int getPendingBills();
    
    List<Bill> getAllBillsWithPatientName();
    
    List<Payment> getAllPaymentsWithPatientName();

}