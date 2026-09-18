package com.spendwise;

import java.util.Scanner;

/**
 * A simple console utility for SpendWise.
 * This class is specifically designed to demonstrate the use of Scanner 
 * and hasNextInt() for console-based user input validation, which is often 
 * a requirement in college Java projects.
 */
public class ConsoleRunner {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        boolean running = true;

        System.out.println("=========================================");
        System.out.println("   Welcome to SpendWise Console Utility  ");
        System.out.println("=========================================");

        while (running) {
            System.out.println("\nMenu:");
            System.out.println("1. Quick Budget Calculator");
            System.out.println("2. Exit");
            System.out.print("Please enter your choice (1 or 2): ");

            // Using hasNextInt() to strictly validate that the user entered a number
            if (scanner.hasNextInt()) {
                int choice = scanner.nextInt();
                
                switch (choice) {
                    case 1:
                        calculateBudget(scanner);
                        break;
                    case 2:
                        System.out.println("Exiting SpendWise Console. Goodbye!");
                        running = false;
                        break;
                    default:
                        System.out.println("Invalid choice. Please enter 1 or 2.");
                }
            } else {
                // If the user entered text instead of a number, hasNextInt() returns false
                System.out.println("Error: Invalid input! You must enter a valid integer number.");
                scanner.next(); // Consume and discard the invalid input to prevent an infinite loop
            }
        }
        
        scanner.close();
    }

    private static void calculateBudget(Scanner scanner) {
        System.out.print("Enter your total monthly allowance: ");
        
        // Another demonstration of hasNextInt()
        if (scanner.hasNextInt()) {
            int allowance = scanner.nextInt();
            System.out.println("Your daily spending limit for a 30-day month is: Rs. " + (allowance / 30));
        } else {
            System.out.println("Error: Please enter a whole number for your allowance.");
            scanner.next(); // Consume invalid input
        }
    }
}
