package com.spendwise.controller;

import com.spendwise.dao.CategoryDAO;
import com.spendwise.dao.TransactionDAO;
import com.spendwise.model.Category;
import com.spendwise.model.Transaction;
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

@WebServlet("/transactions")
public class TransactionServlet extends HttpServlet {
    
    private TransactionDAO transactionDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        transactionDAO = new TransactionDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Limit 50 for the history view
        List<Transaction> transactions = transactionDAO.getRecentTransactions(user.getId(), 50);
        List<Category> expensesCats = categoryDAO.getCategoriesForUser(user.getId(), "EXPENSE");
        List<Category> incomeCats = categoryDAO.getCategoriesForUser(user.getId(), "INCOME");

        request.setAttribute("transactions", transactions);
        request.setAttribute("expenseCategories", expensesCats);
        request.setAttribute("incomeCategories", incomeCats);

        request.getRequestDispatcher("/transactions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        String type = request.getParameter("type");
        double amount = Double.parseDouble(request.getParameter("amount"));
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String paymentMethod = request.getParameter("paymentMethod");
        String description = request.getParameter("description");
        String merchant = request.getParameter("merchant");
        String dateStr = request.getParameter("transactionDate");
        String notes = request.getParameter("notes");

        Transaction txn = new Transaction();
        txn.setUserId(user.getId());
        txn.setType(type);
        txn.setAmount(amount);
        txn.setCategoryId(categoryId);
        txn.setPaymentMethod(paymentMethod);
        txn.setDescription(description);
        txn.setMerchant(merchant);
        txn.setTransactionDate(Date.valueOf(dateStr));
        txn.setNotes(notes);

        transactionDAO.addTransaction(txn);

        // Redirect back to dashboard or transactions depending on origin
        String origin = request.getParameter("origin");
        if ("dashboard".equals(origin)) {
            response.sendRedirect("dashboard");
        } else {
            response.sendRedirect("transactions");
        }
    }
}
