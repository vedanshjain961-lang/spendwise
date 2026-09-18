<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transactions - SpendWise</title>
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
                            <a class="nav-link active" href="transactions"><i class="bi bi-list-columns-reverse me-2"></i> Transactions</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="budgets"><i class="bi bi-pie-chart-fill me-2"></i> Budgets</a>
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
                    <h1 class="h3 fw-bold">Transaction History</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <div class="btn-group me-2 gap-2">
                            <button type="button" class="btn btn-sm btn-primary rounded-pill shadow-sm px-3" data-bs-toggle="modal" data-bs-target="#transactionModal" onclick="setTxnType('EXPENSE')">
                                <i class="bi bi-dash-circle me-1"></i> Add Expense
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-success rounded-pill px-3" data-bs-toggle="modal" data-bs-target="#transactionModal" onclick="setTxnType('INCOME')">
                                <i class="bi bi-plus-circle me-1"></i> Add Income
                            </button>
                        </div>
                    </div>
                </div>

                <div class="card border-0 shadow-sm rounded-4">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th scope="col" class="ps-4">Date</th>
                                        <th scope="col">Description</th>
                                        <th scope="col">Category</th>
                                        <th scope="col">Payment</th>
                                        <th scope="col" class="text-end pe-4">Amount</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${empty transactions}">
                                        <tr>
                                            <td colspan="5" class="text-center py-5 text-muted">
                                                <i class="bi bi-folder-x fs-1 d-block mb-3"></i>
                                                No transactions recorded yet.
                                            </td>
                                        </tr>
                                    </c:if>
                                    <c:forEach var="txn" items="${transactions}">
                                        <tr>
                                            <td class="ps-4 text-muted"><fmt:formatDate value="${txn.transactionDate}" pattern="MMM dd, yyyy"/></td>
                                            <td><span class="fw-medium">${txn.description}</span></td>
                                            <td>
                                                <span class="badge rounded-pill bg-light text-dark border">
                                                    <i class="bi ${txn.categoryIcon} me-1" style="color: ${txn.categoryColor};"></i> ${txn.categoryName}
                                                </span>
                                            </td>
                                            <td><small class="text-muted">${txn.paymentMethod}</small></td>
                                            <td class="text-end pe-4">
                                                <c:choose>
                                                    <c:when test="${txn.type == 'EXPENSE'}">
                                                        <span class="text-danger fw-bold">-<fmt:formatNumber value="${txn.amount}" type="currency" currencySymbol="₹"/></span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-success fw-bold">+<fmt:formatNumber value="${txn.amount}" type="currency" currencySymbol="₹"/></span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Add Transaction Modal -->
    <div class="modal fade" id="transactionModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content rounded-4 border-0 shadow">
                <div class="modal-header border-bottom-0">
                    <h5 class="modal-title fw-bold" id="modalTitle">Add Transaction</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="transactions" method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="type" id="txnType" value="EXPENSE">
                        <input type="hidden" name="origin" value="transactions">
                        
                        <div class="mb-3">
                            <label class="form-label fw-medium small">Amount (₹)</label>
                            <input type="number" step="0.01" min="0.01" class="form-control form-control-lg bg-light" name="amount" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-medium small">Description</label>
                            <input type="text" class="form-control bg-light" name="description" placeholder="e.g. Canteen Lunch" required>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-6">
                                <label class="form-label fw-medium small">Date</label>
                                <input type="date" class="form-control bg-light" name="transactionDate" id="txnDate" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label fw-medium small">Payment Method</label>
                                <select class="form-select bg-light" name="paymentMethod">
                                    <option value="UPI">UPI</option>
                                    <option value="CASH">Cash</option>
                                    <option value="DEBIT_CARD">Debit Card</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-medium small">Category</label>
                            <select class="form-select bg-light" name="categoryId" id="categorySelect" required>
                                <!-- Populated dynamically based on type -->
                                <optgroup label="Expenses" id="expenseOptions">
                                    <c:forEach var="cat" items="${expenseCategories}">
                                        <option value="${cat.id}">${cat.name}</option>
                                    </c:forEach>
                                </optgroup>
                                <optgroup label="Incomes" id="incomeOptions" style="display: none;">
                                    <c:forEach var="cat" items="${incomeCategories}">
                                        <option value="${cat.id}">${cat.name}</option>
                                    </c:forEach>
                                </optgroup>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer border-top-0 pt-0">
                        <button type="submit" class="btn btn-primary w-100 rounded-pill fw-medium">Save Transaction</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('txnDate').valueAsDate = new Date();

        function setTxnType(type) {
            document.getElementById('txnType').value = type;
            document.getElementById('modalTitle').innerText = 'Add ' + (type === 'EXPENSE' ? 'Expense' : 'Income');
            
            const expGrp = document.getElementById('expenseOptions');
            const incGrp = document.getElementById('incomeOptions');
            const select = document.getElementById('categorySelect');

            if(type === 'EXPENSE') {
                expGrp.style.display = 'block';
                incGrp.style.display = 'none';
                if(expGrp.firstElementChild) select.value = expGrp.firstElementChild.value;
            } else {
                expGrp.style.display = 'none';
                incGrp.style.display = 'block';
                if(incGrp.firstElementChild) select.value = incGrp.firstElementChild.value;
            }
        }
    </script>
</body>
</html>
