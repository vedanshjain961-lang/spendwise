package com.spendwise.controller;

import com.spendwise.model.User;
import com.spendwise.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String college = request.getParameter("college");
        String course = request.getParameter("course");
        
        // Parse numbers safely
        int semester = 1;
        double allowance = 0.0;
        try {
            if (request.getParameter("semester") != null && !request.getParameter("semester").isEmpty()) {
                semester = Integer.parseInt(request.getParameter("semester"));
            }
            if (request.getParameter("allowance") != null && !request.getParameter("allowance").isEmpty()) {
                allowance = Double.parseDouble(request.getParameter("allowance"));
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid numeric values provided.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setCollege(college);
        user.setCourse(course);
        user.setSemester(semester);
        user.setMonthlyAllowance(allowance);

        boolean success = userService.register(user, password);

        if (success) {
            response.sendRedirect("login?registered=true");
        } else {
            request.setAttribute("error", "Registration failed. Email might already exist.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
