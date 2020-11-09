import 'dart:io';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum PaymentType { Cash, Credit, CashAndCredit }

class AddExpense extends StatefulWidget {
  @override
  _AddExpenseState createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final suplierNameController = TextEditingController();
  List<File> attachments = [];
  final amountController = TextEditingController();
  PaymentType type = PaymentType.Cash;
  bool loading = false;
  final cashController = TextEditingController();
  final creditController = TextEditingController();
  bool approved = false;
  bool called = false;

  List suppliers = [];
  GlobalKey expenkey = new GlobalKey<AutoCompleteTextFieldState<String>>();

  TextEditingController noteController = TextEditingController();

  String selected = '';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    suplierNameController.text = selected;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    return FutureBuilder<DocumentSnapshot>(
        future:
            Firestore.instance.collection('myInfo').document('expenses').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !called) {
            called = true;
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          suppliers = snapshot.data()['suppliers'];

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
                height: size.height,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            'Add New Expenses',
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
                            'User Name: ${user.name}',
                            style: TextStyle(
                                color: Color.fromRGBO(
                                    96, 125, 130, 1), //rgb(96, 125, 130)
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(
                            'Date: ${DateFormat.yMd().format(DateTime.now())}',
                            style: TextStyle(
                                color: Color.fromRGBO(96, 125, 130, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
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
                            'Supplier Name',
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
                              child: AutoCompleteTextField<String>(
                                controller: suplierNameController,
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
                                key: expenkey,
                                suggestions: suppliers
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
                      height: MediaQuery.of(context).size.height / 4,
                      margin: EdgeInsets.symmetric(horizontal: 12),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Attachment',
                                style: TextStyle(
                                    color: Color.fromRGBO(
                                        170, 44, 94, 1), //rgb(96, 125, 130)
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              InkWell(
                                onTap: () async {
                                  print('Select Source');
                                  final type = await showDialog(
                                      context: context,
                                      child: AlertDialog(
                                        title: Text('Select Source'),
                                        actions: <Widget>[
                                          FlatButton.icon(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(ImageSource.gallery);
                                            },
                                            icon: Icon(Icons.filter),
                                            label: Text('Gallery'),
                                          ),
                                          FlatButton.icon(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(ImageSource.camera);
                                            },
                                            icon: Icon(Icons.camera_alt),
                                            label: Text('Camera'),
                                          ),
                                        ],
                                      ));
                                  PickedFile image = await ImagePicker()
                                      .getImage(source: type);
                                  final file = File(image.path);
                                  setState(() {
                                    attachments.add(file);
                                  });
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey[400], width: 2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Icon(
                                      Icons.add,
                                      size: 25,
                                      color: Color.fromRGBO(96, 125, 129, 1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                            child: Divider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                          ),
                          Expanded(
                            child: attachments.length > 0
                                ? ListView.builder(
                                    itemBuilder: (ctx, index) {
                                      return ListTile(
                                        title: Text(
                                          '${Path.basename(attachments[index].path)}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Divider(
                                          thickness: 2.5,
                                        ),
                                        trailing: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                attachments.removeAt(index);
                                              });
                                            }),
                                      );
                                    },
                                    itemCount: attachments.length,
                                  )
                                : Center(
                                    child: Text(
                                      'Please Add a Photo of receipt',
                                      style: TextStyle(fontSize: 22),
                                    ),
                                  ),
                          )
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
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[400], width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          CheckboxListTile(
                            value: type == PaymentType.Cash,
                            onChanged: (v) {
                              setState(() {
                                if (v) type = PaymentType.Cash;
                              });
                            },
                            title: Text("Cash"),
                            activeColor: Colors.orange,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 18,
                            ),
                            child: Divider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                          ),
                          CheckboxListTile(
                            value: type == PaymentType.Credit,
                            onChanged: (v) {
                              setState(() {
                                if (v) type = PaymentType.Credit;
                              });
                            },
                            title: Text("Credit"),
                            activeColor: Colors.orange,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 18,
                            ),
                            child: Divider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                          ),
                          CheckboxListTile(
                            value: type == PaymentType.CashAndCredit,
                            onChanged: (v) {
                              if (v)
                                setState(() {
                                  type = PaymentType.CashAndCredit;
                                });
                            },
                            title: Text("Cash and Credit"),
                            activeColor: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                    type == PaymentType.CashAndCredit
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey[400], width: 2),
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.all(12),
                            padding: EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: size.width / 2.5,
                                  child: TextField(
                                    controller: cashController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 1.5),
                                        ),
                                        labelText: 'Cash'),
                                  ),
                                ),
                                Container(
                                  width: size.width / 2.5,
                                  child: TextField(
                                    controller: creditController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 1.5),
                                        ),
                                        labelText: 'Credit'),
                                  ),
                                )
                              ],
                            ))
                        : SizedBox(),
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
                            'Add new note',
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
                            keyboardType: TextInputType.text,
                            controller: noteController,
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
                    loading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : InkWell(
                            onTap: () async {
                              print(attachments);
                              print(suplierNameController.text);
                              print(amountController.value.text);
                              var cashAmount;
                              var creditAmount;
                              if (suplierNameController.text.isEmpty ||
                                  amountController.value.text.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Validation Error'),
                                    content:
                                        Text('All Field must be completed'),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('OK!'))
                                    ],
                                  ),
                                );
                                return;
                              }
                              if (attachments.length <= 0) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('Validation Error'),
                                    content: Text(
                                        'A Photo of receipt must be inserted'),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('OK!'))
                                    ],
                                  ),
                                );
                                return;
                              }
                              if (type == PaymentType.CashAndCredit) {
                                if (creditController.text.isEmpty ||
                                    cashController.text.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text('Validation Error'),
                                      content: Text(
                                          'The Credit and Cash Amount must be inserted'),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text('OK!'))
                                      ],
                                    ),
                                  );
                                  return;
                                }
                                cashAmount = double.parse(cashController.text);
                                creditAmount =
                                    double.parse(creditController.text);
                                final amount =
                                    double.parse(amountController.text);
                                if ((cashAmount + creditAmount) != amount) {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text('Validation Error'),
                                      content: Text(
                                          'The Cash and Credit amount must equal the total amount'),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: Text('OK!'))
                                      ],
                                    ),
                                  );
                                  return;
                                }
                              }
                              bool confirmation = await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Validation Error'),
                                  content: Text('Are you sure to Continue?'),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text(
                                        'No',
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
                              if (!confirmation) return;
                              setState(() {
                                loading = true;
                              });
                              var reference = FirebaseStorage().ref();
                              List<String> imageUrls = [];
                              for (int i = 0; i < attachments.length; i++) {
                                final nowDate = DateTime.now();
                                final task = reference
                                    .child('expenses/${nowDate.toString()}}')
                                    .putFile(attachments[i]);
                                final storage = await task.onComplete;
                                if (task.isSuccessful) {
                                  print('successed');
                                } else {
                                  print('not successed');
                                }
                                final url = await storage.ref.getDownloadURL();
                                print(url);
                                imageUrls.add(url);
                              }
                              print(imageUrls);
                              final date =
                                  DateFormat.yMd().format(DateTime.now());
                              final amount =
                                  double.parse(amountController.text);

                              final amountType = type == PaymentType.Cash
                                  ? 'Cash'
                                  : type == PaymentType.Credit
                                      ? 'Credit'
                                      : 'Cash and Credit';
                              var document;
                              List notes = [];
                              noteController.text.isNotEmpty
                                  ? notes.add({
                                      'from': user.name,
                                      'note': noteController.text
                                    })
                                  : notes.length;
                              String supplierName = suplierNameController.text;
                              if (supplierName != null &&
                                  supplierName.isNotEmpty) {
                                if (!suppliers.contains(supplierName)) {
                                  suppliers.add(supplierName);
                                  Firestore.instance
                                      .collection('myInfo')
                                      .document('expenses')
                                      .updateData({'suppliers': suppliers});
                                }
                              }
                              if (approved && user.type == 'admin') {
                                if (type == PaymentType.CashAndCredit) {
                                  document = {
                                    'userName': user.name,
                                    'date': date,
                                    'supplier': suplierNameController.text,
                                    'amount': amount,
                                    'type': amountType,
                                    'credit': creditAmount,
                                    'cash': cashAmount,
                                    'attachments': imageUrls,
                                    'status': 'approved',
                                    'notes': notes,
                                    'time': DateTime.now(),
                                  };
                                } else {
                                  document = {
                                    'userName': user.name,
                                    'date': date,
                                    'supplier': suplierNameController.text,
                                    'amount': amount,
                                    'type': amountType,
                                    'attachments': imageUrls,
                                    'status': 'approved',
                                    'notes': notes,
                                    'time': DateTime.now(),
                                  };
                                }
                              } else {
                                if (type == PaymentType.CashAndCredit) {
                                  document = {
                                    'userName': user.name,
                                    'date': date,
                                    'supplier': suplierNameController.text,
                                    'amount': amount,
                                    'type': amountType,
                                    'credit': creditAmount,
                                    'cash': cashAmount,
                                    'attachments': imageUrls,
                                    'status': 'notApproved',
                                    'notes': notes,
                                    'time': DateTime.now(),
                                  };
                                } else {
                                  document = {
                                    'userName': user.name,
                                    'date': date,
                                    'supplier': suplierNameController.text,
                                    'amount': amount,
                                    'type': amountType,
                                    'attachments': imageUrls,
                                    'status': 'notApproved',
                                    'notes': notes,
                                    'time': DateTime.now(),
                                  };
                                }
                              }

                              await Firestore.instance
                                  .collection('expenses')
                                  .add(document);
                              await showDialog(
                                context: context,
                                child: AlertDialog(
                                  title: Text('Task Complete'),
                                  content: Text(
                                      'The Expenses has been added successfully'),
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
