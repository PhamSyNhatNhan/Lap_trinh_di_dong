
import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:nhonn/Page/HomePage.dart';
import 'package:nhonn/Page/LoginPage.dart';
//import 'package:nhonn/Value/Database.dart';
import 'package:nhonn/class/User.dart';

import 'Value/Database.dart';
import 'class/Dish.dart';
import 'class/DishImage.dart';

late final conn;
final User user = new User('', '', '', '', '', '');
final DateTime defaultDateTime = DateTime.now();
final Dish dish = new Dish('', '', '', '','','','','','' as List<DishImage>);
final DishImage dishimage = new DishImage('', '');

void main() {
  runApp( const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Widget _currentWidget;

  void _changeToHomePage() {
    setState(() {
      _currentWidget = HomePage(onSignOut: () {
        _changeToLoginPage();
      },);
    });
  }

  void _changeToLoginPage() {
    setState(() {
      _currentWidget = LoginPage(onLoginSuccess: () {
        _changeToHomePage();
      },);
    });
  }

  @override
  void initState(){
    super.initState();
    _currentWidget = LoginPage(onLoginSuccess: () {
      _changeToHomePage();
    });

    getConnect();
  }

  Future<void> getConnect() async {
    try{
      conn = await MySQLConnection.createConnection(
        host: sqlTextHost,
        port: int.parse(sqlTextPort),
        userName: sqlTextUser,
        password: sqlTextPassword,
        databaseName: sqlTextDatabase,
      );

      await conn.connect();
    }
    catch(e){
      print("Error connecting");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _currentWidget,
    );
  }


}


