//Screen 12
import 'package:flutter/material.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';

class DateDetails extends StatelessWidget {
  const DateDetails({Key key}) : super(key: key);

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
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: Image.asset(
                'assets/images/DateIcon.png',
                width: 50,
                height: 50,
              ),
              title: Text(
                '18/05/2020',
                style: TextStyle(
                    color: Color.fromRGBO(170, 44, 94, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              trailing: Icon(
                Icons.search,
                size: 30,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.5), width: 2),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      'Mohamed Amr',
                      style: TextStyle(
                          color: Color.fromRGBO(170, 44, 94, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    subtitle: Text(
                      'New Cairo',
                      style: TextStyle(
                          color: Color.fromRGBO(183, 196, 199, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    trailing: Icon(
                      Icons.info,
                      color: Colors.amber,
                      size: 30,
                    ),
                  ),
                );
              },
              itemCount: 10,
              reverse: true,
            ),
          ))
        ],
      ),
    );
  }
}
