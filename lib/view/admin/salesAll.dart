import 'package:flutter/material.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';


//Screen 38
class SalesAll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;
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
        actions: <Widget>[
          Icon(
            Icons.notifications_none,
            color: Color.fromRGBO(170, 44, 94, 1),
          )
        ],
      ),
      body: SizedBox(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                leading: Image.asset('assets/images/AllIcon.png'),
                title: Text(
                  'Sales',
                  style: TextStyle(
                      color: Color.fromRGBO(170, 44, 94, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                trailing: Icon(
                  Icons.search,
                  color: Colors.grey[400],
                  size: 32,
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                            border:
                                Border.all(width: 2.5, color: Colors.grey[400]),
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '9723 EGP',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            ],
                          ),
                          title: Text(
                            'Tarek Darwesh',
                            style: TextStyle(
                              color: Color.fromRGBO(170, 44, 94, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'New Cairo Narges 2, NO. 41',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(131, 153, 158, 1),
                                fontWeight: FontWeight.bold),
                          ), //rgb(131, 153, 158)
                        ),
                      );
                    },
                    itemCount: 6)),
          ],
        ),
      ),
    );
  }
}
