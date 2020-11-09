import 'package:flutter/material.dart';

class AddRepresentatives extends StatefulWidget {
  @override
  _AddRepresentativesState createState() => _AddRepresentativesState();
}

class _AddRepresentativesState extends State<AddRepresentatives> {
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
                'Add Representatives',
                style: TextStyle(
                    color: Color.fromRGBO(170, 44, 94, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: Colors.grey[400].withOpacity(0.9)),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Name',
                            contentPadding: EdgeInsets.only(left: 15),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: Colors.grey[400].withOpacity(0.9)),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Mobile Number',
                            contentPadding: EdgeInsets.only(left: 15),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: SizedBox()),
          Material(
            color: Colors.white,
            elevation: 20,
                      child: Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Center(
                child: Text('ADD',style: TextStyle(
                      color: Color.fromRGBO(170, 44, 94, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
