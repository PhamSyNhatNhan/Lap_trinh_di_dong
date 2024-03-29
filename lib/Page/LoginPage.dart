import 'package:flutter/material.dart';
import 'package:nhonn/MaterialPage/LoginMat.dart';
import 'package:nhonn/MaterialPage/RegisterMat.dart';
//import 'package:nhonn/Value/color.dart';

class LoginPage extends StatefulWidget{
  final VoidCallback onLoginSuccess;
  const LoginPage({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  State<LoginPage> createState() =>_LoginPage();

}

class _LoginPage extends State<LoginPage> {
  int index = 0;

  void select(int page){
    print("change");
    setState(() {
      index = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      LoginMat(
        changePage: () {
          select(1);
        },
        loginSuccess: () {
          widget.onLoginSuccess();
        },
      ),
      RegisterMat(changePage: () {
        select(0);
      }),
    ];

    return Scaffold(
      body: pages[index],
    );
  }
}