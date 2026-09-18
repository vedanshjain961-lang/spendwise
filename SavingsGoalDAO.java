package com.spendwise.dao;

import com.spendwise.model.SavingsGoal;
import com.spendwise.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SavingsGoalDAO {

    public boolean addGoal(SavingsGoal goal) {
        String query = "INSERT INTO savings_goals (user_id, name, target_amount, current_amount, deadline, description) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, goal.getUserId());
            stmt.setString(2, goal.getName());
            stmt.setDouble(3, goal.getTargetAmount());
            stmt.setDouble(4, goal.getCurrentAmount());
            stmt.setDate(5, goal.getDeadline());
            stmt.setString(6, goal.getDescription());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<SavingsGoal> getGoalsForUser(int userId) {
        List<SavingsGoal> list = new ArrayList<>();
        String query = "SELECT * FROM savings_goals WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SavingsGoal g = new SavingsGoal();
                    g.setId(rs.getInt("id"));
                    g.setUserId(rs.getInt("user_id"));
                    g.setName(rs.getString("name"));
                    g.setTargetAmount(rs.getDouble("target_amount"));
                    g.setCurrentAmount(rs.getDouble("current_amount"));
                    g.setDeadline(rs.getDate("deadline"));
                    g.setDescription(rs.getString("description"));
                    g.setStatus(rs.getString("status"));
                    g.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    list.add(g);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public boolean addFunds(int goalId, int userId, double amount) {
        String query = "UPDATE savings_goals SET current_amount = current_amount + ? WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setDouble(1, amount);
            stmt.setInt(2, goalId);
            stmt.setInt(3, userId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
