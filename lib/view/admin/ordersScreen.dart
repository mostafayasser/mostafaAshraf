import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  @override
  _RevenueState createState() => _RevenueState();
}

class _RevenueState extends State<OrderScreen> {
  List<String> dates = [];
  List<String> areas = [];
  List<String> lines = [
    'Pajamas',
    'Pants',
    'Slipper',
    'Blankets',
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
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
                leading: Image.asset('assets/images/OrdersIcon.png'),
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
            child: FutureBuilder<QuerySnapshot>(
                future: Firestore.instance.collection('orders').getDocuments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  final documents = snapshot.data.documents;
                  documents.sort((a, b) => (a.data()['time'] as Timestamp)
                      .compareTo((b.data()['time'] as Timestamp)));
                  documents.forEach((element) {
                    if (!dates.contains(element.data()['createdAt']))
                      dates.add(element.data()['createdAt']);
                    if (!areas.contains(element.data()['area']))
                      areas.add(element.data()['area']);
                  });
                  print('dates:$dates');
                  print('suppliers:$areas');
                  print('userNames:$lines');
                  return ListView(
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed('/dateScreen', arguments: {
                                'route': '/orders',
                                'date': areas,
                                'type': 1,
                                'logo': 'assets/images/CairoIcon.png',
                                'title': 'Area',
                              }),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Image.asset(
                                          'assets/images/CairoIcon.png'),
                                      width: 100,
                                      height: 100,
                                    ),
                                    Text(
                                      'Area',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(134, 134, 134, 1),
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed('/dateScreen', arguments: {
                                'route': '/orders',
                                'date': dates,
                                'type': 2,
                                'logo': 'assets/images/DateIcon.png',
                                'title': 'Date'
                              }),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Image.asset(
                                          'assets/images/DateIcon.png'),
                                      width: 100,
                                      height: 100,
                                    ),
                                    Text(
                                      'Date',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(134, 134, 134, 1),
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
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed('/dateScreen', arguments: {
                                'route': '/orders',
                                'date': lines,
                                'type': 3,
                                'logo': 'assets/images/Line.png',
                                'title': 'Line'
                              }),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child:
                                          Image.asset('assets/images/Line.png'),
                                      width: 100,
                                      height: 100,
                                    ),
                                    Text(
                                      'Line',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(134, 134, 134, 1),
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
                                'title': 'All'
                              }),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Image.asset(
                                          'assets/images/AllIcon.png'),
                                      width: 100,
                                      height: 100,
                                    ),
                                    Text(
                                      'All',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(134, 134, 134, 1),
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
                  );
                }),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}
