import 'package:maglis_app/view/admin/autoBL.dart';
import 'package:maglis_app/view/admin/autoCashFlow.dart';
import 'package:maglis_app/view/admin/blHome.dart';
import 'package:maglis_app/view/admin/customerServicesHome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maglis_app/view/admin/addExpense.dart';
import 'package:maglis_app/view/admin/addLoan.dart';
import 'package:maglis_app/view/admin/addOrder.dart';
import 'package:maglis_app/view/admin/addRepresentatives.dart';
import 'package:maglis_app/view/admin/addRevenue.dart';
import 'package:maglis_app/view/admin/addRoute.dart';
import 'package:maglis_app/view/admin/addSalary.dart';
import 'package:maglis_app/view/admin/adminPage.dart';
import 'package:maglis_app/view/admin/allScreens.dart';
import 'package:maglis_app/view/admin/approved-one.dart';
import 'package:maglis_app/view/admin/approvedData.dart';
import 'package:maglis_app/view/admin/approvedDetails.dart';
import 'package:maglis_app/view/admin/approvedRevenue.dart';
import 'package:maglis_app/view/admin/approvedTwo.dart';
import 'package:maglis_app/view/admin/beforeLogin.dart';
import 'package:maglis_app/view/admin/blCalculation.dart';
import 'package:maglis_app/view/admin/cashFlowHome.dart';
import 'package:maglis_app/view/admin/citiesOrders.dart';
import 'package:maglis_app/view/admin/citiyOrderDetails.dart';
import 'package:maglis_app/view/admin/collectedRouteDetails.dart';
import 'package:maglis_app/view/admin/corporateHome.dart';
import 'package:maglis_app/view/admin/corporateOrderDetails.dart';
import 'package:maglis_app/view/admin/corporateOrders.dart';
import 'package:maglis_app/view/admin/distribute.dart';
import 'package:maglis_app/view/admin/cashFlow.dart';
import 'package:maglis_app/view/admin/editRoute.dart';
import 'package:maglis_app/view/admin/employeeLoans.dart';
import 'package:maglis_app/view/admin/employeeSalaryScreen.dart';
import 'package:maglis_app/view/admin/expensesDetails.dart';
import 'package:maglis_app/view/admin/collectedRoute.dart';
import 'package:maglis_app/view/admin/dateDetails.dart';
import 'package:maglis_app/view/admin/dateScreen.dart';
import 'package:maglis_app/view/admin/distributionCities.dart';
import 'package:maglis_app/view/admin/distributionHome.dart';
import 'package:maglis_app/view/admin/distributionType.dart';
import 'package:maglis_app/view/admin/editOrder.dart';
import 'package:maglis_app/view/admin/expenses.dart';
import 'package:maglis_app/view/admin/expensesNotApprobedDetails.dart';
import 'package:maglis_app/view/admin/filterScreen.dart';
import 'package:maglis_app/view/admin/finance.dart';
import 'package:maglis_app/view/admin/financeAndShipments.dart';
import 'package:maglis_app/view/admin/financeFilter.dart';
import 'package:maglis_app/view/admin/home.dart';
import 'package:maglis_app/view/admin/issueHome.dart';
import 'package:maglis_app/view/admin/issueScreen.dart';
import 'package:maglis_app/view/admin/loans.dart';
import 'package:maglis_app/view/admin/login.dart';
import 'package:maglis_app/view/admin/monthSalary.dart';
import 'package:maglis_app/view/admin/newRoutes.dart';
import 'package:maglis_app/view/admin/notApproved-one.dart';
import 'package:maglis_app/view/admin/notApprovedDate.dart';
import 'package:maglis_app/view/admin/notApprovedDetails.dart';
import 'package:maglis_app/view/admin/notApprovedTwo.dart';
import 'package:maglis_app/view/admin/oldCashFlow.dart';
import 'package:maglis_app/view/admin/oldCashFlowHome.dart';
import 'package:maglis_app/view/admin/onDistributionItemDetails.dart';
import 'package:maglis_app/view/admin/onDistributionRoute.dart';
import 'package:maglis_app/view/admin/onDistributionType.dart';
import 'package:maglis_app/view/operation/operationFinance.dart';
import 'package:maglis_app/view/operation/operationHome.dart';
import 'package:maglis_app/view/admin/orders.dart';
import 'package:maglis_app/view/admin/representativePage.dart';
import 'package:maglis_app/view/admin/representatives.dart';
import 'package:maglis_app/view/admin/revenue.dart';
import 'package:maglis_app/view/admin/revenueNotApprovedDetails.dart';
import 'package:maglis_app/view/admin/salaries.dart';

import 'package:maglis_app/view/admin/OrderDetails.dart';
import 'package:maglis_app/view/admin/shipment.dart';
import 'package:maglis_app/view/admin/shippedRouteScreen.dart';
import 'package:maglis_app/view/admin/splashscreen.dart';
import 'package:maglis_app/view/admin/RouteItemDetails.dart';
import 'package:maglis_app/view/admin/orderHome.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:maglis_app/view/sales/salesHome.dart';
import 'package:maglis_app/view/warehouse/totalProduction.dart';
import 'package:maglis_app/view/warehouse/totalProductionHome.dart';
import 'package:maglis_app/view/warehouse/warehouseHome.dart';
import 'package:maglis_app/view/warehouse/warehouseOnDistribution.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: Get.key,
        theme: ThemeData(
          primaryIconTheme: IconThemeData(color: Colors.black),
        ),
        home: LoginPage(),
        routes: {
          "/autoCashFlow": (ctx) => AutoCashFlow(),
          "/splashscreen": (ctx) => SplashScreen(),
          "/allScreens": (ctx) => AllScreens(),
          "/addOrder": (ctx) => AddOrder(),
          "/addRoute": (ctx) => AddRoute(),
          "/addRevenue": (ctx) => AddRevenue(),
          "/approvedRevenue": (ctx) => ApprovedRevenue(),
          "/autoBL": (ctx) => AutoBlCalc(),
          "/blCalc": (ctx) => BlCalc(),
          "/blHome": (ctx) => BLCalculationHome(),
          "/corporateHome": (ctx) => CorporateHome(),
          "/corporateOrders": (ctx) => CorporateOrders(),
          "/corporateOrderDetails": (ctx) => CorporateOrderDetails(),
          "/newRoute": (ctx) => NewRoutes(),
          "/onDistributionRoutes": (ctx) => OnDistributionRoutes(),
          "/onDistributionItem": (ctx) => OnDistributionDetails(),
          "/beforeLogin": (ctx) => BeforeLogin(),
          "/home": (ctx) => HomePage(),
          "/login": (ctx) => LoginPage(),
          "/orders": (ctx) => OrdersPage(),
          "/orderScreen": (ctx) => OrderHomeScreen(),
          "/orderDetails": (ctx) => OrderDetails(),
          "/citiesOrders": (ctx) => CitiesOrders(),
          "/citiyOrderDetails": (ctx) => CitiyOrderDetails(),
          "/distribution": (ctx) => Distribution(),
          "/distributionHome": (ctx) => DistributionHome(),
          "/distributionCities": (ctx) => DistributionCities(),
          "/distributionType": (ctx) => DistributionType(),
          "/financeFilter": (ctx) => FinanceFilter(),
          "/onDistributionType": (ctx) => OnDistributionType(),
          "/editOrder": (ctx) => EditOrder(),
          "/reprePage": (ctx) => ReprePage(),
          "/representatives": (ctx) => RepresentativesPage(),
          "/addRepresentatives": (ctx) => AddRepresentatives(),
          "/financeAndShipments": (ctx) => FinanceAndShipments(),
          "/shipments": (ctx) => Shipments(),
          "/filter": (ctx) => FilterScreen(),
          "/shippedRoute": (ctx) => ShippedRouteScreen(),
          "/admin": (ctx) => AdminPage(),
          "/finance": (ctx) => Finance(),
          "/revenue": (ctx) => Revenue(),
          "/expense": (ctx) => Expense(),
          "/expensesNotApprovedDetails": (ctx) => ExpensesNotApprovedDetails(),
          "/revenueNotApprovedDetails": (ctx) => RevenueNotApprovedDetails(),
          "/cashFlow": (ctx) => CashFlow(),
          "/cashFlowHome": (ctx) => CashFlowHome(),
          "/oldCashFlow": (ctx) => OldCashFlow(),
          "/issueHome": (ctx) => IssueHome(),
          "/issueScreen": (ctx) => IssueScreen(),
          "/oldCashFlowHome": (ctx) => OldCashFlowHome(),
          "/expensesDetails": (ctx) => ExpensesDetails(),
          "/collectedRoutes": (ctx) => CollectedRoutes(),
          "/collectedItemDetails": (ctx) => CollectedDetails(),
          "/dateScreen": (ctx) => DateScreen(),
          "/dateDetails": (ctx) => DateDetails(),
          "/routeItemDetails": (ctx) => RouteItemDetails(),
          "/approved-one": (ctx) => ApprovedOne(),
          "/approvedDate": (ctx) => ApprovedDate(),
          "/notapproved-one": (ctx) => NotApprovedOne(),
          "/notApprovedDate": (ctx) => NotApprovedDate(),
          "/approvedDetails": (ctx) => ApprovedDetails(),
          "/notApprovedDetails": (ctx) => NotApprovedDetails(),
          "/addExpense": (ctx) => AddExpense(),
          "/approvedTwo": (ctx) => ApprovedTwo(),
          "/notapprovedTwo": (ctx) => NotApprovedTwo(),
          "/loans": (ctx) => Loans(),
          "/employeeLoan": (ctx) => EmployeeLoans(),
          "/employeeSalary": (ctx) => EmployeeSalaries(),
          "/addLoans": (ctx) => AddLoans(),
          "/salaries": (ctx) => SalaryScreen(),
          "/monthSalary": (ctx) => MonthSalary(),
          "/addSalary": (ctx) => AddSalaries(),
          "/editRoute": (ctx) => EditRoute(),
          //OperationApp
          "/operation": (ctx) => OperationHome(),
          "/operationFinance": (ctx) => OprationFinance(),
          //sales
          "/sales": (ctx) => SalesHome(),
          //warehouse
          "/warehouse": (ctx) => WarehouseHome(),
          "/warehouseOnDistribution": (ctx) => WareOnDistribution(),
          "/totalProduction": (ctx) => TotalPro(),
          "/totalProductionHome": (ctx) => TotalProductionHome(),
        },

        //initialRoute: '/distributionCities',
      ),
    );
  }
}
