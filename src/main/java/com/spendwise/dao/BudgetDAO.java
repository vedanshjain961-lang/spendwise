package com.spendwise.dao;

import com.spendwise.model.Budget;
import com.spendwise.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BudgetDAO {

    public boolean setBudget(Budget budget) {
        // Check if budget exists for this category/month/year
        String checkQuery = "SELECT id FROM budgets WHERE user_id = ? AND category_id = ? AND month = ? AND year = ?";
        String insertQuery = "INSERT INTO budgets (user_id, category_id, amount, month, year) VALUES (?, ?, ?, ?, ?)";
        String updateQuery = "UPDATE budgets SET amount = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
            
            checkStmt.setInt(1, budget.getUserId());
            checkStmt.setInt(2, budget.getCategoryId());
            checkStmt.setInt(3, budget.getMonth());
            checkStmt.setInt(4, budget.getYear());
            
            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next()) {
                    // Update existing
                    int id = rs.getInt("id");
                    try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                        updateStmt.setDouble(1, budget.getAmount());
                        updateStmt.setInt(2, id);
                        return updateStmt.executeUpdate() > 0;
                    }
                } else {
                    // Insert new
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertQuery)) {
                        insertStmt.setInt(1, budget.getUserId());
                        insertStmt.setInt(2, budget.getCategoryId());
                        insertStmt.setDouble(3, budget.getAmount());
                        insertStmt.setInt(4, budget.getMonth());
                        insertStmt.setInt(5, budget.getYear());
                        return insertStmt.executeUpdate() > 0;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Budget> getBudgetsWithSpending(int userId, int month, int year) {
        List<Budget> list = new ArrayList<>();
        // Complex query to get budget and left join with transactions to get spent amount
        String query = "SELECT b.*, c.name as category_name, c.icon as category_icon, c.color as category_color, " +
                       "(SELECT COALESCE(SUM(amount), 0) FROM transactions t WHERE t.user_id = b.user_id AND t.category_id = b.category_id AND MONTH(t.transaction_date) = b.month AND YEAR(t.transaction_date) = b.year) as spent_amount " +
                       "FROM budgets b " +
                       "JOIN categories c ON b.category_id = c.id " +
                       "WHERE b.user_id = ? AND b.month = ? AND b.year = ?";
                       
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, month);
            stmt.setInt(3, year);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Budget b = new Budget();
                    b.setId(rs.getInt("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setCategoryId(rs.getInt("category_id"));
                    b.setAmount(rs.getDouble("amount"));
                    b.setMonth(rs.getInt("month"));
                    b.setYear(rs.getInt("year"));
                    
                    b.setCategoryName(rs.getString("category_name"));
                    b.setCategoryIcon(rs.getString("category_icon"));
                    b.setCategoryColor(rs.getString("category_color"));
                    b.setSpentAmount(rs.getDouble("spent_amount"));
                    
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
