import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  final String title;
  final String address;
  final String price;
  final String factoryName;
  final String lineName;
  final bool isDistribution;
  final bool isEdit;
  OrderTile(
      {this.title,
      this.address,
      this.price,
      this.factoryName,
      this.lineName,
      this.isDistribution,
      this.isEdit});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 12, left: 8, right: 8),
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: TextStyle(
                  color: Color.fromRGBO(170, 44, 94, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 17.5),
            ),
            subtitle: Text(
              "" + address,
              style: TextStyle(
                  color: Color.fromRGBO(96, 125, 129, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 15.5),
            ),
            trailing: Text(
              price,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    factoryName,
                    style: TextStyle(
                        color: Color.fromRGBO(96, 125, 129, 1), fontSize: 14),
                  ),
                ),
                Center(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Non veniam eu ea anim\noccaecat culpa nisi\ndo veniam aute\nnon irure consequat.'),
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    lineName,
                    style: TextStyle(
                      color: Color.fromRGBO(255, 171, 0, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
       isDistribution == true  ? Container(
            color: Colors.grey[300],
            width: MediaQuery.of(context).size.width,
            height: 3,
          ) : Wrap(),
       isEdit == true  ? Container(
            color: Colors.grey[300],
            width: MediaQuery.of(context).size.width,
            height: 3,
          ) : Wrap(),
          isDistribution == true
              ? Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          "Add to Distribution",
                          style: TextStyle(
                              color: Color.fromRGBO(96, 125, 129, 1),
                              fontSize: 14),
                        ),
                      ),
                      Container(
                        width: 100,
                        child: Center(
                            child: Container(
                          width: 2.5,
                          height: 20,
                          color: Color.fromRGBO(170, 44, 94, 1),
                        )),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 45),
                        child: Text(
                          "Call",
                          style: TextStyle(
                            color: Colors.green[400],
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Wrap(),
          isEdit == true
              ? Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Text(
                          "Edit",
                          style: TextStyle(
                              color: Color.fromRGBO(96, 125, 129, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        child: Center(
                            child: Container(
                          width: 2.5,
                          height: 20,
                          color: Color.fromRGBO(170, 44, 94, 1),
                        )),
                      ),
                      Container(
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Wrap(),
        ],
      ),
    );
  }
}

class CustomizedOrderTile extends StatefulWidget {
  final String title;
  final String address;
  final String price;
  final String factoryName;
  final String lineName;

  CustomizedOrderTile(
      {this.title, this.address, this.price, this.factoryName, this.lineName});

  @override
  _CustomizedOrderTileState createState() => _CustomizedOrderTileState();
}

class _CustomizedOrderTileState extends State<CustomizedOrderTile> {

  var radioGroup = 'true';
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 0, left: 8, right: 8),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.title,
              style: TextStyle(
                  color: Color.fromRGBO(170, 44, 94, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 17.5),
            ),
            subtitle: Text(
              "" + widget.address,
              style: TextStyle(
                  color: Color.fromRGBO(96, 125, 129, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 15.5),
            ),
            trailing: Text(
              widget.price,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    widget.factoryName,
                    style: TextStyle(
                        color: Color.fromRGBO(96, 125, 129, 1), fontSize: 14),
                  ),
                ),
                Center(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Non veniam eu ea anim\noccaecat culpa nisi\ndo veniam aute\nnon irure consequat.'),
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    widget.lineName,
                    style: TextStyle(
                      color: Color.fromRGBO(255, 171, 0, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.grey[300],
            width: MediaQuery.of(context).size.width,
            height: 3,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Radio(
                  activeColor: Colors.red,
                  value: 'false', groupValue: radioGroup, onChanged: (v){
                  setState(() {
                    radioGroup = v;
                  });
                }),
                Container(
                  child: Center(
                      child: Container(
                    width: 2.5,
                    height: 20,
                    color: Color.fromRGBO(170, 44, 94, 1),
                  )),
                ),
                Radio(
                  focusColor: Colors.green,
                  autofocus: true,

                  activeColor: Colors.green[500],
                  value: 'true', groupValue: radioGroup, onChanged: (v){
                  setState(() {
                    radioGroup = v;
                  });
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
