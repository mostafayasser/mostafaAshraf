import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';
import 'package:provider/provider.dart';

class AddRoute extends StatefulWidget {
  @override
  _AddRouteState createState() => _AddRouteState();
}

class _AddRouteState extends State<AddRoute> {
  final nameController = TextEditingController();

  final areaController = TextEditingController();

  DateTime currentDate = DateTime.now();
  bool loading = false;

  bool called1 = false;

  bool called2 = false;

  List agents = [];
  GlobalKey agentsKey = new GlobalKey<AutoCompleteTextFieldState<String>>();

  String selected = '';

  List areas = [];

  GlobalKey areaKey = new GlobalKey<AutoCompleteTextFieldState<String>>();

  String areaSelected = '';
  @override
  Widget build(BuildContext context) {
    nameController.text = selected;
    areaController.text = areaSelected;
    final size = MediaQuery.of(context).size;
    final user = Provider.of<UserProvider>(context).user;
    return FutureBuilder<DocumentSnapshot>(
        future: Firestore.instance.collection('myInfo').document('agent').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && !called1) {
            called1 = true;
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          agents = snapshot.data['agents'] as List;

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
                future: Firestore.instance
                    .collection('myInfo')
                    .document('area')
                    .get(),
                builder: (context, areaSnapshot) {
                  if (areaSnapshot.connectionState == ConnectionState.waiting &&
                      !called2) {
                    called2 = true;
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  areas = areaSnapshot.data['areas'] as List;

                  return Container(
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
                              'Add new Route',
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
                                        width: 3.5,
                                        color: Colors.grey.withOpacity(0.5)),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Name',
                                      style: TextStyle(
                                          color: Color.fromRGBO(170, 44, 94, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Divider(
                                      color: Color.fromRGBO(128, 151, 155, 0.6),
                                      thickness: 2.5,
                                    ),
                                    AutoCompleteTextField<String>(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 1.5),
                                          ),
                                          hintText: 'Search Agent:',
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
                                      key: agentsKey,
                                      suggestions: agents
                                          .map<String>((e) => e.toString())
                                          .toList(),
                                      itemBuilder: (context, suggestion) =>
                                          new Padding(
                                              child: new ListTile(
                                                title: new Text(suggestion),
                                              ),
                                              padding: EdgeInsets.all(8.0)),
                                      itemFilter: (suggestion, input) =>
                                          suggestion
                                              .toLowerCase()
                                              .startsWith(input.toLowerCase()),
                                      itemSorter: (a, b) => a == b
                                          ? 0
                                          : a.length > b.length ? -1 : 1,
                                    ) //rgb(128, 151, 155)
                                  ],
                                ),
                              ),
                              Container(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Area',
                                      style: TextStyle(
                                          color: Color.fromRGBO(170, 44, 94, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Divider(
                                      color: Color.fromRGBO(128, 151, 155, 0.6),
                                      thickness: 2.5,
                                    ),
                                    AutoCompleteTextField<String>(
                                      controller: areaController,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 1.5),
                                          ),
                                          hintText: 'Search Areas:',
                                          suffixIcon: Icon(Icons.search)),
                                      itemSubmitted: (item) =>
                                          setState(() => areaSelected = item),
                                      textSubmitted: (item) {
                                        print('itemss:$item');
                                        setState(() {
                                          areaSelected = item;
                                        });
                                      },
                                      textChanged: (item) {
                                        print('itesmss:$item');
                                        areaSelected = item;
                                      },
                                      key: areaKey,
                                      suggestions: areas
                                          .map<String>((e) => e.toString())
                                          .toList(),
                                      itemBuilder: (context, suggestion) =>
                                          new Padding(
                                              child: new ListTile(
                                                title: new Text(suggestion),
                                              ),
                                              padding: EdgeInsets.all(8.0)),
                                      itemFilter: (suggestion, input) =>
                                          suggestion
                                              .toLowerCase()
                                              .startsWith(input.toLowerCase()),
                                      itemSorter: (a, b) => a == b
                                          ? 0
                                          : a.length > b.length ? -1 : 1,
                                    )
                                  ],
                                ),
                              ),
                              Container(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Date',
                                      style: TextStyle(
                                          color: Color.fromRGBO(170, 44, 94, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Divider(
                                      color: Color.fromRGBO(128, 151, 155, 0.6),
                                      thickness: 2.5,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final lastDate = currentDate;
                                        currentDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2019),
                                            lastDate: DateTime(2021));
                                        if (currentDate == null) {
                                          currentDate = lastDate;
                                        }
                                        setState(() {});
                                      },
                                      child: Text(
                                        '${DateFormat.yMd().format(currentDate)}',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(170, 44, 94, 1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ) //rgb(128, 151, 155)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        loading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : InkWell(
                                onTap: () async {
                                  String name = nameController.text;
                                  String area = areaController.text;
                                  String routeDate =
                                      DateFormat.yMd().format(currentDate);
                                  String nowDate =
                                      DateFormat.yMd().format(DateTime.now());
                                  setState(() {
                                    loading = true;
                                  });
                                  if (name.isEmpty ||
                                      name == null ||
                                      area.isEmpty ||
                                      area == null) {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('Validation Error'),
                                        content: Text(
                                            'All Fields must be completed'),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: Text('Ok'))
                                        ],
                                      ),
                                    );
                                    return;
                                  }
                                  if (name != null) {
                                    if (!agents.contains(name)) {
                                      agents.add(name);
                                      Firestore.instance
                                          .collection('myInfo')
                                          .document('agent')
                                          .updateData({'agents': agents});
                                    }
                                  }
                                  if (area != null) {
                                    if (!areas.contains(area)) {
                                      areas.add(area);
                                      Firestore.instance
                                          .collection('myInfo')
                                          .document('area')
                                          .updateData({'areas': areas});
                                    }
                                  }
                                  await Firestore.instance
                                      .collection('routes')
                                      .add({
                                    'name': name,
                                    'area': area,
                                    'date': routeDate,
                                    'createdAt': nowDate,
                                    'createdBy': user.name,
                                    'orders': [],
                                    'status': 'new',
                                    'totalAmount': 0,
                                    'time': DateTime.now(),
                                  });
                                  await showDialog(
                                    context: context,
                                    child: AlertDialog(
                                      title: Text('Operation Succeeded'),
                                      content: Text(
                                          'The Route has beeen added successfully'),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('OK!'),
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
                              )
                      ],
                    ),
                  );
                }),
          );
        });
  }
}
