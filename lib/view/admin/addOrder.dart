import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';
import 'package:provider/provider.dart';

enum Channel { Facebook, Instagram, Website }

class AddOrder extends StatefulWidget {
  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  TextEditingController nameController = TextEditingController();

  TextEditingController descriptionConroller = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  TextEditingController underAccountController = TextEditingController();

  TextEditingController quantityController = TextEditingController();

  TextEditingController areaController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  TextEditingController noteController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController channelController = TextEditingController();

  String lineType = 'Pajamas';

  Channel channel;
  bool loading = false;
  final goverments = [
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
    'Suez',
  ];

  List areas = [];

  GlobalKey areaKey = new GlobalKey<AutoCompleteTextFieldState<String>>();

  bool enableArea = false;
  GlobalKey key = new GlobalKey<AutoCompleteTextFieldState<String>>();
  String selected = '';
  String areaSelected = '';
  bool isFinished = false;
  bool isCorporate = false;

  List<String> namesList = [];
  final user = User(name: 'hos', type: 'admin');
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    //final user =Provider.of<UserProvider>(context).user;
    
    cityController.text = selected;
    areaController.text = areaSelected;
    return Scaffold(
      bottomNavigationBar: BottomNavigator(),
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
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
                  'Add new Order',
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
                        Text(
                          'Channel',
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
                          controller: channelController,
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
                        TextField(
                          controller: nameController,
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
                          'Quantity',
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
                          controller: quantityController,
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
                          'City',
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
                          controller: cityController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 1.5),
                              ),
                              hintText: 'Search goverment',
                              suffixIcon: Icon(Icons.search)),
                          itemSubmitted: (item) {
                            print('items' + item);

                            setState(() => selected = item);
                          },
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
                          key: key,
                          suggestions: goverments,
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
                          'Address',
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
                          controller: addressController,
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
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 3.5, color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: DropdownButton<String>(
                        value: lineType,
                        disabledHint: Text('Production line'),
                        hint: Text('Production line'),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromRGBO(170, 44, 94, 1),
                          size: 35,
                        ),
                        //value: lineType,
                        items:[
                            DropdownMenuItem(
                              child: Text('Pajamas'),
                              value: 'Pajamas',
                              onTap: () {
                                setState(() {
                                  lineType = 'Pajamas';
                                });
                              },
                            ),
                            DropdownMenuItem(
                              child: Text('Pants'),
                              value: 'Pants',
                              onTap: () {
                                setState(() {
                                  lineType = 'Pants';
                                });
                              },
                            ),
                            DropdownMenuItem(
                              child: Text('Slipper'),
                              value: 'Slipper',
                              onTap: () {
                                setState(() {
                                  lineType = 'Slipper';
                                });
                              },
                            ),
                            DropdownMenuItem(
                              child: Text('Blankets'),
                              value: 'Blankets',
                              onTap: () {
                                setState(() {
                                  lineType = 'Blankets';
                                });
                              },
                            ),
                            
                          ],
                        onChanged: (value) {
                          setState(() {
                            lineType = value;
                          });
                        },
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Description',
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
                          controller: descriptionConroller,
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
                          'Phone number',
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
                          keyboardType: TextInputType.phone,
                          controller: phoneController,
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
                          'Amount',
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
                          controller: priceController,
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
                          'Downpayment',
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
                          controller: underAccountController,
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
                  user.type == 'admin'
                      ? Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.grey[400], width: 2),
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.all(12),
                          child: Column(
                            children: [
                              CheckboxListTile(
                                value: isCorporate,
                                onChanged: (v) {
                                  setState(() {
                                    if (v) isCorporate = v;
                                  });
                                },
                                title: Text("Is Corporate?"),
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
                ],
              ),
            ),
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : InkWell(
                    onTap: () async {
                      if (nameController.text.isEmpty ||
                          quantityController.text.isEmpty ||
                          descriptionConroller.text.isEmpty ||
                          phoneController.text.isEmpty ||
                          priceController.text.isEmpty ||
                          underAccountController.text.isEmpty ||
                          addressController.text.isEmpty ||
                          channelController.text.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: Text('Validation Error'),
                                  content: Text('Please complete all fields'),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text('Ok!'))
                                  ],
                                ));
                        return;
                      }
                     

                      String name = nameController.text;
                      int quantity = int.parse(quantityController.text);
                      String area = areaController.text;
                      String address = addressController.text;

                      
                      String description = descriptionConroller.text;
                      String phoneNumber = phoneController.text;
                      double amount = double.parse(priceController.text);
                      double downpayment =
                          double.parse(underAccountController.text);
                      String date = DateFormat.yMd().format(DateTime.now());
                      String channel = channelController.text;
                      setState(() {
                        loading = true;
                      });
                      if (downpayment > amount) {
                        showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                                  title: Text('Validation Error'),
                                  content: Text(
                                      'The downpayment can\'t be greater than total amount'),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text('Ok!'))
                                  ],
                                ));
                        return;
                      }

                      List note = [];
                      if (noteController.text.isNotEmpty) {
                        note.add(
                            {'note': noteController.text, 'from': user.name});
                      }

                      
                        await Firestore.instance.collection('orders').add({
                          'time': DateTime.now(),
                          'city': selected,
                          'notes': note,
                          'createdAt': date,
                          'description': description,
                          'line': lineType,
                          'name': name,
                          'phone': phoneNumber,
                          'quantity': quantity,
                          'totalAccount': amount,
                          'underAccount': downpayment,
                          'address': address,
                          'status': 'noAction',
                          'isCairo': false,
                          'isCorporate': isCorporate,
                          'issued': false,
                          'returned': false,
                          'channel': channel,
                        });
                      
                      await showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Text('Operation Succeeded'),
                          content:
                              Text('The Order has beeen added successfully'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(),
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
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
