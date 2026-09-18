package com.spendwise.model;

import java.sql.Timestamp;

public class User {
    private int id;
    private String name;
    private String email;
    private String passwordHash;
    private String college;
    private String course;
    private int semester;
    private double monthlyAllowance;
    private String currency;
    private Timestamp createdAt;

    // Default constructor
    public User() {}

    // Constructor with all fields
    public User(int id, String name, String email, String passwordHash, String college, 
                String course, int semester, double monthlyAllowance, String currency, Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.passwordHash = passwordHash;
        this.college = college;
        this.course = course;
        this.semester = semester;
        this.monthlyAllowance = monthlyAllowance;
        this.currency = currency;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getCollege() { return college; }
    public void setCollege(String college) { this.college = college; }

    public String getCourse() { return course; }
    public void setCourse(String course) { this.course = course; }

    public int getSemester() { return semester; }
    public void setSemester(int semester) { this.semester = semester; }

    public double getMonthlyAllowance() { return monthlyAllowance; }
    public void setMonthlyAllowance(double monthlyAllowance) { this.monthlyAllowance = monthlyAllowance; }

    public String getCurrency() { return currency; }
    public void setCurrency(String currency) { this.currency = currency; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
