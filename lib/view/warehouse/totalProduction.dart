import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:provider/provider.dart';

class TotalPro extends StatefulWidget {
  @override
  _TotalProState createState() => _TotalProState();
}

class _TotalProState extends State<TotalPro> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final map = ModalRoute.of(context).settings.arguments as Map;
    Stream productionStream;
    if (map['type'] == 1) {
      productionStream = Firestore.instance
          .collection('orders')
          .where('status', isEqualTo: 'onDistribution')
          .where('isCairo', isEqualTo: true)
          .where('isCorporate', isEqualTo: false)
          .snapshots();
    } else if (map['type'] == 2) {
      productionStream = Firestore.instance
          .collection('orders')
          .where('status', isEqualTo: 'onDistribution')
          .where('isCairo', isEqualTo: false)
          .where('isCorporate', isEqualTo: false)
          .snapshots();
    } else if (map['type'] == 3) {
      productionStream = Firestore.instance
          .collection('orders')
          .where('status', isEqualTo: 'onDistribution')
          .where('isCorporate', isEqualTo: true)
          .snapshots();
    }
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
                'Total Production',
                style: TextStyle(
                    color: Color.fromRGBO(170, 44, 94, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: productionStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                final ordersData = snapshot.data.documents;

                return ListView.builder(
                  itemCount: ordersData.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: InkWell(
                        onTap: () {
                          if (ordersData[i].data()['isCairo'] &&
                              !ordersData[i].data()['isCorporate']) {
                            Navigator.of(context)
                                .pushNamed('/orderDetails', arguments: {
                              'docId': ordersData[i].documentID,
                            });
                          } else if (!ordersData[i].data()['isCairo'] &&
                              !ordersData[i].data()['isCorporate']) {
                            Navigator.of(context)
                                .pushNamed('/citiyOrderDetails', arguments: {
                              'docId': ordersData[i].documentID,
                            });
                          } else {
                            Navigator.of(context).pushNamed(
                                '/corporateOrderDetails',
                                arguments: {
                                  'docId': ordersData[i].documentID,
                                });
                          }
                        },
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          actions: <Widget>[
                            IconSlideAction(
                              onTap: () async {
                                bool confirm = await showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Confirmation?'),
                                    content: Text(
                                        'Are You sure about consdiring this issue as solved?'),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm) {
                                  Firestore.instance
                                      .collection('orders')
                                      .document(ordersData[i].documentID)
                                      .updateData({'done': true});
                                }
                              },
                              color: Colors.green,
                              icon: Icons.check_circle,
                              caption: 'Done',
                            )
                          ],
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              onTap: () async {
                                bool confirm = await showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Confirmation?'),
                                    content: Text(
                                        'Are You sure about consdiring this issue as solved?'),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm) {
                                  Firestore.instance
                                      .collection('orders')
                                      .document(ordersData[i].documentID)
                                      .updateData({'done': true});
                                }
                              },
                              color: Colors.green,
                              icon: Icons.check_circle,
                              caption: 'Done',
                            )
                          ],
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
                            margin: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      '${ordersData[i].data()['name']}',
                                      style: TextStyle(
                                          color: Color.fromRGBO(170, 44, 94, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    ordersData[i].data()['done'] == null ||
                                            !ordersData[i].data()['done']
                                        ? Icon(
                                            Icons.info,
                                            color: Colors.amber,
                                          )
                                        : Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          ),
                                    Text(
                                      '${ordersData[i].data()['orderNumber']}',
                                      style: TextStyle(
                                          color: Color.fromRGBO(170, 44, 94, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.black.withOpacity(0.6),
                                  thickness: 2,
                                ),
                                Text(
                                  '${ordersData[i].data()['description']}',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                )
                              ],
                            ),
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
