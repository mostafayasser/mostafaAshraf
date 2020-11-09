import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';

class FinanceFilter extends StatefulWidget {
  @override
  _FinanceFilterState createState() => _FinanceFilterState();
}

class _FinanceFilterState extends State<FinanceFilter> {
  int month = 1;
  bool isMonth = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            Container(
              color: Colors.white,
              child: ListTile(
                leading: Icon(Icons.sort, size: 35),
                title: Text(
                  'Filter',
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
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: 3.5, color: Colors.grey.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DropdownButton<int>(
                      value: month,
                      disabledHint: Text('Month'),
                      hint: Text('Filter with Month'),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromRGBO(170, 44, 94, 1),
                        size: 35,
                      ),
                      //value: lineType,
                      items: [
                        DropdownMenuItem(
                          child: Text('1 January'),
                          value: 1,
                          onTap: () {
                            setState(() {
                              month = 1;
                            });
                          },
                        ),
                        DropdownMenuItem(
                          child: Text('2 February'),
                          value: 2,
                          onTap: () {
                            setState(() {
                              month = 2;
                            });
                          },
                        ),
                        DropdownMenuItem(
                          child: Text('3 March'),
                          value: 3,
                          onTap: () {
                            setState(() {
                              month = 3;
                            });
                          },
                        ),
                        DropdownMenuItem(
                          child: Text('4 April'),
                          value: 4,
                          onTap: () {
                            setState(() {
                              month = 4;
                            });
                          },
                        ),
                        DropdownMenuItem(
                          child: Text('5 May'),
                          value: 5,
                          onTap: () {
                            setState(() {
                              month = 5;
                            });
                          },
                        ),
                        DropdownMenuItem(
                          child: Text('6 June'),
                          value: 6,
                          onTap: () {
                            setState(() {
                              month = 6;
                            });
                          },
                        ),
                        DropdownMenuItem(
                          child: Text('7 July'),
                          value: 7,
                          onTap: () {
                            setState(() {
                              month = 7;
                            });
                          },
                        ),
                        DropdownMenuItem(
                          child: Text('8 August'),
                          value: 8,
                          onTap: () {
                            setState(() {
                              month = 8;
                            });
                          },
                        ),
                        DropdownMenuItem(
                          child: Text('9 September'),
                          value: 9,
                          onTap: () {
                            setState(() {
                              month = 9;
                            });
                          },
                        ),
                        DropdownMenuItem(
                          child: Text('10 October'),
                          value: 10,
                          onTap: () {
                            setState(() {
                              month = 10;
                            });
                          },
                        ),
                        DropdownMenuItem(
                          child: Text('11 November'),
                          value: 11,
                          onTap: () {
                            setState(() {
                              month = 11;
                            });
                          },
                        ),
                        DropdownMenuItem(
                          child: Text('12 December'),
                          value: 12,
                          onTap: () {
                            setState(() {
                              month = 12;
                            });
                          },
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          month = value;
                        });
                      },
                    ),
                    Checkbox(
                      value: isMonth,
                      onChanged: (val) {
                        setState(() {
                          isMonth = val;
                        });
                      },
                      activeColor: Colors.orange,
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                Map filterMap = {
                  'month': month,
                };
                print(filterMap);
                Navigator.of(context).pop(filterMap);
              },
              child: Container(
                color: Color.fromRGBO(170, 44, 94, 1),
                width: size.width,
                height: 50,
                child: Center(
                  child: Text(
                    'Filter',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
