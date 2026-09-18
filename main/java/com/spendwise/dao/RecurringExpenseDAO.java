package com.spendwise.dao;

import com.spendwise.model.RecurringExpense;
import com.spendwise.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RecurringExpenseDAO {
    
    public List<RecurringExpense> getActiveExpenses(int userId) {
        List<RecurringExpense> list = new ArrayList<>();
        String query = "SELECT * FROM recurring_expenses WHERE user_id = ? AND is_active = TRUE";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while(rs.next()) {
                    RecurringExpense re = new RecurringExpense();
                    re.setId(rs.getInt("id"));
                    re.setUserId(rs.getInt("user_id"));
                    re.setName(rs.getString("name"));
                    re.setAmount(rs.getDouble("amount"));
                    re.setFrequency(rs.getString("frequency"));
                    re.setStartDate(rs.getDate("start_date"));
                    re.setNextDueDate(rs.getDate("next_due_date"));
                    re.setCategoryId(rs.getInt("category_id"));
                    re.setActive(rs.getBoolean("is_active"));
                    list.add(re);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
