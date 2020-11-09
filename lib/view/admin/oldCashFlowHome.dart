import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';

class OldCashFlowHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(children: [
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  leading: Image.asset(
                    'assets/images/CashFlow.png',
                    width: 50,
                    height: 50,
                  ),
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
                height: 10,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream:
                        Firestore.instance.collection('cashFlow').snapshots(),
                    builder: (context, snapshot) {
                      print(snapshot.data.documents.length);
                      return ListView.builder(
                        itemBuilder: (ctx, index) {
                          print(index);
                          final net =
                              snapshot.data.documents[index].data()['net'];
                          final cashIn =
                              snapshot.data.documents[index].data()['cashIn'];
                          final date =
                              snapshot.data.documents[index].data()['date'];
                          final cashOut =
                              snapshot.data.documents[index].data()['cashOut'];
                          return approvedTile(
                              date,
                              cashIn,
                              cashOut,
                              net,
                              snapshot.data.documents[index].documentID,
                              context);
                        },
                        itemCount: snapshot.data.documents.length,
                      );
                    }),
              )
            ])));
  }

  approvedTile(String date, cashIn, cashOut, net, String id, context) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed('/oldCashFlow', arguments: {'id': id}),
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
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: RichText(
                            text: TextSpan(
                          text: "$date",
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
                                '$net EGP',
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
                  Divider(
                    thickness: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Cash In: ${cashIn.round()} EGP',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      VerticalDivider(
                        thickness: 2,
                      ),
                      Text(
                        'Cash Out: ${cashOut.round()} EGP',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
