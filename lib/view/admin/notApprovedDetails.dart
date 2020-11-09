import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';

class NotApprovedDetails extends StatefulWidget {
  @override
  _ApprovedDetailsState createState() => _ApprovedDetailsState();
}

class _ApprovedDetailsState extends State<NotApprovedDetails> {
  Map filterData;

  @override
  Widget build(BuildContext context) {
    final map = ModalRoute.of(context).settings.arguments as Map;
    Stream revenuetream;
    print('This is Not Approved revenue');
    if (map != null) {
      if (map['type'] == 1) {
        revenuetream = Firestore.instance
            .collection('revenue')
            .where('date', isEqualTo: map['date'])
            .where('status', isEqualTo: 'notApproved')
            .snapshots();
      } else if (map['type'] == 2) {
        revenuetream = Firestore.instance
            .collection('revenue')
            .where('userName', isEqualTo: map['date'])
            .where('status', isEqualTo: 'notApproved')
            .snapshots();
      } else if (map['type'] == 3) {
        print('cairo');
        revenuetream = Firestore.instance
            .collection('revenue')
            .where('isCairo', isEqualTo: true)
            .where('status', isEqualTo: 'notApproved')
            .snapshots();
      } else if (map['type'] == 4) {
        print('Cities');
        revenuetream = Firestore.instance
            .collection('revenue')
            .where('isCairo', isEqualTo: false)
            .where('status', isEqualTo: 'notApproved')
            .snapshots();
      } else {
        revenuetream = Firestore.instance
            .collection('revenue')
            .where('status', isEqualTo: 'notApproved')
            .snapshots();
      }
    } else {
      revenuetream = Firestore.instance
          .collection('revenue')
          .where('status', isEqualTo: 'notApproved')
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
          actions: [
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
        body: Container(
            child: ListView(children: [
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
            ),
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: revenuetream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<DocumentSnapshot> docs = snapshot.data.documents;
                docs.forEach((element) {
                  print('docs:${element.data}');
                });
                docs.sort((a, b) {
                  if (a.data()['time'] == null) return -1;
                  if (b.data()['time'] == null) return 1;
                  return (a.data()['time'] as Timestamp).compareTo(
                    (b.data()['time'] as Timestamp),
                  );
                });
                if (filterData != null &&
                    (filterData['month'] as int) != null &&
                    (filterData['month'] as int) > 0) {
                  final month = filterData['month'] as int;
                  print(month);
                  print(docs.length);
                  docs.removeWhere((element) {
                    return !((element.data()['time'] as Timestamp)
                            .toDate()
                            .month ==
                        month);
                  });
                  print(docs.length);
                }
                docs.forEach((element) {
                  print('docs:${element.data}');
                });
                return ListView.builder(
                  itemBuilder: (ctx, index) {
                    print(index);
                    final userName = docs[index].data()['userName'];
                    final supplier = docs[index].data()['supplier'];
                    final date = docs[index].data()['date'];
                    final amount = docs[index].data()['amount'];
                    return approvedTile(supplier, userName, date, amount,
                        docs[index].documentID);
                  },
                  itemCount: docs.length,
                );
              })
        ])));
  }

  approvedTile(String suplierName, String userName, Timestamp itemStamp, amount,
      String id) {
    DateTime itemDate = itemStamp.toDate();
    String date = DateFormat.yMd().format(itemDate);
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed('/expensesDetails', arguments: {'id': id}),
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
                      Container(
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
                      )
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
