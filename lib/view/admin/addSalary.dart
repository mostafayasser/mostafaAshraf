//Screen 14
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:maglis_app/view/admin/addExpense.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';
import 'package:provider/provider.dart';

enum PaymentType {
  Const,
  Variable,
  ConstAndVariable,
}

class AddSalaries extends StatefulWidget {
  @override
  _AddSalariesState createState() => _AddSalariesState();
}

class _AddSalariesState extends State<AddSalaries> {
  final nameController = TextEditingController();

  final moneyController = TextEditingController();

  final varMoneyController = TextEditingController();

  GlobalKey key =
      new GlobalKey<AutoCompleteTextFieldState<Map<dynamic, dynamic>>>();
  Map<dynamic, dynamic> selected = {'name': ''};
  String empName;
  String empId = '';
  bool loading = false;
  List<Map> names = [];
  var totalSalaries;
  PaymentType type = PaymentType.Const;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<UserProvider>(context).user;
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
                  'Add new Salaries',
                  style: TextStyle(
                      color: Color.fromRGBO(170, 44, 94, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                trailing: selected['loan'] == null || selected['salary'] == null
                    ? SizedBox()
                    : Text(
                        '${selected['loan']} EGP total loan \n ${selected['salary']} EGP last Salary',
                        style: TextStyle(
                            color: Color.fromRGBO(170, 44, 94, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
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
                                        'salary':
                                            element.data()['salary'] == null
                                                ? 0
                                                : element.data()['salary'],
                                        'loan': element.data()['loan'] == null
                                            ? 0
                                            : element.data()['loan']
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
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[400], width: 2),
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          value: type == PaymentType.Const,
                          onChanged: (v) {
                            setState(() {
                              if (v) type = PaymentType.Const;
                            });
                          },
                          title: Text("Const"),
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
                          value: type == PaymentType.Variable,
                          onChanged: (v) {
                            setState(() {
                              if (v) type = PaymentType.Variable;
                            });
                          },
                          title: Text("Variable"),
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
                          value: type == PaymentType.ConstAndVariable,
                          onChanged: (v) {
                            if (v)
                              setState(() {
                                type = PaymentType.ConstAndVariable;
                              });
                          },
                          title: Text("Const and Variable"),
                          activeColor: Colors.orange,
                        ),
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
                          type == PaymentType.Variable
                              ? 'Variable Money'
                              : 'Const Money',
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
                  type == PaymentType.ConstAndVariable
                      ? Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 3.5,
                                  color: Colors.grey.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Variable Money',
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
                                controller: varMoneyController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.5),
                                  ),
                                  hintText: 'Write Here',
                                ),
                              ) //rgb(128, 151, 155)
                            ],
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            !loading
                ? InkWell(
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
                      final collectedAmount = TextEditingController();

                      final name = nameController.text;
                      if (moneyController.text.isEmpty) {
                        await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Validation Error'),
                            content: Text('You have insert the value amount'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
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
                      if (type == PaymentType.ConstAndVariable &&
                          varMoneyController.text.isEmpty) {
                        await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Validation Error'),
                            content: Text('You have insert the value amount'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
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
                      setState(() {
                        loading = true;
                      });
                      final salaryValue = double.parse(moneyController.text);
                      double totalSalaries = salaryValue;
                      print(names);
                      int loanIndex = names
                          .indexWhere((element) => element['name'] == name);
                      if (loanIndex != -1) {
                        final loanData = names[loanIndex];

                        if (loanData != null) {
                          final amountCollected = await showDialog<double>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                    'Paied Amount? Loans: ${loanData['loan']}'),
                                content: TextField(
                                  controller: collectedAmount,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 1.5),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      labelText: 'Paid Salary:'),
                                ),
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
                                        final collected =
                                            double.parse(collectedAmount.text);

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
                          if (amountCollected > totalSalaries) {
                            showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                      title: Text('Validation Error'),
                                      content: Text(
                                          'The Paid amount can not be greateer than the salary'),
                                      actions: [
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK!'))
                                      ],
                                    ));
                            return;
                          }
                          double netLoan = loanData['loan'];
                          if (amountCollected < totalSalaries) {
                            final netValue = totalSalaries - amountCollected;
                            netLoan = (loanData['loan'] - netValue) < 0
                                ? 0
                                : (loanData['loan'] - netValue);
                          }
                          final time = DateTime.now();

                          if (type == PaymentType.Const) {
                            await Firestore.instance
                                .collection('employee')
                                .document(loanData['docId'])
                                .updateData({
                              'salary': totalSalaries,
                              'lastSalary': time,
                              'salaryType': 'Constant',
                              'mode': 1,
                              'loan': netLoan,
                              'lastTime': time
                            });
                            await Firestore.instance
                                .collection('employee')
                                .document(loanData['docId'])
                                .collection('salaries')
                                .add({
                              'salary': totalSalaries,
                              'time': time,
                              'type': 'Constant',
                              'mode': 1,
                            });
                          } else if (type == PaymentType.Variable) {
                            await Firestore.instance
                                .collection('employee')
                                .document(loanData['docId'])
                                .updateData({
                              'salary': totalSalaries,
                              'lastSalary': time,
                              'salaryType': 'Variable',
                              'mode': 2,
                              'loan': netLoan,
                              'lastTime': time
                            });
                            await Firestore.instance
                                .collection('employee')
                                .document(loanData['docId'])
                                .collection('salaries')
                                .add({
                              'salary': totalSalaries,
                              'time': time,
                              'type': 'Variable',
                              'mode': 2,
                            });
                          } else {
                            final varSalaryValue =
                                double.parse(varMoneyController.text);
                            totalSalaries += varSalaryValue;
                            await Firestore.instance
                                .collection('employee')
                                .document(loanData['docId'])
                                .updateData({
                              'salary': totalSalaries,
                              'variableSalary': varSalaryValue,
                              'lastSalary': time,
                              'salaryType': 'Constant and Variable',
                              'mode': 3,
                              'loan': netLoan,
                              'lastTime': time
                            });
                            await Firestore.instance
                                .collection('employee')
                                .document(loanData['docId'])
                                .collection('salaries')
                                .add({
                              'salary': totalSalaries,
                              'variableSalary': varSalaryValue,
                              'time': time,
                              'type': 'Constant and Variable',
                              'mode': 3,
                            });
                          }
                          final expensesDocument = {
                            'userName': user.name,
                            'date': DateFormat.yMd().format(time),
                            'supplier': '$name\'s Salary',
                            'amount': totalSalaries,
                            'status': 'approved',
                            'attachments': [],
                            'note': [],
                            'type': 'Cash',
                            'time': time,
                          };
                          await Firestore.instance
                              .collection('expenses')
                              .add(expensesDocument);
                          setState(() {
                            loading = true;
                          });
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            '/salaries',
                            ModalRoute.withName('/finance'),
                          );
                        }
                      } else {
                        await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Validation Error'),
                            content: Text(
                                'This employee is not exist in the system'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text(
                                  'OK',
                                  style: TextStyle(color: Colors.green),
                                ),
                              )
                            ],
                          ),
                        );
                        setState(() {
                          loading = false;
                        });
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
                : Center(child: CircularProgressIndicator())
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigator(),
    );
  }
}
