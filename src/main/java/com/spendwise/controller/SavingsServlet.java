package com.spendwise.controller;

import com.spendwise.dao.SavingsGoalDAO;
import com.spendwise.model.SavingsGoal;
import com.spendwise.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/savings")
public class SavingsServlet extends HttpServlet {
    
    private SavingsGoalDAO savingsDAO;

    @Override
    public void init() throws ServletException {
        savingsDAO = new SavingsGoalDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        List<SavingsGoal> goals = savingsDAO.getGoalsForUser(user.getId());
        request.setAttribute("goals", goals);

        request.getRequestDispatcher("/savings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        String action = request.getParameter("action");
        
        if ("addFund".equals(action)) {
            int goalId = Integer.parseInt(request.getParameter("goalId"));
            double amount = Double.parseDouble(request.getParameter("amount"));
            savingsDAO.addFunds(goalId, user.getId(), amount);
        } else {
            // Add new goal
            String name = request.getParameter("name");
            double target = Double.parseDouble(request.getParameter("targetAmount"));
            double current = 0;
            if (request.getParameter("currentAmount") != null && !request.getParameter("currentAmount").isEmpty()) {
                current = Double.parseDouble(request.getParameter("currentAmount"));
            }
            String deadlineStr = request.getParameter("deadline");
            String description = request.getParameter("description");
            
            SavingsGoal goal = new SavingsGoal();
            goal.setUserId(user.getId());
            goal.setName(name);
            goal.setTargetAmount(target);
            goal.setCurrentAmount(current);
            if (deadlineStr != null && !deadlineStr.isEmpty()) {
                goal.setDeadline(Date.valueOf(deadlineStr));
            }
            goal.setDescription(description);
            
            savingsDAO.addGoal(goal);
        }

        response.sendRedirect("savings");
    }
}
