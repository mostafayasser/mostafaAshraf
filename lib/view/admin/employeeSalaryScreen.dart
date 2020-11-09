//Screen 14

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';

class EmployeeSalaries extends StatefulWidget {
  @override
  _EmployeeSalariesState createState() => _EmployeeSalariesState();
}

class _EmployeeSalariesState extends State<EmployeeSalaries> {
  bool called = false;

  double amount = 0.0;

  var type = 0;
  Map filterData;

  @override
  Widget build(BuildContext context) {
    final map = ModalRoute.of(context).settings.arguments as Map;

    if (map == null) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('System Error'),
          content: Text('You have to choose the employee'),
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK!'),
            )
          ],
        ),
      ).then((value) => Navigator.of(context).pop());
    }
    final id = map['id'];
    final name = map['name'] == null ? '' : map['name'];
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
        actions: [
          InkWell(
            onTap: () async {
              filterData = await Navigator.of(context)
                  .pushNamed('/financeFilter') as Map;
              print(filterData);
              setState(() {});
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400], width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Icon(
                  Icons.filter_list,
                  size: 25,
                  color: Color.fromRGBO(96, 125, 129, 1),
                ),
              ),
            ),
          ),
        ],
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
                '${name}\'s Salary',
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('employee')
                      .document(id)
                      .collection('salaries')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );

                    final documents = snapshot.data.documents;
                    documents.sort((a, b) {
                      if (a.data()['time'] == null) {
                        return 1;
                      }
                      if (b.data()['time'] == null) {
                        return -1;
                      }
                      return (a.data()['time'] as Timestamp)
                          .compareTo((b.data()['time'] as Timestamp));
                    });
                    if (filterData != null &&
                        (filterData['month'] as int) != null &&
                        (filterData['month'] as int) > 0) {
                      final month = filterData['month'] as int;
                      print(month);
                      print(documents.length);
                      documents.removeWhere((element) {
                        return !((element.data()['time'] as Timestamp)
                                .toDate()
                                .month ==
                            month);
                      });
                      print(documents.length);
                    }
                    if (snapshot.data.documents.length <= 0) {
                      return Center(
                        child: Text(
                          'This employee has not registered a Salary',
                          style: TextStyle(
                              color: Color.fromRGBO(170, 44, 94, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (ctx, index) {
                        Timestamp timestamp =
                            documents[index]['time'] as Timestamp;
                        DateTime dateStamp = timestamp != null
                            ? timestamp.toDate()
                            : DateTime.now();
                        final date = DateFormat.yMd().format(dateStamp);
                        return Container(
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
                                      '${name}',
                                      style: TextStyle(
                                          color: Color.fromRGBO(170, 44, 94, 1),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          documents[index]['type'] == null
                                              ? 'Undefined'
                                              : '${documents[index]['type']}',
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
                            ));
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
