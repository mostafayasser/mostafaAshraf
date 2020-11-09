import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';

import 'package:maglis_app/widgets/orderTile.dart';

class CollectedRoutes extends StatefulWidget {
  @override
  _CollectedRoutesState createState() => _CollectedRoutesState();
}

class _CollectedRoutesState extends State<CollectedRoutes> {
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
                'Collected Routes',
                style: TextStyle(
                    color: Color.fromRGBO(170, 44, 94, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: InkWell(
                        onTap: () async {
                          Navigator.of(context).pushNamed(
                              '/collectedItemDetails',
                              arguments: {'docId': routesData[i].documentID});
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
                                  Icon(
                                    Icons.info,
                                    color: Colors.amber,
                                  )
                                ],
                              ),
                              Text(
                                'Area: ${routesData[i].data()['area']}',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              Text(
                                'Date: ${routesData[i].data()['date']}', //date
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
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
