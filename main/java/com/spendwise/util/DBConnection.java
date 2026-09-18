package com.spendwise.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Utility class to manage database connections.
 * Uses an embedded H2 database for portability in this college project.
 */
public class DBConnection {

    // Database configuration
    private static final String URL = "jdbc:h2:~/spendwise_db;AUTO_SERVER=TRUE;MODE=MySQL";
    private static final String USER = "sa";
    private static final String PASSWORD = ""; 

    // Static block to load the H2 JDBC Driver and initialize schema
    static {
        try {
            Class.forName("org.h2.Driver");
            initializeDatabase();
        } catch (ClassNotFoundException e) {
            System.err.println("Failed to load H2 JDBC Driver!");
            e.printStackTrace();
        }
    }

    private static void initializeDatabase() {
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            
            // Basic check if tables exist
            try {
                stmt.executeQuery("SELECT 1 FROM users");
                // If this succeeds, DB is already initialized
                return;
            } catch (SQLException e) {
                // Table does not exist, proceed with initialization
            }

            // Create tables manually since H2 embedded doesn't easily read external schema.sql in this environment without specific paths
            String schema = "CREATE TABLE IF NOT EXISTS users (" +
                            "id INT AUTO_INCREMENT PRIMARY KEY," +
                            "name VARCHAR(100) NOT NULL," +
                            "email VARCHAR(100) NOT NULL UNIQUE," +
                            "password_hash VARCHAR(255) NOT NULL," +
                            "monthly_allowance DECIMAL(10,2) DEFAULT 0.00," +
                            "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                            ");" +
                            "CREATE TABLE IF NOT EXISTS categories (" +
                            "id INT AUTO_INCREMENT PRIMARY KEY," +
                            "name VARCHAR(50) NOT NULL," +
                            "type ENUM('INCOME', 'EXPENSE') NOT NULL," +
                            "icon VARCHAR(50)," +
                            "color VARCHAR(20)" +
                            ");" +
                            "CREATE TABLE IF NOT EXISTS transactions (" +
                            "id INT AUTO_INCREMENT PRIMARY KEY," +
                            "user_id INT NOT NULL," +
                            "category_id INT NOT NULL," +
                            "amount DECIMAL(10,2) NOT NULL," +
                            "type ENUM('INCOME', 'EXPENSE') NOT NULL," +
                            "transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                            "description VARCHAR(255)," +
                            "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE," +
                            "FOREIGN KEY (category_id) REFERENCES categories(id)" +
                            ");" +
                            "CREATE TABLE IF NOT EXISTS budgets (" +
                            "id INT AUTO_INCREMENT PRIMARY KEY," +
                            "user_id INT NOT NULL," +
                            "category_id INT NOT NULL," +
                            "amount DECIMAL(10,2) NOT NULL," +
                            "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                            "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE," +
                            "FOREIGN KEY (category_id) REFERENCES categories(id)" +
                            ");" +
                            "CREATE TABLE IF NOT EXISTS savings_goals (" +
                            "id INT AUTO_INCREMENT PRIMARY KEY," +
                            "user_id INT NOT NULL," +
                            "name VARCHAR(100) NOT NULL," +
                            "target_amount DECIMAL(10,2) NOT NULL," +
                            "current_amount DECIMAL(10,2) DEFAULT 0.00," +
                            "deadline DATE," +
                            "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                            "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE" +
                            ");" +
                            "CREATE TABLE IF NOT EXISTS recurring_expenses (" +
                            "id INT AUTO_INCREMENT PRIMARY KEY," +
                            "user_id INT NOT NULL," +
                            "category_id INT NOT NULL," +
                            "name VARCHAR(100) NOT NULL," +
                            "amount DECIMAL(10,2) NOT NULL," +
                            "frequency VARCHAR(20) DEFAULT 'MONTHLY'," +
                            "start_date DATE," +
                            "next_due_date DATE," +
                            "is_active BOOLEAN DEFAULT TRUE," +
                            "FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE," +
                            "FOREIGN KEY (category_id) REFERENCES categories(id)" +
                            ");";
                            
            stmt.execute(schema);
            
            // Insert default categories
            String insertCategories = "INSERT INTO categories (name, type, icon, color) VALUES " +
                "('Pocket Money', 'INCOME', 'bi-wallet', 'success')," +
                "('Freelance', 'INCOME', 'bi-laptop', 'primary')," +
                "('Scholarship', 'INCOME', 'bi-mortarboard', 'info')," +
                "('Hostel/Mess', 'EXPENSE', 'bi-house-door', 'danger')," +
                "('Food & Dining', 'EXPENSE', 'bi-cup-hot', 'warning')," +
                "('Transportation', 'EXPENSE', 'bi-bus-front', 'info')," +
                "('Academics', 'EXPENSE', 'bi-book', 'primary')," +
                "('Entertainment', 'EXPENSE', 'bi-controller', 'secondary')," +
                "('Shopping', 'EXPENSE', 'bi-bag', 'danger')," +
                "('Health', 'EXPENSE', 'bi-heart-pulse', 'danger')," +
                "('Utilities', 'EXPENSE', 'bi-lightning', 'warning')," +
                "('Subscriptions', 'EXPENSE', 'bi-play-circle', 'dark')," +
                "('Miscellaneous', 'EXPENSE', 'bi-box', 'secondary');";
                
            stmt.execute(insertCategories);
            System.out.println("Database initialized successfully with default tables and categories.");

        } catch (SQLException e) {
            System.err.println("Error initializing database: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Gets a connection to the database.
     * @return Connection object
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
