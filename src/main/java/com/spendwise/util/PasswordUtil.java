package com.spendwise.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utility class for secure password hashing using SHA-256 with a random salt.
 * This ensures no passwords are saved in plain text in the database.
 */
public class PasswordUtil {

    /**
     * Hashes a password with a generated salt.
     * Format returned: Base64(salt) + ":" + Base64(hash)
     * 
     * @param password The plain-text password
     * @return The salt and hash formatted as a string
     */
    public static String hashPassword(String password) {
        try {
            // Generate random salt
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[16];
            random.nextBytes(salt);
            
            // Hash password with salt
            byte[] hash = getHash(password, salt);
            
            // Encode both to Base64 to store as a single string
            String encodedSalt = Base64.getEncoder().encodeToString(salt);
            String encodedHash = Base64.getEncoder().encodeToString(hash);
            
            return encodedSalt + ":" + encodedHash;
            
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    /**
     * Verifies a plain-text password against a stored hashed password.
     * 
     * @param password The plain-text password to verify
     * @param storedPasswordHash The stored format (salt:hash)
     * @return true if passwords match, false otherwise
     */
    public static boolean verifyPassword(String password, String storedPasswordHash) {
        if (storedPasswordHash == null || !storedPasswordHash.contains(":")) {
            return false;
        }
        
        try {
            // Split the salt and the hash
            String[] parts = storedPasswordHash.split(":");
            byte[] salt = Base64.getDecoder().decode(parts[0]);
            String originalHash = parts[1];
            
            // Hash the input password with the same salt
            byte[] hashOfInput = getHash(password, salt);
            String encodedHashOfInput = Base64.getEncoder().encodeToString(hashOfInput);
            
            // Compare the hashes
            return originalHash.equals(encodedHashOfInput);
            
        } catch (Exception e) {
            System.err.println("Error verifying password: " + e.getMessage());
            return false;
        }
    }

    /**
     * Helper method to generate the SHA-256 hash
     */
    private static byte[] getHash(String password, byte[] salt) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(salt);
        return md.digest(password.getBytes());
    }
}
