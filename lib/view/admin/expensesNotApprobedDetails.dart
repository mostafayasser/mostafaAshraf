import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';
import 'package:provider/provider.dart';

class ExpensesNotApprovedDetails extends StatefulWidget {
  @override
  _ApprovedDetailsState createState() => _ApprovedDetailsState();
}

class _ApprovedDetailsState extends State<ExpensesNotApprovedDetails> {
  User user;
  Map filterData;
  final searchController = TextEditingController();
  bool isSearch = false;
  bool searched = false;
  bool isCalled = false;
  List<String> recomendations = [];
  String selected = '';
  Stream expenseStream;

  final expensesKey = new GlobalKey<AutoCompleteTextFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final map = ModalRoute.of(context).settings.arguments as Map;
    user = Provider.of<UserProvider>(context).user;

    //searchController.text = selected;

    var totalCash = 0.0;
    if (!searched) {
      if (map['type'] == 1) {
        expenseStream = Firestore.instance
            .collection('expenses')
            .where('date', isEqualTo: map['date'])
            .where('status', isEqualTo: 'notApproved')
            .snapshots();
      } else if (map['type'] == 2) {
        expenseStream = Firestore.instance
            .collection('expenses')
            .where('userName', isEqualTo: map['date'])
            .where('status', isEqualTo: 'notApproved')
            .snapshots();
      } else if (map['type'] == 3) {
        expenseStream = Firestore.instance
            .collection('expenses')
            .where('supplier', isEqualTo: map['date'])
            .where('status', isEqualTo: 'notApproved')
            .snapshots();
      } else {
        expenseStream = Firestore.instance
            .collection('expenses')
            .where('status', isEqualTo: 'notApproved')
            .snapshots();
      }
    }
    return FutureBuilder<DocumentSnapshot>(
      future:
          Firestore.instance.collection('myInfo').document('expenses').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !isCalled) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!isCalled) {
          recomendations.addAll((snapshot.data.data()['suppliers'] as List)
              .map((e) => e.toString()));

          isCalled = true;
        }
        return Scaffold(
          bottomNavigationBar: BottomNavigator(),
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            elevation: 10,
            centerTitle: true,
            backgroundColor: Colors.white,
            title: isSearch
                ? AutoCompleteTextField<String>(
                    clearOnSubmit: true,
                    controller: searchController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.5),
                        ),
                        hintText: 'Search Order:',
                        suffixIcon: Icon(Icons.search)),
                    itemSubmitted: (item) {
                      Query orderquery =
                          Firestore.instance.collection('expenses');

                      orderquery = Firestore.instance
                          .collection('expenses')
                          .where('supplier', isEqualTo: item);

                      expenseStream = orderquery.snapshots();
                      isSearch = false;
                      selected = item;

                      setState(() => searched = true);
                    },
                    textSubmitted: (item) {
                      Query orderquery =
                          Firestore.instance.collection('expenses');

                      orderquery = Firestore.instance
                          .collection('expenses')
                          .where('supplier', isEqualTo: item);

                      expenseStream = orderquery.snapshots();
                      isSearch = false;
                      selected = item;

                      setState(() => searched = true);
                    },
                    textChanged: (item) {
                      print('itesmss:$item');
                      selected = item;
                    },
                    key: expensesKey,
                    suggestions: recomendations,
                    itemBuilder: (context, suggestion) => new Padding(
                        child: new ListTile(
                          title: new Text(suggestion),
                        ),
                        padding: EdgeInsets.all(8.0)),
                    itemFilter: (suggestion, input) => suggestion
                        .toLowerCase()
                        .startsWith(input.toLowerCase()),
                    itemSorter: (a, b) =>
                        a == b ? 0 : a.length > b.length ? -1 : 1,
                  )
                : Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                  ),
            actions: <Widget>[
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400], width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isSearch = !isSearch;
                        searched = !searched;
                      });
                    },
                    child: Icon(
                      Icons.search,
                      size: 25,
                      color: Color.fromRGBO(96, 125, 129, 1),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  filterData = await Navigator.of(context)
                      .pushNamed('/financeFilter') as Map;
                  print(filterData);
                  setState(() {});
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400], width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(
                      Icons.filter_list,
                      size: 25,
                      color: Color.fromRGBO(96, 125, 129, 1),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: expenseStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );

              final documents = snapshot.data.documents;
              documents.sort((a, b) => (a.data()['time'] as Timestamp)
                  .compareTo((b.data()['time'] as Timestamp)));
              if (filterData != null &&
                  (filterData['month'] as int) != null &&
                  (filterData['month'] as int) > 0) {
                final month = filterData['month'] as int;
                print(month);
                print(documents.length);
                documents.removeWhere((element) {
                  return !((element.data()['time'] as Timestamp)
                          .toDate()
                          .month ==
                      month);
                });
                print(documents.length);
              }
              documents.forEach((element) {
                totalCash += element.data()['amount'];
              });
              return Container(
                width: size.width,
                height: size.height,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Text(
                          'Not Approved',
                          style: TextStyle(
                              color: Color.fromRGBO(170, 44, 94, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        trailing: Text(
                          '$totalCash EGP',
                          style: TextStyle(
                              color: Color.fromRGBO(170, 44, 94, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (ctx, index) {
                          final userName = documents[index].data()['userName'];
                          final supplier = documents[index].data()['supplier'];
                          final date = documents[index].data()['date'];
                          final amount = documents[index].data()['amount'];
                          return approvedTile(
                              userName: userName,
                              suplierName: supplier,
                              date: date,
                              amount: amount,
                              documentId: documents[index].documentID,
                              isApproved:
                                  documents[index]['status'] == 'notApproved');
                        },
                        itemCount: documents.length,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  approvedTile(
      {String suplierName,
      String userName,
      String date,
      amount,
      String documentId,
      isApproved}) {
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
                      user != null && user.type == 'admin' && isApproved
                          ? InkWell(
                              onTap: () async {
                                await Firestore.instance
                                    .collection('expenses')
                                    .document(documentId)
                                    .updateData({
                                  'status': 'cashed',
                                });
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
                                  color: Colors.black,
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
