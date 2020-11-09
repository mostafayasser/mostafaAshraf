//Screen 13
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';

class CollectedDetails extends StatefulWidget {
  @override
  _CollectedDetailsState createState() => _CollectedDetailsState();
}

class _CollectedDetailsState extends State<CollectedDetails> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final map = ModalRoute.of(context).settings.arguments as Map;
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
      resizeToAvoidBottomPadding: false,
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('routes')
            .document(map['docId'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          final routeData = snapshot.data.data();
          final ordersList = routeData['orders'] as List;

          return Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    '${routeData['name']}',
                    style: TextStyle(
                        color: Color.fromRGBO(170, 44, 94, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  trailing: Icon(
                    Icons.search,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                padding: EdgeInsets.only(left: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${routeData['area']}',
                      style: TextStyle(
                          color: Color.fromRGBO(
                              96, 125, 130, 1), //rgb(96, 125, 130)
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      'Created By: ${routeData['createdBy']}',
                      style: TextStyle(
                          color: Color.fromRGBO(96, 125, 130, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      'Created At : ${routeData['createdAt']}',
                      style: TextStyle(
                          color: Color.fromRGBO(96, 125, 130, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      'Orders: ${ordersList.length} Orders',
                      style: TextStyle(
                          color: Color.fromRGBO(96, 125, 130, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      'Total Amount: ${routeData['totalAmount']} EGP',
                      style: TextStyle(
                          color: Color.fromRGBO(96, 125, 130, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      'Fees: ${routeData['fees']} EGP',
                      style: TextStyle(
                          color: Color.fromRGBO(96, 125, 130, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      'Status: ${routeData['status']}',
                      style: TextStyle(
                          color: Color.fromRGBO(96, 125, 130, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.withOpacity(0.5), width: 2),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              onTap: () => Navigator.of(context)
                                  .pushNamed('/orderDetails', arguments: {
                                'docId': ordersList[index]['docId'],
                              }),
                              title: Row(
                                children: <Widget>[
                                  Text(
                                    '${ordersList[index]['name']}',
                                    style: TextStyle(
                                        color: Color.fromRGBO(170, 44, 94, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                '${ordersList[index]['address']}',
                                style: TextStyle(
                                    color: Color.fromRGBO(96, 125, 130, 1),
                                    fontSize: 14),
                              ),
                              trailing: Text(
                                '${ordersList[index]['totalAccount']} EGP',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 12),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.grey, width: 2),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  )),
                              child: ordersList[index]['shipped']
                                  ? Center(
                                      child: Text(
                                        'Shipped',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        'Not Shipped',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: ordersList.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
