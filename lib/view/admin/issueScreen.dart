import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';
import 'package:provider/provider.dart';

class IssueScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final map = ModalRoute.of(context).settings.arguments as Map;
    Stream issueStream;
    final user = Provider.of<UserProvider>(context).user;
    if (map['type'] == 1) {
      issueStream = Firestore.instance
          .collection('issues')
          .where('isSolved', isEqualTo: false)
          .snapshots();
    } else {
      issueStream = Firestore.instance
          .collection('issues')
          .where('isSolved', isEqualTo: true)
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
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: Image.asset(
                'assets/images/Report.png',
                width: 50,
                height: 50,
              ),
              title: Text(
                'Issues',
                style: TextStyle(
                    color: Color.fromRGBO(170, 44, 94, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: issueStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                return ListView.builder(
                  itemBuilder: (ctx, index) {
                    return Slidable(
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
                                  .collection('issues')
                                  .document(
                                      snapshot.data.documents[index].documentID)
                                  .updateData({
                                'isSolved': true,
                                'solver': user.name,
                                'solvedAt': DateTime.now()
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
                                  .collection('issues')
                                  .document(
                                      snapshot.data.documents[index].documentID)
                                  .updateData({
                                'isSolved': true,
                                'solver': user.name,
                                'solvedAt': DateTime.now()
                              });
                            }
                          },
                          color: Colors.green,
                          icon: Icons.check_circle,
                          caption: 'Solved',
                        )
                      ],
                      child: approvedTile(
                          isCairo:
                              snapshot.data.documents[index].data()['isCairo'],
                          suplierName: snapshot.data.documents[index]
                              .data()['createdUser'],
                          date: snapshot.data.documents[index]
                              .data()['createdDate'],
                          userName: (snapshot.data.documents[index]
                                  .data()['isCairo'] as bool)
                              ? 'Cairo Route'
                              : 'Cities Routes',
                          context: context,
                          description: snapshot.data.documents[index]
                              .data()['description'],
                          isSolved:
                              snapshot.data.documents[index].data()['isSolved'],
                          issueNumber: snapshot.data.documents[index]
                              .data()['issueNumber'],
                          documentId:
                              snapshot.data.documents[index].data()['orderId'],
                          solver:
                              snapshot.data.documents[index].data()['solver']),
                    ); //isCairo
                  },
                  itemCount: snapshot.data.documents.length,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  approvedTile(
      {String suplierName,
      String userName,
      String date,
      description,
      String documentId,
      issueNumber,
      isSolved,
      context,
      isCairo,
      solver}) {
    return InkWell(
      onTap: () {
        if (isCairo) {
          Navigator.of(context).pushNamed('/orderDetails', arguments: {
            'docId': documentId,
          });
        } else {
          Navigator.of(context).pushNamed('/citiyOrderDetails', arguments: {
            'docId': documentId,
          });
        }
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
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      isSolved
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            )
                          : Icon(
                              Icons.info,
                              color: Colors.red,
                            ),
                      Text(
                        'Issue Number:$issueNumber',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      solver != null
                          ? Text(
                              'Solver:$solver',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            )
                          : SizedBox()
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
