package com.spendwise.dao;

import com.spendwise.model.User;
import com.spendwise.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    public boolean registerUser(User user) {
        String query = "INSERT INTO users (name, email, password_hash, college, course, semester, monthly_allowance) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPasswordHash());
            stmt.setString(4, user.getCollege());
            stmt.setString(5, user.getCourse());
            stmt.setInt(6, user.getSemester());
            stmt.setDouble(7, user.getMonthlyAllowance());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public User getUserByEmail(String email) {
        String query = "SELECT * FROM users WHERE email = ?";
        User user = null;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setPasswordHash(rs.getString("password_hash"));
                    user.setCollege(rs.getString("college"));
                    user.setCourse(rs.getString("course"));
                    user.setSemester(rs.getInt("semester"));
                    user.setMonthlyAllowance(rs.getDouble("monthly_allowance"));
                    user.setCurrency(rs.getString("currency"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return user;
    }

    public boolean updateProfile(User user) {
        String query = "UPDATE users SET name=?, college=?, course=?, semester=?, monthly_allowance=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getCollege());
            stmt.setString(3, user.getCourse());
            stmt.setInt(4, user.getSemester());
            stmt.setDouble(5, user.getMonthlyAllowance());
            stmt.setInt(6, user.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
