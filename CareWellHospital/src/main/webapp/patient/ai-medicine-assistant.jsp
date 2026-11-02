
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>AI Medicine Assistant | CareWell Hospital</title>

<link rel="stylesheet"
	href="<%= request.getContextPath() %>/css/patient-common.css?v=2">

<link rel="stylesheet"
	href="<%= request.getContextPath() %>/css/ai-medicine-assistant.css">

</head>

<body>


	<!-- =========================
     PATIENT SIDEBAR
     ========================= -->

	<aside class="sidebar">

		<!-- BRAND -->
		<div class="brand">

			<div class="brand-icon">♥︎</div>

			<div>
				<h2>CareWell</h2>
				<span>HOSPITAL</span>
			</div>

		</div>


		<!-- NAVIGATION -->
		<nav class="navigation">

			<!-- PATIENT PORTAL -->
			<div class="nav-section-title">PATIENT PORTAL</div>


			<!-- DASHBOARD -->
			<a href="<%= request.getContextPath() %>/patient/dashboard.jsp"
				class="nav-item"> <span class="nav-icon">🏠</span> <span>Dashboard</span>

			</a>


			<!-- MY APPOINTMENTS -->
			<a href="<%= request.getContextPath() %>/patient/appointments.jsp"
				class="nav-item"> <span class="nav-icon">📅</span> <span>My
					Appointments</span>

			</a>


			<!-- BOOK APPOINTMENT -->
			<a
				href="<%= request.getContextPath() %>/patient/book-appointment.jsp"
				class="nav-item"> <span class="nav-icon">📝</span> <span>Book
					Appointment</span>

			</a>


			<!-- MY HEALTH -->
			<div class="nav-section-title">MY HEALTH</div>


			<!-- MEDICAL RECORDS -->
			<a href="<%= request.getContextPath() %>/patient/medical-records.jsp"
				class="nav-item"> <span class="nav-icon">🏥</span> <span>Medical
					Records</span>

			</a>


			<!-- PRESCRIPTIONS -->
			<a href="<%= request.getContextPath() %>/patient/prescriptions.jsp"
				class="nav-item"> <span class="nav-icon">℞</span> <span>Prescriptions</span>

			</a>

			<!-- AI MEDICINE ASSISTANT -->
			<a
				href="<%= request.getContextPath() %>/patient/ai-medicine-assistant.jsp"
				class="nav-item active"> <span class="nav-icon">🤖</span> <span>AI
					Medicine Assistant</span>

			</a>


			<!-- BILLS & PAYMENTS -->
			<a href="<%= request.getContextPath() %>/patient/bills.jsp"
				class="nav-item"> <span class="nav-icon">💸</span> <span>Bills
					& Payments</span>

			</a>


			<!-- ACCOUNT -->
			<div class="nav-section-title">ACCOUNT</div>


			<!-- MY PROFILE -->
			<a href="<%= request.getContextPath() %>/patient/profile.jsp"
				class="nav-item"> <span class="nav-icon">👤</span> <span>My
					Profile</span>

			</a>

		</nav>


		<!-- LOGOUT -->
		<div class="sidebar-bottom">

			<a href="<%= request.getContextPath() %>/LogoutController"
				class="nav-item logout"> <span class="nav-icon">🏃🚪</span> <span>Logout</span>

			</a>

		</div>

	</aside>


	<div class="chatbot-container">

		<header class="chat-header">
			<div class="bot-avatar">✚</div>
			<div>
				<h2>CareWell AI Medicine Assistant</h2>
				<p>Ask questions about your medicines and prescriptions</p>
			</div>
		</header>

		<main class="chat-messages" id="chatMessages">

			<div class="message bot-message">
				<div class="message-content welcome-content">
					<p>Hello! Welcome to CareWell Hospital.</p>

					<p>I'm your AI Medicine Assistant. I can help you understand
						existing prescriptions and general medicine information.</p>

					<p>How can I help you today?</p>
				</div>
			</div>

		</main>

		<div class="medical-disclaimer">
			<strong>Medical Disclaimer:</strong> This assistant provides
			informational guidance only. It does not replace a doctor or
			pharmacist and cannot independently prescribe medicines or dosages.
		</div>

		<footer class="chat-input-area">
			<input type="text" id="messageInput"
				placeholder="Type your medicine-related question..."
				autocomplete="off">

			<button type="button" id="sendButton">Send</button>
		</footer>

	</div>


	<script>
document.addEventListener("DOMContentLoaded", function () {

    const messageInput = document.getElementById("messageInput");
    const sendButton = document.getElementById("sendButton");
    const chatMessages = document.getElementById("chatMessages");

    const contextPath = "<%=request.getContextPath()%>";

    function addMessage(message, sender) {

        const messageDiv = document.createElement("div");
        messageDiv.className = "message " + sender + "-message";

        const contentDiv = document.createElement("div");
        contentDiv.className = "message-content";

        // Fix common mismatched Markdown bold markers
        message = message.replace(
            /\*\*([^*\n]+)\*(?=[:.,!?;])/g,
            "**$1**"
        );

        // Identify bold and italic-style Markdown
        const parts = message.split(/(\*\*[^*]+?\*\*|\*[^*]+?\*)/g);

        parts.forEach(part => {

            if (part.startsWith("**") && part.endsWith("**")) {

                const boldText = document.createElement("strong");
                boldText.textContent = part.slice(2, -2);
                contentDiv.appendChild(boldText);

            } else if (part.startsWith("*") && part.endsWith("*")) {

                const boldText = document.createElement("strong");
                boldText.textContent = part.slice(1, -1);
                contentDiv.appendChild(boldText);

            } else {

                contentDiv.appendChild(document.createTextNode(part));

            }
        });

        messageDiv.appendChild(contentDiv);
        chatMessages.appendChild(messageDiv);

        chatMessages.scrollTop = chatMessages.scrollHeight;

        return messageDiv;
    }

    async function sendMessage() {

        const message = messageInput.value.trim();

        if (!message) {
            return;
        }

        addMessage(message, "user");

        messageInput.value = "";
        sendButton.disabled = true;

        const typingMessage = addMessage(
            "CareWell AI is preparing your response...",
            "bot"
        );

        try {

            const response = await fetch(
                contextPath + "/ai-chat",
                {
                    method: "POST",
                    headers: {
                        "Content-Type":
                            "application/x-www-form-urlencoded"
                    },
                    body: new URLSearchParams({
                        message: message
                    })
                }
            );

            const result = await response.json();

            typingMessage.remove();

            if (!response.ok || !result.success) {
                addMessage(
                    result.message || "Unable to get a response. Please try again.",
                    "bot"
                );
                return;
            }

            addMessage(result.reply, "bot");

        } catch (error) {

            typingMessage.remove();

            addMessage(
                "Unable to connect to the AI service. Please try again later.",
                "bot"
            );

            console.error("AI Chat Error:", error);

        } finally {
            sendButton.disabled = false;
            messageInput.focus();
        }
    }

    sendButton.addEventListener("click", sendMessage);

    messageInput.addEventListener("keydown", function (event) {
        if (event.key === "Enter") {
            sendMessage();
        }
    });

});
</script>

</body>
</html>
