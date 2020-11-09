import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';

class OldCashFlow extends StatefulWidget {
  @override
  _CashFlowState createState() => _CashFlowState();
}

class _CashFlowState extends State<OldCashFlow> {
  double cashOut = 0;
  double cashIn = 0;
  double net = 0;
  List<DocumentSnapshot> allDocs = [];
  TextEditingController collectedAmount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final id = (ModalRoute.of(context).settings.arguments as Map)['id'];
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
      body: FutureBuilder<DocumentSnapshot>(
        future: Firestore.instance.collection('cashFlow').document(id).get(),
        builder: (ctx, cashSnapshot) => FutureBuilder<QuerySnapshot>(
          future: Firestore.instance
              .collection('cashFlow')
              .document(id)
              .collection('expenses')
              .getDocuments(),
          builder: (context, expensesSnapshot) {
            return FutureBuilder<QuerySnapshot>(
              future: Firestore.instance
                  .collection('cashFlow')
                  .document(id)
                  .collection('routes')
                  .getDocuments(),
              builder: (context, routesSnapshot) {
                print('in:$cashIn');
                print('out$cashOut');
                //net = cashIn - cashOut;
                return FutureBuilder<QuerySnapshot>(
                    future: Firestore.instance
                        .collection('cashFlow')
                        .document(id)
                        .collection('revenue')
                        .getDocuments(),
                    builder: (context, revenueSnapshot) {
                      allDocs = routesSnapshot.data.documents +
                          expensesSnapshot.data.documents +
                          revenueSnapshot.data.documents;
                      print(
                          'length1:${expensesSnapshot.data.documents.length}');
                      print('length2:${routesSnapshot.data.documents.length}');
                      print('length3:${revenueSnapshot.data.documents.length}');

                      print('length:${allDocs.length}');
                      allDocs.forEach((elemen) {
                        print('${elemen.data}');
                      });
                      if (cashSnapshot.connectionState ==
                              ConnectionState.waiting ||
                          expensesSnapshot.connectionState ==
                              ConnectionState.waiting ||
                          revenueSnapshot.connectionState ==
                              ConnectionState.waiting ||
                          routesSnapshot.connectionState ==
                              ConnectionState.waiting)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: Colors.white,
                              child: ListTile(
                                title: Text(
                                  'Cash Flow',
                                  style: TextStyle(
                                      color: Color.fromRGBO(170, 44, 94, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(170, 44, 94, 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          "Cash In\n${cashSnapshot.data.data()['cashIn'].round()} EGP",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          "Cash Out\n${cashSnapshot.data.data()['cashOut'].round()} EGP",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          "NET\n${cashSnapshot.data.data()['net'].round()} EGP",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 2.2,
                              child: allDocs.length == 0
                                  ? Center(
                                      child: Text(
                                      'No Cashed Item, Just Shortage in cash out and excess in cash in',
                                      style: TextStyle(
                                          color: Color.fromRGBO(170, 44, 94, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26),
                                    ))
                                  : ListView.builder(
                                      itemBuilder: (ctx, index) {
                                        print('data: ${allDocs[index].data}');
                                        final path = allDocs[index]
                                            .reference
                                            .path
                                            .split(
                                                '${cashSnapshot.data.documentID}/')[1]
                                            .split('/')[0];
                                        print('path $path');

                                        if (path == 'routes') {
                                          final userName =
                                              allDocs[index].data()['name'];
                                          final supplier = 'Distribution Route';
                                          final date =
                                              allDocs[index].data()['date'];
                                          final amount = allDocs[index]
                                                  .data()['totalAmount'] -
                                              allDocs[index].data()['fees'];
                                          return routeCashFlowTile(
                                            userName: userName,
                                            suplierName: supplier,
                                            date: date,
                                            amount: amount,
                                            fee: allDocs[index].data()['fees'],
                                            total: allDocs[index]
                                                .data()['totalAmount'],
                                            documentId:
                                                allDocs[index].documentID,
                                            index: index,
                                          );
                                        } else if (path == 'expenses') {
                                          print('its an expenses');
                                          final userName =
                                              allDocs[index].data()['userName'];
                                          final supplier =
                                              allDocs[index].data()['supplier'];
                                          final date =
                                              allDocs[index].data()['date'];
                                          final amount =
                                              allDocs[index].data()['amount'];
                                          print('its an expenses2');

                                          return expensesCashFlowTile(
                                            userName: userName,
                                            suplierName: supplier,
                                            date: date,
                                            amount: amount,
                                            documentId:
                                                allDocs[index].documentID,
                                            index: index,
                                          );
                                        } else if (path == 'revenue') {
                                          final userName =
                                              allDocs[index].data()['userName'];
                                          final supplier =
                                              allDocs[index].data()['source'];
                                          final date =
                                              allDocs[index].data()['date'];
                                          final amount =
                                              allDocs[index].data()['amount'];

                                          return revenueCashFlowTile(
                                            userName: userName,
                                            suplierName: supplier,
                                            date: date,
                                            amount: amount,
                                            documentId:
                                                allDocs[index].documentID,
                                            index: index,
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                      itemCount: allDocs.length),
                            ),
                          ],
                        ),
                      );
                    });
              },
            );
          },
        ),
      ),
    );
  }

  expensesCashFlowTile({
    String suplierName,
    String userName,
    String date,
    amount,
    String documentId,
    index,
  }) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed('/expensesDetails', arguments: {'id': documentId}),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 2.5,
              color: Colors.black,
            ),
            color: Colors.white,
          ),
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: RichText(
                        text: TextSpan(
                      text: "${suplierName}\n",
                      children: [
                        TextSpan(
                          text: '${userName}\n',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '${date}',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                      ],
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            '${amount} EGP',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Color.fromRGBO(170, 44, 94, 1),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  revenueCashFlowTile({
    String suplierName,
    String userName,
    String date,
    amount,
    fee,
    total,
    String documentId,
    index,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: 2.5,
            color: Color.fromRGBO(170, 44, 94, 1),
          ),
          color: Colors.white,
        ),
        width: MediaQuery.of(context).size.width,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: RichText(
                      text: TextSpan(
                    text: "${suplierName}\n",
                    children: [
                      TextSpan(
                        text: '${userName}\n',
                        style: TextStyle(
                          color: Color.fromRGBO(96, 125, 129, 1),
                        ),
                      ),
                      TextSpan(
                        text: '${date}',
                        style: TextStyle(
                            color: Color.fromRGBO(96, 125, 129, 1),
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ],
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(170, 44, 94, 1)),
                  )),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '${amount.round()} EGP',
                          style: TextStyle(
                              color: Color.fromRGBO(170, 44, 94, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Color.fromRGBO(170, 44, 94, 1),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  routeCashFlowTile({
    String suplierName,
    String userName,
    String date,
    amount,
    fee,
    total,
    String documentId,
    index,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('routeItemDetails', arguments: {
          'docId': documentId,
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 2.5,
              color: Color.fromRGBO(170, 44, 94, 1),
            ),
            color: Colors.white,
          ),
          width: MediaQuery.of(context).size.width,
          child: Container(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: RichText(
                        text: TextSpan(
                      text: "${suplierName}\n",
                      children: [
                        TextSpan(
                          text: '${userName}\n',
                          style: TextStyle(
                            color: Color.fromRGBO(96, 125, 129, 1),
                          ),
                        ),
                        TextSpan(
                          text: '${date}',
                          style: TextStyle(
                              color: Color.fromRGBO(96, 125, 129, 1),
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                      ],
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(170, 44, 94, 1)),
                    )),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            '${amount.round()} EGP',
                            style: TextStyle(
                                color: Color.fromRGBO(170, 44, 94, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Color.fromRGBO(170, 44, 94, 1),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
