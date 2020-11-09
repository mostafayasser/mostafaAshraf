import 'package:flutter/material.dart';

class BeforeLogin extends StatefulWidget {
  @override
  _BeforeLoginState createState() => _BeforeLoginState();
}

class _BeforeLoginState extends State<BeforeLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png',width: 220,),
            SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: ()=> Navigator.pushReplacementNamed(context, '/login'),
                          child: Container(
                width: 225,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Sign In",
                      style: TextStyle(color: Colors.blueGrey[600].withOpacity(0.9), fontSize: 20,
                      fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey[600].withOpacity(0.9),
                  width: 2.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
