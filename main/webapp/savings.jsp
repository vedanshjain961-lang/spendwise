<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savings Goals - SpendWise</title>
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
                        <li class="nav-item"><a class="nav-link" href="dashboard"><i class="bi bi-grid-1x2-fill me-2"></i> Dashboard</a></li>
                        <li class="nav-item"><a class="nav-link" href="transactions"><i class="bi bi-list-columns-reverse me-2"></i> Transactions</a></li>
                        <li class="nav-item"><a class="nav-link" href="budgets"><i class="bi bi-pie-chart-fill me-2"></i> Budgets</a></li>
                        <li class="nav-item"><a class="nav-link active" href="savings"><i class="bi bi-piggy-bank-fill me-2"></i> Savings Goals</a></li>
                        <li class="nav-item"><a class="nav-link" href="analytics"><i class="bi bi-bar-chart-fill me-2"></i> Analytics</a></li>
                    </ul>
                </div>
            </nav>

            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-4 border-bottom">
                    <h1 class="h3 fw-bold">Savings Goals</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <button type="button" class="btn btn-sm btn-success rounded-pill shadow-sm px-3" data-bs-toggle="modal" data-bs-target="#goalModal">
                            <i class="bi bi-plus-circle me-1"></i> New Goal
                        </button>
                    </div>
                </div>

                <div class="row">
                    <c:if test="${empty goals}">
                        <div class="col-12 text-center py-5">
                            <i class="bi bi-flag text-muted fs-1 mb-3"></i>
                            <h5 class="text-muted">No savings goals yet.</h5>
                            <p class="text-muted">Start tracking your savings for that new laptop, trip, or emergency fund.</p>
                        </div>
                    </c:if>

                    <c:forEach var="g" items="${goals}">
                        <div class="col-md-6 col-xl-4 mb-4">
                            <div class="card border-0 shadow-sm rounded-4 h-100 p-3">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div>
                                            <h5 class="fw-bold mb-1">${g.name}</h5>
                                            <c:if test="${not empty g.deadline}">
                                                <small class="text-muted"><i class="bi bi-calendar-event me-1"></i> Target: <fmt:formatDate value="${g.deadline}" pattern="MMM dd, yyyy"/></small>
                                            </c:if>
                                        </div>
                                        <button class="btn btn-sm btn-light rounded-circle" data-bs-toggle="modal" data-bs-target="#addFundModal" onclick="document.getElementById('addFundGoalId').value = '${g.id}';">
                                            <i class="bi bi-plus text-success fs-5"></i>
                                        </button>
                                    </div>
                                    
                                    <p class="text-muted small mb-4">${g.description}</p>
                                    
                                    <div class="d-flex justify-content-between mb-1">
                                        <span class="text-dark fw-bold"><fmt:formatNumber value="${g.currentAmount}" type="currency" currencySymbol="₹"/></span>
                                        <span class="text-muted small fw-medium">of <fmt:formatNumber value="${g.targetAmount}" type="currency" currencySymbol="₹"/></span>
                                    </div>
                                    
                                    <c:set var="pct" value="${g.percentage}" />
                                    <div class="progress progress-slim bg-light mb-3">
                                        <div class="progress-bar bg-success" role="progressbar" style="width: ${pct}%" aria-valuenow="${pct}" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                    
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="badge bg-success-subtle text-success border border-success-subtle rounded-pill">
                                            <fmt:formatNumber value="${pct}" maxFractionDigits="0"/>% complete
                                        </span>
                                        <small class="text-muted fw-medium"><fmt:formatNumber value="${g.targetAmount - g.currentAmount}" type="currency" currencySymbol="₹"/> remaining</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </main>
        </div>
    </div>

    <!-- Create Goal Modal -->
    <div class="modal fade" id="goalModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header border-bottom-0">
                    <h5 class="modal-title fw-bold">Create Savings Goal</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="savings" method="POST">
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-medium small">Goal Name</label>
                            <input type="text" class="form-control bg-light" name="name" required placeholder="e.g. MacBook Air">
                        </div>
                        <div class="row mb-3">
                            <div class="col-6">
                                <label class="form-label fw-medium small">Target Amount (₹)</label>
                                <input type="number" class="form-control bg-light" name="targetAmount" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label fw-medium small">Starting Balance (₹)</label>
                                <input type="number" class="form-control bg-light" name="currentAmount" value="0">
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-medium small">Target Date (Optional)</label>
                            <input type="date" class="form-control bg-light" name="deadline">
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-medium small">Description</label>
                            <textarea class="form-control bg-light" name="description" rows="2"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-top-0 pt-0">
                        <button type="submit" class="btn btn-success w-100 rounded-pill fw-medium">Create Goal</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Add Funds Modal -->
    <div class="modal fade" id="addFundModal" tabindex="-1">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header border-bottom-0">
                    <h6 class="modal-title fw-bold">Add to Savings</h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="savings" method="POST">
                    <div class="modal-body py-2">
                        <input type="hidden" name="action" value="addFund">
                        <input type="hidden" name="goalId" id="addFundGoalId">
                        <div class="mb-3">
                            <label class="form-label fw-medium small">Amount (₹)</label>
                            <input type="number" class="form-control form-control-lg bg-light" name="amount" required min="1">
                        </div>
                    </div>
                    <div class="modal-footer border-top-0">
                        <button type="submit" class="btn btn-success w-100 rounded-pill fw-medium">Add Funds</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
