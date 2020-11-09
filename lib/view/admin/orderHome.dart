import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';
import 'package:provider/provider.dart';

class OrderHomeScreen extends StatefulWidget {
  @override
  _RevenueState createState() => _RevenueState();
}

class _RevenueState extends State<OrderHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<UserProvider>(context, listen: false).user;
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
                leading: Image.asset('assets/images/SalesIcon.png'),
                title: Text(
                  'Orders',
                  style: TextStyle(
                      color: Color.fromRGBO(170, 44, 94, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                trailing: user.type == 'admin' ||
                        user.type == 'sales' ||
                        user.type == 'operation'
                    ? InkWell(
                        onTap: () =>
                            Navigator.of(context).pushNamed('/addOrder'),
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
                      )
                    : SizedBox(),
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
                        onTap: () => Navigator.of(context)
                            .pushNamed('/orders', arguments: {
                          'logo': 'assets/images/AllIcon.png',
                          'type': 0,
                          'title': 'All',
                        }),
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
                                child: Image.asset('assets/images/AllIcon.png'),
                                width: 100,
                                height: 100,
                              ),
                              Text(
                                'All',
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
                        onTap: () => Navigator.of(context)
                            .pushNamed('/orders', arguments: {
                          'logo': 'assets/images/CancelIcon.png',
                          'type': 0,
                          'title': 'No Action',
                          'status': 'noAction',
                        }), //status
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
                                child:
                                    Image.asset('assets/images/CancelIcon.png'),
                                width: 100,
                                height: 100,
                              ),
                              Text(
                                'No Action',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(134, 134, 134, 1),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () => Navigator.of(context)
                            .pushNamed('/orders', arguments: {
                          'logo': 'assets/images/CancelIcon.png',
                          'type': 0,
                          'title': 'Cancel',
                          'status': 'canceled',
                        }),
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
                                child:
                                    Image.asset('assets/images/CancelIcon.png'),
                                width: 100,
                                height: 100,
                              ),
                              Text(
                                'Cancel',
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
                        onTap: () => Navigator.of(context)
                            .pushNamed('/orders', arguments: {
                          'logo': 'assets/images/PersonCheck.png',
                          'type': 0,
                          'title': 'Collected',
                          'status': 'collected',
                        }),
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
                                    'assets/images/PersonCheck.png'),
                                width: 100,
                                height: 100,
                              ),
                              Text(
                                'Collected',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(134, 134, 134, 1),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () => Navigator.of(context)
                            .pushNamed('/orders', arguments: {
                          'logo': 'assets/images/NotApproved.png',
                          'type': 7,
                          'title': 'On Distribution',
                          'status': ['onDistribution', 'onShipping'],
                        }),
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
                                'On Distribution',
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
                        onTap: () => Navigator.of(context)
                            .pushNamed('/orders', arguments: {
                          'logo': 'assets/images/PersonCheck.png',
                          'type': 0,
                          'title': 'Shipped',
                          'status': 'shipped',
                        }),
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
                                    'assets/images/PersonCheck.png'),
                                width: 100,
                                height: 100,
                              ),
                              Text(
                                'Shipped',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(134, 134, 134, 1),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () => Navigator.of(context)
                            .pushNamed('/orders', arguments: {
                          'logo': 'assets/images/DateIcon.png',
                          'type': 0,
                          'title': 'Archived',
                          'status': 'archived',
                        }),
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
                                child:
                                    Image.asset('assets/images/DateIcon.png'),
                                width: 100,
                                height: 100,
                              ),
                              Text(
                                'Archived',
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
                        onTap: () => Navigator.of(context)
                            .pushNamed('/orders', arguments: {
                          'logo': 'assets/images/AllIcon.png',
                          'type': 0,
                          'title': 'All',
                          'follow': true,
                        }),
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
                                child: Icon(
                                  Icons.arrow_upward,
                                  size: 45,
                                  color: Color.fromRGBO(170, 44, 94, 1),
                                ),
                                width: 100,
                                height: 100,
                              ),
                              Text(
                                'Follow Up',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(134, 134, 134, 1),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
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
