
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
                <p class="subtitle">
                    Join CareWell Hospital to manage your healthcare
                    information and appointments.
                </p>

                <div class="account-badge">
                    <span class="badge-icon">✚</span>
                    <div>
                        <strong>Patient Registration</strong>
                        <small>Create your personal patient account</small>
                    </div>
                </div>
            </header>

            <div class="form-content">

                <% if ("emailExists".equals(request.getParameter("error"))) { %>
                    <div class="form-alert error-message">
                        An account with this email already exists.
                        Please sign in or use another email.
                    </div>
                <% } else if ("patientCreationFailed".equals(request.getParameter("error"))) { %>
                    <div class="form-alert error-message">
                        Your account could not be fully created.
                        Please try again or contact support.
                    </div>
                <% } else if ("registrationFailed".equals(request.getParameter("error"))) { %>
                    <div class="form-alert error-message">
                        Registration failed. Please check your details and try again.
                    </div>
                <% } %>

                <div class="section-heading">
                    <h2>Personal information</h2>
                    <p>Enter your details as they appear on your records.</p>
                </div>

                <form action="${pageContext.request.contextPath}/register"
                      method="post">

                    <div class="form-grid">

                        <div class="form-field full-width">
                            <label for="fullName">Full name <span>*</span></label>
                            <input id="fullName" type="text" name="fullName"
                                   placeholder="Enter your full name"
                                   autocomplete="name" maxlength="100" required>
                        </div>

                        <div class="form-field">
                            <label for="email">Email address <span>*</span></label>
                            <input id="email" type="email" name="email"
                                   placeholder="you@example.com"
                                   autocomplete="email" maxlength="150" required>
                        </div>

                        <div class="form-field">
                            <label for="phone">Phone number <span>*</span></label>
                            <input id="phone" type="tel" name="phone"
                                   placeholder="10-digit mobile number"
                                   pattern="[0-9]{10}" minlength="10"
                                   maxlength="10" inputmode="numeric"
                                   autocomplete="tel" required>
                        </div>

                        <div class="form-field">
                            <label for="password">Password <span>*</span></label>
                            <input id="password" type="password" name="password"
                                   placeholder="At least 8 characters"
                                   minlength="8" autocomplete="new-password"
                                   required>
                            <small class="field-hint">
                                Use at least 8 characters.
                            </small>
                        </div>

                        <div class="form-field">
                            <label for="dateOfBirth">Date of birth <span>*</span></label>
                            <input id="dateOfBirth" type="date" name="dateOfBirth"
                                   autocomplete="bday" required>
                        </div>

                        <div class="form-field">
                            <label for="gender">Gender <span>*</span></label>
                            <select id="gender" name="gender" required>
                                <option value="">Select gender</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>

                        <div class="form-field">
                            <label for="bloodGroup">Blood group <span>*</span></label>
                            <select id="bloodGroup" name="bloodGroup" required>
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
                                      placeholder="Enter your complete address"
                                      maxlength="500" autocomplete="street-address"
                                      required></textarea>
                        </div>

                    </div>

                    <div class="section-heading emergency-heading">
                        <h2>Emergency contact</h2>
                        <p>Provide someone we can contact when necessary.</p>
                    </div>

                    <div class="form-grid">
                        <div class="form-field">
                            <label for="emergencyContactName">
                                Contact person's name <span>*</span>
                            </label>
                            <input id="emergencyContactName" type="text"
                                   name="emergencyContactName"
                                   placeholder="Enter contact person's name"
                                   maxlength="100" required>
                        </div>

                        <div class="form-field">
                            <label for="emergencyContactPhone">
                                Contact phone number <span>*</span>
                            </label>
                            <input id="emergencyContactPhone" type="tel"
                                   name="emergencyContactPhone"
                                   placeholder="10-digit mobile number"
                                   pattern="[0-9]{10}" minlength="10"
                                   maxlength="10" inputmode="numeric" required>
                        </div>
                    </div>

                    <div class="privacy-note">
                        <span class="privacy-icon">✓</span>
                        <p>
                            Your information is intended for managing your
                            patient account and healthcare services.
                        </p>
                    </div>

                    <button type="submit" class="submit-btn">
                        Create Patient Account
                        <span aria-hidden="true">→</span>
                    </button>

                </form>

                <p class="login-link">
                    Already have an account?
                    <a href="${pageContext.request.contextPath}/login.jsp">
                        Sign in
                    </a>
                </p>

            </div>

            <footer class="register-footer">
                CareWell Hospital · Your health, our priority.
            </footer>

        </section>
    </main>
</body>
</html>
