import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:provider/provider.dart';

class ShippedRouteScreen extends StatefulWidget {
  @override
  _ShippedRouteScreenState createState() => _ShippedRouteScreenState();
}

class _ShippedRouteScreenState extends State<ShippedRouteScreen> {
  @override
  Widget build(BuildContext context) {
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
              leading: Image.asset('assets/images/NotApproved.png'),
              title: Text(
                'Shipped Routes',
                style: TextStyle(
                    color: Color.fromRGBO(170, 44, 94, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400], width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.sort,
                        size: 25,
                        color: Color.fromRGBO(96, 125, 129, 1),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  (user.type == 'admin' || user.type == 'operation')
                      ? InkWell(
                          onTap: () =>
                              Navigator.of(context).pushNamed('/addRoute'),
                          child: Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey[400], width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.add,
                                size: 25,
                                color: Color.fromRGBO(96, 125, 129, 1),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('routes')
                  .where('status', isEqualTo: 'shipped')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                final routesData = snapshot.data.documents;

                return ListView.builder(
                  itemCount: routesData.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: InkWell(
                        onTap: () => Navigator.of(context).pushNamed(
                            '/onDistributionItem',
                            arguments: {'docId': routesData[i].documentID}),
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
                                  ), //rgb(130, 34, 94)
                                  user.type == 'admin'
                                      ? RaisedButton(
                                          onPressed: () {
                                            Firestore.instance
                                                .collection('routes')
                                                .document(
                                                    routesData[i].documentID)
                                                .updateData(
                                                    {'status': 'cashed'});
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Add to Finance',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                          color: Color.fromRGBO(130, 34, 94, 1),
                                          elevation: 8,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.all(8),
                                        )
                                      : SizedBox()
                                ],
                              ),
                              Divider(
                                color: Colors.black.withOpacity(0.6),
                                thickness: 2,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Area: ${routesData[i].data()['area']}',
                                    style: TextStyle(
                                        color: Color.fromRGBO(170, 44, 94, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    'Date: ${routesData[i].data()['date']}', //date
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Cash: ${routesData[i].data()['totalAmount']} EGP',
                                    style: TextStyle(
                                        color: Color.fromRGBO(170, 44, 94, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    'Fee: ${routesData[i].data()['fees']} EGP', //date
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )
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
