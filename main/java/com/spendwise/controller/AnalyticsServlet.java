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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/analytics")
public class AnalyticsServlet extends HttpServlet {
    
    private TransactionDAO transactionDAO;

    @Override
    public void init() throws ServletException {
        transactionDAO = new TransactionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Fetch recent transactions to compute category distribution for charts
        // In a real app, you'd write a specific GROUP BY query. Here we use Streams for simplicity on the limited data set.
        List<Transaction> transactions = transactionDAO.getRecentTransactions(user.getId(), 500); // get up to 500
        
        LocalDate today = LocalDate.now();
        int month = today.getMonthValue();
        int year = today.getYear();
        
        // Filter for current month and Expenses
        Map<String, Double> categorySpending = transactions.stream()
            .filter(t -> t.getType().equals("EXPENSE") && t.getTransactionDate().toLocalDate().getMonthValue() == month && t.getTransactionDate().toLocalDate().getYear() == year)
            .collect(Collectors.groupingBy(Transaction::getCategoryName, Collectors.summingDouble(Transaction::getAmount)));
            
        // Calculate insights
        double totalMonthlySpend = categorySpending.values().stream().mapToDouble(Double::doubleValue).sum();
        String topCategory = "";
        double topCategoryAmount = 0;
        for (Map.Entry<String, Double> entry : categorySpending.entrySet()) {
            if (entry.getValue() > topCategoryAmount) {
                topCategoryAmount = entry.getValue();
                topCategory = entry.getKey();
            }
        }
        
        double avgDaily = totalMonthlySpend / today.getDayOfMonth();
        
        request.setAttribute("categoryLabels", categorySpending.keySet());
        request.setAttribute("categoryData", categorySpending.values());
        
        request.setAttribute("topCategory", topCategory);
        request.setAttribute("avgDaily", String.format("%.2f", avgDaily));
        
        // Calculate a mock financial score (just a fun metric for students)
        int score = 85; 
        if (totalMonthlySpend > user.getMonthlyAllowance()) score -= 30;
        else if (totalMonthlySpend > user.getMonthlyAllowance() * 0.8) score -= 15;
        if (avgDaily > (user.getMonthlyAllowance() / 30)) score -= 10;
        request.setAttribute("healthScore", score);

        request.getRequestDispatcher("/analytics.jsp").forward(request, response);
    }
}
