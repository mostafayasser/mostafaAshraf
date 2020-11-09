import 'package:flutter/material.dart';

class GridItems extends StatelessWidget {
  final firstItemName;
  final firstItemAsset;
  final secondItemName;
  final secondItemAsset;

  GridItems({this.firstItemAsset,this.firstItemName,this.secondItemAsset,this.secondItemName});
  @override
  Widget build(BuildContext context) {
    return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          width: 2.5, color: Colors.grey[400].withOpacity(0.9)),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical:20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timeline,
                            color: Color.fromRGBO(170, 44, 94, 1),
                            size: 30,
                          ),
                          Text(
                            firstItemName,
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          width: 2.5, color: Colors.grey[400].withOpacity(0.9)),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timeline,
                            color: Color.fromRGBO(170, 44, 94, 1),
                            size: 30,
                          ),
                          Text(
                            secondItemName,
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
  }
}