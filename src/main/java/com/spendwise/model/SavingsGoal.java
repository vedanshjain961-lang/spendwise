package com.spendwise.model;

import java.sql.Date;
import java.sql.Timestamp;

public class SavingsGoal {
    private int id;
    private int userId;
    private String name;
    private double targetAmount;
    private double currentAmount;
    private Date deadline;
    private String description;
    private String status; // 'IN_PROGRESS', 'ACHIEVED', 'CANCELLED'
    private Timestamp createdAt;

    public SavingsGoal() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public double getTargetAmount() { return targetAmount; }
    public void setTargetAmount(double targetAmount) { this.targetAmount = targetAmount; }

    public double getCurrentAmount() { return currentAmount; }
    public void setCurrentAmount(double currentAmount) { this.currentAmount = currentAmount; }

    public Date getDeadline() { return deadline; }
    public void setDeadline(Date deadline) { this.deadline = deadline; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public double getPercentage() {
        if (targetAmount == 0) return 0;
        double pct = (currentAmount / targetAmount) * 100;
        return pct > 100 ? 100 : pct;
    }
}
