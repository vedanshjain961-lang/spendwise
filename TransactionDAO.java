package com.spendwise.dao;

import com.spendwise.model.Transaction;
import com.spendwise.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAO {

    public boolean addTransaction(Transaction txn) {
        String query = "INSERT INTO transactions (user_id, type, amount, category_id, payment_method, description, merchant, transaction_date, notes) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, txn.getUserId());
            stmt.setString(2, txn.getType());
            stmt.setDouble(3, txn.getAmount());
            stmt.setInt(4, txn.getCategoryId());
            stmt.setString(5, txn.getPaymentMethod() != null ? txn.getPaymentMethod() : "CASH");
            stmt.setString(6, txn.getDescription());
            stmt.setString(7, txn.getMerchant());
            stmt.setDate(8, txn.getTransactionDate());
            stmt.setString(9, txn.getNotes());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Transaction> getRecentTransactions(int userId, int limit) {
        List<Transaction> list = new ArrayList<>();
        String query = "SELECT t.*, c.name as category_name, c.icon as category_icon, c.color as category_color " +
                       "FROM transactions t " +
                       "JOIN categories c ON t.category_id = c.id " +
                       "WHERE t.user_id = ? " +
                       "ORDER BY t.transaction_date DESC, t.created_at DESC " +
                       "LIMIT ?";
                       
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToTransaction(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public double getTotalSum(int userId, String type, int month, int year) {
        String query = "SELECT SUM(amount) FROM transactions WHERE user_id = ? AND type = ? AND MONTH(transaction_date) = ? AND YEAR(transaction_date) = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            stmt.setString(2, type);
            stmt.setInt(3, month);
            stmt.setInt(4, year);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    private Transaction mapRowToTransaction(ResultSet rs) throws SQLException {
        Transaction txn = new Transaction();
        txn.setId(rs.getInt("id"));
        txn.setUserId(rs.getInt("user_id"));
        txn.setType(rs.getString("type"));
        txn.setAmount(rs.getDouble("amount"));
        txn.setCategoryId(rs.getInt("category_id"));
        txn.setPaymentMethod(rs.getString("payment_method"));
        txn.setDescription(rs.getString("description"));
        txn.setMerchant(rs.getString("merchant"));
        txn.setTransactionDate(rs.getDate("transaction_date"));
        txn.setNotes(rs.getString("notes"));
        txn.setCreatedAt(rs.getTimestamp("created_at"));
        
        // Joined fields
        txn.setCategoryName(rs.getString("category_name"));
        txn.setCategoryIcon(rs.getString("category_icon"));
        txn.setCategoryColor(rs.getString("category_color"));
        
        return txn;
    }
}
