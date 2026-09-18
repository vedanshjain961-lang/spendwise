<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Budgets - SpendWise</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="bg-light">

    <!-- Top Navbar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm border-bottom sticky-top">
        <div class="container-fluid px-4">
            <a class="navbar-brand fw-bold text-primary d-flex align-items-center" href="dashboard">
                <i class="bi bi-wallet2 fs-4 me-2"></i> SpendWise
            </a>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            
            <!-- Sidebar -->
            <nav class="col-md-3 col-lg-2 d-md-block bg-white sidebar collapse border-end" id="sidebarMenu">
                <div class="position-sticky pt-4 px-3">
                    <ul class="nav flex-column gap-1">
                        <li class="nav-item">
                            <a class="nav-link" href="dashboard"><i class="bi bi-grid-1x2-fill me-2"></i> Dashboard</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="transactions"><i class="bi bi-list-columns-reverse me-2"></i> Transactions</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="budgets"><i class="bi bi-pie-chart-fill me-2"></i> Budgets</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="savings"><i class="bi bi-piggy-bank-fill me-2"></i> Savings Goals</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="analytics"><i class="bi bi-bar-chart-fill me-2"></i> Analytics</a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-4 border-bottom">
                    <h1 class="h3 fw-bold">Monthly Budgets</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <button type="button" class="btn btn-sm btn-primary rounded-pill shadow-sm px-3" data-bs-toggle="modal" data-bs-target="#budgetModal">
                            <i class="bi bi-plus-circle me-1"></i> Set Category Budget
                        </button>
                    </div>
                </div>

                <div class="row">
                    <div class="col-12 mb-4">
                        <h5 class="fw-medium text-muted">Budget for ${currentMonth}</h5>
                    </div>
                    
                    <c:if test="${empty budgets}">
                        <div class="col-12 text-center py-5">
                            <i class="bi bi-pie-chart text-muted fs-1 mb-3"></i>
                            <h5 class="text-muted">No budgets set for this month.</h5>
                            <p class="text-muted">Set budgets to track your category spending and get alerts.</p>
                            <button class="btn btn-primary rounded-pill mt-2" data-bs-toggle="modal" data-bs-target="#budgetModal">Set First Budget</button>
                        </div>
                    </c:if>

                    <c:forEach var="b" items="${budgets}">
                        <div class="col-md-6 col-xl-4 mb-4">
                            <div class="card border-0 shadow-sm rounded-4 h-100 p-3">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <div class="d-flex align-items-center">
                                            <div class="icon-shape rounded-circle text-white me-3" style="background-color: ${b.categoryColor}; width: 45px; height: 45px;">
                                                <i class="bi ${b.categoryIcon} fs-5"></i>
                                            </div>
                                            <div>
                                                <h5 class="mb-0 fw-bold">${b.categoryName}</h5>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="d-flex justify-content-between mb-1 mt-4">
                                        <span class="text-muted small fw-medium">Spent: <fmt:formatNumber value="${b.spentAmount}" type="currency" currencySymbol="₹"/></span>
                                        <span class="text-dark small fw-bold"><fmt:formatNumber value="${b.amount}" type="currency" currencySymbol="₹"/></span>
                                    </div>
                                    
                                    <c:set var="pct" value="${b.percentageUsed}" />
                                    <c:set var="bgClass" value="bg-success" />
                                    <c:choose>
                                        <c:when test="${pct > 100}">
                                            <c:set var="bgClass" value="bg-danger" />
                                            <c:set var="pct" value="100" />
                                        </c:when>
                                        <c:when test="${pct > 80}">
                                            <c:set var="bgClass" value="bg-warning" />
                                        </c:when>
                                    </c:choose>
                                    
                                    <div class="progress progress-slim bg-light">
                                        <div class="progress-bar ${bgClass}" role="progressbar" style="width: ${pct}%" aria-valuenow="${pct}" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                    
                                    <div class="mt-3">
                                        <c:choose>
                                            <c:when test="${b.percentageUsed > 100}">
                                                <div class="alert alert-danger py-2 mb-0 border-0 rounded-3 small">
                                                    <i class="bi bi-exclamation-triangle-fill me-1"></i> Over budget by <fmt:formatNumber value="${b.spentAmount - b.amount}" type="currency" currencySymbol="₹"/>
                                                </div>
                                            </c:when>
                                            <c:when test="${b.percentageUsed > 80}">
                                                <div class="alert alert-warning py-2 mb-0 border-0 rounded-3 small">
                                                    <i class="bi bi-exclamation-circle-fill me-1"></i> <fmt:formatNumber value="${b.percentageUsed}" maxFractionDigits="0"/>% used. Slow down!
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="alert alert-success py-2 mb-0 border-0 rounded-3 small">
                                                    <i class="bi bi-check-circle-fill me-1"></i> On track. <fmt:formatNumber value="${b.amount - b.spentAmount}" type="currency" currencySymbol="₹"/> left.
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </main>
        </div>
    </div>

    <!-- Set Budget Modal -->
    <div class="modal fade" id="budgetModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header border-bottom-0">
                    <h5 class="modal-title fw-bold">Set Category Budget</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="budgets" method="POST">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-medium small">Category</label>
                            <select class="form-select bg-light" name="categoryId" required>
                                <c:forEach var="cat" items="${expenseCategories}">
                                    <option value="${cat.id}">${cat.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-medium small">Monthly Limit (₹)</label>
                            <input type="number" step="10" min="1" class="form-control form-control-lg bg-light" name="amount" required placeholder="e.g. 3000">
                        </div>
                    </div>
                    <div class="modal-footer border-top-0 pt-0">
                        <button type="submit" class="btn btn-primary w-100 rounded-pill fw-medium">Save Budget</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
