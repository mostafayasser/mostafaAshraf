import 'package:flutter/material.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';

class OprationFinance extends StatefulWidget {
  @override
  _FinanceState createState() => _FinanceState();
}

class _FinanceState extends State<OprationFinance> {
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
        body: Column(children: [
          SizedBox(
            height: 10,
          ),
          Container(
              color: Colors.white,
              child: ListTile(
                leading: Image.asset(
                  'assets/images/FinanceIcon.png',
                  width: 50,
                  height: 50,
                ),
                title: Text(
                  'Finance',
                  style: TextStyle(
                      color: Color.fromRGBO(170, 44, 94, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
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
                            Navigator.of(context).pushNamed('/revenue'),
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
                                child: Image.asset('assets/images/Revenue.png'),
                                width: 100,
                                height: 100,
                              ),
                              Text(
                                'Revenue',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Color.fromRGBO(134, 134, 134, 1),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            Navigator.of(context).pushNamed('/expense'),
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
                                    'assets/images/AllIcon.png',
                                  ),
                                  width: 100,
                                  height: 100,
                                ),
                                Text(
                                  'Expenses',
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Color.fromRGBO(134, 134, 134, 1),
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: size.width / 2.25,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(width: 2.5, color: Colors.grey[400]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () =>
                                  Navigator.of(context).pushNamed('/loans'),
                              child: Container(
                                width: 100,
                                height: 100,
                                child: Image.asset(
                                  'assets/images/Loans.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Text(
                              'Loans',
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Color.fromRGBO(134, 134, 134, 1),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
