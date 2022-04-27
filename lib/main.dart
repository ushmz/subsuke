import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:subsuke/blocs/edit_screen_bloc.dart';
import 'package:subsuke/blocs/pagination_bloc.dart';
import 'package:subsuke/blocs/settings_bloc.dart';
import 'package:subsuke/blocs/subscription_item_bloc.dart';
import 'package:subsuke/ui/entrypoints/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [Locale('en', ''), Locale('ja', 'JP')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      title: 'Subsuke',
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFF8B4492),
          primarySwatch: Colors.purple,
          scaffoldBackgroundColor: Colors.white,
          bottomAppBarColor: Color(0xFF8B4492),
          hintColor: Colors.black54,
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.black, fontSize: 24),
            bodyText2: TextStyle(color: Colors.black54, fontSize: 18),
          )),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color(0xFF9A57A2),
          primarySwatch: Colors.deepPurple,
          backgroundColor: Color(0xFF252428),
          scaffoldBackgroundColor: Color(0xFF252428),
          bottomAppBarColor: Color(0xFF8B4492),
          hintColor: Colors.white54,
          iconTheme: IconThemeData(color: Colors.white),
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.white, fontSize: 24),
            bodyText2: TextStyle(color: Colors.white54, fontSize: 18),
          )),
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => MultiProvider(
              providers: [
                Provider<PaginationBloc>(
                  create: (context) => PaginationBloc(),
                  dispose: (context, bloc) => bloc.dispose(),
                ),
                Provider<SubscriptionItemBloc>(
                  create: (context) => SubscriptionItemBloc(),
                  dispose: (context, bloc) => bloc.dispose(),
                ),
                Provider<SettingsBloc>(
                  create: (context) => SettingsBloc(),
                  dispose: (context, bloc) => bloc.dispose(),
                )
              ],
              child: HomeScreen(),
            ),
        /* '/edit': (BuildContext context) => Provider<EditScreenBloc>( */
        /*       create: (context) => EditScreenBloc(), */
        /*       dispose: (context, bloc) => bloc.dispose(), */
        /*       child: EditScreen(), */
        /*     ), */
      },
    );
  }
}
