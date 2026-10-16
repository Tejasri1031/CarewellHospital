package com.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.dao.UserDAO;
import com.daoimpl.UserDAOImpl;
import com.model.User;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDAO.getUserByEmail(email);

        if (user != null
                && user.getPassword().equals(password)
                && "ACTIVE".equalsIgnoreCase(user.getStatus())) {

            HttpSession session = request.getSession();

            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("role", user.getRole());

            String role = user.getRole();

            if ("ADMIN".equalsIgnoreCase(role)) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/dashboard.jsp");

            } else if ("DOCTOR".equalsIgnoreCase(role)) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/doctor/dashboard.jsp");

            } else if ("PATIENT".equalsIgnoreCase(role)) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/patient/dashboard.jsp");

            } else {

                session.invalidate();

                response.sendRedirect(
                        request.getContextPath()
                        + "/login.jsp?error=invalidRole");
            }

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp?error=invalid");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect(
                request.getContextPath() + "/login.jsp");
    }
}