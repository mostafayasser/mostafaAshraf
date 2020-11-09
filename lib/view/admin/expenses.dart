import 'package:flutter/material.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';

class Expense extends StatefulWidget {
  @override
  _RevenueState createState() => _RevenueState();
}

class _RevenueState extends State<Expense> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavigator(),
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 10,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/logo.png',
          width: 150,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
              color: Colors.white,
              child: ListTile(
                leading: Image.asset('assets/images/AllIcon.png'),
                title: Text(
                  'Expenses',
                  style: TextStyle(
                      color: Color.fromRGBO(170, 44, 94, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                trailing: InkWell(
                  onTap: () => Navigator.of(context).pushNamed('/addExpense'),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 35,
                    ),
                  ),
                ),
              )),
          Expanded(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () =>
                            Navigator.of(context).pushNamed('/notapprovedTwo'),
                        child: Container(
                          width: size.width / 2.25,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(width: 2.5, color: Colors.grey[400]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Image.asset(
                                    'assets/images/NotApproved.png'),
                                width: 100,
                                height: 100,
                              ),
                              Text(
                                'Not Approved',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(134, 134, 134, 1),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            Navigator.of(context).pushNamed('/approvedTwo'),
                        child: Container(
                            width: size.width / 2.25,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 2.5, color: Colors.grey[400]),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Image.asset(
                                    'assets/images/PersonCheck.png',
                                  ),
                                  width: 100,
                                  height: 100,
                                ),
                                Text(
                                  'Approved',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromRGBO(134, 134, 134, 1),
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
         
        ],
      ),
    );
  }
}
