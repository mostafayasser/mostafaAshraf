//Screen 13
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';

class OnDistributionDetails extends StatefulWidget {
  @override
  _OnDistributionDetailsState createState() => _OnDistributionDetailsState();
}

class _OnDistributionDetailsState extends State<OnDistributionDetails> {
  TextEditingController textEditingController = TextEditingController();
  List<Map> orderState = [];

  @override
  Widget build(BuildContext context) {
    final map = ModalRoute.of(context).settings.arguments as Map;
    final size = MediaQuery.of(context).size;
    bool loading = false;
    bool allShippedConfirmed = false;

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

          if (ordersList != null && ordersList.length > 0) {
            ordersList.first['shipped'] == null
                ? allShippedConfirmed = false
                : allShippedConfirmed = true;
            ordersList.forEach((element) {
              if (element['shipped'] == null) {
                allShippedConfirmed = false;
                print('not called');
                return;
              }
              if (allShippedConfirmed) {
                if (element['shipped'] != null) {
                  print('called');
                  allShippedConfirmed = true;
                  return;
                }
              }
              print('dont called');
              allShippedConfirmed = false;
            });
          }

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
                              child: ordersList[index]['shipped'] == null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(child: SizedBox()),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                                useRootNavigator: true,
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Give The Reason:'),
                                                    content: TextField(
                                                      controller:
                                                          textEditingController,
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      decoration:
                                                          InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                    width: 1.5),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25),
                                                              ),
                                                              labelText:
                                                                  'Reason'),
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        onPressed: () {
                                                          textEditingController
                                                              .clear();

                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                      FlatButton(
                                                          onPressed: () async {
                                                            if (textEditingController
                                                                .text.isEmpty)
                                                              return;
                                                            ordersList[index][
                                                                    'shipped'] =
                                                                false;
                                                            var totalAmount = routeData[
                                                                    'totalAmount'] -
                                                                ordersList[
                                                                        index][
                                                                    'totalAccount'];
                                                            if (totalAmount < 0)
                                                              totalAmount = 0;

                                                            ordersList[index]
                                                                    ['reason'] =
                                                                textEditingController
                                                                    .text;
                                                            final date = DateFormat
                                                                    .yMd()
                                                                .format(DateTime
                                                                    .now());

                                                            Firestore.instance
                                                                .collection(
                                                                    'orders')
                                                                .document(
                                                                    ordersList[
                                                                            index]
                                                                        [
                                                                        'docId'])
                                                                .updateData({
                                                              'issued': true,
                                                              'returned': true,
                                                              'reason':
                                                                  textEditingController
                                                                      .text
                                                            });

                                                            textEditingController
                                                                .clear();
                                                            orderState.add({
                                                              'docId':
                                                                  ordersList[
                                                                          index]
                                                                      ['docId'],
                                                              'shipped': false,
                                                            });
                                                            await Firestore
                                                                .instance
                                                                .collection(
                                                                    'routes')
                                                                .document(snapshot
                                                                    .data
                                                                    .documentID)
                                                                .updateData(
                                                              {
                                                                'orders':
                                                                    ordersList,
                                                                'totalAmount':
                                                                    totalAmount
                                                              },
                                                            );

                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            setState(() {});
                                                          },
                                                          child: Text(
                                                            'Send',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green),
                                                          ))
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Text(
                                            'Not Shipped',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(child: SizedBox()),
                                        VerticalDivider(
                                          color: Color.fromRGBO(170, 44, 94, 1),
                                          thickness: 3,
                                        ),
                                        Expanded(child: SizedBox()),
                                        InkWell(
                                          onTap: () async {
                                            bool confirmation =
                                                await showDialog(
                                              context: context,
                                              child: AlertDialog(
                                                title: Text('Confirmation'),
                                                content: Text(
                                                    'Are you sure about completeing this process'),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                    },
                                                    child: Text(
                                                      'No',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                  FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(true);
                                                    },
                                                    child: Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                            if (confirmation) {
                                              ordersList[index]['shipped'] =
                                                  true;

                                              orderState.add({
                                                'docId': ordersList[index]
                                                    ['docId'],
                                                'shipped': true,
                                              });
                                              Firestore.instance
                                                  .collection('routes')
                                                  .document(
                                                      snapshot.data.documentID)
                                                  .updateData(
                                                      {'orders': ordersList});

                                              setState(() {});
                                            }
                                          },
                                          child: Text(
                                            'Shipped',
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(child: SizedBox()),
                                      ],
                                    )
                                  : ordersList[index]['shipped']
                                      ? Center(
                                          child: Text(
                                            'Shipped',
                                            style:
                                                TextStyle(color: Colors.green),
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
              routeData['status'] == 'shipped'
                  ? Container(
                      color: Color.fromRGBO(170, 44, 94, 1),
                      width: size.width,
                      height: 50,
                      child: Center(
                        child: Text(
                          'Pushed to Finance',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : loading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : allShippedConfirmed
                          ? InkWell(
                              onTap: () async {
                                final amountController =
                                    TextEditingController();
                                final confirm = await showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    title: Text('Fees Charged'),
                                    content: TextField(
                                      controller: amountController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 1.5),
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          labelText: 'Fees',
                                          hintText:
                                              'Enter The Distribution Fees:'),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('Ok',
                                            style:
                                                TextStyle(color: Colors.green)),
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                                if (!confirm) return;
                                ordersList.forEach((element) async {
                                  print(element);
                                  if (element['shipped']) {
                                    print('shipped');
                                    await Firestore.instance
                                        .collection('orders')
                                        .document(element['docId'])
                                        .updateData({'status': 'shipped'});
                                  } else {
                                    print('canceled');
                                    await Firestore.instance
                                        .collection('orders')
                                        .document(element['docId'])
                                        .updateData({'status': 'noAction'});
                                  }
                                });
                                await Firestore.instance
                                    .collection('routes')
                                    .document(snapshot.data.documentID)
                                    .updateData(
                                  {
                                    'status': 'shipped',
                                    'fees': double.parse(amountController.text)
                                  },
                                );
                                Navigator.of(context, rootNavigator: true)
                                    .pushReplacementNamed('/newRoute');
                              },
                              child: Container(
                                color: Color.fromRGBO(170, 44, 94, 1),
                                width: size.width,
                                height: 50,
                                child: Center(
                                  child: Text(
                                    'Push to Shipped',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () async {
                                bool confirmation = await showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    title: Text('Confirmation'),
                                    content: Text(
                                        'Are you sure about completeing this process'),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text(
                                          'No',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                                if (!confirmation) return;
                                double total = 0.0;
                                ordersList.forEach((element) {
                                  element['shipped'] = true;
                                  total += (0.0 + element['totalAccount']);
                                });

                                allShippedConfirmed = true;
                                await Firestore.instance
                                    .collection('routes')
                                    .document(snapshot.data.documentID)
                                    .updateData({
                                  'orders': ordersList,
                                  'totalAmount': total
                                });

                                setState(() {});
                              },
                              child: Container(
                                color: Color.fromRGBO(170, 44, 94, 1),
                                width: size.width,
                                height: 50,
                                child: Center(
                                  child: Text(
                                    'Check All Orders First',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
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
