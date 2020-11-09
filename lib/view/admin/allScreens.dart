import 'package:flutter/material.dart';


class AllScreens extends StatefulWidget {
  @override
  _AllScreensState createState() => _AllScreensState();
}

class _AllScreensState extends State<AllScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),

      body: Container(child: ListView(
        children: [
          RaisedButton(onPressed: (){Navigator.pushNamed(context, '/admin');},child: Text("Admin"),),
          RaisedButton(onPressed: (){Navigator.pushNamed(context, '/finance');},child: Text("Finance"),),
          RaisedButton(onPressed: (){Navigator.pushNamed(context, '/revenue');},child: Text("revenue"),),
          RaisedButton(onPressed: (){Navigator.pushNamed(context, '/expense');},child: Text("expense"),),
          RaisedButton(onPressed: (){Navigator.pushNamed(context, '/cashFlow');},child: Text("cashFlow"),),
          RaisedButton(onPressed: (){Navigator.pushNamed(context, '/collectedRoutes');},child: Text("CollectedRoutes"),),
          RaisedButton(onPressed: (){Navigator.pushNamed(context, '/dateScreen');},child: Text("dateScreen"),),
          RaisedButton(onPressed: (){Navigator.pushNamed(context, '/dateDetails');},child: Text("dateDetails"),),
          RaisedButton(onPressed: (){Navigator.pushNamed(context, '/customerItemDetails');},child: Text("customerItemDetails"),),
          RaisedButton(onPressed: (){Navigator.pushNamed(context, '/customerRepresentative');},child: Text("customerRepresentative"),),
          RaisedButton(onPressed: (){Navigator.pushNamed(context, '/distributionCities');},child: Text("distributionCities"),),
          RaisedButton(onPressed: (){Navigator.pushNamed(context, '/cairoDistribution');},child: Text("cairoDistribution"),),
          RaisedButton(onPressed: (){Navigator.pushNamed(context, '/approved-one');},child: Text("Approved One"),),
          RaisedButton(onPressed: (){Navigator.pushNamed(context, '/notapproved-one');},child: Text("Not Approved One"),),
          RaisedButton(onPressed: (){Navigator.pushNamed(context, '/approvedTwo');},child: Text("Approved Two"),),
          RaisedButton(onPressed: (){Navigator.pushNamed(context, '/notapprovedTwo');},child: Text("Not Approved Two"),),
          RaisedButton(onPressed: (){Navigator.pushNamed(context, '/approvedDetails');},child: Text("Approved Details"),),
          RaisedButton(onPressed: (){Navigator.pushNamed(context, '/expensesNotApprovedDetails');},child: Text("Not Approved Details"),),
          RaisedButton(onPressed: (){Navigator.pushNamed(context, '/expensesNotApproved');},child: Text("Expenses Not Approved Details"),),
          RaisedButton(onPressed: (){Navigator.pushNamed(context, '/addExpense');},child: Text("Add Expense"),),
        ],
      ),),
    );
  }
}