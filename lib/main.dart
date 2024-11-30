import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:register_work/Theme/theme.dart';
import 'package:register_work/ThemeProvider/theme_provider.dart';
import 'package:register_work/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(builder: (context, notifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: const [Locale('fa', 'IR')],
          locale: const Locale("fa", "IR"),
          title: 'Flutter Demo',
          darkTheme: ThemeData(
            colorScheme: MaterialTheme.darkScheme(),
            useMaterial3: true,
          ),
          theme: ThemeData(
            colorScheme: MaterialTheme.lightScheme(),
            useMaterial3: true,
          ),
          themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
          home: const Home(),
        );
      }),
    );
  }
}
