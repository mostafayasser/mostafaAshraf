import 'package:flutter/material.dart';
import 'package:maglis_app/widgets/orderTile.dart';

class ReprePage extends StatefulWidget {
  @override
  _ReprePageState createState() => _ReprePageState();
}

class _ReprePageState extends State<ReprePage> {
  @override
  Widget build(BuildContext context) {
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

      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              subtitle: Text(
                          "18.05.2020",
                          style: TextStyle(
                            color: Color.fromRGBO(96, 125, 129, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.w600
                          ),
                        ),
              title: Text(
                'Mohamed Amr',
                style: TextStyle(
                    color: Color.fromRGBO(170, 44, 94, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400], width: 2),
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
                      isEdit: true,
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
