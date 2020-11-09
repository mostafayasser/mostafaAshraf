import 'package:flutter/material.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';
import 'package:maglis_app/widgets/orderTile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2, color: Colors.grey[400].withOpacity(0.9)),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.search, color: Colors.grey[500]),
                        ),
                        border: InputBorder.none),
                  ),
                ),
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[400],
                    width: 2
                  ),
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
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              title: Text(
                'Orders',
                style: TextStyle(
                    color: Color.fromRGBO(170, 44, 94, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              trailing: Icon(
                Icons.sort,
                size: 30,
                color: Color.fromRGBO(96, 125, 129, 1),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: OrderTile(
                      title: 'Tarek Darwesh',
                      price: '22,000 EGP',
                      address: 'New Cairo',
                      factoryName: 'Bean Bags',
                      lineName: 'Cairo - 23 Street',
                      isDistribution: false,
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
