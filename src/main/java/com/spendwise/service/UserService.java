package com.spendwise.service;

import com.spendwise.dao.UserDAO;
import com.spendwise.model.User;
import com.spendwise.util.PasswordUtil;

public class UserService {
    
    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public boolean register(User user, String rawPassword) {
        // Validate
        if (userDAO.getUserByEmail(user.getEmail()) != null) {
            return false; // Email already exists
        }

        // Hash password
        String hashedPassword = PasswordUtil.hashPassword(rawPassword);
        user.setPasswordHash(hashedPassword);

        return userDAO.registerUser(user);
    }

    public User authenticate(String email, String rawPassword) {
        User user = userDAO.getUserByEmail(email);
        
        if (user != null && PasswordUtil.verifyPassword(rawPassword, user.getPasswordHash())) {
            return user;
        }
        
        return null;
    }
}
