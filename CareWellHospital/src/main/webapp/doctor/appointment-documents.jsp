<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.model.MedicalDocument" %>
<%@ page import="com.model.Appointment" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>

<%
    List<MedicalDocument> documents =
            (List<MedicalDocument>) request.getAttribute("documents");

    Appointment appointment =
            (Appointment) request.getAttribute("appointment");

    if (documents == null || appointment == null) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Patient Medical Documents | CareWell</title>
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/doctor-appointment-documents.css">
</head>

<body>

<div class="documents-container">

    <h2>Patient Medical Documents</h2>

    <p>
        Appointment ID:
        <strong><%= appointment.getAppointmentId() %></strong>
    </p>

    <% if (documents.isEmpty()) { %>

        <div class="empty-message">
            No medical documents have been uploaded for this appointment.
        </div>

    <% } else { %>

        <table>
            <thead>
                <tr>
                    <th>Document Name</th>
                    <th>Category</th>
                    <th>Upload Date</th>
                    <th>Action</th>
                </tr>
            </thead>

            <tbody>

            <% for (MedicalDocument document : documents) { %>

                <tr>
                    <td>
                        <%= document.getOriginalFileName() %>
                    </td>

                    <td>
                        <%= document.getDocumentType().replace("_", " ") %>
                    </td>

                    <td>
                        <%= document.getUploadedAt() != null
                                ? new SimpleDateFormat("dd-MM-yyyy HH:mm")
                                    .format(document.getUploadedAt())
                                : "Not available" %>
                    </td>

                    <td>
                        <a href="<%= request.getContextPath() %>/doctor/medical-document?documentId=<%= document.getDocumentId() %>&appointmentId=<%= appointment.getAppointmentId() %>"
                           class="view-document-btn">
                            View Document
                        </a>
                    </td>
                </tr>

            <% } %>

            </tbody>
        </table>

    <% } %>

    <a href="<%= request.getContextPath() %>/appointments?action=doctor"
       class="back-btn">
        Back to Appointments
    </a>

</div>

</body>
</html>