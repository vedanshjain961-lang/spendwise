package com.spendwise.controller;

import com.spendwise.dao.TransactionDAO;
import com.spendwise.model.Transaction;
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

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    
    private TransactionDAO transactionDAO;

    @Override
    public void init() throws ServletException {
        transactionDAO = new TransactionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        LocalDate today = LocalDate.now();
        int month = today.getMonthValue();
        int year = today.getYear();

        // Get recent transactions
        List<Transaction> recentTransactions = transactionDAO.getRecentTransactions(user.getId(), 5);
        
        // Get totals
        double totalExpense = transactionDAO.getTotalSum(user.getId(), "EXPENSE", month, year);
        double totalIncome = transactionDAO.getTotalSum(user.getId(), "INCOME", month, year);
        
        // Basic balance (just income - expense for the month as a demo, or overall)
        // For a full app, we might want overall balance, but for student monthly view, monthly balance makes sense.
        // We will calculate remaining allowance.
        double remainingBudget = user.getMonthlyAllowance() - totalExpense;

        request.setAttribute("recentTransactions", recentTransactions);
        request.setAttribute("totalExpense", totalExpense);
        request.setAttribute("totalIncome", totalIncome);
        request.setAttribute("remainingBudget", remainingBudget);

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
}
