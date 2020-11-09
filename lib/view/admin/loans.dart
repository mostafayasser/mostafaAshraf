//Screen 14

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';
import 'package:provider/provider.dart';

class Loans extends StatefulWidget {
  @override
  _LoansState createState() => _LoansState();
}

class _LoansState extends State<Loans> {
  bool called = false;

  double amount = 0.0;

  var type = 0;

  @override
  Widget build(BuildContext context) {
    final map = ModalRoute.of(context).settings.arguments as Map;
    final user = Provider.of<UserProvider>(context).user;
    if (map != null && !called) {
      amount = map['money'];
      type = map['type'];
      called = true;
    }

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
        actions: <Widget>[
          map != null
              ? CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  radius: 25,
                  child: Text(
                    '${amount.round()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                )
              : SizedBox(),
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
                'Loans',
                style: TextStyle(
                    color: Color.fromRGBO(170, 44, 94, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              trailing: user.type == 'admin'
                  ? InkWell(
                      onTap: () => Navigator.of(context).pushNamed('/addLoans'),
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
                      if (a.data()['lastTime'] == null) {
                        return 1;
                      }
                      if (b.data()['lastTime'] == null) {
                        return -1;
                      }
                      return (a.data()['lastTime'] as Timestamp)
                          .compareTo((b.data()['lastTime'] as Timestamp));
                    });
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (ctx, index) {
                        Timestamp timestamp =
                            documents[index]['lastTime'] as Timestamp;
                        DateTime dateStamp = timestamp != null
                            ? timestamp.toDate()
                            : DateTime.now();
                        final date = DateFormat.yMd().format(dateStamp);
                        return InkWell(
                          onTap: () async {
                            print('amounted$amount');
                            if (type != 2) {
                              Navigator.of(context)
                                  .pushNamed('/employeeLoan', arguments: {
                                'id': documents[index].documentID,
                                'name': documents[index].data()['name'],
                              });
                            }
                            if (type != 2 || amount == 0) return;
                            final totalAmount = documents[index]['loan'];
                            if (totalAmount == 0) return;
                            if (amount <= totalAmount) {
                              final netAmount = totalAmount - amount;

                              setState(() {
                                amount = 0;
                              });
                              await Firestore.instance
                                  .collection('employee')
                                  .document(documents[index].documentID)
                                  .updateData({'loan': netAmount});
                            } else {
                              setState(() {
                                amount -= totalAmount;
                              });
                              await Firestore.instance
                                  .collection('employee')
                                  .document(documents[index].documentID)
                                  .updateData({'loan': 0});
                            }
                            if (amount == 0 && type == 2)
                              Navigator.of(context).pop(true);
                          },
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
                                        documents[index]['loan'] == null
                                            ? '0 EGP'
                                            : '${documents[index]['loan']} EGP',
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
                                      Text(
                                        '${date}',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                105, 132, 137, 1),
                                            fontWeight: FontWeight
                                                .bold, //rgb(105, 132, 137)
                                            fontSize: 15),
                                      ),
                                      user.type == 'admin'
                                          ? InkWell(
                                              onTap: () => Navigator.of(context)
                                                  .pushNamed('/addLoans',
                                                      arguments: {
                                                    'id': snapshot
                                                        .data
                                                        .documents[index]
                                                        .documentID,
                                                    'name': documents[index]
                                                        ['name'],
                                                    'money': snapshot.data
                                                            .documents[index]
                                                        ['money']
                                                  }),
                                              child: Image.asset(
                                                'assets/images/noteAdd.png',
                                                width: 50,
                                                height: 50,
                                              ),
                                            )
                                          : SizedBox()
                                    ],
                                  )
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
