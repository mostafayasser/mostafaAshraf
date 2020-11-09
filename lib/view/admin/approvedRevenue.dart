import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';

class ApprovedRevenue extends StatefulWidget {
  @override
  _ApprovedRevenueState createState() => _ApprovedRevenueState();
}

class _ApprovedRevenueState extends State<ApprovedRevenue> {
  bool isCalled = false;
  Map filterData;
  User user;
  final searchController = TextEditingController();
  bool isSearch = false;
  bool searched = false;
  List<String> recomendations = [];
  String selected = '';
  Stream revenuetream;

  final revenueKey = new GlobalKey<AutoCompleteTextFieldState<String>>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final map = ModalRoute.of(context).settings.arguments as Map;
    var totalCash = 0.0;
    if (!searched) {
      if (map != null) {
        if (map['type'] == 1) {
          revenuetream = Firestore.instance
              .collection('revenue')
              .where('date', isEqualTo: map['date'])
              .where('status', isEqualTo: 'approved')
              .snapshots();
        } else if (map['type'] == 2) {
          revenuetream = Firestore.instance
              .collection('revenue')
              .where('userName', isEqualTo: map['date'])
              .where('status', isEqualTo: 'approved')
              .snapshots();
        } else if (map['type'] == 3) {
          print('cairo');
          revenuetream = Firestore.instance
              .collection('revenue')
              .where('isCairo', isEqualTo: true)
              .where('status', isEqualTo: 'approved')
              .snapshots();
        } else if (map['type'] == 4) {
          print('Cities');
          revenuetream = Firestore.instance
              .collection('revenue')
              .where('isCairo', isEqualTo: false)
              .where('status', isEqualTo: 'approved')
              .snapshots();
        } else {
          revenuetream = Firestore.instance
              .collection('revenue')
              .where('status', isEqualTo: 'approved')
              .snapshots();
        }
      } else {
        revenuetream = Firestore.instance
            .collection('revenue')
            .where('status', isEqualTo: 'approved')
            .snapshots();
      }
    }
    return FutureBuilder<DocumentSnapshot>(
        future:
            Firestore.instance.collection('myInfo').document('revenue').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !isCalled) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!isCalled) {
            recomendations.addAll((snapshot.data.data()['sources'] as List)
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
                            Firestore.instance.collection('revenue');

                        orderquery = Firestore.instance
                            .collection('revenue')
                            .where('source', isEqualTo: item);

                        revenuetream = orderquery.snapshots();
                        isSearch = false;
                        selected = item;

                        setState(() => searched = true);
                      },
                      textSubmitted: (item) {
                        Query orderquery =
                            Firestore.instance.collection('revenue');

                        orderquery = Firestore.instance
                            .collection('revenue')
                            .where('source', isEqualTo: item);

                        revenuetream = orderquery.snapshots();
                        isSearch = false;
                        selected = item;

                        setState(() => searched = true);
                      },
                      textChanged: (item) {
                        print('itesmss:$item');
                        selected = item;
                      },
                      key: revenueKey,
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
                InkWell(
                  onTap: () {
                    setState(() {
                      isSearch = !isSearch;
                      searched = !searched;
                    });
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
              stream: revenuetream,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !isCalled)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                final docs = snapshot.data.documents;
                docs.sort((a, b) {
                  if (a.data()['time'] == null) return -1;
                  if (b.data()['time'] == null) return 1;
                  return (a.data()['time'] as Timestamp)
                      .compareTo((b.data()['time'] as Timestamp));
                });
                if (filterData != null &&
                    (filterData['month'] as int) != null &&
                    (filterData['month'] as int) > 0) {
                  final month = filterData['month'] as int;
                  print(month);
                  print(docs.length);
                  docs.removeWhere((element) {
                    return !((element.data()['time'] as Timestamp) == null
                        ? true
                        : (element.data()['time'] as Timestamp)
                                .toDate()
                                .month ==
                            month);
                  });
                  print(docs.length);
                }
                totalCash = 0.0;
                docs.forEach((element) {
                  final amount = element.data()['amount'];
                  totalCash += amount;
                });
                isCalled = true;
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
                            'Approved',
                            style: TextStyle(
                                color: Color.fromRGBO(170, 44, 94, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          trailing: Text('$totalCash EGP',
                              style: TextStyle(
                                  color: Color.fromRGBO(170, 44, 94, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: ListView.builder(
                        itemBuilder: (ctx, index) {
                          final userName = docs[index].data()['userName'];
                          final supplier = docs[index].data()['source'];
                          final date = docs[index].data()['date'];
                          final amount = docs[index].data()['amount'];
                          return approvedTile(
                            userName: userName,
                            suplierName: supplier,
                            date: date,
                            amount: (amount).round(),
                            documentId: docs[index].documentID,
                          );
                        },
                        itemCount: docs.length,
                      )),
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  approvedTile(
      {String suplierName,
      String userName,
      String date,
      amount,
      String documentId}) {
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
