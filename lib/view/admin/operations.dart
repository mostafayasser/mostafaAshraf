import 'package:flutter/material.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';

//Screen 30
class Operations extends StatelessWidget {
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
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: Image.asset('assets/images/DistributionIcon.png'),
              title: Text(
                'Operations',
                style: TextStyle(
                    color: Color.fromRGBO(170, 44, 94, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: size.width / 2.25,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 2.5, color: Colors.grey[400]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset('assets/images/Distribution.png'),
                ),
                Container(
                  width: size.width / 2.25,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 2.5, color: Colors.grey[400]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset('assets/images/Finance.png'),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: size.width / 2.25,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 2.5, color: Colors.grey[400]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset('assets/images/CustomerService.png'),
                ),
                Container(
                  width: size.width / 2.25,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 2.5, color: Colors.grey[400]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset('assets/images/Sales.png'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
