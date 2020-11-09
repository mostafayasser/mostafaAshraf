import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';

import 'package:maglis_app/widgets/orderTile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart' as url;

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final searchController = TextEditingController();
  Map filterData;
  bool isSearch = false;
  String selected = '';
  final searchKey = new GlobalKey<AutoCompleteTextFieldState<String>>();
  bool isCalled = false;

  bool searched = false;

  bool areaAsc = false;
  bool areaDes = false;
  bool timeAsc = false;
  bool timeDes = false;
  bool numberAsc = false;
  bool numberDes = false;

  List<String> names = [];
  List<String> address = [];
  List<String> phones = [];
  List<String> orderNumbers = [];

  List<String> recomendations = [];

  Future orderstream;
  Query orderQuery;

  List<String> checkedOrder = [];

  Future<QuerySnapshot> checkFilter(Query firestoreQuery) async {
    final preference = await SharedPreferences.getInstance();
    final lines = preference.getStringList('lines');
    final areas = preference.getStringList('areas');
    final date = preference.getString('date');
    final month = preference.getInt('month');
    filterData = {};

    if (date != null && date.isNotEmpty) {
      filterData['date'] = date;
      firestoreQuery = firestoreQuery.where('createdAt', isEqualTo: date);
    }
    if (lines != null) {
      filterData.putIfAbsent('lines', () => lines);
    }
    if (month != null) {
      filterData['month'] = month;
    }
    final snapshot = await firestoreQuery.getDocuments();
    print(snapshot.documents.length);
    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    final map = ModalRoute.of(context).settings.arguments as Map;
    final title = (map == null) ? 'All' : map['title'];
    final logo = (map == null) ? 'assets/images/AllIcon.png' : map['logo'];
    final user = Provider.of<UserProvider>(context).user;
    bool cancel = false;
    searchController.text = selected;
    if (!searched) {
      if (filterData == null) {
        // print(map['type']);
        if (map != null) {
          // print(map['date']);
          if (map['type'] == 1) {
            orderstream = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: map['status'])
                .where('area', isEqualTo: map['date'])
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false)
                .getDocuments();
            orderQuery = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: map['status'])
                .where('area', isEqualTo: map['date'])
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false);
          } else if (map['type'] == 2) {
            orderstream = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: map['status'])
                .where('createdAt', isEqualTo: map['date'])
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false)
                .getDocuments();
            orderQuery = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: map['status'])
                .where('createdAt', isEqualTo: map['date'])
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false);
          } else if (map['type'] == 3) {
            orderstream = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: map['status'])
                .where('line', isEqualTo: map['date'])
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false)
                .getDocuments();
            orderQuery = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: map['status'])
                .where('line', isEqualTo: map['date'])
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false);
          } else if (map['type'] == 4) {
            orderstream = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: map['status'])
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false)
                .getDocuments();
            orderQuery = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: map['status'])
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false);
          } else if (map['type'] == 7) {
            orderstream = Firestore.instance
                .collection('orders')
                .where('status', whereIn: map['status'])
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false)
                .getDocuments();
            orderQuery = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: map['status'])
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false);
          } else if (map['follow'] != null && map['follow']) {
            orderstream = Firestore.instance
                .collection('orders')
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false)
                .where('follow', isEqualTo: true)
                .getDocuments();
            orderQuery = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: map['status'])
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false)
                .where('follow', isEqualTo: true);
          } else {
            orderstream = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: map['status'])
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false)
                .getDocuments();
            orderQuery = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: map['status'])
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false);
          }
        } else {
          orderstream = Firestore.instance
              .collection('orders')
              .where('isCairo', isEqualTo: false)
              .where('isCorporate', isEqualTo: false)
              .getDocuments();
          orderQuery = Firestore.instance
              .collection('orders')
              .where('isCairo', isEqualTo: false)
              .where('isCorporate', isEqualTo: false);
        }
      } else {
        List<String> areas = filterData['areas'];
        String date = filterData['date'];

        Query firestoreQuery = Firestore.instance
            .collection('orders')
            .where('isCairo', isEqualTo: false)
            .where('isCorporate', isEqualTo: false);
        if (areas != null && areas.length > 0) {
          firestoreQuery = firestoreQuery.where('area', whereIn: areas);
        }

        if (date != null && date.isNotEmpty) {
          firestoreQuery = firestoreQuery.where('createdAt', isEqualTo: date);
        }
        if (map['status'] != null) {
          firestoreQuery =
              firestoreQuery.where('status', isEqualTo: map['status']);
        }
        orderstream = firestoreQuery.getDocuments();
      }
    }

    return FutureBuilder<QuerySnapshot>(
      future: orderstream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        final ordersData = snapshot.data.documents;

        if (filterData != null &&
            (filterData['lines'] as List) != null &&
            (filterData['lines'] as List).length > 0) {
          final lines = filterData['lines'] as List;
          ordersData.removeWhere(
              (element) => !lines.contains(element.data()['line']));
        }
        if (filterData != null &&
            (filterData['month'] as int) != null &&
            (filterData['month'] as int) > 0) {
          final month = filterData['month'] as int;
          print(month);
          print(ordersData.length);
          ordersData.removeWhere((element) {
            return !((element.data()['time'] as Timestamp).toDate().month ==
                month);
          });
          print(ordersData.length);
        }
        if (!searched) {
          if (areaAsc) {
            ordersData.sort((a, b) {
              if (a.data()['area'] == null) {
                return 1;
              }
              if (b.data()['area'] == null) {
                return -1;
              }
              return (a.data()['area'] as String)
                  .toLowerCase()
                  .compareTo((b.data()['area'] as String).toLowerCase());
            });
          } else if (areaDes) {
            ordersData.sort((b, a) {
              if (a.data()['area'] == null) {
                return 1;
              }
              if (b.data()['area'] == null) {
                return -1;
              }
              return (a.data()['area'] as String)
                  .toLowerCase()
                  .compareTo((b.data()['area'] as String).toLowerCase());
            });
          } else if (timeAsc) {
            ordersData.sort((a, b) {
              if (a.data()['time'] == null) {
                return 1;
              }
              if (b.data()['time'] == null) {
                return -1;
              }
              return (a.data()['time'] as Timestamp)
                  .compareTo((b.data()['time'] as Timestamp));
            });
          } else if (timeDes) {
            ordersData.sort((b, a) {
              if (a.data()['time'] == null) {
                return 1;
              }
              if (b.data()['time'] == null) {
                return -1;
              }
              return (a.data()['time'] as Timestamp)
                  .compareTo((b.data()['time'] as Timestamp));
            });
          } else if (numberDes) {
            ordersData.sort((b, a) {
              if (a.data()['orderNumber'] == null) {
                return 1;
              }
              if (b.data()['orderNumber'] == null) {
                return -1;
              }
              return (a.data()['orderNumber'] as int)
                  .compareTo((b.data()['orderNumber'] as int));
            });
          } else {
            ordersData.sort((a, b) {
              if (a.data()['orderNumber'] == null) {
                return 1;
              }
              if (b.data()['orderNumber'] == null) {
                return -1;
              }
              return (a.data()['orderNumber'] as int)
                  .compareTo((b.data()['orderNumber'] as int));
            });
          }
        }

        var qty = 0;
        var ordersQuantity = 0;
        ordersQuantity = ordersData.length;
        ordersData.forEach((element) {
          qty += element.data()['quantity'];
        });

        if (!isCalled) {
          recomendations.addAll((snapshot.data.documents)
              .map<String>((e) => e.data()['name'].toString()));
          names = (snapshot.data.documents)
              .map<String>((e) => e.data()['name'].toString())
              .toList();
          recomendations.addAll((snapshot.data.documents)
              .map<String>((e) => e.data()['address'].toString()));
          address = (snapshot.data.documents)
              .map<String>((e) => e.data()['address'].toString())
              .toList();
          recomendations.addAll((snapshot.data.documents)
              .map<String>((e) => e.data()['phone'].toString()));
          phones = (snapshot.data.documents)
              .map<String>((e) => e.data()['phone'].toString())
              .toList();
          recomendations.addAll((snapshot.data.documents)
              .map<String>((e) => e.data()['orderNumber'].toString()));
          orderNumbers = snapshot.data.documents
              .map<String>((e) => e.data()['orderNumber'].toString())
              .toList();

          isCalled = true;
        }

        return Scaffold(
          bottomNavigationBar: BottomNavigator(),
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            leading: isSearch ? Container() : BackButton(),
            elevation: 10,
            centerTitle: true,
            backgroundColor: Colors.white,
            title: isSearch
                ? AutoCompleteTextField<String>(
                    controller: searchController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 1.5),
                        ),
                        hintText: 'Search Order:',
                        suffixIcon: Icon(Icons.search)),
                    itemSubmitted: (item) {
                      Query orderquery =
                          Firestore.instance.collection('orders');
                      if (names.contains(item)) {
                        orderquery = Firestore.instance
                            .collection('orders')
                            .where('name', isEqualTo: item);
                      } else if (address.contains(item)) {
                        orderquery = Firestore.instance
                            .collection('orders')
                            .where('address', isEqualTo: item);
                      } else if (phones.contains(item)) {
                        orderquery = Firestore.instance
                            .collection('orders')
                            .where('phone', isEqualTo: item);
                      } else if (orderNumbers.contains(item)) {
                        final number = int.parse(item);
                        orderquery = Firestore.instance
                            .collection('orders')
                            .where('orderNumber', isEqualTo: number);
                      } else {
                        orderquery = Firestore.instance
                            .collection('orders')
                            .where('orderNumber', isEqualTo: item);
                      }
                      orderstream = orderquery.getDocuments();
                      isSearch = false;
                      selected = item;

                      setState(() => searched = true);
                    },
                    textSubmitted: (item) {
                      Query orderquery =
                          Firestore.instance.collection('orders');
                      if (names.contains(item)) {
                        orderquery = Firestore.instance
                            .collection('orders')
                            .where('name', isEqualTo: item);
                      }
                      if (address.contains(item)) {
                        orderquery = Firestore.instance
                            .collection('orders')
                            .where('address', isEqualTo: item);
                      }
                      if (phones.contains(item)) {
                        orderquery = Firestore.instance
                            .collection('orders')
                            .where('phone', isEqualTo: item);
                      }
                      if (map['status'] != null) {
                        orderquery = orderquery.where('status',
                            isEqualTo: map['status']);
                      }
                      orderstream = orderquery.getDocuments();
                      isSearch = false;
                      selected = item;

                      setState(() => searched = true);
                    },
                    textChanged: (item) {
                      print('itesmss:$item');
                      selected = item;
                    },
                    key: searchKey,
                    suggestions: recomendations,
                    itemBuilder: (context, suggestion) => new Padding(
                        child: new ListTile(
                          title: new Text(suggestion),
                        ),
                        padding: EdgeInsets.all(8.0)),
                    itemFilter: (suggestion, input) => suggestion
                        .toLowerCase()
                        .startsWith(input.toLowerCase()),
                    itemSorter: (a, b) =>
                        a == b ? 0 : a.length > b.length ? -1 : 1,
                  )
                : Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                  ),
            actions: <Widget>[
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400], width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isSearch = !isSearch;
                        searched = !searched;
                      });
                    },
                    child: Icon(
                      Icons.search,
                      size: 25,
                      color: Color.fromRGBO(96, 125, 129, 1),
                    ),
                  ),
                ),
              ),
              map['type'] == 4
                  ? InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400], width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'done',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '$title',
                        style: TextStyle(
                            color: Color.fromRGBO(170, 44, 94, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Text(
                        'Order:${ordersQuantity}',
                        style: TextStyle(
                            color: Color.fromRGBO(170, 44, 94, 1),
                            fontSize: 16),
                      ),
                      Text(
                        'Qty:${qty}',
                        style: TextStyle(
                            color: Color.fromRGBO(170, 44, 94, 1),
                            fontSize: 16),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400], width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: InkWell(
                            onTap: () async {
                              filterData = await showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        title: Text('Sort By'),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  areaAsc = true;
                                                  areaDes = false;
                                                  timeAsc = false;
                                                  timeDes = false;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Area ascending')),
                                          FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  timeDes = false;
                                                  areaAsc = false;
                                                  areaDes = true;
                                                  timeAsc = false;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Area descending')),
                                          FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  areaAsc = false;
                                                  areaDes = false;
                                                  timeAsc = true;
                                                  timeDes = false;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Time ascending')),
                                          FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  areaAsc = false;
                                                  areaDes = false;
                                                  timeAsc = false;
                                                  timeDes = true;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Time descending')),
                                          FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  areaAsc = false;
                                                  areaDes = false;
                                                  timeAsc = false;
                                                  timeDes = false;
                                                  numberAsc = true;
                                                  numberDes = false;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('number ascending')),
                                          FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  areaAsc = false;
                                                  areaDes = false;
                                                  timeAsc = false;
                                                  timeDes = false;
                                                  numberAsc = false;
                                                  numberDes = true;
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('number descending'))
                                        ],
                                      ));
                              print(filterData);
                            },
                            child: Icon(
                              Icons.sort,
                              size: 25,
                              color: Color.fromRGBO(96, 125, 129, 1),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400], width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: InkWell(
                            onTap: () async {
                              filterData = await Navigator.of(context)
                                  .pushNamed('/filter',
                                      arguments: {'isCity': false}) as Map;
                              print(filterData);
                              setState(() {
                                searched = false;
                              });
                            },
                            child: Icon(
                              Icons.filter_list,
                              size: 25,
                              color: Color.fromRGBO(96, 125, 129, 1),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      user.type == 'admin' || user.type == 'sales'
                          ? InkWell(
                              onTap: () =>
                                  Navigator.of(context).pushNamed('/addOrder'),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey[400], width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.add,
                                    size: 25,
                                    color: Color.fromRGBO(96, 125, 129, 1),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: (snapshot.data.documents.length <= 0)
                    ? Center(
                        child: Text(
                          'No Orders',
                          style: TextStyle(
                              color: Color.fromRGBO(170, 44, 94, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      )
                    : ListView.builder(
                        itemCount: ordersData.length,
                        itemBuilder: (context, i) {
                          final line = ordersData[i].data()['area'] == null
                              ? ordersData[i].data()['city']
                              : ordersData[i].data()['area'];

                          return StatefulBuilder(builder: (context, orderStat) {
                            return InkWell(
                                onDoubleTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text('Description:'),
                                      content: Text(
                                          '${ordersData[i].data()['description']}'),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK!'))
                                      ],
                                    ),
                                  );
                                },
                                onTap: () async {
                                  if (map['type'] == 4) {
                                    final confirmation = await showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('Confirmation'),
                                        content: Text(
                                          'Do you want to procssed?',
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: Text(
                                                'No',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )),
                                          FlatButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: Text(
                                                'Yes',
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ))
                                        ],
                                      ),
                                    );

                                    if (!confirmation) return;

                                    final lastOrders =
                                        map['lastOrders'] as List;
                                    final totalAmount = map['amount'];
                                    final ordersIds = lastOrders
                                        .map((e) => e['docId'])
                                        .toList();
                                    if (ordersIds
                                        .contains(ordersData[i].documentID)) {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text('Validation Error'),
                                          content: Text(
                                              'This order is already in the route'),
                                          actions: <Widget>[
                                            FlatButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: Text('Ok!'))
                                          ],
                                        ),
                                      );
                                      return;
                                    }
                                    if (ordersData[i].data()['status'] !=
                                        'noAction') {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text('Validation Error'),
                                          content: Text(
                                              'This order is already on Distribution'),
                                          actions: <Widget>[
                                            FlatButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: Text('Ok!'))
                                          ],
                                        ),
                                      );
                                      return;
                                    }
                                    checkedOrder.add(ordersData[i].documentID);
                                    orderStat(() {});
                                    lastOrders.add({
                                      'docId': ordersData[i].documentID,
                                      'name': ordersData[i].data()['name'],
                                      'address':
                                          ordersData[i].data()['address'],
                                      'totalAccount': ordersData[i]
                                              .data()['totalAccount'] -
                                          ordersData[i].data()['underAccount'],
                                      'qty': ordersData[i].data()['quantity'],
                                    });
                                    final orderAmount = totalAmount +
                                        ordersData[i].data()['totalAccount'] -
                                        ordersData[i].data()['underAccount'];
                                    await Firestore.instance
                                        .collection('routes')
                                        .document(map['routeId'])
                                        .updateData({
                                      'orders': lastOrders,
                                      'totalAmount': orderAmount
                                    });
                                    final issuesDocs = await Firestore.instance
                                        .collection('orders')
                                        .document(ordersData[i].documentID)
                                        .collection('issues')
                                        .getDocuments();
                                    issuesDocs.documents.forEach((element) {
                                      Firestore.instance
                                          .collection('orders')
                                          .document(ordersData[i].documentID)
                                          .collection('issues')
                                          .document(element.documentID)
                                          .updateData({'isSolved': true});
                                    });
                                    await Firestore.instance
                                        .collection('orders')
                                        .document(ordersData[i].documentID)
                                        .updateData(
                                            {'status': 'onDistribution'});
                                  } else {
                                    if (ordersData[i].data()['isCairo'] &&
                                        !ordersData[i].data()['isCorporate']) {
                                      Navigator.of(context).pushNamed(
                                          '/orderDetails',
                                          arguments: {
                                            'docId': ordersData[i].documentID,
                                          });
                                    } else if (!ordersData[i]
                                            .data()['isCairo'] &&
                                        !ordersData[i].data()['isCorporate']) {
                                      Navigator.of(context).pushNamed(
                                          '/citiyOrderDetails',
                                          arguments: {
                                            'docId': ordersData[i].documentID,
                                          });
                                    } else {
                                      Navigator.of(context).pushNamed(
                                          '/corporateOrderDetails',
                                          arguments: {
                                            'docId': ordersData[i].documentID,
                                          });
                                    }
                                  }
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 1.0),
                                  child: orderItem(
                                    id: ordersData[i].documentID,
                                    address: ordersData[i].data()['address'],
                                    title: '${ordersData[i].data()['name']}',
                                    price: ordersData[i].data()['totalAccount'],
                                    line: '${line}', //area
                                    factoryName:
                                        '${ordersData[i].data()['line']}',
                                    quantity: ordersData[i].data()['quantity'],
                                    date:
                                        '${ordersData[i].data()['createdAt']}',
                                    description:
                                        '${ordersData[i].data()['description']}',
                                    phone: '${ordersData[i].data()['phone']}',
                                    underAccount:
                                        ordersData[i].data()['underAccount'],
                                    number: ordersData[i].data()['orderNumber'],
                                    isChecked: checkedOrder
                                        .contains(ordersData[i].documentID),
                                    type: (ordersData[i].data()['status'] ==
                                            'noAction' &&
                                        ordersData[i].data()['returned'] !=
                                            null &&
                                        !ordersData[i].data()['returned'] &&
                                        user.type != 'sales' &&
                                        user.type != 'warehouse'),
                                    downPayment:
                                        ordersData[i].data()['underAccount'],
                                    issueCount:
                                        ordersData[i].data()['issueCount'],
                                    notesCount:
                                        (ordersData[i].data()['notes'] as List)
                                            .length,
                                  ),
                                ));
                          });
                        },
                      ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget orderItem(
      {id,
      title,
      number,
      price,
      line,
      factoryName,
      quantity,
      date,
      underAccount,
      phone,
      description,
      isChecked,
      type,
      address,
      downPayment,
      issueCount,
      notesCount}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 2,
            color: Colors.grey.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${title}',
                style: TextStyle(
                    color: Color.fromRGBO(170, 44, 94, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Text(
                '#${number}',
                style: TextStyle(
                    color: Color.fromRGBO(170, 44, 94, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Text(
                '${price} EGP',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${factoryName}',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              isChecked != null && isChecked
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                  : SizedBox(),
              Text(
                'QTY : ${quantity}',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${line}',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              InkWell(
                onTap: () => url.launch('tel:${phone}'),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.5, color: Colors.grey.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.call,
                    color: Colors.green,
                    size: 30,
                  ),
                ),
              ),
              type
                  ? InkWell(
                      onTap: () async {
                        final confirmation = await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Confirmation'),
                            content: Text(
                              'Do you want to procssed?',
                            ),
                            actions: <Widget>[
                              FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text(
                                    'No',
                                    style: TextStyle(color: Colors.red),
                                  )),
                              FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.green),
                                  ))
                            ],
                          ),
                        );

                        if (!confirmation) return;
                        final issuesDocs = await Firestore.instance
                            .collection('orders')
                            .document(id)
                            .collection('issues')
                            .getDocuments();
                        issuesDocs.documents.forEach((element) {
                          Firestore.instance
                              .collection('orders')
                              .document(id)
                              .collection('issues')
                              .document(element.documentID)
                              .updateData({'isSolved': true});
                        });
                        await Navigator.of(context)
                            .pushNamed('/newRoute', arguments: {
                          'type': 2,
                          'docId': id,
                          'address': address,
                          'name': title,
                          'totalAccount': price - downPayment,
                          'qty': quantity,
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.5, color: Colors.grey.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                    )
                  : SizedBox(),
              Text(
                '${date}',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Issues: ${issueCount == null ? 0 : issueCount}',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              isChecked != null && isChecked
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                  : SizedBox(),
              Text(
                'Notes: $notesCount',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )
            ],
          ),
        ],
      ),
    );
  }
}
