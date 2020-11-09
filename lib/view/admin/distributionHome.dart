import 'package:flutter/material.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:maglis_app/widgets/bottomNavigator.dart';
import 'package:provider/provider.dart';

class DistributionHome extends StatefulWidget {
  @override
  _DistributionState createState() => _DistributionState();
}

class _DistributionState extends State<DistributionHome> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
        bottomNavigationBar: BottomNavigator(),
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          elevation: 10,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Image.asset(
            'assets/images/logo.png',
            width: 170,
          ),
        ),
        body: Column(children: [
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: Image.asset('assets/images/DistributionIcon.png'),
              title: Text(
                'Distribution',
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
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () => Navigator.of(context)
                            .pushNamed('/distributionCities'),
                        child: Container(
                          width: size.width / 2.25,
                          height: 170,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(width: 2.5, color: Colors.grey[400]),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child:
                                    Image.asset('assets/images/LinesIcon.png'),
                                width: 100,
                                height: 100,
                              ),
                              Text(
                                'Cities',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(134, 134, 134, 1),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ),
                      user.type == 'admin' ||
                              user.type == 'warehouse' ||
                              user.type == 'operation'
                          ? InkWell(
                              onTap: () => Navigator.of(context)
                                  .pushNamed('/corporateHome'),
                              child: Container(
                                width: size.width / 2.25,
                                height: 170,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 2.5, color: Colors.grey[400]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Image.asset(
                                          'assets/images/AllIcon.png'),
                                      width: 100,
                                      height: 100,
                                    ),
                                    Text(
                                      'Corporation',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromRGBO(134, 134, 134, 1),
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}

// import 'package:flutter/material.dart';

// class Distribute extends StatefulWidget {
//   @override
//   _DistributeState createState() => _DistributeState();
// }

// class _DistributeState extends State<Distribute> {
//   List checkedMap = [];
//   var expanded = true;
//   @override
//   Widget build(BuildContext context) {
//     // for (var i = 0; i < 4; i++) {
//     //   if (days.length  4) {
//     //     checkedMap.add({
//     //       'value': false,
//     //     });

//     //     days.add(CheckboxListTile(
//     //         title: Text(
//     //           'Sunday 13.04.2020',
//     //           style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
//     //         ),
//     //         activeColor: Colors.orange,
//     //         autofocus: true,
//     //         value: checkedMap[i]['value'],
//     //         onChanged: (v) => onChanged(v, i)));
//     //   }
//     // }

//     return Scaffold(
//       backgroundColor: Colors.grey[200],
//       appBar: AppBar(
//         elevation: 10,
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         title: Image.asset(
//           'assets/images/logo.png',
//           width: 170,
//         ),
//       ),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 10,
//           ),
//           Container(
//             color: Colors.white,
//             child: ListTile(
//               title: Text(
//                 '',
//                 style: TextStyle(
//                     color: Color.fromRGBO(170, 44, 94, 1),
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20),
//               ),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey[400], width: 2),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(6.0),
//                       child: Icon(
//                         Icons.sort,
//                         size: 25,
//                         color: Color.fromRGBO(96, 125, 129, 1),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: 15,
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey[400], width: 2),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(6.0),
//                       child: Icon(
//                         Icons.add,
//                         size: 25,
//                         color: Color.fromRGBO(96, 125, 129, 1),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Container(
//             color: Colors.white,
//             child: Column(
//               children: <Widget>[
//                 ListTile(
//                   onTap: () {
//                     if (expanded == true) {
//                       setState(() {
//                         expanded = false;
//                       });
//                     } else {
//                       setState(() {
//                         expanded = true;
//                       });
//                     }
//                   },
//                   trailing: Icon(
//                     expanded == false ? Icons.expand_more : Icons.expand_less,
//                     color: Color.fromRGBO(170, 44, 94, 1),
//                   ),
//                   title: Text(
//                     'Day',
//                     style: TextStyle(
//                         color: Color.fromRGBO(170, 44, 94, 1),
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20),
//                   ),
//                 ),
//                 expanded == true
//                     ? Container(
//                         height: double.parse((4 * 55).toString()),
//                         child: ListView.builder(
//                           itemCount: 4,
//                           itemBuilder: (context, i) {
//                             checkedMap.add({
//                               'value': false,
//                             });
//                             return CheckboxListTile(
//                                 title: Text(
//                                   'Sunday 13.04.2020',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 18),
//                                 ),
//                                 activeColor: Colors.orange,
//                                 autofocus: true,
//                                 value: checkedMap[i]['value'],
//                                 onChanged: (v) {
//                                   if (checkedMap[i]['value'] == true) {
//                                     setState(() {
//                                       checkedMap[i]['value'] = false;
//                                     });
//                                   } else {
//                                     setState(() {
//                                       checkedMap[i]['value'] = true;
//                                     });
//                                   }
//                                 });
//                           },
//                         ),
//                       )
//                     : Wrap()
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           Expanded(
//               child: ListView.builder(
//                   itemCount: 5,
//                   itemBuilder: (context, i) {
//                     return Container(

//                       color: Colors.white,

//                       child: ListTile(
//                         trailing: Icon(Icons.edit,
//                         color: Colors.orange,),
//                         subtitle: Text(
//                           "18.05.2020",
//                           style: TextStyle(
//                             color: Color.fromRGBO(96, 125, 129, 1),
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600
//                           ),
//                         ),
//                         title: Text(
//                           "Mohamed Amr",
//                           style: TextStyle(
//                               fontSize: 17, fontWeight: FontWeight.w600),
//                         ),
//                       ),
//                     );
//                   }))
//         ],
//       ),
//     );
//   }
// }
