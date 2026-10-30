
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Create Account | CareWell Hospital</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/style.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/register.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
</head>
<body>

	<main class="register-page">
		<section class="register-card">

			<header class="register-header">
				<div class="brand">
					<div class="brand-icon">♥</div>
					<div>
						<div class="brand-name">CareWell</div>
						<div class="brand-caption">H O S P I T A L</div>
					</div>
				</div>

				<span class="secure-label">● Secure Registration</span>
				<h1>Create your account</h1>
				<p class="subtitle">Join CareWell Hospital to manage your
					healthcare information and appointments.</p>

				<div class="account-badge">
					<span class="badge-icon">✚</span>
					<div>
						<strong>Patient Registration</strong> <small>Create your
							personal patient account</small>
					</div>
				</div>
			</header>

			<div class="form-content">

				<% if ("emailExists".equals(request.getParameter("error"))) { %>
				<div class="form-alert error-message">An account with this
					email already exists. Please sign in or use another email.</div>
				<% } else if ("patientCreationFailed".equals(request.getParameter("error"))) { %>
				<div class="form-alert error-message">Your account could not
					be fully created. Please try again or contact support.</div>
				<% } else if ("registrationFailed".equals(request.getParameter("error"))) { %>
				<div class="form-alert error-message">Registration failed.
					Please check your details and try again.</div>
				<% } else if ("invalidInput".equals(request.getParameter("error"))) { %>
				<div class="form-alert error-message">Please check your
					details. Enter a valid name, email, phone, date of birth, address,
					and emergency contact information. Your password must contain 8–72
					characters, and both password fields must match.</div>
				<% } %>

				<div class="section-heading">
					<h2>Personal information</h2>
					<p>Enter your details as they appear on your records.</p>
				</div>

				<form action="${pageContext.request.contextPath}/register"
					method="post" id="registerForm" novalidate>

					<div class="form-grid">

						<div class="form-field full-width">
							<label for="fullName">Full name <span>*</span></label> <input
								id="fullName" type="text" name="fullName"
								placeholder="Enter your full name" autocomplete="name"
								maxlength="100" pattern="[A-Za-z][A-Za-z .'-]{1,99}"
								title="Start with a letter. Use only letters, spaces, periods, apostrophes, and hyphens."
								required>
						</div>




						<!-- Email and Phone -->
						<div class="form-row">

							<div class="form-group">
								<label for="email">Email address <span>*</span></label> <input
									type="email" id="email" name="email" class="form-input"
									placeholder="you@example.com" required
									aria-describedby="email-error"> <small id="email-error"
									class="validation-message" aria-live="polite"></small>
							</div>

							<div class="form-group">
								<label for="phone">Phone number <span>*</span></label> <input
									type="tel" id="phone" name="phone" class="form-input"
									placeholder="10-digit Indian mobile number" maxlength="10"
									inputmode="numeric" required> <small id="phone-error"
									class="validation-message" aria-live="polite"></small>
							</div>

						</div>



						<!-- Password with show/hide eye icon -->
						<div class="form-field">
							<label for="password">Password <span>*</span></label>

							<div class="password-input-wrapper">
								<input id="password" type="password" name="password"
									placeholder="At least 8 characters" minlength="8"
									maxlength="72" autocomplete="new-password" required>

								<button type="button" class="password-toggle"
									data-toggle-password="password" aria-label="Show password"
									aria-pressed="false">
									<i class="fa-regular fa-eye" aria-hidden="true"></i>
								</button>
							</div>

							<small class="field-hint"> Use at least 8 characters. </small>
						</div>

						<!-- Confirm password with show/hide eye icon -->
						<div class="form-field">
							<label for="confirmPassword"> Confirm password <span>*</span>
							</label>

							<div class="password-input-wrapper">
								<input id="confirmPassword" type="password"
									name="confirmPassword" placeholder="Re-enter your password"
									minlength="8" maxlength="72" autocomplete="new-password"
									required>

								<button type="button" class="password-toggle"
									data-toggle-password="confirmPassword"
									aria-label="Show password" aria-pressed="false">
									<i class="fa-regular fa-eye" aria-hidden="true"></i>
								</button>
							</div>

							<small id="passwordMatchMessage" class="field-hint"
								aria-live="polite"></small>
						</div>

						<div class="form-field">
							<label for="dateOfBirth">Date of birth <span>*</span></label> <input
								id="dateOfBirth" type="date" name="dateOfBirth" min="1900-01-01"
								autocomplete="bday" required>
						</div>

						<div class="form-field">
							<label for="gender">Gender <span>*</span></label> <select
								id="gender" name="gender" required>
								<option value="">Select gender</option>
								<option value="Male">Male</option>
								<option value="Female">Female</option>
								<option value="Other">Other</option>
							</select>
						</div>

						<div class="form-field">
							<label for="bloodGroup">Blood group <span>*</span></label> <select
								id="bloodGroup" name="bloodGroup" required>
								<option value="">Select blood group</option>
								<option value="A+">A+</option>
								<option value="A-">A-</option>
								<option value="B+">B+</option>
								<option value="B-">B-</option>
								<option value="AB+">AB+</option>
								<option value="AB-">AB-</option>
								<option value="O+">O+</option>
								<option value="O-">O-</option>
							</select>
						</div>

						<div class="form-field full-width">
							<label for="address">Residential address <span>*</span></label>
							<textarea id="address" name="address" rows="3"
								placeholder="Enter your complete address" maxlength="500"
								autocomplete="street-address" required></textarea>
						</div>

					</div>

					<div class="section-heading emergency-heading">
						<h2>Emergency contact</h2>
						<p>Provide someone we can contact when necessary.</p>
					</div>

					<div class="form-grid">

						<div class="form-field">
							<label for="emergencyContactName"> Contact person's name
								<span>*</span>
							</label> <input id="emergencyContactName" type="text"
								name="emergencyContactName"
								placeholder="Enter contact person's name"
								pattern="[A-Za-z][A-Za-z .'-]{1,99}" maxlength="100" required>
						</div>

						<div class="form-field">
							<label for="emergencyContactPhone"> Contact phone number
								<span>*</span>
							</label> <input id="emergencyContactPhone" type="tel"
								name="emergencyContactPhone"
								placeholder="10-digit mobile number" pattern="[6-9][0-9]{9}"
								minlength="10" maxlength="10" inputmode="numeric" required>
						</div>

					</div>

					<div class="privacy-note">
						<span class="privacy-icon">✓</span>
						<p>Your information is intended for managing your patient
							account and healthcare services.</p>
					</div>

					<button type="submit" class="submit-btn">
						Create Patient Account <span aria-hidden="true">→</span>
					</button>

				</form>

				<p class="login-link">
					Already have an account? <a
						href="${pageContext.request.contextPath}/login.jsp"> Sign in </a>
				</p>

			</div>

			<footer class="register-footer"> CareWell Hospital · Your
				health, our priority. </footer>

		</section>
	</main>



	<script>
    // ==========================================
    // 1. PREVENT FUTURE DATE OF BIRTH
    // ==========================================

    const dobInput = document.getElementById("dateOfBirth");

    if (dobInput) {
        const today = new Date();

        const localToday = [
            today.getFullYear(),
            String(today.getMonth() + 1).padStart(2, "0"),
            String(today.getDate()).padStart(2, "0")
        ].join("-");

        dobInput.max = localToday;
    }


    // ==========================================
    // 2. SHOW / HIDE PASSWORD
    // ==========================================

    document.querySelectorAll("[data-toggle-password]").forEach(button => {

        button.addEventListener("click", () => {

            const inputId = button.getAttribute("data-toggle-password");
            const input = document.getElementById(inputId);
            const icon = button.querySelector("i");

            const showPassword = input.type === "password";

            input.type = showPassword ? "text" : "password";

            icon.classList.toggle("fa-eye", !showPassword);
            icon.classList.toggle("fa-eye-slash", showPassword);

            button.setAttribute(
                "aria-label",
                showPassword ? "Hide password" : "Show password"
            );

            button.setAttribute("aria-pressed", String(showPassword));
        });

    });


    // ==========================================
    // 3. GET FORM ELEMENTS
    // ==========================================

    const password = document.getElementById("password");
    const confirmPassword = document.getElementById("confirmPassword");

    const passwordMatchMessage =
        document.getElementById("passwordMatchMessage");

    const registerForm = document.getElementById("registerForm");

    const emailInput = document.getElementById("email");
    const emailError = document.getElementById("email-error");

    const phoneInput = document.getElementById("phone");
    const phoneError = document.getElementById("phone-error");


    // ==========================================
    // 4. EMAIL VALIDATION
    // ==========================================

    function validateEmail() {

        emailError.textContent = "";
        emailInput.classList.remove("invalid");

        if (emailInput.value.trim() === "") {

            emailError.textContent = "Please enter your email address.";
            emailInput.classList.add("invalid");

            return false;
        }

        if (!emailInput.validity.valid) {

            emailError.textContent =
                "Enter a valid email address, e.g. name@example.com.";

            emailInput.classList.add("invalid");

            return false;
        }

        return true;
    }

    emailInput.addEventListener("input", validateEmail);
    emailInput.addEventListener("blur", validateEmail);


    // ==========================================
    // 5. PHONE NUMBER VALIDATION
    // ==========================================

    function validatePhone() {

        phoneError.textContent = "";
        phoneInput.classList.remove("invalid");

        const phone = phoneInput.value.trim();

        if (phone === "") {

            phoneError.textContent = "Please enter your phone number.";

        } else if (!/^[0-9]+$/.test(phone)) {

            phoneError.textContent = "Only numbers are allowed.";

        } else if (phone.length !== 10) {

            phoneError.textContent =
                "Phone number must contain exactly 10 digits.";

        } else {

            return true;
        }

        phoneInput.classList.add("invalid");
        return false;
    }

    phoneInput.addEventListener("input", validatePhone);
    phoneInput.addEventListener("blur", validatePhone);


    // ==========================================
    // 6. PASSWORD MATCH VALIDATION
    // ==========================================

    function validatePasswordMatch() {

        confirmPassword.setCustomValidity("");

        if (confirmPassword.value === "") {

            passwordMatchMessage.textContent = "";
            confirmPassword.classList.remove("invalid");

            return false;
        }

        const matches = password.value === confirmPassword.value;

        passwordMatchMessage.textContent = matches
            ? "Passwords match."
            : "Passwords do not match.";

        passwordMatchMessage.style.color = matches
            ? "#15803d"
            : "#dc2626";

        confirmPassword.classList.toggle("invalid", !matches);

        if (!matches) {

            confirmPassword.setCustomValidity(
                "Passwords do not match."
            );

        }

        return matches;
    }

    password.addEventListener("input", validatePasswordMatch);
    confirmPassword.addEventListener("input", validatePasswordMatch);


    // ==========================================
    // 7. FORM SUBMISSION VALIDATION
    // ==========================================

    registerForm.addEventListener("submit", function(event) {

        const emailValid = validateEmail();

        const phoneValid = validatePhone();

        const passwordValid = password.checkValidity();

        const passwordsMatch = validatePasswordMatch();


        if (
            !emailValid ||
            !phoneValid ||
            !passwordValid ||
            !passwordsMatch
        ) {

            event.preventDefault();

            if (!emailValid) {

                emailInput.focus();

            } else if (!phoneValid) {

                phoneInput.focus();

            } else if (!passwordValid) {

                password.focus();

            } else {

                confirmPassword.focus();

            }

        }

    });

</script>

</body>
</html>
