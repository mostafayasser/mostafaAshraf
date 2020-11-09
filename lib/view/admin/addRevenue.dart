import 'dart:ffi';
import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';
import 'package:provider/provider.dart';

class AddRevenue extends StatefulWidget {
  @override
  _AddRevenueState createState() => _AddRevenueState();
}

class _AddRevenueState extends State<AddRevenue> {
  final revenueSorce = TextEditingController();
  List<File> attachments = [];
  final amountController = TextEditingController();
  DateTime date = DateTime.now();
  bool loading = false;

  bool approved = false;
  bool called = false;
  List sources = [];
  GlobalKey revenKey = new GlobalKey<AutoCompleteTextFieldState<String>>();

  String selected = '';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    revenueSorce.text = selected;

    return FutureBuilder<DocumentSnapshot>(
        future:
            Firestore.instance.collection('myInfo').document('revenue').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !called) {
            called = true;
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          sources = snapshot.data.data()['sources'];
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
                width: size.width,
                height: size.height / 1.2,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            'Add New Revenues',
                            style: TextStyle(
                                color: Color.fromRGBO(170, 44, 94, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        )),
                    Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'User Name:${user.name}',
                            style: TextStyle(
                                color: Color.fromRGBO(
                                    96, 125, 130, 1), //rgb(96, 125, 130)
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          InkWell(
                            onTap: () async {
                              date = await showDatePicker(
                                  context: context,
                                  initialDate: date,
                                  firstDate: DateTime(date.year),
                                  lastDate:
                                      DateTime(date.year, date.month + 1));
                              setState(() {});
                            },
                            child: Text(
                              'Date: ${DateFormat.yMd().format(date)}',
                              style: TextStyle(
                                  color: Color.fromRGBO(96, 125, 130, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Revenue from',
                            style: TextStyle(
                                color: Color.fromRGBO(
                                    170, 44, 94, 1), //rgb(96, 125, 130)
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                            child: Divider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2,
                                      color: Colors.grey[400].withOpacity(0.9)),
                                  borderRadius: BorderRadius.circular(10)),
                              child: AutoCompleteTextField<String>(
                                controller: revenueSorce,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.5),
                                    ),
                                    hintText: 'Search Supplier:',
                                    suffixIcon: Icon(Icons.search)),
                                itemSubmitted: (item) =>
                                    setState(() => selected = item),
                                textSubmitted: (item) {
                                  print('itemss:$item');
                                  setState(() {
                                    selected = item;
                                  });
                                },
                                textChanged: (item) {
                                  print('itesmss:$item');
                                  selected = item;
                                },
                                key: revenKey,
                                suggestions: sources
                                    .map<String>((e) => e.toString())
                                    .toList(),
                                itemBuilder: (context, suggestion) =>
                                    new Padding(
                                        child: new ListTile(
                                          title: new Text(suggestion),
                                        ),
                                        padding: EdgeInsets.all(8.0)),
                                itemFilter: (suggestion, input) => suggestion
                                    .toLowerCase()
                                    .startsWith(input.toLowerCase()),
                                itemSorter: (a, b) =>
                                    a == b ? 0 : a.length > b.length ? -1 : 1,
                              ),
                            ),
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
                            'Amount',
                            style: TextStyle(
                                color: Color.fromRGBO(
                                    170, 44, 94, 1), //rgb(96, 125, 130)
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                            child: Divider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2,
                                      color: Colors.grey[400].withOpacity(0.9)),
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                controller: amountController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: 'Write here',
                                    contentPadding: EdgeInsets.only(left: 10),
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    user.type == 'admin'
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey[400], width: 2),
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.all(12),
                            child: Column(
                              children: [
                                CheckboxListTile(
                                  value: approved,
                                  onChanged: (v) {
                                    setState(() {
                                      if (v) approved = v;
                                    });
                                  },
                                  title: Text("Approved Expense"),
                                  activeColor: Colors.orange,
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    loading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : InkWell(
                            onTap: () async {
                              print(attachments);
                              print(revenueSorce.text);
                              print(amountController.value.text);
                              if (revenueSorce.text.isEmpty ||
                                  amountController.value.text.isEmpty) {
                                print('Complete all filed');
                                return;
                              }
                              setState(() {
                                loading = true;
                              });

                              final finalDate = DateFormat.yMd().format(date);
                              final amount =
                                  double.parse(amountController.text);
                              var document;
                              String revSource = revenueSorce.text;
                              if (revSource != null && revSource.isNotEmpty) {
                                if (!sources.contains(revSource)) {
                                  sources.add(revSource);
                                  Firestore.instance
                                      .collection('myInfo')
                                      .document('revenue')
                                      .updateData({'sources': sources});
                                }
                              }
                              if (approved) {
                                document = {
                                  'userName': user.name,
                                  'date': finalDate,
                                  'source': revenueSorce.text,
                                  'amount': amount,
                                  'status': 'approved',
                                  'time': DateTime.now(),
                                };
                              } else {
                                document = {
                                  'userName': user.name,
                                  'date': finalDate,
                                  'source': revenueSorce.text,
                                  'amount': amount,
                                  'status': 'notApproved',
                                  'time': DateTime.now(),
                                };
                              }

                              await Firestore.instance
                                  .collection('revenue')
                                  .add(document);
                              await showDialog(
                                context: context,
                                child: AlertDialog(
                                  title: Text('Task Complete'),
                                  content: Text(
                                      'The Revenues has been added successfully'),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'OK',
                                      ),
                                    )
                                  ],
                                ),
                              );
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              color: Color.fromRGBO(170, 44, 94, 1),
                              width: size.width,
                              height: 50,
                              child: Center(
                                child: Text(
                                  'ADD',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ));
        });
  }
}
