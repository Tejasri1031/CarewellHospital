
package com.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;

import com.dao.DepartmentDAO;
import com.dao.DoctorDAO;
import com.dao.UserDAO;

import com.daoimpl.DepartmentDAOImpl;
import com.daoimpl.DoctorDAOImpl;
import com.daoimpl.UserDAOImpl;

import com.model.Department;
import com.model.Doctor;
import com.model.User;

import com.service.SymptomRecommendationService;
import com.service.SymptomRecommendationService.Recommendation;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/symptom-recommendation")
public class SymptomRecommendationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DepartmentDAO departmentDAO;
    private DoctorDAO doctorDAO;
    private UserDAO userDAO;
    private SymptomRecommendationService recommendationService;
    private Gson gson;

    @Override
    public void init() throws ServletException {

        departmentDAO = new DepartmentDAOImpl();
        doctorDAO = new DoctorDAOImpl();
        userDAO = new UserDAOImpl();

        recommendationService = new SymptomRecommendationService();
        gson = new Gson();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
    	System.out.println("SYMPTOM RECOMMENDATION SERVLET CALLED");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        // Only logged-in patients can use this endpoint.
        if (session == null) {
            sendError(response, 401, "Please log in first.");
            return;
        }

        User loggedUser = (User) session.getAttribute("user");

        if (loggedUser == null
                || !"PATIENT".equalsIgnoreCase(loggedUser.getRole())) {

            sendError(response, 403,
                    "Only logged-in patients can request recommendations.");
            return;
        }

        try {

            // Read symptoms from the JSON request.
            StringBuilder requestBody = new StringBuilder();

            try (BufferedReader reader = request.getReader()) {

                String line;

                while ((line = reader.readLine()) != null) {
                    requestBody.append(line);
                }
            }

            JsonObject input = gson.fromJson(
                    requestBody.toString(), JsonObject.class);

            if (input == null
                    || !input.has("symptoms")
                    || input.get("symptoms").isJsonNull()
                    || !input.get("symptoms").isJsonPrimitive()
                    || !input.get("symptoms").getAsJsonPrimitive().isString()) {

                sendError(response, 400, "Please enter valid symptoms.");
                return;
            }

            String symptoms = input.get("symptoms").getAsString().trim();

            if (symptoms.isEmpty() || symptoms.length() > 2000) {

                sendError(response, 400,
                        "Symptoms must contain 1 to 2000 characters.");
                return;
            }

            // Load actual active departments from the database.
            List<Department> departments =
                    departmentDAO.getAllDepartments();

            if (departments == null || departments.isEmpty()) {

                sendError(response, 500,
                        "No hospital departments are currently available.");
                return;
            }

            // Get recommendation using Java-based symptom rules.
            Recommendation recommendation =
                    recommendationService.recommendDepartment(
                            symptoms, departments);

            JsonObject result = new JsonObject();

            result.addProperty("success", true);
            result.addProperty(
                    "departmentName",
                    recommendation.getDepartmentName());

            result.addProperty(
                    "reason",
                    recommendation.getReason());

            result.addProperty(
                    "emergency",
                    recommendation.isEmergency());

            // Do not recommend routine doctors for emergency symptoms.
            if (recommendation.isEmergency()) {

                result.addProperty(
                        "message",
                        "Your symptoms may require urgent medical attention. "
                        + "Please seek emergency medical care immediately.");

                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Handle symptoms that do not match any department.
            if (recommendation.getDepartmentName().isEmpty()) {

                result.addProperty(
                        "message",
                        recommendation.getReason());

                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write(gson.toJson(result));
                return;
            }

            // Find the exact department ID from the database.
            int departmentId = -1;

            for (Department department : departments) {

                if (department.getDepartmentName() != null
                        && department.getDepartmentName().equalsIgnoreCase(
                                recommendation.getDepartmentName())) {

                    departmentId = department.getDepartmentId();
                    break;
                }
            }

            if (departmentId == -1) {

                sendError(response, 500,
                        "The recommended department could not be verified.");
                return;
            }

            // Retrieve real available doctors from the existing DAO.
            List<Doctor> doctors =
                    doctorDAO.getAvailableDoctorsByDepartment(departmentId);

            result.addProperty("departmentId", departmentId);

            JsonArray doctorArray = new JsonArray();

            for (Doctor doctor : doctors) {

                User doctorUser =
                        userDAO.getUserById(doctor.getUserId());

                if (doctorUser == null) {
                    continue;
                }

                JsonObject doctorJson = new JsonObject();

                doctorJson.addProperty(
                        "doctorId", doctor.getDoctorId());

                doctorJson.addProperty(
                        "doctorName", doctorUser.getFullName());

                doctorJson.addProperty(
                        "specialization", doctor.getSpecialization());

                doctorJson.addProperty(
                        "qualification", doctor.getQualification());

                doctorJson.addProperty(
                        "experienceYears", doctor.getExperienceYears());

                doctorJson.addProperty(
                        "consultationFee", doctor.getConsultationFee());

                doctorArray.add(doctorJson);
            }

            result.add("doctors", doctorArray);

            result.addProperty(
                    "message",
                    doctorArray.size() == 0
                    ? "No available doctors were found in this department."
                    : "Available doctors retrieved successfully.");

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {

            e.printStackTrace();

            sendError(response, 500,
                    "Unable to process your recommendation right now.");
        }
    }

    private void sendError(
            HttpServletResponse response,
            int status,
            String message) throws IOException {

        response.setStatus(status);

        JsonObject error = new JsonObject();

        error.addProperty("success", false);
        error.addProperty("message", message);

        response.getWriter().write(gson.toJson(error));
    }
}
