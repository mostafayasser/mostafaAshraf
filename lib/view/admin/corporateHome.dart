import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';
import 'package:maglis_app/widgets/gridItems.dart';
import 'package:provider/provider.dart';

class CorporateHome extends StatefulWidget {
  @override
  _CorporateHomeState createState() => _CorporateHomeState();
}

class _CorporateHomeState extends State<CorporateHome> {
  List<String> dates = [];
  List<String> userName = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<UserProvider>(context).user;
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
      body: Container(
        child: Column(children: [
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: Image.asset('assets/images/OrdersIcon.png'),
              title: Text(
                'Corporate Orders',
                style: TextStyle(
                    color: Color.fromRGBO(170, 44, 94, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () => Navigator.of(context).pushNamed(
                            '/corporateOrders',
                            arguments: {'status': 'noAction', 'type': 2}),
                        child: Container(
                          width: size.width / 2.25,
                          height: 170,
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
                                'No Action Orders',
                                textAlign: TextAlign.center,
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
                        onTap: () => Navigator.of(context).pushNamed(
                            '/corporateOrders',
                            arguments: {'status': 'onDistribution', 'type': 2}),
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
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      user.type != 'warehouse'
                          ? InkWell(
                              onTap: () => Navigator.of(context).pushNamed(
                                  '/corporateOrders',
                                  arguments: {'status': 'shipped', 'type': 2}),
                              child: Container(
                                width: size.width / 2.25,
                                height: 170,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 2.5, color: Colors.grey[400]),
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
                                          color:
                                              Color.fromRGBO(134, 134, 134, 1),
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(),
                      InkWell(
                        onTap: () => Navigator.of(context).pushNamed(
                            '/corporateOrders',
                            arguments: {'status': 'collected', 'type': 2}),
                        child: Container(
                          width: size.width / 2.25,
                          height: 170,
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
                                'Collected Orders',
                                textAlign: TextAlign.center,
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
                        onTap: () => Navigator.of(context).pushNamed(
                            '/corporateOrders',
                            arguments: {'status': 'archived', 'type': 2}),
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
                        onTap: () => Navigator.of(context).pushNamed(
                            '/corporateOrders',
                            arguments: {'status': 'canceled', 'type': 2}),
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 5.0),
                  child: InkWell(
                    onTap: () => Navigator.of(context)
                        .pushNamed('/corporateOrders', arguments: {'type': 10}),
                    child: Container(
                      width: size.width / 2.25,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 2.5, color: Colors.grey[400]),
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
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
