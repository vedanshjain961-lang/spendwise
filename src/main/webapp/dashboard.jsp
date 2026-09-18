<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - SpendWise</title>
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
            
            <div class="d-flex align-items-center ms-auto">
                <div class="dropdown">
                    <a href="#" class="d-flex align-items-center text-decoration-none dropdown-toggle text-dark" id="userDropdown" data-bs-toggle="dropdown">
                        <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 35px; height: 35px; font-weight: 600;">
                            ${sessionScope.user.name.substring(0, 1).toUpperCase()}
                        </div>
                        <span class="d-none d-md-inline fw-medium">${sessionScope.user.name}</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow border-0 rounded-3 mt-2">
                        <li><a class="dropdown-item" href="profile"><i class="bi bi-person me-2"></i> Profile</a></li>
                        <li><a class="dropdown-item" href="settings"><i class="bi bi-gear me-2"></i> Settings</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="logout"><i class="bi bi-box-arrow-right me-2"></i> Logout</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            
            <!-- Sidebar -->
            <nav class="col-md-3 col-lg-2 d-md-block bg-white sidebar collapse border-end" id="sidebarMenu">
                <div class="position-sticky pt-4 px-3">
                    <ul class="nav flex-column gap-1">
                        <li class="nav-item">
                            <a class="nav-link active" href="dashboard">
                                <i class="bi bi-grid-1x2-fill me-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="transactions">
                                <i class="bi bi-list-columns-reverse me-2"></i> Transactions
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="budgets">
                                <i class="bi bi-pie-chart-fill me-2"></i> Budgets
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="savings">
                                <i class="bi bi-piggy-bank-fill me-2"></i> Savings Goals
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="analytics">
                                <i class="bi bi-bar-chart-fill me-2"></i> Analytics
                            </a>
                        </li>
                    </ul>
                    
                    <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-2 text-muted text-uppercase text-xs fw-bold">
                        <span>Quick Actions</span>
                    </h6>
                    <ul class="nav flex-column mb-2 gap-1 px-2">
                        <li class="nav-item">
                            <button class="btn btn-primary w-100 rounded-3 mb-2 shadow-sm text-start" data-bs-toggle="modal" data-bs-target="#addExpenseModal">
                                <i class="bi bi-dash-circle me-2"></i> Add Expense
                            </button>
                        </li>
                        <li class="nav-item">
                            <button class="btn btn-outline-success w-100 rounded-3 text-start" data-bs-toggle="modal" data-bs-target="#addIncomeModal">
                                <i class="bi bi-plus-circle me-2"></i> Add Income
                            </button>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-4 border-bottom">
                    <h1 class="h3 fw-bold">Good morning, ${sessionScope.user.name.split(" ")[0]} 👋</h1>
                </div>

                <!-- Financial Summary Cards -->
                <div class="row g-4 mb-4">
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="card dashboard-card border-0 rounded-4 shadow-sm bg-primary text-white h-100">
                            <div class="card-body p-4">
                                <h6 class="text-white-50 fw-semibold mb-1">Monthly Allowance</h6>
                                <h2 class="fw-bold mb-0"><fmt:formatNumber value="${sessionScope.user.monthlyAllowance}" type="currency" currencySymbol="₹"/></h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="card dashboard-card border-0 rounded-4 shadow-sm h-100">
                            <div class="card-body p-4">
                                <h6 class="text-muted fw-semibold mb-1">Remaining Budget</h6>
                                <h2 class="fw-bold text-dark mb-0"><fmt:formatNumber value="${remainingBudget}" type="currency" currencySymbol="₹"/></h2>
                                <c:choose>
                                    <c:when test="${remainingBudget < 0}">
                                        <small class="text-danger fw-medium"><i class="bi bi-exclamation-triangle"></i> Over budget</small>
                                    </c:when>
                                    <c:otherwise>
                                        <small class="text-success fw-medium"><i class="bi bi-check-circle"></i> On track</small>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="card dashboard-card border-0 rounded-4 shadow-sm h-100">
                            <div class="card-body p-4">
                                <h6 class="text-muted fw-semibold mb-1">This Month's Expense</h6>
                                <h2 class="fw-bold text-danger mb-0">-<fmt:formatNumber value="${totalExpense}" type="currency" currencySymbol="₹"/></h2>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="card dashboard-card border-0 rounded-4 shadow-sm h-100">
                            <div class="card-body p-4">
                                <h6 class="text-muted fw-semibold mb-1">This Month's Income</h6>
                                <h2 class="fw-bold text-success mb-0">+<fmt:formatNumber value="${totalIncome}" type="currency" currencySymbol="₹"/></h2>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row g-4">
                    <!-- Recent Transactions -->
                    <div class="col-12 col-xl-8">
                        <div class="card border-0 shadow-sm rounded-4 h-100">
                            <div class="card-header bg-white border-0 pt-4 pb-0 px-4 d-flex justify-content-between align-items-center">
                                <h5 class="fw-bold mb-0">Recent Transactions</h5>
                                <a href="transactions" class="btn btn-sm btn-light rounded-pill px-3">View All</a>
                            </div>
                            <div class="card-body p-4">
                                <c:if test="${empty recentTransactions}">
                                    <div class="text-center text-muted py-5">
                                        <i class="bi bi-receipt fs-1 text-light mb-3"></i>
                                        <p>No transactions found for this period.</p>
                                    </div>
                                </c:if>
                                <c:if test="${not empty recentTransactions}">
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <tbody>
                                                <c:forEach var="txn" items="${recentTransactions}">
                                                    <tr>
                                                        <td style="width: 50px;">
                                                            <div class="icon-shape rounded-circle text-white" style="background-color: ${txn.categoryColor}; width: 40px; height: 40px;">
                                                                <i class="bi ${txn.categoryIcon}"></i>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <h6 class="mb-0 fw-semibold">${txn.description}</h6>
                                                            <small class="text-muted">${txn.categoryName} • <fmt:formatDate value="${txn.transactionDate}" pattern="MMM dd, yyyy"/></small>
                                                        </td>
                                                        <td class="text-end">
                                                            <c:choose>
                                                                <c:when test="${txn.type == 'EXPENSE'}">
                                                                    <h6 class="mb-0 text-danger fw-bold">-<fmt:formatNumber value="${txn.amount}" type="currency" currencySymbol="₹"/></h6>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <h6 class="mb-0 text-success fw-bold">+<fmt:formatNumber value="${txn.amount}" type="currency" currencySymbol="₹"/></h6>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Smart Spending Limit -->
                    <div class="col-12 col-xl-4">
                        <div class="card border-0 shadow-sm rounded-4 h-100 bg-dark text-white" style="background: linear-gradient(145deg, #2b2b2b, #1a1a1a);">
                            <div class="card-body p-4 d-flex flex-column justify-content-center text-center">
                                <div class="mb-3">
                                    <i class="bi bi-lightning-charge-fill text-warning" style="font-size: 3rem;"></i>
                                </div>
                                <h5>Smart Daily Limit</h5>
                                <p class="text-white-50 small mb-4">Recommended spending limit for today to stay on track.</p>
                                
                                <h1 class="fw-bold text-warning display-5 mb-2">₹<fmt:formatNumber value="${remainingBudget / 30}" pattern="#,##0"/></h1>
                                <p class="small text-white-50">Based on a 30-day month.</p>
                                
                                <div class="mt-4">
                                    <button class="btn btn-outline-light rounded-pill w-100" data-bs-toggle="modal" data-bs-target="#affordModal">Can I afford it?</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </main>
        </div>
    </div>

    <!-- Modals for adding transactions (placeholders for now) -->
    <!-- ... will be implemented in the next steps ... -->

    <!-- Affordability Calculator Modal -->
    <div class="modal fade" id="affordModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header border-bottom-0">
                    <h5 class="modal-title fw-bold">Can I Afford It?</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pb-0">
                    <p class="text-muted small">Enter the amount of a planned purchase. We'll analyze your budget and upcoming bills to see if it's safe.</p>
                    <div class="mb-3">
                        <label class="form-label fw-medium small">Item Cost (₹)</label>
                        <input type="number" id="affordAmount" class="form-control form-control-lg bg-light" placeholder="e.g. 2500">
                    </div>
                    <div id="affordResult" class="d-none alert mt-3 rounded-3"></div>
                </div>
                <div class="modal-footer border-top-0 pt-3">
                    <button type="button" class="btn btn-primary w-100 rounded-pill fw-medium" onclick="checkAffordability()">Analyze</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function checkAffordability() {
            const amount = document.getElementById('affordAmount').value;
            if(!amount) return;

            const resDiv = document.getElementById('affordResult');
            resDiv.className = 'alert mt-3 rounded-3 bg-light text-muted';
            resDiv.innerHTML = '<div class="spinner-border spinner-border-sm" role="status"></div> Analyzing...';
            resDiv.classList.remove('d-none');

            // Setup POST request via Fetch API
            const formData = new URLSearchParams();
            formData.append('cost', amount);

            fetch('api/affordability', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                resDiv.className = 'alert mt-3 rounded-3 ' + (data.color === 'text-success' ? 'alert-success' : (data.color === 'text-warning' ? 'alert-warning' : 'alert-danger'));
                resDiv.innerHTML = '<h6 class="fw-bold ' + data.color + ' mb-2">' + data.result + '</h6><p class="small mb-0 text-dark">' + data.message + '</p>';
            })
            .catch(err => {
                resDiv.className = 'alert mt-3 rounded-3 alert-danger';
                resDiv.innerHTML = 'Error checking affordability.';
            });
        }
    </script>
</body>
</html>
