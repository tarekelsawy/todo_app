// @dart=2.9
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/shared/bloc_observer.dart';

import 'layout/todo_home_layout.dart';
// import 'modules/login/LoginScreen.dart';
// import 'my_contacts.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoHome(),
    );
  }
}
