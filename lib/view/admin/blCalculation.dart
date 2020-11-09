import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';
import 'package:provider/provider.dart';

class BlCalc extends StatefulWidget {
  @override
  _BlCalcState createState() => _BlCalcState();
}

class _BlCalcState extends State<BlCalc> {
  TextEditingController collectedAmount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double cashIn = 0;
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
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('orders')
            .where('status', isEqualTo: 'cashed')
            .snapshots(),
        builder: (context, orderSnapshot) {
          if (orderSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final docs = orderSnapshot.data.documents;
          docs.sort((a, b) => (a.data()['time'] as Timestamp)
              .compareTo((b.data()['time'] as Timestamp)));
          orderSnapshot.data.documents.forEach((element) {
            cashIn += element['totalAccount'];
          });
          print('in:$cashIn');
          //net = cashIn - cashOut;
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    'B/L Calculation',
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
                            "Cash In\n${cashIn.round()} EGP",
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
                            "${orderSnapshot.data.documents.length} Orders",
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
              Expanded(
                child: orderSnapshot.data.documents.length == 0
                    ? Center(
                        child: Text(
                        'No Orders Exist!!',
                        style: TextStyle(
                            color: Color.fromRGBO(170, 44, 94, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 26),
                      ))
                    : ListView.builder(
                        itemBuilder: (ctx, index) {
                          final userName = orderSnapshot.data.documents[index]
                              .data()['name'];
                          final supplier = 'Cities Orders';
                          final date = orderSnapshot.data.documents[index]
                              .data()['createdAt'];
                          final amount = orderSnapshot.data.documents[index]
                              .data()['totalAccount'];
                          return revenueBlCalcTile(
                            userName: userName,
                            suplierName: supplier,
                            date: date,
                            amount: amount,
                            documentId:
                                orderSnapshot.data.documents[index].documentID,
                          );
                        },
                        itemCount: orderSnapshot.data.documents.length,
                      ),
              ),
              InkWell(
                onTap: () async {
                  final amountCollected = await showDialog<double>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Collected Amount?'),
                        content: TextField(
                          controller: collectedAmount,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.5),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              labelText: 'Collected:'),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              collectedAmount.clear();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          FlatButton(
                              onPressed: () async {
                                final collected =
                                    double.parse(collectedAmount.text);
                                collectedAmount.clear();
                                Navigator.of(context).pop(collected);
                              },
                              child: Text(
                                'Send',
                                style: TextStyle(color: Colors.green),
                              ))
                        ],
                      );
                    },
                  );
                  if (amountCollected == null) {
                    print('not clear');
                    return;
                  }
                  if (amountCollected == cashIn) {
                    print('clear');
                    orderSnapshot.data.documents.forEach((element) async {
                      await Firestore.instance
                          .collection('orders')
                          .document(element.documentID)
                          .updateData({'status': 'collected'});
                      await Firestore.instance.collection('revenue').add({
                        'source': 'Cities Distribution revenue',
                        'userName': user.name,
                        'status': 'approved',
                        'isCairo': false,
                        'amount': element.data()['totalAccount'],
                        'date': DateFormat.yMd().format(DateTime.now()),
                        'time': DateTime.now(),
                      });
                    });
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Successed'),
                        content: Text('The Cashes were collected Succefuly'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              collectedAmount.clear();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Ok',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                    return;
                  } else {
                    print('not good not totaly good');

                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Fiscal deficit'),
                        content: Text('There is a loan has to be determined'),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed('/addLoans', arguments: {
                                'money': '${cashIn - amountCollected}',
                              });
                            },
                            child: Text(
                              'Ok',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Container(
                  color: Color.fromRGBO(170, 44, 94, 1),
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text(
                      'Collect',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }

  revenueBlCalcTile({
    String suplierName,
    String userName,
    String date,
    amount,
    String documentId,
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
                          '${amount} EGP',
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
}
