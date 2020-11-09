//Screen 10
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';

class CollectedRoutes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final map = ModalRoute.of(context).settings.arguments as Map;
    Stream routestream;
    if (map != null) {
      print(map['date']);
      if (map['type'] == 1) {
        routestream = Firestore.instance
            .collection('routes')
            .where('createdAt', isEqualTo: map['date'])
            .where('status', isEqualTo: 'collected')
            .snapshots();
      } else if (map['type'] == 2) {
        routestream = Firestore.instance
            .collection('routes')
            .where('name', isEqualTo: map['date'])
            .where('status', isEqualTo: 'collected')
            .snapshots();
      } else if (map['type'] == 3) {
        routestream = Firestore.instance
            .collection('routes')
            .where('area', isEqualTo: map['date'])
            .where('status', isEqualTo: 'collected')
            .snapshots();
      } else {
        routestream = Firestore.instance
            .collection('routes')
            .where('status', isEqualTo: 'collected')
            .snapshots();
      }
    } else {
      routestream = Firestore.instance
          .collection('routes')
          .where('status', isEqualTo: 'collected')
          .snapshots();
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
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: Image.asset('assets/images/PersonCheck.png'),
              title: Text(
                'collected Routes',
                style: TextStyle(
                    color: Color.fromRGBO(170, 44, 94, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: routestream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                final routesData = snapshot.data.documents;
                routesData.sort((a, b) => (a.data()['time'] as Timestamp)
                    .compareTo((b.data()['time'] as Timestamp)));
                return ListView.builder(
                  itemCount: routesData.length,
                  itemBuilder: (context, i) {
                    int qty = 0;
                    (routesData[i].data()['orders'] as List).forEach((element) {
                      qty += element['qty'] == null ? 0 : element['qty'];
                    });
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: InkWell(
                        onTap: () async {
                          if (map != null) {
                            if (map['type'] == 2) {
                              final lastroutes =
                                  routesData[i].data()['orders'] as List;
                              final routesId =
                                  lastroutes.map((e) => e['docId']).toList();
                              if (!routesId.contains(map['docId'])) {
                                lastroutes.add({
                                  'docId': map['docId'],
                                  'name': map['name'],
                                  'address': map['address'],
                                  'totalAccount': map['totalAccount'],
                                });
                                final totalAmount =
                                    routesData[i].data()['totalAmount'] +
                                        map['totalAccount'];
                                await Firestore.instance
                                    .collection('routes')
                                    .document(routesData[i].documentID)
                                    .updateData({
                                  'orders': lastroutes,
                                  'totalAmount': totalAmount,
                                });
                                await Firestore.instance
                                    .collection('orders')
                                    .document(map['docId'])
                                    .updateData({'status': 'routed'});
                                Navigator.of(context).pushNamed(
                                    '/collectedItemDetails',
                                    arguments: {
                                      'docId': routesData[i].documentID
                                    });
                              }
                            }
                          } else {
                            Navigator.of(context).pushNamed(
                                '/collectedItemDetails',
                                arguments: {'docId': routesData[i].documentID});
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 2,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    '${routesData[i].data()['name']}',
                                    style: TextStyle(
                                        color: Color.fromRGBO(170, 44, 94, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    'Orders: ${(routesData[i].data()['orders'] as List).length}',
                                    style: TextStyle(
                                        color: Color.fromRGBO(170, 44, 94, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Area: ${routesData[i].data()['area']}',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    'Total: ${routesData[i].data()['totalAmount']} EGP',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Date: ${routesData[i].data()['date']}', //date
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  qty > 0
                                      ? Text(
                                          'Qty: ${qty}',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        )
                                      : SizedBox(),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
