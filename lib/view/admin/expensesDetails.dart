import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';
import 'package:provider/provider.dart';

//Screen 7
class ExpensesDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;
    final map = (ModalRoute.of(context).settings.arguments as Map);
    final id = map['id'];
    final user = Provider.of<UserProvider>(context, listen: false).user;
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
          future: Firestore.instance.collection('expenses').document(id).get(),
          builder: (context, snapshot) {
            final data = snapshot.data.data();
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(
                      '${data['userName']}',
                      style: TextStyle(
                          color: Color.fromRGBO(170, 44, 94, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: size.width,
                          height: height / 4.5,
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                width: 2.5,
                                color: Colors.grey[400].withOpacity(0.9)),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Supplier : ${data['supplier']}',
                                style: TextStyle(
                                    color: Color.fromRGBO(170, 44, 94, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              Text(
                                '${data['date']}',
                                style: TextStyle(
                                    color: Color.fromRGBO(96, 125, 130, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              Text(
                                'Status: ${data['status']}',
                                style: TextStyle(
                                    color: Color.fromRGBO(96, 125, 130, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ), //rgb(96, 125, 130)
                              Row(
                                children: <Widget>[
                                  Text(
                                    '${data['type']}',
                                    style: TextStyle(
                                        color: Color.fromRGBO(96, 125, 130, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    width: 35,
                                  ),
                                  Text(
                                    'Total: ${data['amount']} EGP',
                                    style: TextStyle(
                                        color: Color.fromRGBO(96, 125, 130, 1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              data['type'] == 'Cash and Credit'
                                  ? Text(
                                      'Cash:${data['cash']} EGP',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(96, 125, 130, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    )
                                  : SizedBox(),
                              data['type'] == 'Cash and Credit'
                                  ? Text(
                                      'Credit:${data['credit']} EGP',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(96, 125, 130, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                        Container(
                          width: size.width,
                          height: height * 2 / 5,
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                width: 2.5,
                                color: Colors.grey[400].withOpacity(0.9)),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Image',
                                style: TextStyle(
                                    color: Color.fromRGBO(170, 44, 94, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 3,
                                ),
                              ), //rgb(96, 125, 130)
                              Expanded(
                                  child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(224, 224, 224, 1),
                                    borderRadius: BorderRadius.circular(10)),
                                //rgb(224, 224, 224)
                                child: ClipRRect(
                                  child: PageView.builder(
                                    itemBuilder: (ctx, index) => Image.network(
                                      data['attachments'][index],
                                    ),
                                    itemCount: (data['attachments'] as List) ==
                                            null
                                        ? 0
                                        : (data['attachments'] as List).length,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ))
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Notes',
                                    style: TextStyle(
                                        color: Color.fromRGBO(
                                            170, 44, 94, 1), //rgb(96, 125, 130)
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  RaisedButton(
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
                                              hintText: 'Write the Note here:',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
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
                                              title: Text('Validation Error'),
                                              content: Text(
                                                  'You must define the note\'s description'),
                                              actions: <Widget>[
                                                FlatButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: Text('Ok!'))
                                              ],
                                            ),
                                          );
                                          return;
                                        }
                                        List notes = data['notes'];
                                        notes.add({
                                          'from': user.name,
                                          'note': noteController.text
                                        });
                                        Firestore.instance
                                            .collection('expenses')
                                            .document(snapshot.data.documentID)
                                            .updateData({'notes': notes});
                                      }
                                    },
                                    child: Text(
                                      'Add Note',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: Color.fromRGBO(170, 44, 94, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  )
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
                                child: (data['notes'] as List) != null
                                    ? (data['notes'] as List).length <= 0
                                        ? Center(
                                            child: Text(
                                              'No Notes to Display',
                                              style: TextStyle(fontSize: 28),
                                            ),
                                          )
                                        : ListView.builder(
                                            itemBuilder: (ctx, index) => Column(
                                              children: <Widget>[
                                                ListTile(
                                                  title: Text(
                                                    '${data['notes'][index]['note']}',
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          96, 125, 130, 1),
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  trailing: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        '${data['notes'][index]['from']}',
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
                                                (data['notes'] as List).length,
                                          )
                                    : SizedBox(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}
