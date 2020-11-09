import 'package:flutter/material.dart';
import 'package:maglis_app/controllers/userProvider.dart';
import 'package:provider/provider.dart';

class BottomNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    //final user = Provider.of<UserProvider>(context).user;
    final size = MediaQuery.of(context).size;
    if (user.type == 'admin') {
      return Container(
        width: size.width,
        height: size.height * 0.09,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            InkWell(
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  '/finance', ModalRoute.withName('/admin')),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/FinanceIcon.png',
                    width: 45,
                    height: 45,
                  ),
                  Text('Finance'),
                ],
              ),
            ),
            VerticalDivider(),
            InkWell(
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  '/distributionHome', ModalRoute.withName('/admin')),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/DistributionIcon.png',
                    width: 45,
                    height: 45,
                  ),
                  Text('Operation'),
                ],
              ),
            ),
            VerticalDivider(),
            InkWell(
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  '/orderScreen', ModalRoute.withName('/admin')),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/OrdersIcon.png',
                    width: 45,
                    height: 45,
                  ),
                  Text('Orders'),
                ],
              ),
            ),
            VerticalDivider(),
            InkWell(
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  '/issueHome', ModalRoute.withName('/admin')),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/Report.png',
                    width: 45,
                    height: 45,
                  ),
                  Text('Issues'),
                ],
              ),
            )
          ],
        ),
      );
    } else if (user.type == 'operation') {
      return Container(
        width: size.width,
        height: size.height * 0.09,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            InkWell(
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  '/finance', ModalRoute.withName('/operation')),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/FinanceIcon.png',
                    width: 45,
                    height: 45,
                  ),
                  Text('Finance'),
                ],
              ),
            ),
            VerticalDivider(),
            InkWell(
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  '/distributionHome', ModalRoute.withName('/operation')),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/DistributionIcon.png',
                    width: 45,
                    height: 45,
                  ),
                  Text('Operation'),
                ],
              ),
            ),
            VerticalDivider(),
            InkWell(
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  '/orderScreen', ModalRoute.withName('/operation')),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/OrdersIcon.png',
                    width: 45,
                    height: 45,
                  ),
                  Text('Orders'),
                ],
              ),
            ),
            VerticalDivider(),
            InkWell(
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  '/issueHome', ModalRoute.withName('/operation')),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/Report.png',
                    width: 45,
                    height: 45,
                  ),
                  Text('Issues'),
                ],
              ),
            )
          ],
        ),
      );
    } else if (user.type == 'warehouse') {
      return Container(
        width: size.width,
        height: size.height * 0.09,
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            InkWell(
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  '/finance', ModalRoute.withName('/warehouse')),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/FinanceIcon.png',
                    width: 45,
                    height: 45,
                  ),
                  Text('Finance'),
                ],
              ),
            ),
            VerticalDivider(),
            InkWell(
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  '/distributionHome', ModalRoute.withName('/warehouse')),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/DistributionIcon.png',
                    width: 45,
                    height: 45,
                  ),
                  Text('Operation'),
                ],
              ),
            ),
            VerticalDivider(),
            InkWell(
              onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  '/issueHome', ModalRoute.withName('/warehouse')),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/Report.png',
                    width: 45,
                    height: 45,
                  ),
                  Text('Issues'),
                ],
              ),
            )
          ],
        ),
      );
    }
    return Container(
      width: size.width,
      height: size.height * 0.09,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                '/orderScreen', ModalRoute.withName('/admin')),
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/images/OrdersIcon.png',
                  width: 45,
                  height: 45,
                ),
                Text('Orders'),
              ],
            ),
          ),
          VerticalDivider(),
          InkWell(
            onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                '/issueHome', ModalRoute.withName('/sales')),
            child: Column(
              children: <Widget>[
                Image.asset(
                  'assets/images/Report.png',
                  width: 45,
                  height: 45,
                ),
                Text('Issues'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
