import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
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
        hintColor: Colors.black54,
        hoverColor: Colors.black54,
        backgroundColor: Color(0xFFFFFFFF),
        scaffoldBackgroundColor: Color(0xFFF2F2F6),
        appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFFF2F2F6),
            foregroundColor: Color(0xFF000000)),
        bottomAppBarColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Colors.black),
        cardTheme: CardTheme(
            color: Color(0xFFFFFFFF),
            clipBehavior: Clip.antiAlias,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black, fontSize: 32),
          bodyMedium: TextStyle(color: Colors.black, fontSize: 24),
          bodySmall: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color(0xFF9A57A2),
          hintColor: Colors.white54,
          hoverColor: Colors.white54,
          backgroundColor: Color(0xFF212121),
          scaffoldBackgroundColor: Color(0xFF000000),
          appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFF000000),
              foregroundColor: Color(0xFFFFFFFF)),
          bottomAppBarColor: Color(0xFF212121),
          iconTheme: IconThemeData(color: Colors.white),
          cardTheme: CardTheme(
              color: Color(0xFF1C1C1E),
              clipBehavior: Clip.antiAlias,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.white, fontSize: 32),
            bodyMedium: TextStyle(color: Colors.white, fontSize: 24),
            bodySmall: TextStyle(color: Colors.white, fontSize: 18),
          )),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => MultiProvider(
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
