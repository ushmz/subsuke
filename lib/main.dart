import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/pagination_bloc.dart';
import 'package:subsuke/ui/screen/home.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.purple,
      ),
      home: Provider<PaginationBloc>(
				create: (context) => PaginationBloc(),
				dispose: (context, bloc) => bloc.dispose(),
				child: HomeScreen(),
			),
    );
  }
}


