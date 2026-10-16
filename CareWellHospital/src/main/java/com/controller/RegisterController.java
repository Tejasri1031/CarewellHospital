package com.controller;

import java.io.IOException;
import java.sql.Date;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.dao.UserDAO;
import com.dao.PatientDAO;
import com.daoimpl.UserDAOImpl;
import com.daoimpl.PatientDAOImpl;
import com.model.User;
import com.model.Patient;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;
    private PatientDAO patientDAO;

    @Override
    public void init() throws ServletException {

        userDAO = new UserDAOImpl();
        patientDAO = new PatientDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");

        String dateOfBirth = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String bloodGroup = request.getParameter("bloodGroup");
        String address = request.getParameter("address");

        String emergencyContactName =
                request.getParameter("emergencyContactName");

        String emergencyContactPhone =
                request.getParameter("emergencyContactPhone");

        try {

            // Check whether email already exists

            User existingUser = userDAO.getUserByEmail(email);

            if (existingUser != null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/register.jsp?error=emailExists");

                return;
            }

            // Create User

            User user = new User();

            user.setFullName(fullName);
            user.setEmail(email);
            user.setPassword(password);
            user.setPhone(phone);
            user.setRole("PATIENT");
            user.setStatus("ACTIVE");

            boolean userAdded = userDAO.addUser(user);

            if (!userAdded) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/register.jsp?error=registrationFailed");

                return;
            }

            // Get newly created User using email

            User createdUser = userDAO.getUserByEmail(email);

            if (createdUser == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/register.jsp?error=registrationFailed");

                return;
            }

            // Create Patient

            Patient patient = new Patient();

            patient.setUserId(createdUser.getUserId());

            if (dateOfBirth != null && !dateOfBirth.isEmpty()) {

                patient.setDateOfBirth(
                        Date.valueOf(dateOfBirth));
            }

            patient.setGender(gender);
            patient.setBloodGroup(bloodGroup);
            patient.setAddress(address);
            patient.setEmergencyContactName(
                    emergencyContactName);
            patient.setEmergencyContactPhone(
                    emergencyContactPhone);

            boolean patientAdded =
                    patientDAO.addPatient(patient);

            if (patientAdded) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/login.jsp?registered=success");

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/register.jsp?error=patientCreationFailed");
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/register.jsp?error=registrationFailed");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/register.jsp");
    }
}