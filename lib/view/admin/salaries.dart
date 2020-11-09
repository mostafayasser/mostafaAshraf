//Screen 14

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';
import 'package:provider/provider.dart';

class SalaryScreen extends StatefulWidget {
  @override
  _SalaryScreenState createState() => _SalaryScreenState();
}

class _SalaryScreenState extends State<SalaryScreen> {
  bool called = false;

  double amount = 0.0;

  var type = 0;

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              title: Text(
                'SalaryScreen',
                style: TextStyle(
                    color: Color.fromRGBO(170, 44, 94, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              trailing: user.type == 'admin'
                  ? InkWell(
                      onTap: () =>
                          Navigator.of(context).pushNamed('/addSalary'),
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.add,
                          size: 35,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.5, color: Colors.grey),
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    )
                  : SizedBox(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('employee').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );

                    final documents = snapshot.data.documents;
                    documents.sort((a, b) {
                      if (a.data()['lastSalary'] == null) {
                        return 1;
                      }
                      if (b.data()['lastSalary'] == null) {
                        return -1;
                      }
                      return (a.data()['lastSalary'] as Timestamp)
                          .compareTo((b.data()['lastSalary'] as Timestamp));
                    });
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (ctx, index) {
                        Timestamp timestamp =
                            documents[index]['lastSalary'] as Timestamp;
                        DateTime dateStamp = timestamp != null
                            ? timestamp.toDate()
                            : DateTime.now();
                        final date = DateFormat.yMd().format(dateStamp);
                        return InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamed('/employeeSalary', arguments: {
                            'id': documents[index].documentID,
                            'name': documents[index].data()['name'],
                          }),
                          child: Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.only(
                                  top: 10, left: 12, right: 8, bottom: 0.0),
                              margin: EdgeInsets.all(6),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        '${documents[index]['name']}',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(170, 44, 94, 1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        documents[index]['salary'] == null
                                            ? '0 EGP'
                                            : '${documents[index]['salary']} EGP',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${date}',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    105, 132, 137, 1),
                                                fontWeight: FontWeight
                                                    .bold, //rgb(105, 132, 137)
                                                fontSize: 15),
                                          ),
                                          Text(
                                            documents[index]['salaryType'] ==
                                                    null
                                                ? 'Undefined'
                                                : '${documents[index]['salaryType']}',
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    105, 132, 137, 1),
                                                fontWeight: FontWeight
                                                    .bold, //rgb(105, 132, 137)
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          documents[index]['mode'] != null &&
                                                  documents[index]['mode'] == 3
                                              ? Text(
                                                  documents[index][
                                                              'variableSalary'] ==
                                                          null
                                                      ? 'Constant: 0 EGP'
                                                      : 'Constant: ${documents[index]['salary'] - documents[index]['variableSalary']} EGP',
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          105, 132, 137, 1),
                                                      fontWeight: FontWeight
                                                          .bold, //rgb(105, 132, 137)
                                                      fontSize: 15),
                                                )
                                              : SizedBox(),
                                          documents[index]['mode'] != null &&
                                                  documents[index]['mode'] == 3
                                              ? Text(
                                                  documents[index][
                                                              'variableSalary'] ==
                                                          null
                                                      ? 'Variable: 0 EGP'
                                                      : 'Variable: ${documents[index]['variableSalary']} EGP',
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          105, 132, 137, 1),
                                                      fontWeight: FontWeight
                                                          .bold, //rgb(105, 132, 137)
                                                      fontSize: 15),
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        );
                      },
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
