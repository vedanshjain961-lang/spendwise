package com.spendwise.model;

import java.sql.Date;

public class RecurringExpense {
    private int id;
    private int userId;
    private String name;
    private double amount;
    private String frequency;
    private Date startDate;
    private Date nextDueDate;
    private int categoryId;
    private boolean isActive;

    public RecurringExpense() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getFrequency() { return frequency; }
    public void setFrequency(String frequency) { this.frequency = frequency; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getNextDueDate() { return nextDueDate; }
    public void setNextDueDate(Date nextDueDate) { this.nextDueDate = nextDueDate; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }
}
