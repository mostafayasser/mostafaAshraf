import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as url;

//Screen 39
class CorporateOrderDetails extends StatefulWidget {
  @override
  _CorporateOrderDetailsState createState() => _CorporateOrderDetailsState();
}

class _CorporateOrderDetailsState extends State<CorporateOrderDetails> {
  String docId = '';

  bool showMenu = false;

  bool isCalled = false;

  bool isIssue = false;

  int orderNumber;

  var textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final orderData =
        ModalRoute.of(context).settings.arguments as Map<dynamic, dynamic>;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('orders')
            .document(orderData['docId'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final order = snapshot.data.data();
          docId = snapshot.data.documentID;
          orderNumber = snapshot.data.data()['orderNumber'];
          isIssue = order['issued'];
          showMenu = (order['status'] == 'noAction' ||
                  order['status'] == 'archived' ||
                  order['status'] == 'onDistribution')
              ? true
              : false;

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
                isIssue
                    ? Icon(
                        Icons.error,
                        color: Colors.red,
                      )
                    : Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                showMenu
                    ? PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.black,
                        ),
                        onSelected: (val) async {
                          if (val == 'Cancel') {
                            Firestore.instance
                                .collection('orders')
                                .document(docId)
                                .updateData({'status': 'canceled'}).then(
                                    (value) => Navigator.of(context).pop());
                          } else if (val == 'Archive') {
                            //canceled  archived
                            final issuesDocs = await Firestore.instance
                                .collection('orders')
                                .document(snapshot.data.documentID)
                                .collection('issues')
                                .getDocuments();
                            issuesDocs.documents.forEach((element) {
                              Firestore.instance
                                  .collection('orders')
                                  .document(snapshot.data.documentID)
                                  .collection('issues')
                                  .document(element.documentID)
                                  .updateData({'isSolved': true});
                            });
                            Firestore.instance
                                .collection('orders')
                                .document(docId)
                                .updateData({'status': 'archived'}).then(
                                    (value) => Navigator.of(context).pop());
                          } else if (val == 'No Action') {
                            Firestore.instance
                                .collection('orders')
                                .document(docId)
                                .updateData({'status': 'noAction'}).then(
                                    (value) => Navigator.of(context).pop());
                          }
                        },
                        itemBuilder: ((BuildContext context) {
                          if (snapshot.data.data()['status'] == 'archived') {
                            return {'Cancel', 'No Action'}.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          }
                          return {'Cancel', 'Archive'}.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        }),
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
                      '${order['name']}',
                      style: TextStyle(
                          color: Color.fromRGBO(170, 44, 94, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    trailing: (order['status'] != 'collected' &&
                            order['status'] != 'canceled' &&
                            order['status'] != 'archived')
                        ? InkWell(
                            onTap: () => Navigator.of(context)
                                .pushNamed('/editOrder', arguments: {
                              'id': snapshot.data.documentID,
                              'orderMap': snapshot.data.data
                            }),
                            child: Image.asset(
                              'assets/images/noteAdd.png',
                              width: 50,
                              height: 50,
                            ),
                          )
                        : SizedBox(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: 210,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 2,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Qty: ${order['quantity']}',
                              style: TextStyle(
                                  color: Color.fromRGBO(
                                      170, 44, 94, 1), //rgb(96, 125, 130)
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            order['channel'] != null
                                ? Text(
                                    'Channel: ${order['channel']}',
                                    style: TextStyle(
                                        color: Color.fromRGBO(170, 44, 94, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                : SizedBox(),
                            Text(
                              'Created Date: ${order['createdAt']}',
                              style: TextStyle(
                                  color: Color.fromRGBO(170, 44, 94, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            /*Text(
                                'Received Date: 18/5/2020',
                                style: TextStyle(
                                    color: Color.fromRGBO(170, 44, 94, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),*/
                            Text(
                              'Area: ${order['isCairo'] ? order['area'] : order['city']}',
                              style: TextStyle(
                                  color: Color.fromRGBO(170, 44, 94, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Text(
                              'Address: ${order['address']}',
                              style: TextStyle(
                                  color: Color.fromRGBO(170, 44, 94, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Text(
                              'Corporate',
                              style: TextStyle(
                                  color: Color.fromRGBO(170, 44, 94, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Text(
                              'Line: ${order['line']}', //line
                              style: TextStyle(
                                  color: Color.fromRGBO(170, 44, 94, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 2,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Description',
                              style: TextStyle(
                                  color: Color.fromRGBO(
                                      170, 44, 94, 1), //rgb(96, 125, 130)
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Divider(
                                color: Colors.grey,
                                thickness: 4,
                              ),
                            ),
                            Text(
                              '${order['description']}', //description
                              style: TextStyle(
                                color: Color.fromRGBO(96, 125, 130, 1),
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ),
                      user.type == 'admin'
                          ? Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  width: 2,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Phone number',
                                    style: TextStyle(
                                        color: Color.fromRGBO(
                                            170, 44, 94, 1), //rgb(96, 125, 130)
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    child: Divider(
                                      color: Colors.grey,
                                      thickness: 4,
                                    ),
                                  ),
                                  Text(
                                    '${order['phone']}',
                                    style: TextStyle(
                                      color: Color.fromRGBO(96, 125, 130, 1),
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                      user.type == 'admin'
                          ? Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  width: 2,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Downpayment',
                                    style: TextStyle(
                                        color: Color.fromRGBO(
                                            170, 44, 94, 1), //rgb(96, 125, 130)
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    child: Divider(
                                      color: Colors.grey,
                                      thickness: 4,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Amount of the invoice',
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(96, 125, 130, 1),
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${order['totalAccount']} EGP',
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(96, 125, 130, 1),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Amount under the account',
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(96, 125, 130, 1),
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${order['underAccount']} EGP',
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(96, 125, 130, 1),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    child: Divider(
                                      color: Colors.grey,
                                      thickness: 4,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Total after downpayment',
                                        style: TextStyle(
                                            color: Color.fromRGBO(170, 44, 94,
                                                1), //rgb(96, 125, 130)
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        '${order['totalAccount'] - order['underAccount']} EGP',
                                        style: TextStyle(
                                            color: Color.fromRGBO(170, 44, 94,
                                                1), //rgb(96, 125, 130)
                                            fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 2,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Notes',
                                  style: TextStyle(
                                      color: Color.fromRGBO(
                                          170, 44, 94, 1), //rgb(96, 125, 130)
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                (order['status'] !=
                                            'collected' && //canceled  archived
                                        order['status'] != 'archived' &&
                                        order['status'] != 'canceled' &&
                                        order['status'] != 'canceled')
                                    ? RaisedButton(
                                        onPressed: () async {
                                          TextEditingController noteController =
                                              TextEditingController();
                                          bool confrimation = await showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text('Add New Note'),
                                              content: TextField(
                                                controller: noteController,
                                                decoration: InputDecoration(
                                                  labelText: 'Note',
                                                  hintText:
                                                      'Write the Note here:',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    borderSide: BorderSide(
                                                        color: Colors.blue,
                                                        width: 1.5),
                                                  ),
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                                FlatButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: Text(
                                                    'Send',
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confrimation) {
                                            if (noteController.text.isEmpty) {
                                              await showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title:
                                                      Text('Validation Error'),
                                                  content: Text(
                                                      'You must define the note\'s description'),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                        child: Text('Ok!'))
                                                  ],
                                                ),
                                              );
                                              return;
                                            }
                                            List notes = order['notes'];
                                            notes.add({
                                              'from': user.name,
                                              'note': noteController.text,
                                              'time': DateFormat.yMd()
                                                  .add_jm()
                                                  .format(DateTime.now())
                                            });
                                            Firestore.instance
                                                .collection('orders')
                                                .document(
                                                    snapshot.data.documentID)
                                                .updateData({'notes': notes});
                                          }
                                        },
                                        child: Text(
                                          'Add Note',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: Color.fromRGBO(170, 44, 94, 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Divider(
                                color: Colors.grey,
                                thickness: 4,
                              ),
                            ),
                            Expanded(
                              child: (order['notes'] != null &&
                                      (order['notes'] as List).isNotEmpty)
                                  ? ListView.builder(
                                      itemBuilder: (ctx, index) => Column(
                                        children: <Widget>[
                                          ListTile(
                                            title: Text(
                                              '${order['notes'][index]['note']}',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    96, 125, 130, 1),
                                                fontSize: 18,
                                              ),
                                            ),
                                            trailing: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  '${order['notes'][index]['from']}',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        96, 125, 130, 1),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  '${order['notes'][index]['time']}',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        96, 125, 130, 1),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            thickness: 2.5,
                                          )
                                        ],
                                      ),
                                      itemCount:
                                          (order['notes'] as List).length,
                                    )
                                  : Center(
                                      child: Text('No note to show'),
                                    ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 2,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Issues',
                                  style: TextStyle(
                                      color: Color.fromRGBO(
                                          170, 44, 94, 1), //rgb(96, 125, 130)
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                order['status'] == 'noAction'
                                    ? RaisedButton(
                                        onPressed: () async {
                                          TextEditingController
                                              issueDescription =
                                              TextEditingController();
                                          bool confirmation = await showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text('Add New Issue'),
                                              content: TextField(
                                                controller: issueDescription,
                                                decoration: InputDecoration(
                                                  labelText: 'Description',
                                                  hintText:
                                                      'Write the Description here:',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    borderSide: BorderSide(
                                                        color: Colors.blue,
                                                        width: 1.5),
                                                  ),
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                                FlatButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: Text(
                                                    'Send',
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                          if (confirmation) {
                                            if (issueDescription.text.isEmpty) {
                                              await showDialog(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title:
                                                      Text('Validation Error'),
                                                  content: Text(
                                                      'You must define the issue\'s description'),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(),
                                                        child: Text('Ok!'))
                                                  ],
                                                ),
                                              );
                                              return;
                                            }
                                            Firestore.instance
                                                .collection('issues')
                                                .add({
                                              'description':
                                                  issueDescription.text,
                                              'createdUser': user.name,
                                              'createdDate': DateFormat.yMd()
                                                  .add_jm()
                                                  .format(DateTime.now()),
                                              'isCairo': order['isCairo'],
                                              'isSolved': false,
                                              'orderId':
                                                  snapshot.data.documentID
                                            });
                                          }
                                        },
                                        child: Text(
                                          'Add Issue',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: Color.fromRGBO(170, 44, 94, 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Divider(
                                color: Colors.grey,
                                thickness: 4,
                              ),
                            ),
                            Expanded(
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance
                                      .collection('orders')
                                      .document(snapshot.data.documentID)
                                      .collection('issues')
                                      .snapshots(),
                                  builder: (context, issueSnapshot) {
                                    if (issueSnapshot.connectionState ==
                                        ConnectionState.waiting)
                                      return Center(
                                          child: CircularProgressIndicator());
                                    final issueDocument =
                                        issueSnapshot.data.documents;

                                    return issueSnapshot
                                                .data.documents.length ==
                                            0
                                        ? Center(
                                            child: Text('No Issue Exit'),
                                          )
                                        : ListView.builder(
                                            itemBuilder: (ctx, index) => Column(
                                              children: <Widget>[
                                                Slidable(
                                                  actionPane:
                                                      SlidableDrawerActionPane(),
                                                  actionExtentRatio: 0.25,
                                                  actions: <Widget>[
                                                    IconSlideAction(
                                                      onTap: () async {
                                                        bool confirm =
                                                            await showDialog(
                                                          context: context,
                                                          builder: (ctx) =>
                                                              AlertDialog(
                                                            title: Text(
                                                                'Confirmation?'),
                                                            content: Text(
                                                                'Are You sure about consdiring this issue as solved?'),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                onPressed: () =>
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            false),
                                                                child: Text(
                                                                  'Cancel',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              ),
                                                              FlatButton(
                                                                onPressed: () =>
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            true),
                                                                child: Text(
                                                                  'Yes',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                        if (confirm) {
                                                          Firestore.instance
                                                              .collection(
                                                                  'orders')
                                                              .document(snapshot
                                                                  .data
                                                                  .documentID)
                                                              .collection(
                                                                  'issues')
                                                              .document(
                                                                  issueDocument[
                                                                          index]
                                                                      .documentID)
                                                              .updateData({
                                                            'isSolved': true,
                                                            'solver': user.name,
                                                          });
                                                        }
                                                      },
                                                      color: Colors.green,
                                                      icon: Icons.check_circle,
                                                      caption: 'Solved',
                                                    )
                                                  ],
                                                  secondaryActions: <Widget>[
                                                    IconSlideAction(
                                                      onTap: () async {
                                                        bool confirm =
                                                            await showDialog(
                                                          context: context,
                                                          builder: (ctx) =>
                                                              AlertDialog(
                                                            title: Text(
                                                                'Confirmation?'),
                                                            content: Text(
                                                                'Are You sure about consdiring this issue as solved?'),
                                                            actions: <Widget>[
                                                              FlatButton(
                                                                onPressed: () =>
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            false),
                                                                child: Text(
                                                                  'Cancel',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              ),
                                                              FlatButton(
                                                                onPressed: () =>
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            true),
                                                                child: Text(
                                                                  'Yes',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                        if (confirm) {
                                                          Firestore.instance
                                                              .collection(
                                                                  'orders')
                                                              .document(snapshot
                                                                  .data
                                                                  .documentID)
                                                              .collection(
                                                                  'issues')
                                                              .document(
                                                                  issueDocument[
                                                                          index]
                                                                      .documentID)
                                                              .updateData({
                                                            'isSolved': true,
                                                            'solver': user.name,
                                                          });
                                                        }
                                                      },
                                                      color: Colors.green,
                                                      icon: Icons.check_circle,
                                                      caption: 'Solved',
                                                    )
                                                  ],
                                                  child: ListTile(
                                                    onTap: () {},
                                                    title: Text(
                                                      '${issueDocument[index].data()['description']}',
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            96, 125, 130, 1),
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                      'Issue Number: ${issueDocument[index].data()['issueNumber']}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    trailing: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        issueDocument[index]
                                                                    .data()[
                                                                'isSolved']
                                                            ? Icon(
                                                                Icons
                                                                    .check_circle,
                                                                color: Colors
                                                                    .green,
                                                              )
                                                            : Icon(
                                                                Icons.error,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                        Text(
                                                          'Creator:${issueDocument[index].data()['createdUser']}',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    96,
                                                                    125,
                                                                    130,
                                                                    1),
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        issueDocument[index]
                                                                        .data()[
                                                                    'solver'] !=
                                                                null
                                                            ? Text(
                                                                'Solver:${issueDocument[index].data()['solver']}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          96,
                                                                          125,
                                                                          130,
                                                                          1),
                                                                  fontSize: 14,
                                                                ),
                                                              )
                                                            : SizedBox()
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Divider(
                                                  thickness: 2.5,
                                                )
                                              ],
                                            ),
                                            itemCount: issueSnapshot
                                                .data.documents.length,
                                          );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      order['reason'] != null
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  width: 2,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Reason',
                                    style: TextStyle(
                                        color: Color.fromRGBO(
                                            170, 44, 94, 1), //rgb(96, 125, 130)
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    child: Divider(
                                      color: Colors.grey,
                                      thickness: 4,
                                    ),
                                  ),
                                  Text(
                                    '${order['reason']}', //description
                                    style: TextStyle(
                                      color: Color.fromRGBO(96, 125, 130, 1),
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 2),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            )),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(child: SizedBox()),
                            order['status'] == 'noAction' &&
                                    (user.type == 'admin' ||
                                        user.type == 'operation')
                                ? InkWell(
                                    onTap: () async {
                                      bool confirm = await showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                                title: Text('Confirmation?'),
                                                content: Text(
                                                    'Do you want to processe?'),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    child: Text(
                                                      'No',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                  FlatButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(true),
                                                    child: Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    ),
                                                  )
                                                ],
                                              ));
                                      if (!confirm) return;
                                      await Firestore.instance
                                          .collection('orders')
                                          .document(snapshot.data.documentID)
                                          .updateData({
                                        'status': 'onDistribution',
                                      });
                                    },
                                    child: Text(
                                      'Add to Distribution',
                                      style: TextStyle(
                                        color: Color.fromRGBO(96, 125, 130, 1),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : order['status'] == 'noAction' &&
                                        (user.type != 'admin' &&
                                            user.type != 'operation')
                                    ? Text(
                                        'No Action',
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(96, 125, 130, 1),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : order['status'] == 'onDistribution' &&
                                            (user.type == 'admin' ||
                                                user.type == 'warehouse' ||
                                                user.type == 'operation')
                                        ? InkWell(
                                            onTap: () async {
                                              bool confirm = await showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                        title: Text(
                                                            'Confirmation?'),
                                                        content: Text(
                                                            'Do you want to processe?'),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(false),
                                                            child: Text(
                                                              'No',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ),
                                                          FlatButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(true),
                                                            child: Text(
                                                              'Yes',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green),
                                                            ),
                                                          )
                                                        ],
                                                      ));
                                              if (!confirm) return;
                                              await Firestore.instance
                                                  .collection('orders')
                                                  .document(
                                                      snapshot.data.documentID)
                                                  .updateData({
                                                'status': 'shipped',
                                              });
                                            },
                                            child: Text(
                                              'Shipped',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        : order['status'] == 'onDistribution' &&
                                                (user.type != 'admin' &&
                                                    user.type != 'warehouse')
                                            ? Text(
                                                'On Distribtuion',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      96, 125, 130, 1),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : order['status'] == 'canceled'
                                                ? Text(
                                                    'Cancelled',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                : order['status'] ==
                                                            'shipped' &&
                                                        (user.type == 'admin')
                                                    ? InkWell(
                                                        onTap: () async {
                                                          bool confirm =
                                                              await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (ctx) =>
                                                                      AlertDialog(
                                                                        title: Text(
                                                                            'Confirmation?'),
                                                                        content:
                                                                            Text('Do you want to processe?'),
                                                                        actions: <
                                                                            Widget>[
                                                                          FlatButton(
                                                                            onPressed: () =>
                                                                                Navigator.of(context).pop(false),
                                                                            child:
                                                                                Text(
                                                                              'No',
                                                                              style: TextStyle(color: Colors.red),
                                                                            ),
                                                                          ),
                                                                          FlatButton(
                                                                            onPressed: () =>
                                                                                Navigator.of(context).pop(true),
                                                                            child:
                                                                                Text(
                                                                              'Yes',
                                                                              style: TextStyle(color: Colors.green),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ));
                                                          if (!confirm) return;
                                                          await Firestore
                                                              .instance
                                                              .collection(
                                                                  'orders')
                                                              .document(snapshot
                                                                  .data
                                                                  .documentID)
                                                              .updateData({
                                                            'status':
                                                                'collected',
                                                          });
                                                        },
                                                        child: Text(
                                                          'Add to Finance',
                                                          style: TextStyle(
                                                            color: Colors.green
                                                                .withOpacity(
                                                                    0.7),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      )
                                                    : order['status'] ==
                                                                'shipped' &&
                                                            user.type != 'admin'
                                                        ? Text(
                                                            'Shipped',
                                                            style: TextStyle(
                                                              color: Colors
                                                                  .green
                                                                  .withOpacity(
                                                                      0.7),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )
                                                        : order['status'] ==
                                                                'collected'
                                                            ? Text(
                                                                'Collected',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              )
                                                            : order['status'] ==
                                                                    'cashed'
                                                                ? Text(
                                                                    'Cashed',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color.fromRGBO(
                                                                          226,
                                                                          208,
                                                                          168,
                                                                          1),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  )
                                                                : Text(
                                                                    'Arechived',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color.fromRGBO(
                                                                          226,
                                                                          208,
                                                                          168,
                                                                          1),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
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
                              onTap: () => url.launch('tel:${order['phone']}'),
                              child: Text(
                                'Call',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            order['status'] == 'onDistribution' &&
                                    (user.type == 'admin' ||
                                        user.type == 'warehouse' ||
                                        user.type == 'operation')
                                ? Expanded(child: SizedBox())
                                : SizedBox(),
                            order['status'] == 'onDistribution' &&
                                    (user.type == 'admin' ||
                                        user.type == 'warehouse' ||
                                        user.type == 'operation')
                                ? VerticalDivider(
                                    color: Color.fromRGBO(170, 44, 94, 1),
                                    thickness: 3,
                                  )
                                : SizedBox(),
                            order['status'] == 'onDistribution' &&
                                    (user.type == 'admin' ||
                                        user.type == 'warehouse' ||
                                        user.type == 'operation')
                                ? Expanded(child: SizedBox())
                                : SizedBox(),
                            order['status'] == 'onDistribution' &&
                                    (user.type == 'admin' ||
                                        user.type == 'warehouse' ||
                                        user.type == 'operation')
                                ? InkWell(
                                    child: Text(
                                      'Returned',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onTap: () async {
                                      showDialog(
                                        useRootNavigator: true,
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Give The Reason:'),
                                            content: TextField(
                                              controller: textEditingController,
                                              textInputAction:
                                                  TextInputAction.done,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 1.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  labelText: 'Reason'),
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                onPressed: () {
                                                  textEditingController.clear();

                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                              FlatButton(
                                                child: Text(
                                                  'Send',
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                ),
                                                onPressed: () async {
                                                  await showDialog(
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
                                                              TextInputAction
                                                                  .done,
                                                          decoration:
                                                              InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .grey,
                                                                        width:
                                                                            1.5),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
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

                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ),
                                                          FlatButton(
                                                            child: Text(
                                                              'Send',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                  if (textEditingController
                                                      .text.isEmpty) return;
                                                  await Firestore.instance
                                                      .collection('orders')
                                                      .document(snapshot
                                                          .data.documentID)
                                                      .updateData({
                                                    'status': 'noAction',
                                                    'returned': true,
                                                    'reason':
                                                        textEditingController
                                                            .text
                                                  });
                                                  textEditingController.clear();
                                                  setState(() {});
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  )
                                : SizedBox(),
                            Expanded(child: SizedBox()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
