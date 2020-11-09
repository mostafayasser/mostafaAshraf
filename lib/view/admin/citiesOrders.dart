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

class CitiesOrders extends StatefulWidget {
  @override
  _CitiesOrdersState createState() => _CitiesOrdersState();
}

class _CitiesOrdersState extends State<CitiesOrders> {
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

  List<String> recomendations = [];

  Future orderstream;

  List<String> checkedOrder = [];

  String status = '';
  var title = 'All';
  var logo = 'assets/images/AllIcon.png';
  Query firestoreQuery;
  Future<QuerySnapshot> checkFilter(Query firestoreQuery) async {
    final preference = await SharedPreferences.getInstance();
    final lines = preference.getStringList('lines');
    final city = preference.getStringList('city');
    final date = preference.getString('date');
    final month = preference.getInt('month');
    filterData = {};
    if (city != null && city.length > 0) {
      filterData['areas'] = city;
      firestoreQuery = firestoreQuery.where('city', whereIn: city);
    }

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

    final user = Provider.of<UserProvider>(context).user;
    bool cancel = false;
    searchController.text = selected;
    if (!searched) {
      if (filterData == null) {
        // print(map['type']);
        if (map != null) {
          // print(map['date']);
          if (map['type'] == 1) {
            title = 'No Action';
            status = 'noAction';
            logo = 'assets/images/CancelIcon.png';
            orderstream = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: 'noAction')
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false)
                .getDocuments();
            firestoreQuery = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: 'noAction')
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false);
          } else if (map['type'] == 2) {
            title = 'On Distribution';
            status = 'onDistribution';
            logo = 'assets/images/NotApproved.png';
            orderstream = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: 'onDistribution')
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false)
                .getDocuments();
            firestoreQuery = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: 'onDistribution')
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false);
          } else if (map['type'] == 3) {
            title = 'Shipped';
            status = 'shipped';
            logo = 'assets/images/PersonCheck.png';
            orderstream = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: 'shipped')
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false)
                .getDocuments();
            firestoreQuery = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: 'shipped')
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false);
          } else if (map['type'] == 4) {
            title = 'Collected';
            status = 'collected';
            logo = 'assets/images/PersonCheck.png';
            orderstream = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: 'collected')
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false)
                .getDocuments();
            firestoreQuery = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: 'collected')
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false);
            print(orderstream.toString());
          } else if (map['type'] == 5) {
            title = 'Archived';
            logo = 'assets/images/DateIcon.png';
            status = 'archived';
            orderstream = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: 'archived')
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false)
                .getDocuments();
            firestoreQuery = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: 'archived')
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false);
            print(orderstream.toString());
          } else if (map['type'] == 6) {
            title = 'Cancel';
            logo = 'assets/images/CancelIcon.png';
            status = 'canceled';
            orderstream = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: 'canceled')
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false)
                .getDocuments();
            firestoreQuery = Firestore.instance
                .collection('orders')
                .where('status', isEqualTo: 'canceled')
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false);
            print(orderstream.toString());
          } else {
            title = 'All';
            logo = 'assets/images/OrdersIcon.png';
            status = '';
            orderstream = Firestore.instance
                .collection('orders')
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false)
                .getDocuments();
            firestoreQuery = Firestore.instance
                .collection('orders')
                .where('isCairo', isEqualTo: false)
                .where('isCorporate', isEqualTo: false);
          }
        } else {
          status = '';
          orderstream = Firestore.instance
              .collection('orders')
              .where('isCairo', isEqualTo: false)
              .where('isCorporate', isEqualTo: false)
              .getDocuments();
          firestoreQuery = Firestore.instance
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

        if (status.isNotEmpty && status != null) {
          firestoreQuery = firestoreQuery.where('status', isEqualTo: status);
        }

        if (areas != null && areas.length > 0) {
          firestoreQuery = firestoreQuery.where('city', whereIn: areas);
        }

        if (date != null && date.isNotEmpty) {
          firestoreQuery = firestoreQuery.where('createdAt', isEqualTo: date);
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
              ],
            ),
            body: Column(children: [
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
                        width: 40,
                        height: 40,
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
                        width: 40,
                        height: 40,
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
                                      arguments: {'isCity': true}) as Map;
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
                      user.type == 'admin' ||
                              user.type == 'sales' ||
                              user.type == 'operation'
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
                child: snapshot.data.documents.length <= 0
                    ? Center(
                        child: Text(
                          'No Orders to Routed',
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
                                Navigator.of(context).pushNamed(
                                    '/citiyOrderDetails',
                                    arguments: {
                                      'docId': ordersData[i].documentID,
                                    });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 1.0),
                                child: orderItem(
                                  id: ordersData[i].documentID,
                                  address: ordersData[i].data()['address'],
                                  title: '${ordersData[i].data()['name']}',
                                  price: ordersData[i].data()['totalAccount'],
                                  factoryName:
                                      '${ordersData[i].data()['line']}',
                                  quantity: ordersData[i].data()['quantity'],
                                  date: '${ordersData[i].data()['createdAt']}',
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
                                  city: ordersData[i].data()['city'],
                                  issueCount:
                                      ordersData[i].data()['issueCount'],
                                  notesCount:
                                      (ordersData[i].data()['notes'] as List)
                                          .length,
                                ),
                              ),
                            );
                          });
                        },
                      ),
              )
            ]),
          );
        });
  }

  Widget orderItem(
      {id,
      title,
      number,
      price,
      factoryName,
      quantity,
      date,
      underAccount,
      phone,
      description,
      isChecked,
      type,
      address,
      city,
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
                '$city',
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
                        bool confirm = await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: Text('Confirmation?'),
                                  content: Text('Do you want to processe?'),
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
                                    )
                                  ],
                                ));
                        if (!confirm) return;
                        Firestore.instance
                            .collection('orders')
                            .document(id)
                            .updateData({
                          'status': 'shipped',
                        }).then((value) => Navigator.of(context).pop());
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
