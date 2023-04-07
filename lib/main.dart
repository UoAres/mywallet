// @dart=2.9
import 'package:flutter/material.dart';
import 'routes/Routes.dart';

void main() => runApp(MyWallet());

class MyWallet extends StatelessWidget {
  const MyWallet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/', //what is the initial route
        onGenerateRoute: onGenerateRoute); //what is the route behavior
  }
}
