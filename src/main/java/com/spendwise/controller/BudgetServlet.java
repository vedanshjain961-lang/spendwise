package com.spendwise.controller;

import com.spendwise.dao.BudgetDAO;
import com.spendwise.dao.CategoryDAO;
import com.spendwise.model.Budget;
import com.spendwise.model.Category;
import com.spendwise.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/budgets")
public class BudgetServlet extends HttpServlet {
    
    private BudgetDAO budgetDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        budgetDAO = new BudgetDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        LocalDate today = LocalDate.now();
        int month = today.getMonthValue();
        int year = today.getYear();

        List<Budget> budgets = budgetDAO.getBudgetsWithSpending(user.getId(), month, year);
        List<Category> expenseCategories = categoryDAO.getCategoriesForUser(user.getId(), "EXPENSE");

        request.setAttribute("budgets", budgets);
        request.setAttribute("expenseCategories", expenseCategories);
        request.setAttribute("currentMonth", today.getMonth().name());

        request.getRequestDispatcher("/budgets.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        double amount = Double.parseDouble(request.getParameter("amount"));
        
        LocalDate today = LocalDate.now();
        
        Budget b = new Budget();
        b.setUserId(user.getId());
        b.setCategoryId(categoryId);
        b.setAmount(amount);
        b.setMonth(today.getMonthValue());
        b.setYear(today.getYear());

        budgetDAO.setBudget(b);

        response.sendRedirect("budgets");
    }
}
