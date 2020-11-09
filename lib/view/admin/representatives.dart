import 'package:flutter/material.dart';

class RepresentativesPage extends StatefulWidget {
  @override
  _RepresentativesPageState createState() => _RepresentativesPageState();
}

class _RepresentativesPageState extends State<RepresentativesPage> {
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
              title: Text(
                'Representatives',
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
                      Divider(),

        
           Container(
              color: Colors.white,
              child: ListTile(
                trailing: Icon(
                  Icons.navigate_next,
                  color: Color.fromRGBO(170, 44, 94, 1),
                ),
                title: Text(
                  'Tamer Ayman',
                  style: TextStyle(
                      color: Color.fromRGBO(170, 44, 94, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
             Container(
              color: Colors.white,
              child: ListTile(
                trailing: Icon(
                  Icons.navigate_next,
                  color: Color.fromRGBO(170, 44, 94, 1),
                ),
                title: Text(
                  'Mohanad Ismail',
                  style: TextStyle(
                      color: Color.fromRGBO(170, 44, 94, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
             Container(
              color: Colors.white,
              child: ListTile(
                trailing: Icon(
                  Icons.navigate_next,
                  color: Color.fromRGBO(170, 44, 94, 1),
                ),
                title: Text(
                  'Mohamed Ahmed',
                  style: TextStyle(
                      color: Color.fromRGBO(170, 44, 94, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
