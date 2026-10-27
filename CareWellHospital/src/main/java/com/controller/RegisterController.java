
package com.controller;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Set;
import java.util.regex.Pattern;

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
import com.util.PasswordUtil;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final Pattern NAME_PATTERN =
            Pattern.compile("^[A-Za-z][A-Za-z .'-]{1,99}$");

    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^[6-9][0-9]{9}$");

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile(
                "^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+"
                + "@[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}"
                + "[A-Za-z0-9])?"
                + "(?:\\.[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}"
                + "[A-Za-z0-9])?)+$"
            );

    private static final Set<String> GENDERS =
            Set.of("Male", "Female", "Other");

    private static final Set<String> BLOOD_GROUPS =
            Set.of("A+", "A-", "B+", "B-", "AB+", "AB-",
                   "O+", "O-");

    private static final LocalDate MIN_DATE_OF_BIRTH =
            LocalDate.of(1900, 1, 1);

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

        request.setCharacterEncoding("UTF-8");

        String fullName = trim(request.getParameter("fullName"));
        String email = trim(request.getParameter("email"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = trim(request.getParameter("phone"));
        
        String dobText = trim(request.getParameter("dateOfBirth"));
        String gender = trim(request.getParameter("gender"));
        String bloodGroup = trim(request.getParameter("bloodGroup"));
        String address = trim(request.getParameter("address"));

        String emergencyContactName =
                trim(request.getParameter("emergencyContactName"));

        String emergencyContactPhone =
                trim(request.getParameter("emergencyContactPhone"));

        // Validate every field before accessing the database.
        if (!isValidName(fullName)
                || !isValidEmail(email)
                || password == null
                || password.length() < 8
                || password.length() > 72
                || !isValidPhone(phone)
                || !isValidDateOfBirth(dobText)
                || !GENDERS.contains(gender)
                || !BLOOD_GROUPS.contains(bloodGroup)
                || !isValidAddress(address)
                || !isValidName(emergencyContactName)
                || !isValidPhone(emergencyContactPhone)
        	|| confirmPassword == null
            || !password.equals(confirmPassword))
            
        {

            response.sendRedirect(
                    request.getContextPath()
                    + "/register.jsp?error=invalidInput");
            return;
        }

        try {
            // Check for an existing email.
            User existingUser = userDAO.getUserByEmail(email);

            if (existingUser != null) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/register.jsp?error=emailExists");
                return;
            }

            // Create the user with a BCrypt password hash.
            User user = new User();
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPassword(PasswordUtil.hashPassword(password));
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

            User createdUser = userDAO.getUserByEmail(email);

            if (createdUser == null) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/register.jsp?error=registrationFailed");
                return;
            }

            Patient patient = new Patient();
            patient.setUserId(createdUser.getUserId());
            patient.setDateOfBirth(Date.valueOf(dobText));
            patient.setGender(gender);
            patient.setBloodGroup(bloodGroup);
            patient.setAddress(address);
            patient.setEmergencyContactName(emergencyContactName);
            patient.setEmergencyContactPhone(emergencyContactPhone);

            boolean patientAdded = patientDAO.addPatient(patient);

            if (patientAdded) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/login.jsp?registered=success");
            } else {
                // The user row already exists. Do not claim registration
                // succeeded; this case needs cleanup or transaction support.
                response.sendRedirect(
                        request.getContextPath()
                        + "/register.jsp?error=patientCreationFailed");
            }

        } catch (Exception e) {
            getServletContext().log("Patient registration failed.", e);

            response.sendRedirect(
                    request.getContextPath()
                    + "/register.jsp?error=registrationFailed");
        }
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private static boolean isValidName(String value) {
        return value != null
                && NAME_PATTERN.matcher(value).matches();
    }

    private static boolean isValidPhone(String value) {
        return value != null
                && PHONE_PATTERN.matcher(value).matches();
    }

    private static boolean isValidEmail(String value) {
        return value != null
                && value.length() <= 150
                && EMAIL_PATTERN.matcher(value).matches();
    }

    private static boolean isValidAddress(String value) {
        return value != null
                && !value.isBlank()
                && value.length() <= 500;
    }

    private static boolean isValidDateOfBirth(String value) {
        if (value == null || value.isBlank()) {
            return false;
        }

        try {
            LocalDate dob = LocalDate.parse(value);

            return !dob.isBefore(MIN_DATE_OF_BIRTH)
                    && !dob.isAfter(LocalDate.now());

        } catch (DateTimeParseException e) {
            return false;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
                request.getContextPath() + "/register.jsp");
    }
}
