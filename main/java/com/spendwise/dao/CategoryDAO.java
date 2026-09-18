package com.spendwise.dao;

import com.spendwise.model.Category;
import com.spendwise.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    public List<Category> getCategoriesForUser(int userId, String type) {
        List<Category> categories = new ArrayList<>();
        // Fetch default categories (user_id IS NULL) and user-specific ones
        String query = "SELECT * FROM categories WHERE (user_id IS NULL OR user_id = ?) AND type = ? ORDER BY name ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, type);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Category cat = new Category();
                    cat.setId(rs.getInt("id"));
                    cat.setName(rs.getString("name"));
                    cat.setType(rs.getString("type"));
                    cat.setIcon(rs.getString("icon"));
                    cat.setColor(rs.getString("color"));
                    
                    int uId = rs.getInt("user_id");
                    if (!rs.wasNull()) {
                        cat.setUserId(uId);
                    }
                    
                    categories.add(cat);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    public boolean addCategory(Category category) {
        String query = "INSERT INTO categories (user_id, name, type, icon, color) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, category.getUserId());
            stmt.setString(2, category.getName());
            stmt.setString(3, category.getType());
            stmt.setString(4, category.getIcon() != null ? category.getIcon() : "bi-tag");
            stmt.setString(5, category.getColor() != null ? category.getColor() : "#6c757d");
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
