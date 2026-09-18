-- SpendWise Database Schema

CREATE DATABASE IF NOT EXISTS spendwise_db;
USE spendwise_db;

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    college VARCHAR(150),
    course VARCHAR(100),
    semester INT,
    monthly_allowance DECIMAL(10, 2) DEFAULT 0.00,
    currency VARCHAR(10) DEFAULT 'INR',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories Table
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL, -- NULL means it's a default category for all users
    name VARCHAR(50) NOT NULL,
    type ENUM('EXPENSE', 'INCOME') NOT NULL,
    icon VARCHAR(50) DEFAULT 'bi-tag',
    color VARCHAR(20) DEFAULT '#6c757d',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Transactions Table
CREATE TABLE IF NOT EXISTS transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    type ENUM('EXPENSE', 'INCOME') NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    category_id INT NOT NULL,
    payment_method ENUM('CASH', 'UPI', 'DEBIT_CARD', 'CREDIT_CARD', 'NET_BANKING', 'WALLET', 'OTHER') DEFAULT 'CASH',
    description VARCHAR(255),
    merchant VARCHAR(100),
    transaction_date DATE NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Budgets Table
CREATE TABLE IF NOT EXISTS budgets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    month INT NOT NULL, -- 1 to 12
    year INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Savings Goals Table
CREATE TABLE IF NOT EXISTS savings_goals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    target_amount DECIMAL(10, 2) NOT NULL,
    current_amount DECIMAL(10, 2) DEFAULT 0.00,
    deadline DATE,
    description TEXT,
    status ENUM('IN_PROGRESS', 'ACHIEVED', 'CANCELLED') DEFAULT 'IN_PROGRESS',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Recurring Expenses Table
CREATE TABLE IF NOT EXISTS recurring_expenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    frequency ENUM('DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY') NOT NULL,
    start_date DATE NOT NULL,
    next_due_date DATE NOT NULL,
    category_id INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Achievements / Gamification Table
CREATE TABLE IF NOT EXISTS achievements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    achievement_name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    points INT DEFAULT 0,
    earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Insert Default Categories
INSERT INTO categories (name, type, icon, color) VALUES
('Food & Dining', 'EXPENSE', 'bi-cup-straw', '#FF5733'),
('Transportation', 'EXPENSE', 'bi-bus-front', '#335BFF'),
('Hostel/Rent', 'EXPENSE', 'bi-house-door', '#9033FF'),
('Education', 'EXPENSE', 'bi-book', '#33FF5B'),
('Entertainment', 'EXPENSE', 'bi-controller', '#FF33A8'),
('Shopping', 'EXPENSE', 'bi-bag', '#FF8F33'),
('Mobile/Internet', 'EXPENSE', 'bi-wifi', '#33FFF5'),
('Health', 'EXPENSE', 'bi-heart-pulse', '#FF3333'),
('Other', 'EXPENSE', 'bi-three-dots', '#6C757D'),
('Pocket Money', 'INCOME', 'bi-wallet2', '#28A745'),
('Scholarship', 'INCOME', 'bi-award', '#17A2B8'),
('Salary/Internship', 'INCOME', 'bi-briefcase', '#007BFF'),
('Family Support', 'INCOME', 'bi-people', '#E83E8C'),
('Other Income', 'INCOME', 'bi-cash-coin', '#20C997');

-- Example Demo Data User (Password is 'password123' hashed using basic SHA-256 for demo, we'll implement BCrypt/SHA in Java)
-- (We'll generate this via the app directly for proper hashing, but this is a placeholder idea)
-- INSERT INTO users (name, email, password_hash, college, course, semester, monthly_allowance) VALUES 
-- ('Aarav Sharma', 'aarav@example.com', '...hash...', 'NIT Surathkal', 'B.Tech CS', 5, 15000.00);
