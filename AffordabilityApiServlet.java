package com.spendwise.controller;

import com.google.gson.Gson;
import com.spendwise.dao.RecurringExpenseDAO;
import com.spendwise.dao.TransactionDAO;
import com.spendwise.model.RecurringExpense;
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

@WebServlet("/api/affordability")
public class AffordabilityApiServlet extends HttpServlet {

    private TransactionDAO transactionDAO;
    private RecurringExpenseDAO recurringDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        transactionDAO = new TransactionDAO();
        recurringDAO = new RecurringExpenseDAO();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        User user = (User) session.getAttribute("user");
        double itemCost = Double.parseDouble(request.getParameter("cost"));
        
        LocalDate today = LocalDate.now();
        int month = today.getMonthValue();
        int year = today.getYear();
        
        // Calculate remaining allowance for the month
        double totalExpense = transactionDAO.getTotalSum(user.getId(), "EXPENSE", month, year);
        double remainingAllowance = user.getMonthlyAllowance() - totalExpense;
        
        // Factor in upcoming recurring expenses for this month
        List<RecurringExpense> recurringList = recurringDAO.getActiveExpenses(user.getId());
        double upcomingRecurring = 0;
        for (RecurringExpense re : recurringList) {
            if (re.getNextDueDate() != null) {
                LocalDate dueDate = re.getNextDueDate().toLocalDate();
                if (dueDate.getMonthValue() == month && dueDate.getYear() == year && dueDate.isAfter(today)) {
                    upcomingRecurring += re.getAmount();
                }
            }
        }
        
        double actualDisposable = remainingAllowance - upcomingRecurring;
        
        // Business Logic
        String result;
        String color;
        String message;

        if (actualDisposable < itemCost) {
            result = "🔴 Not Recommended";
            color = "text-danger";
            message = "This purchase will push you over your planned budget. You only have ₹" + String.format("%.2f", actualDisposable) + " disposable income left after upcoming recurring bills.";
        } else if (actualDisposable * 0.4 < itemCost) {
            result = "🟡 Be Careful";
            color = "text-warning";
            message = "You can afford this, but it takes up more than 40% of your remaining disposable budget for the month.";
        } else {
            result = "🟢 Yes";
            color = "text-success";
            message = "You can afford this purchase comfortably while staying within your budget.";
        }

        Map<String, String> jsonResponse = new HashMap<>();
        jsonResponse.put("result", result);
        jsonResponse.put("color", color);
        jsonResponse.put("message", message);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(jsonResponse));
    }
}
