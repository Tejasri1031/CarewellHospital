<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.dao.FeaturedDoctorDAO"%>
<%@ page import="com.daoimpl.FeaturedDoctorDAOImpl"%>
<%@ page import="com.model.FeaturedDoctor"%>

<%
    FeaturedDoctorDAO featuredDoctorDAO = new FeaturedDoctorDAOImpl();
    List<FeaturedDoctor> featuredDoctors = featuredDoctorDAO.getFeaturedDoctors();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CareWell Hospital | Your Health, Our Priority</title>
<link rel="stylesheet"
	href="<%= request.getContextPath() %>/css/home.css">
</head>
<body>

	<header class="navbar">
		<a href="<%= request.getContextPath() %>/index.jsp" class="brand">
			<span class="brand-icon">♥</span> <span>CareWell<span
				class="brand-highlight"> Hospital</span></span>
		</a>

		<nav class="nav-links">
			<a href="#home">Home</a> <a href="#services">Services</a> <a
				href="#doctors">Our Doctors</a> <a href="#about">About Us</a>
		</nav>

		<a class="nav-login" href="<%= request.getContextPath() %>/login.jsp">
			Login / Portal </a>
	</header>

	<main>
		<!-- Hero Section -->
		<section class="hero" id="home">
			<div class="hero-content">
				<span class="eyebrow">WELCOME TO CAREWELL HOSPITAL</span>

				<h1>
					Your Health Deserves <span>Exceptional Care.</span>
				</h1>

				<p>Discover compassionate healthcare, personalized attention,
					and convenient access to the care you need. Your well-being is our
					priority.</p>

				<div class="hero-actions">
					<a class="btn btn-primary"
						href="<%= request.getContextPath() %>/login.jsp"> Book an
						Appointment <span>→</span>
					</a> <a class="btn btn-secondary" href="#services">Explore Our
						Services</a>
				</div>

				<div class="hero-note">
					<span class="note-icon">♡</span>
					<div>
						<strong>Care that puts you first</strong>
						<p>Supporting you throughout your healthcare journey.</p>
					</div>
				</div>
			</div>

			<div class="hero-visual">
				<div class="hero-image">
					<div class="medical-symbol">♥</div>
					<div class="image-caption">
						<span class="caption-icon">♥</span>
						<div>
							<strong>Your Care, Our Commitment</strong>
							<p>Here for your health journey</p>
						</div>
					</div>
				</div>

				<div class="floating-card">
					<span class="floating-icon">✦</span>
					<div>
						<strong>Personalized Care</strong>
						<p>Focused on your well-being</p>
					</div>
				</div>
			</div>
		</section>

		<!-- Database-driven Doctors Section: only one section uses id="doctors" -->
		<section class="doctors-section" id="doctors">
			<div class="section-heading">
				<span class="section-tag">OUR MEDICAL TEAM</span>
				<h2>Meet Our Experienced Doctors</h2>
				<p>Get expert medical care from our dedicated healthcare
					professionals.</p>
			</div>

			<div class="doctors-grid">
				<%
                if (featuredDoctors != null && !featuredDoctors.isEmpty()) {
                    for (FeaturedDoctor doctor : featuredDoctors) {
                        String imagePath = doctor.getProfileImage();
                        String imageUrl = null;

                        if (imagePath != null && !imagePath.trim().isEmpty()) {
                            imagePath = imagePath.trim().replace("\\", "/");
                            if (imagePath.startsWith("https://") || imagePath.startsWith("http://")) {
                                imageUrl = imagePath;
                            } else {
                                imagePath = imagePath.replaceFirst("^/+", "");
                                imageUrl = request.getContextPath() + "/" + imagePath;
                            }
                        }
            %>
				<article class="doctor-card">
					<div class="doctor-image-wrapper">
						<% if (imageUrl != null) { %>
						<img src="<%= imageUrl %>" alt="Doctor profile"
							class="doctor-image">
						<% } else { %>
						<div class="doctor-image-placeholder">
							<span>Doctor</span>
						</div>
						<% } %>
					</div>

					<div class="doctor-card-content">
						<h3>
							<%= doctor.getFullName() != null
                                ? doctor.getFullName() : "Medical Professional" %>
						</h3>

						<p class="doctor-specialization">
							<%= doctor.getSpecialization() != null
                                ? doctor.getSpecialization() : "General Healthcare" %>
						</p>

						<p class="doctor-qualification">
							<%= doctor.getQualification() != null
                                ? doctor.getQualification() : "" %>
						</p>

						<p class="doctor-experience">
							<%= doctor.getExperienceYears() %>
							years of experience
						</p>

						<%
                        String availability = doctor.getAvailabilityStatus();
                        if (availability != null && availability.equalsIgnoreCase("AVAILABLE")) {
                    %>
						<span class="doctor-status available">Available</span>
						<% } else { %>
						<span class="doctor-status">Contact for availability</span>
						<% } %>
					</div>
				</article>
				<%
                    }
                } else {
            %>
				<div class="doctors-empty-state">
					<h3>Our medical team is here for you</h3>
					<p>Doctor profiles will appear here when active doctor records
						are available.</p>
				</div>
				<% } %>
			</div>
		</section>

		<!-- Services Section -->
		<section class="section services-section" id="services">
			<div class="section-heading">
				<span class="eyebrow">HEALTHCARE SERVICES</span>
				<h2>Care for Every Stage of Life</h2>
				<p>Explore healthcare specialties and find the support that fits
					your needs.</p>
			</div>

			<div class="service-grid">
				<article class="service-card">
					<div class="service-icon blue">♡</div>
					<h3>Cardiology</h3>
					<p>Healthcare focused on heart health and cardiovascular
						well-being.</p>
					<a href="<%= request.getContextPath() %>/login.jsp">Get Started
						→</a>
				</article>

				<article class="service-card">
					<div class="service-icon purple">✧</div>
					<h3>Neurology</h3>
					<p>Care and consultation for conditions affecting the nervous
						system.</p>
					<a href="<%= request.getContextPath() %>/login.jsp">Get Started
						→</a>
				</article>

				<article class="service-card">
					<div class="service-icon green">♥</div>
					<h3>Orthopedics</h3>
					<p>Support for bone, joint, muscle, and mobility concerns.</p>
					<a href="<%= request.getContextPath() %>/login.jsp">Get Started
						→</a>
				</article>

				<article class="service-card">
					<div class="service-icon orange">♧</div>
					<h3>Pediatrics</h3>
					<p>Healthcare guidance for infants, children, and adolescents.</p>
					<a href="<%= request.getContextPath() %>/login.jsp">Get Started
						→</a>
				</article>

				<article class="service-card">
					<div class="service-icon pink">✿</div>
					<h3>General Medicine</h3>
					<p>Consultations for common health concerns and ongoing care.</p>
					<a href="<%= request.getContextPath() %>/login.jsp">Get Started
						→</a>
				</article>

				<article class="service-card">
					<div class="service-icon teal">⌕</div>
					<h3>Diagnostics</h3>
					<p>Explore diagnostic services and discuss your testing needs.</p>
					<a href="<%= request.getContextPath() %>/login.jsp">Get Started
						→</a>
				</article>
			</div>
		</section>

		<!-- About Section -->
		<section class="about-section" id="about">
			<div class="about-visual">
				<div class="about-symbol">♥</div>
				<span>CAREWELL HOSPITAL</span>
				<p>Every patient matters.</p>
			</div>

			<div class="about-content">
				<span class="eyebrow">WHY CAREWELL?</span>
				<h2>Healthcare Made More Accessible</h2>
				<p>Managing healthcare should feel simple and organized.
					CareWell brings essential hospital services and portal access
					together in one convenient place.</p>

				<ul class="benefit-list">
					<li><span>✓</span> Convenient patient portal access</li>
					<li><span>✓</span> Appointment management</li>
					<li><span>✓</span> Dedicated doctor portal</li>
					<li><span>✓</span> Organized hospital administration</li>
				</ul>

				<a class="btn btn-primary"
					href="<%= request.getContextPath() %>/login.jsp"> Access Your
					Portal → </a>
			</div>
		</section>

		<!-- Call to Action -->
		<section class="cta-section">
			<div>
				<span class="eyebrow">TAKE THE NEXT STEP</span>
				<h2>Your Health Journey Starts Here.</h2>
				<p>Sign in to manage appointments and access your hospital
					portal.</p>
			</div>
			<a class="btn btn-light"
				href="<%= request.getContextPath() %>/login.jsp"> Get Started →
			</a>
		</section>
	</main>

	<!-- Footer -->
	<footer class="footer">
		<div class="footer-main">
			<div class="footer-brand">
				<a href="<%= request.getContextPath() %>/index.jsp" class="brand">
					<span class="brand-icon">♥</span> <span>CareWell<span
						class="brand-highlight"> Hospital</span></span>
				</a>
				<p>Bringing hospital services and patient access together in one
					place.</p>
			</div>

			<div class="footer-column">
				<h4>Explore</h4>
				<a href="#home">Home</a> <a href="#services">Services</a> <a
					href="#doctors">Our Doctors</a> <a href="#about">About Us</a>
			</div>

			<div class="footer-column">
				<h4>Portals</h4>
				<a href="<%= request.getContextPath() %>/login.jsp">Patient
					Login</a> <a href="<%= request.getContextPath() %>/login.jsp">Doctor
					Login</a> <a href="<%= request.getContextPath() %>/login.jsp">Admin
					Login</a>
			</div>
		</div>

		<div class="footer-bottom">
			<p>
				©
				<%= java.time.Year.now() %>
				CareWell Hospital. All rights reserved.
			</p>
			<a href="#home">Back to top ↑</a>
		</div>
	</footer>

</body>
</html>
