//Screen 14
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';

class AddLoans extends StatefulWidget {
  @override
  _AddLoansState createState() => _AddLoansState();
}

class _AddLoansState extends State<AddLoans> {
  final nameController = TextEditingController();

  final moneyController = TextEditingController();

  GlobalKey key =
      new GlobalKey<AutoCompleteTextFieldState<Map<dynamic, dynamic>>>();
  Map<dynamic, dynamic> selected = {'name': ''};
  String empName;
  String empId = '';

  List<Map> names = [];
  var totalLoans;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var map = (ModalRoute.of(context).settings.arguments as Map);
    var docId;
    var docName;
    var docMoney;
    if (map != null) {
      docId = map['id'];
      docName = map['name'];
      docMoney = map['money'];
      if (docId != null) {
        nameController.text = docName;
        moneyController.text = docMoney;
      } else {
        moneyController.text = '$docMoney';
      }
    }
    nameController.text = empName;
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
      body: Container(
        width: size.width,
        height: size.height,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  'Add new Loans',
                  style: TextStyle(
                      color: Color.fromRGBO(170, 44, 94, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 3.5, color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FutureBuilder<QuerySnapshot>(
                            future: Firestore.instance
                                .collection('employee')
                                .getDocuments(),
                            builder: (context, snapshot) {
                              names = snapshot.data.documents
                                  .map<Map>((element) => {
                                        'name': element.data()['name'],
                                        'docId': element.documentID,
                                        'loans': element.data()['loan']
                                      })
                                  .toList();
                              return AutoCompleteTextField<
                                  Map<dynamic, dynamic>>(
                                controller: nameController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.5),
                                    ),
                                    hintText: 'Search Employee',
                                    suffixIcon: Icon(Icons.search)),
                                itemSubmitted: (item) {
                                  empName = item['name'];
                                  setState(() => selected = item);
                                },
                                textSubmitted: (item) {
                                  print('itemss:$item');
                                  empName = item;

                                  setState(() {
                                    selected['name'] = item;
                                  });
                                },
                                textChanged: (item) {
                                  print('itesmss:$item');
                                  empName = item;

                                  selected['name'] = item;
                                },
                                key: key,
                                suggestions: names,
                                itemBuilder: (context, suggestion) =>
                                    new Padding(
                                        child: new ListTile(
                                          title: new Text(suggestion['name']),
                                        ),
                                        padding: EdgeInsets.all(8.0)),
                                itemFilter: (suggestion, input) =>
                                    suggestion['name']
                                        .toLowerCase()
                                        .startsWith(input.toLowerCase()),
                                itemSorter: (a, b) =>
                                    a == b ? 0 : a.length > b.length ? -1 : 1,
                              );
                            }),
                        //rgb(128, 151, 155)
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 3.5, color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Money',
                          style: TextStyle(
                              color: Color.fromRGBO(170, 44, 94, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        Divider(
                          color: Color.fromRGBO(128, 151, 155, 0.6),
                          thickness: 2.5,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: moneyController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.5),
                            ),
                            hintText: 'Write Here',
                          ),
                        ) //rgb(128, 151, 155)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () async {
                bool confirm = await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Confirmation?'),
                    content: Text('Do you want to processed?'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(
                          'No',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text(
                          'Yes',
                          style: TextStyle(color: Colors.green),
                        ),
                      )
                    ],
                  ),
                );
                if (!confirm) return;
                final name = nameController.text;
                if (moneyController.text.isEmpty) {
                  await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Validation Error'),
                      content: Text('You have insert the value amount'),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(
                            'OK',
                            style: TextStyle(color: Colors.green),
                          ),
                        )
                      ],
                    ),
                  );
                  return;
                }
                final loanValue = double.parse(moneyController.text);
                double totalLoans = loanValue;
                print(names);
                int loanIndex =
                    names.indexWhere((element) => element['name'] == name);
                if (loanIndex != -1) {
                  final loanData = names[loanIndex];
                  if (loanData != null) {
                    if (loanData['loans'] != null) {
                      totalLoans += loanData['loans'] + 0.0;
                    }
                    final time = DateTime.now();
                    await Firestore.instance
                        .collection('employee')
                        .document(loanData['docId'])
                        .updateData({
                      'loan': totalLoans,
                      'lastTime': time,
                    });
                    await Firestore.instance
                        .collection('employee')
                        .document(loanData['docId'])
                        .collection('loans')
                        .add({
                      'loan': loanValue,
                      'time': time,
                    });
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/loans',
                      ModalRoute.withName('/finance'),
                    );
                  }
                } else {
                  await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Validation Error'),
                      content: Text('This employee is not exist in the system'),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(
                            'OK',
                            style: TextStyle(color: Colors.green),
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
              child: Container(
                color: Color.fromRGBO(170, 44, 94, 1),
                width: size.width,
                height: 50,
                child: Center(
                  child: Text(
                    'ADD',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}
