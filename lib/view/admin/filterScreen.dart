import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  List suppliers = [];
  bool called = false;
  List<String> areas = [];
  List<String> selectedAreas = [];
  List<String> lines = [
    'Pajamas',
    'Pants',
    'Slipper',
    'Blankets',
  ];
  List<String> selectedLines = [];
  DateTime date = DateTime.now();
  bool isDate = false;
  int month = 1;
  bool isMonth = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final map = ModalRoute.of(context).settings.arguments as Map;
    final isCity = map['isCity'] == null ? false : map['isCity'];
    Future getFilter;
    if (!isCity) {
      getFilter =
          Firestore.instance.collection('myInfo').document('area').get();
    } else {
      getFilter = Future.delayed(Duration(milliseconds: 50));
    }
    return FutureBuilder(
        future: getFilter,
        builder: (context, snapshot) {
          if (!isCity) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !called) {
              called = true;
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }

          if (isCity) {
            areas = [
              'Alexandria',
              'Aswan',
              'Asyut',
              'Beheira',
              'Beni Suef',
              'Cairo',
              'Dakahlia',
              'Damietta',
              'Faiyum',
              'Gharbia',
              'Giza',
              'Ismailia',
              'Kafr El Sheikh',
              'Luxor',
              'Minya',
              'Monufia',
              'New Valley',
              'North Sinai',
              'North Coast',
              'Port Said',
              'Qalyubia',
              'Qena',
              'Red Sea',
              'Sharqia',
              'Sohag',
              'South Sinai',
              'Suez'
            ];
          } else {
            areas = (snapshot.data.data()['areas'] as List)
                .map((e) => e.toString())
                .toList();
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
                      height: size.height / 3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[400], width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0, left: 18),
                            child: Text(
                              'Area',
                              style: TextStyle(
                                  color: Color.fromRGBO(170, 44, 94, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 4,
                            ),
                            child: Divider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemBuilder: (ctx, index) {
                                return Column(
                                  children: <Widget>[
                                    CheckboxListTile(
                                      value:
                                          selectedAreas.contains(areas[index]),
                                      onChanged: (v) {
                                        if (v) {
                                          setState(() {
                                            selectedAreas.add(areas[index]);
                                          });
                                        } else {
                                          setState(() {
                                            selectedAreas.removeWhere(
                                                (element) =>
                                                    element == areas[index]);
                                          });
                                        }
                                      },
                                      title: Text("${areas[index]}"),
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
                                  ],
                                );
                              },
                              itemCount: areas.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: size.height / 3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[400], width: 2),
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0, left: 18),
                            child: Text(
                              'Lines',
                              style: TextStyle(
                                  color: Color.fromRGBO(170, 44, 94, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 4,
                            ),
                            child: Divider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemBuilder: (ctx, index) {
                                return Column(
                                  children: <Widget>[
                                    CheckboxListTile(
                                      value:
                                          selectedLines.contains(lines[index]),
                                      onChanged: (v) {
                                        if (v) {
                                          setState(() {
                                            selectedLines.add(lines[index]);
                                          });
                                        } else {
                                          setState(() {
                                            selectedLines.removeWhere(
                                                (element) =>
                                                    element == lines[index]);
                                          });
                                        }
                                      },
                                      title: Text("${lines[index]}"),
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
                                  ],
                                );
                              },
                              itemCount: lines.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        final newDate = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2030),
                        );
                        if (newDate == null) return;
                        setState(() {
                          date = newDate;
                        });
                      },
                      child: Container(
                        height: size.height / 5.5,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.grey[400], width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 18.0, left: 18),
                              child: Text(
                                'Time',
                                style: TextStyle(
                                    color: Color.fromRGBO(170, 44, 94, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 4,
                              ),
                              child: Divider(
                                color: Colors.black,
                                thickness: 2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: CheckboxListTile(
                                value: isDate,
                                onChanged: (v) {
                                  if (v) {
                                    setState(() {
                                      isDate = true;
                                    });
                                  } else {
                                    setState(() {
                                      isDate = false;
                                    });
                                  }
                                },
                                title: Text(
                                  '${DateFormat.yMd().format(date)}',
                                  style: TextStyle(
                                      color: Color.fromRGBO(170, 44, 94, 1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                activeColor: Colors.orange,
                              ),
                            ),
                          ],
                        ),
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
                                  child: Text('February'),
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
                        final preference =
                            await SharedPreferences.getInstance();
                        print(selectedAreas);
                        print(selectedLines);
                        if (isCity != null && isCity) {
                          await preference.setStringList('city', selectedAreas);
                        } else {
                          await preference.setStringList(
                              'areas', selectedAreas);
                        }
                        await preference.setStringList('lines', selectedLines);

                        if (isDate) {
                          await preference.setString(
                              'date', DateFormat.yMd().format(date));
                          Map filterMap = {
                            'lines': selectedLines,
                            'areas': selectedAreas,
                            'date': DateFormat.yMd().format(date),
                          };
                          print(filterMap);
                          Navigator.of(context).pop(filterMap);
                        } else if (isMonth) {
                          await preference.setInt('month', month);
                          Map filterMap = {
                            'lines': selectedLines,
                            'areas': selectedAreas,
                            'month': month,
                          };

                          print(filterMap);
                          Navigator.of(context).pop(filterMap);
                        } else {
                          Map filterMap = {
                            'lines': selectedLines,
                            'areas': selectedAreas,
                          };

                          print(filterMap);
                          Navigator.of(context).pop(filterMap);
                        }
                      },
                      child: Container(
                        color: Color.fromRGBO(170, 44, 94, 1),
                        width: size.width,
                        height: 50,
                        child: Center(
                          child: Text(
                            'Filter',
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
