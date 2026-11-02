package com.filter;

import java.io.IOException;

import com.dao.UserDAO;
import com.daoimpl.UserDAOImpl;
import com.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter("/doctor/*")
public class DoctorAuthFilter implements Filter {

    private UserDAO userDAO;

    @Override
    public void init(jakarta.servlet.FilterConfig filterConfig)
            throws ServletException {
        userDAO = new UserDAOImpl();
    }

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
                         throws IOException, ServletException {
    	
    	System.out.println("DoctorAuthFilter is executing");

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(
                    httpRequest.getContextPath() + "/login.jsp");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");

        if (!"DOCTOR".equalsIgnoreCase(sessionUser.getRole())) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Doctor access required.");
            return;
        }

        User currentUser = userDAO.getUserById(sessionUser.getUserId());
        System.out.println("Filter User ID: " + sessionUser.getUserId());

        System.out.println("Database Account Status: "
                + (currentUser == null ? "USER NOT FOUND" : currentUser.getStatus()));

        if (currentUser == null
                || !"ACTIVE".equalsIgnoreCase(currentUser.getStatus())
                || !"DOCTOR".equalsIgnoreCase(currentUser.getRole())) {

            session.invalidate();

            httpResponse.sendRedirect(
                    httpRequest.getContextPath() + "/login.jsp?error=inactive");
            return;
        }

        chain.doFilter(request, response);
    }
}