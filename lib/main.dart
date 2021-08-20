import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/pagination_bloc.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/ui/Home/home.dart';
import 'package:subsuke/ui/Update/update.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Subsuke',
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.purple,
          primarySwatch: Colors.purple,
          scaffoldBackgroundColor: Colors.white,
          bottomAppBarColor: Colors.white54,
          hintColor: Colors.black54,
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.black, fontSize: 24),
            bodyText2: TextStyle(color: Colors.black54, fontSize: 18),
          )),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.deepPurple,
          primarySwatch: Colors.deepPurple,
          backgroundColor: Colors.black,
          scaffoldBackgroundColor: Colors.black,
          bottomAppBarColor: Colors.black54,
          hintColor: Colors.white54,
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.white, fontSize: 24),
            bodyText2: TextStyle(color: Colors.white54, fontSize: 18),
          )),
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => Provider<PaginationBloc>(
              create: (context) => PaginationBloc(),
              dispose: (context, bloc) => bloc.dispose(),
              child: HomeScreen(),
            ),
        '/edit': (BuildContext context) => Provider<EditScreenBloc>(
              create: (context) => EditScreenBloc(),
              dispose: (context, bloc) => bloc.dispose(),
              child: EditScreen(),
            ),
      },
    );
  }
}
