<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics - SpendWise</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/style.css">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                        <li class="nav-item"><a class="nav-link" href="savings"><i class="bi bi-piggy-bank-fill me-2"></i> Savings Goals</a></li>
                        <li class="nav-item"><a class="nav-link active" href="analytics"><i class="bi bi-bar-chart-fill me-2"></i> Analytics</a></li>
                    </ul>
                </div>
            </nav>

            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-4 border-bottom">
                    <h1 class="h3 fw-bold">Spending Analytics</h1>
                </div>

                <!-- Insights Row -->
                <div class="row g-4 mb-4">
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm rounded-4 h-100 bg-white">
                            <div class="card-body p-4 text-center">
                                <i class="bi bi-heart-pulse text-danger fs-1 mb-2"></i>
                                <h6 class="text-muted fw-semibold mb-1">Financial Health Score</h6>
                                <h2 class="fw-bold mb-0">${healthScore}/100</h2>
                                <p class="small text-muted mt-2">Based on budget adherence and daily spending rate.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm rounded-4 h-100 bg-white">
                            <div class="card-body p-4 text-center">
                                <i class="bi bi-calendar-day text-primary fs-1 mb-2"></i>
                                <h6 class="text-muted fw-semibold mb-1">Average Daily Spend</h6>
                                <h2 class="fw-bold mb-0">₹${avgDaily}</h2>
                                <p class="small text-muted mt-2">Your average daily expense this month.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card border-0 shadow-sm rounded-4 h-100 bg-white">
                            <div class="card-body p-4 text-center">
                                <i class="bi bi-trophy text-warning fs-1 mb-2"></i>
                                <h6 class="text-muted fw-semibold mb-1">Top Category</h6>
                                <h2 class="fw-bold mb-0 text-truncate">${empty topCategory ? 'N/A' : topCategory}</h2>
                                <p class="small text-muted mt-2">Where most of your money went.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Chart Row -->
                <div class="row">
                    <div class="col-12 col-xl-8">
                        <div class="card border-0 shadow-sm rounded-4 p-4">
                            <h5 class="fw-bold mb-4">Category Distribution (This Month)</h5>
                            <div style="height: 400px; display: flex; justify-content: center;">
                                <c:choose>
                                    <c:when test="${empty categoryLabels}">
                                        <div class="d-flex flex-column align-items-center justify-content-center text-muted">
                                            <i class="bi bi-pie-chart fs-1 mb-2"></i>
                                            <p>Not enough data to generate chart.</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <canvas id="categoryChart"></canvas>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        <c:if test="${not empty categoryLabels}">
            // Parse data from server securely
            const labels = [
                <c:forEach var="lbl" items="${categoryLabels}" varStatus="loop">
                    '${lbl}'${!loop.last ? ',' : ''}
                </c:forEach>
            ];
            
            const data = [
                <c:forEach var="val" items="${categoryData}" varStatus="loop">
                    ${val}${!loop.last ? ',' : ''}
                </c:forEach>
            ];

            const ctx = document.getElementById('categoryChart').getContext('2d');
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: labels,
                    datasets: [{
                        data: data,
                        backgroundColor: [
                            '#FF5733', '#335BFF', '#9033FF', '#33FF5B', '#FF33A8',
                            '#FF8F33', '#33FFF5', '#FF3333', '#6C757D', '#28A745'
                        ],
                        borderWidth: 0,
                        hoverOffset: 10
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'right',
                            labels: { font: { family: 'Inter' } }
                        }
                    }
                }
            });
        </c:if>
    </script>
</body>
</html>
