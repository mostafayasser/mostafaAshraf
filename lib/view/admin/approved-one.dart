import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';
import 'package:maglis_app/widgets/gridItems.dart';

class ApprovedOne extends StatefulWidget {
  @override
  _ApprovedOneState createState() => _ApprovedOneState();
}

class _ApprovedOneState extends State<ApprovedOne> {
  List<String> dates = [];
  List<String> userName = [];

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
                trailing: InkWell(
                  onTap: () => Navigator.of(context).pushNamed('/addRevenue'),
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
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                  future: Firestore.instance
                      .collection('revenue')
                      .where('status', isEqualTo: 'approved')
                      .getDocuments(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final documents = snapshot.data.documents;
                    documents.forEach((element) {
                      if (!dates.contains(element.data()['date']))
                        dates.add(element.data()['date']);
                      if (!userName.contains(element.data()['userName']))
                        userName.add(element.data()['userName']);
                    });
                    print('dates:$dates');
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
                                  'route': '/approvedRevenue',
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
                                        width: 75,
                                        height: 75,
                                      ),
                                      Text(
                                        'Date',
                                        style: TextStyle(
                                            fontSize: 24,
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
                                  'route': '/approvedRevenue',
                                  'date': userName,
                                  'type': 2,
                                  'logo': 'assets/images/Person.png',
                                  'title': 'User'
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
                                          width: 75,
                                          height: 75,
                                        ),
                                        Text(
                                          'Pickup',
                                          style: TextStyle(
                                              fontSize: 24,
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
                                    .pushNamed('/approvedRevenue', arguments: {
                                  'type': 3,
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
                                        width: 75,
                                        height: 75,
                                        child: Image.asset(
                                            'assets/images/LineIcon.png'),
                                      ),
                                      Text(
                                        'Cairo',
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Color.fromRGBO(
                                                134, 134, 134, 1),
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
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
                                    InkWell(
                                      onTap: () => Navigator.of(context)
                                          .pushNamed('/approvedRevenue',
                                              arguments: {
                                            'type': 4,
                                          }),
                                      child: Container(
                                        width: 75,
                                        height: 75,
                                        child: Image.asset(
                                          'assets/images/LinesIcon.png',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Cities',
                                      style: TextStyle(
                                          fontSize: 24,
                                          color:
                                              Color.fromRGBO(134, 134, 134, 1),
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                onTap: () => Navigator.of(context)
                                    .pushNamed('/approvedRevenue', arguments: {
                                  'type': 5,
                                }),
                                child: Container(
                                  width: 75,
                                  height: 75,
                                  child: Image.asset(
                                    'assets/images/AllIcon.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Text(
                                'All',
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Color.fromRGBO(134, 134, 134, 1),
                                    fontWeight: FontWeight.bold),
                              )
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
