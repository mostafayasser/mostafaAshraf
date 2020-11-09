import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';

class AutoCashFlow extends StatefulWidget {
  @override
  _AutoCashFlowState createState() => _AutoCashFlowState();
}

class _AutoCashFlowState extends State<AutoCashFlow> {
  double cashOut = 0;
  double cashIn = 0;
  double net = 0;
  List<DocumentSnapshot> allDocs = [];
  List<DocumentSnapshot> savedDocs = [];
  TextEditingController collectedAmount = TextEditingController();
  bool done = false;
  var shortage = 0.0;
  var excess = 0.0;
  int shortageIndex = 0;
  int excessIndex = 0;

  bool called = false;
  @override
  Widget build(BuildContext context) {
    if (!done) {
      Firestore.instance
          .collection('myInfo')
          .document('info')
          .get()
          .then((value) {
        var money = value.data()['cashMoney'];
        var cash = value.data()['cashed'];
        cashIn += cash;
        cashOut += money;
        shortage += money;
        excess += cash;
        if (shortage > 0)
          shortageIndex = 1;
        else
          shortageIndex = 0;

        if (excess > 0)
          excessIndex = 1;
        else
          excessIndex = 0;
        print('shortage:$cashOut');
        print('shortage:$shortage');
        done = true;
        setState(() {
          done = true;
        });
      });
    }
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: BottomNavigator(),
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
            .collection('expenses')
            .where('status', isEqualTo: 'notApproved')
            .snapshots(),
        builder: (context, expensesSnapshot) {
          if (expensesSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final expensesDocs = expensesSnapshot.data.documents;
          expensesDocs.sort((a, b) => (a.data()['time'] as Timestamp)
              .compareTo((b.data()['time'] as Timestamp)));
          return StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('routes')
                .where('status', isEqualTo: 'shipped')
                .snapshots(),
            builder: (context, routesSnapshot) {
              if (routesSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              print('in:$cashIn');
              print('out$cashOut');
              //net = cashIn - cashOut;

              final routesDocs = routesSnapshot.data.documents;
              routesDocs.sort((a, b) => (a.data()['time'] as Timestamp)
                  .compareTo((b.data()['time'] as Timestamp)));
              return StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection('revenue')
                      .where('status', isEqualTo: 'notApproved')
                      .snapshots(),
                  builder: (context, revenueSnapshot) {
                    if (revenueSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final revenueDocs = revenueSnapshot.data.documents;
                    revenueDocs.sort((a, b) => (a.data()['time'] as Timestamp)
                        .compareTo((b.data()['time'] as Timestamp)));
                    if (revenueSnapshot.connectionState ==
                            ConnectionState.waiting ||
                        routesSnapshot.connectionState ==
                            ConnectionState.waiting ||
                        expensesSnapshot.connectionState ==
                            ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    allDocs = routesDocs + expensesDocs + revenueDocs;
                    if (!called) {
                      routesDocs.forEach((element) {
                        cashIn += element.data()['totalAmount'] -
                            element.data()['fees'];
                      });
                      expensesDocs.forEach((element) {
                        cashOut += element.data()['amount'];
                      });
                      revenueDocs.forEach((element) {
                        cashIn += element.data()['amount'];
                      });
                      called = true;
                    }

                    print(cashIn);
                    savedDocs = allDocs;
                    print('length1:${expensesSnapshot.data.documents.length}');
                    print('length2:${routesSnapshot.data.documents.length}');
                    print('length3:${revenueSnapshot.data.documents.length}');

                    print(allDocs.length + shortageIndex);
                    print(
                        'All indexess:${allDocs.length + shortageIndex + excessIndex}');

                    return Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Colors.white,
                          child: ListTile(
                            title: Text(
                              'Automatic Cash Flow',
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
                                      "Cash Out\n${cashOut.round()} EGP",
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
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                                      "NET\n${(cashIn - cashOut).round()} EGP",
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
                          height: MediaQuery.of(context).size.height / 2.4,
                          child: allDocs.length + shortageIndex + excessIndex ==
                                  0
                              ? Center(
                                  child: Text(
                                  'No Cash Flow Exist!!',
                                  style: TextStyle(
                                      color: Color.fromRGBO(170, 44, 94, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26),
                                ))
                              : ListView.builder(
                                  itemBuilder: (ctx, index) {
                                    if ((shortageIndex == 1 &&
                                            excessIndex == 1 &&
                                            index == 1) ||
                                        (shortageIndex == 1 &&
                                            excessIndex == 0 &&
                                            index == 0)) {
                                      print('shortagessss');
                                      return expensesAutoCashFlowTile(
                                        userName: 'Shortage',
                                        suplierName: '',
                                        date: '',
                                        amount: '${shortage}',
                                        isSelcted: false,
                                      );
                                    }

                                    if ((excessIndex == 1 && index == 0)) {
                                      print('Excessesss');
                                      return revenueAutoCashFlowTile(
                                        userName: 'Excess',
                                        suplierName: '',
                                        date: '',
                                        amount: excess,
                                        isSelcted: false,
                                      );
                                    }
                                    print(index);
                                    index -= shortageIndex;
                                    index -= excessIndex;
                                    print('data: ${allDocs[index].data}');

                                    final path = allDocs[index]
                                        .reference
                                        .path
                                        .split('/')[0];
                                    print(index);
                                    savedDocs.forEach((element) {
                                      print(element.data);
                                    });
                                    if (path == 'routes') {
                                      final userName =
                                          allDocs[index].data()['name'];
                                      final supplier = 'Distribution Route';
                                      final date =
                                          allDocs[index].data()['date'];
                                      final amount =
                                          allDocs[index].data()['totalAmount'] -
                                              allDocs[index].data()['fees'];
                                      return routeAutoCashFlowTile(
                                        userName: userName,
                                        suplierName: supplier,
                                        date: date,
                                        amount: amount,
                                        fee: allDocs[index].data()['fees'],
                                        total: allDocs[index]
                                            .data()['totalAmount'],
                                        documentId: allDocs[index].documentID,
                                        index: index,
                                        isSelcted: savedDocs.indexWhere((ele) =>
                                                ele.documentID ==
                                                allDocs[index].documentID) ==
                                            -1,
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

                                      return expensesAutoCashFlowTile(
                                        userName: userName,
                                        suplierName: supplier,
                                        date: date,
                                        amount: amount,
                                        documentId: allDocs[index].documentID,
                                        index: index,
                                        isSelcted: savedDocs.indexWhere((ele) =>
                                                ele.documentID ==
                                                allDocs[index].documentID) ==
                                            -1,
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

                                      return revenueAutoCashFlowTile(
                                        userName: userName,
                                        suplierName: supplier,
                                        date: date,
                                        amount: amount,
                                        documentId: allDocs[index].documentID,
                                        index: index,
                                        isSelcted: savedDocs.indexWhere((ele) =>
                                                ele.documentID ==
                                                allDocs[index].documentID) ==
                                            -1,
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                  itemCount: allDocs.length +
                                      shortageIndex +
                                      excessIndex),
                        ),
                        InkWell(
                          onTap: () async {
                            net = cashIn - cashOut;
                            final amountCollected = await showDialog<double>(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Collected Amount?'),
                                  content: net >= 0
                                      ? TextField(
                                          controller: collectedAmount,
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.5),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              labelText: 'Collected:'),
                                        )
                                      : Text('Do you want to processed?'),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        collectedAmount.clear();
                                        Navigator.of(context).pop(null);
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    FlatButton(
                                        onPressed: () async {
                                          final collected = net >= 0
                                              ? double.parse(
                                                  collectedAmount.text)
                                              : 0.0;
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
                              showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        title: Text('Validation Error'),
                                        content: Text(
                                            'You must add the collected amount'),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: Text('Ok!'))
                                        ],
                                      ));
                              return;
                            }

                            if (amountCollected == (cashIn - cashOut)) {
                              print('clear');
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Successed'),
                                  content: Text(
                                      'The Cashes were collected Succefuly'),
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
                              final result = await Firestore.instance
                                  .collection('AutoCashFlow')
                                  .add({
                                'cashIn': cashIn,
                                'cashOut': cashOut,
                                'net': net,
                                'date': DateFormat.yMd().format(DateTime.now()),
                                'time': DateTime.now(),
                              });
                              Firestore.instance
                                  .collection('myInfo')
                                  .document('info')
                                  .updateData({'cashMoney': 0, 'cashed': 0});
                              savedDocs.forEach((element) {
                                if (element.reference.path.split('/')[0] ==
                                    'revenue') {
                                  Firestore.instance
                                      .collection('AutoCashFlow')
                                      .document(result.documentID)
                                      .collection('revenue')
                                      .document(element.documentID)
                                      .setData(element.data());
                                  Firestore.instance
                                      .collection('revenue')
                                      .document(element.documentID)
                                      .updateData({
                                    'status': 'approved',
                                  });
                                } else if (element.reference.path
                                        .split('/')[0] ==
                                    'expenses') {
                                  Firestore.instance
                                      .collection('AutoCashFlow')
                                      .document(result.documentID)
                                      .collection('expenses')
                                      .document(element.documentID)
                                      .setData(element.data());
                                  Firestore.instance
                                      .collection('expenses')
                                      .document(element.documentID)
                                      .updateData({
                                    'status': 'approved',
                                  });
                                } else if (element.reference.path
                                        .split('/')[0] ==
                                    'routes') {
                                  Firestore.instance
                                      .collection('AutoCashFlow')
                                      .document(result.documentID)
                                      .collection('routes')
                                      .document(element.documentID)
                                      .setData(element.data());

                                  final expensesDocument = {
                                    'userName': element.data()['name'],
                                    'date': element.data()['date'],
                                    'supplier': 'Cairo Distribution fee',
                                    'amount': element.data()['fees'],
                                    'status': 'approved',
                                    'attachments': [],
                                    'note': [],
                                    'type': 'Cash',
                                    'time': DateTime.now(),
                                  };

                                  final revenueDocument = {
                                    'userName': element.data()['name'],
                                    'date': element.data()['date'],
                                    'source': 'Cairo Distribution revenue',
                                    'amount': element.data()['totalAmount'],
                                    'status': 'approved',
                                    'isCairo': true,
                                    'time': DateTime.now(),
                                  };

                                  Firestore.instance
                                      .collection('expenses')
                                      .add(expensesDocument);
                                  print('expeses are added');
                                  Firestore.instance
                                      .collection('revenue')
                                      .add(revenueDocument);
                                  print('revenue are added');

                                  Firestore.instance
                                      .collection('routes')
                                      .document(element.documentID)
                                      .updateData({
                                    'status': 'collected',
                                  });
                                }
                              });
                            } else {
                              print('bad');
                              print(cashIn);
                              print(cashOut);
                              print(amountCollected);
                              double loan = cashIn - cashOut - amountCollected;
                              print(loan);
                              final type = await showDialog(
                                context: context,
                                barrierDismissible: false,
                                child: AlertDialog(
                                  title: Text('Budget deficit'),
                                  content:
                                      Text('The deficit equal${loan.abs()}'),
                                  actions: <Widget>[
                                    FlatButton.icon(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      icon: Icon(Icons.attach_money),
                                      label: Text('Save for another Cash Flow'),
                                    ),
                                    FlatButton.icon(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      icon: Icon(Icons.person),
                                      label: (amountCollected > net && net >= 0)
                                          ? Text('Remove a Loan')
                                          : Text('Save as a Loan'),
                                    ),
                                  ],
                                ),
                              );
                              if (type == null) return;
                              final result = await Firestore.instance
                                  .collection('AutoCashFlow')
                                  .add({
                                'cashIn': cashIn,
                                'cashOut': cashOut,
                                'net': net,
                                'date': DateFormat.yMd().format(DateTime.now()),
                                'time': DateTime.now(),
                              });
                              savedDocs.forEach((element) {
                                if (element.reference.path.split('/')[0] ==
                                    'revenue') {
                                  Firestore.instance
                                      .collection('AutoCashFlow')
                                      .document(result.documentID)
                                      .collection('revenue')
                                      .document(element.documentID)
                                      .setData(element.data());
                                  Firestore.instance
                                      .collection('revenue')
                                      .document(element.documentID)
                                      .updateData({
                                    'status': 'approved',
                                  });
                                } else if (element.reference.path
                                        .split('/')[0] ==
                                    'expenses') {
                                  Firestore.instance
                                      .collection('AutoCashFlow')
                                      .document(result.documentID)
                                      .collection('expenses')
                                      .document(element.documentID)
                                      .setData(element.data());
                                  Firestore.instance
                                      .collection('expenses')
                                      .document(element.documentID)
                                      .updateData({
                                    'status': 'approved',
                                  });
                                } else if (element.reference.path
                                        .split('/')[0] ==
                                    'routes') {
                                  Firestore.instance
                                      .collection('AutoCashFlow')
                                      .document(result.documentID)
                                      .collection('routes')
                                      .document(element.documentID)
                                      .setData(element.data());
                                  final expensesDocument = {
                                    'userName': element.data()['name'],
                                    'date': element.data()['date'],
                                    'supplier': 'Cairo Distribution fee',
                                    'amount': element.data()['fees'],
                                    'status': 'approved',
                                    'attachments': [],
                                    'note': [],
                                    'type': 'Cash',
                                    'time': DateTime.now(),
                                  };

                                  final revenueDocument = {
                                    'userName': element.data()['name'],
                                    'date': element.data()['date'],
                                    'source': 'Cairo Distribution revenue',
                                    'amount': element.data()['totalAmount'],
                                    'status': 'approved',
                                    'isCairo': true,
                                    'time': DateTime.now()
                                  };

                                  Firestore.instance
                                      .collection('expenses')
                                      .add(expensesDocument);
                                  print('expeses are added');
                                  Firestore.instance
                                      .collection('revenue')
                                      .add(revenueDocument);
                                  print('revenue are added');
                                  Firestore.instance
                                      .collection('routes')
                                      .document(element.documentID)
                                      .updateData({
                                    'status': 'collected',
                                  });
                                }
                              });

                              if (type && amountCollected > net && net < 0) {
                                await action1(context);
                              } else if (type &&
                                  amountCollected > net &&
                                  net > 0) {
                                await action2(context, amountCollected);
                                Navigator.of(context).pop();
                              } else if (type && amountCollected < net) {
                                await action3(context, amountCollected);
                                Navigator.of(context).pop();
                              } else if (!type &&
                                  amountCollected > net &&
                                  net < 0) {
                                Firestore.instance
                                    .collection('myInfo')
                                    .document('info')
                                    .updateData({
                                  'cashMoney': net.abs(),
                                  'cashed': 0
                                }).then((value) => Navigator.of(context).pop());
                              } else if (!type &&
                                  amountCollected > net &&
                                  net >= 0) {
                                Firestore.instance
                                    .collection('myInfo')
                                    .document('info')
                                    .updateData({
                                  'cashMoney': 0,
                                  'cashed': amountCollected - net
                                }).then((value) => Navigator.of(context).pop());
                              } else {
                                Firestore.instance
                                    .collection('myInfo')
                                    .document('info')
                                    .updateData({
                                  'cashMoney': net - amountCollected,
                                  'cashed': 0
                                }).then((value) => Navigator.of(context).pop());
                              }
                            }
                            setState(() {
                              cashIn = 0;
                              cashOut = 0;
                              net = 0;
                              shortageIndex = 0;
                              excessIndex = 0;
                            });
                          },
                          child: Container(
                            color: Color.fromRGBO(170, 44, 94, 1),
                            width: double.infinity,
                            height: 50,
                            child: Center(
                              child: Text(
                                'Collect',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  });
            },
          );
        },
      ),
    );
  }

  Future action3(BuildContext context, double amountCollected) async {
    Firestore.instance
        .collection('myInfo')
        .document('info')
        .updateData({'cashMoney': 0, 'cashed': 0});
    final done = await Navigator.of(context)
        .pushNamed('/addLoans', arguments: {'money': net - amountCollected});
    if (done == null || !done) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Validation Error'),
          content: Text('The loan must be added to an employee'),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK!'))
          ],
        ),
      );
      return action3(context, amountCollected);
    } else {
      Navigator.of(context).pop();

      return;
    }
  }

  Future action2(BuildContext context, double amountCollected) async {
    Firestore.instance
        .collection('myInfo')
        .document('info')
        .updateData({'cashMoney': 0, 'cashed': 0});
    final done = await Navigator.of(context).pushNamed('/loans',
        arguments: {'money': amountCollected - net, 'type': 2});
    if (done == null || !done) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Validation Error'),
          content: Text('The loan must be added to an employee'),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK!'))
          ],
        ),
      );
      return action2(context, amountCollected);
    } else {
      Navigator.of(context).pop();

      return;
    }
  }

  Future action1(BuildContext context) async {
    Firestore.instance
        .collection('myInfo')
        .document('info')
        .updateData({'cashMoney': 0, 'cashed': 0});
    final done = await Navigator.of(context)
        .pushNamed('/addLoans', arguments: {'money': net.abs()});
    if (done == null || !done) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Validation Error'),
          content: Text('The loan must be added to an employee'),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK!'))
          ],
        ),
      );
      return action1(context);
    } else {
      Navigator.of(context).pop();
      return;
    }
  }

  expensesAutoCashFlowTile(
      {String suplierName,
      String userName,
      String date,
      amount,
      String documentId,
      index,
      bool isSelcted}) {
    return InkWell(
      onTap: () {
        if (userName == 'Shortage') return;
        Navigator.of(context)
            .pushNamed('/expensesDetails', arguments: {'id': documentId});
      },
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
                      isSelcted
                          ? InkWell(
                              onTap: () async {
                                /*await Firestore.instance
                              .collection('expenses')
                              .document(documentId)
                              .updateData({
                            'approved': true,
                          });*/
                                cashOut += amount;
                                savedDocs.add(allDocs[index]);
                                await showDialog(
                                    context: context,
                                    child: AlertDialog(
                                      title: Text('Confirmed'),
                                      content:
                                          Text('This item has been confirmed'),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Ok'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    ));
                                setState(() {});
                              },
                              child: Container(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "ADD",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(170, 44, 94, 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            )
                          : SizedBox()
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

  revenueAutoCashFlowTile({
    String suplierName,
    String userName,
    String date,
    amount,
    fee,
    total,
    String documentId,
    index,
    bool isSelcted,
  }) {
    print('isItEnable$isSelcted');
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
                    isSelcted
                        ? InkWell(
                            onTap: () async {
                              /* await Firestore.instance
                            .collection('revenue')
                            .document(documentId)
                            .updateData({
                          'status': 'approved',
                        });*/
                              cashIn += amount.round();
                              savedDocs.add(allDocs[index]);

                              await showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    title: Text('Confirmed'),
                                    content:
                                        Text('This item has been confirmed'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  ));
                              setState(() {});
                            },
                            child: Container(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "ADD",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(170, 44, 94, 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  routeAutoCashFlowTile({
    String suplierName,
    String userName,
    String date,
    amount,
    fee,
    total,
    String documentId,
    index,
    bool isSelcted,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/routeItemDetails', arguments: {
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
                      isSelcted
                          ? InkWell(
                              onTap: () async {
                                cashIn += amount.round();
                                /* await Firestore.instance
                              .collection('routes')
                              .document(documentId)
                              .updateData({
                            'status': 'collected',
                          });*/
                                savedDocs.add(allDocs[index]);

                                await showDialog(
                                    context: context,
                                    child: AlertDialog(
                                      title: Text('Confirmed'),
                                      content:
                                          Text('This item has been confirmed'),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Ok'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    ));
                                setState(() {});
                              },
                              child: Container(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      "ADD",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(170, 44, 94, 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            )
                          : SizedBox()
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
