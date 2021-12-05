import 'package:basics/layout/todoAppLayouts/todoHome.dart';
import 'package:basics/shared/bloc_observe/bloc_observe.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

void main(){
 Bloc.observer = MyBlocObserver();

  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}