import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';
import 'package:maglis_app/widgets/gridItems.dart';

class ApprovedTwo extends StatefulWidget {
  @override
  _NotApprovedTwoState createState() => _NotApprovedTwoState();
}

class _NotApprovedTwoState extends State<ApprovedTwo> {
  List<String> dates = [];
  List<String> userName = [];
  List<String> supplier = [];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  'Approved',
                  style: TextStyle(
                      color: Color.fromRGBO(170, 44, 94, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                  future: Firestore.instance
                      .collection('expenses')
                      .where('status', isEqualTo: 'approved')
                      .getDocuments(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    final documents = snapshot.data.documents;
                    documents.sort((a, b) {
                      if (a.data()['time'] == null) {
                        return -1;
                      }
                      if (b.data()['time'] == null) {
                        return 1;
                      }
                      return (a.data()['time'] as Timestamp)
                          .compareTo((b.data()['time'] as Timestamp));
                    });
                    documents.forEach((element) {
                      print('doc' + element.data.toString());
                      if (!dates.contains(element.data()['date']))
                        dates.add(element.data()['date']);
                      if (!supplier.contains(element.data()['supplier']))
                        supplier.add(element.data()['supplier']);
                      if (!userName.contains(element.data()['userName']))
                        userName.add(element.data()['userName']);
                    });
                    print('dates:$dates');
                    print('suppliers:$supplier');
                    print('userNames:$userName');
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
                                  'route': '/approvedDetails',
                                  'date': dates,
                                  'type': 1,
                                  'logo': 'assets/images/DateIcon.png',
                                  'title': 'Date',
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
                                            color: Color.fromRGBO(
                                                134, 134, 134, 1),
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.of(context)
                                    .pushNamed('/dateScreen', arguments: {
                                  'route': '/approvedDetails',
                                  'date': userName,
                                  'logo': 'assets/images/Person.png',
                                  'title': 'User',
                                  'type': 2
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
                                      children: <Widget>[
                                        Container(
                                          child: Image.asset(
                                            'assets/images/Person.png',
                                          ),
                                          width: 100,
                                          height: 100,
                                        ),
                                        Text(
                                          'User',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromRGBO(
                                                  134, 134, 134, 1),
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )),
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
                                  'route': '/approvedDetails',
                                  'date': supplier,
                                  'type': 3,
                                  'logo': 'assets/images/Person.png',
                                  'title': 'Supplier',
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
                                            'assets/images/Person.png'),
                                        width: 100,
                                        height: 100,
                                      ),
                                      Text(
                                        'Supplier',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color.fromRGBO(
                                                134, 134, 134, 1),
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.of(context).pushNamed(
                                    '/approvedDetails',
                                    arguments: {'type': 4}),
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
                                            color: Color.fromRGBO(
                                                134, 134, 134, 1),
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
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}
