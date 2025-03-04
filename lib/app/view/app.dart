import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_shop/l10n/l10n.dart';
import 'package:online_shop/product/product.dart';
import 'package:online_shop/route_path.dart';
import 'package:online_shop/welcome/welcome.dart';

class App extends StatelessWidget {
  const App({
    required this.theme,
    super.key,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme.copyWith(
        textTheme: GoogleFonts.latoTextTheme(theme.textTheme),
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        WelcomeLocalizations.delegate,
        ProductLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('en'),
        Locale('es'),
      ],
      // home: const CounterPage(),
      initialRoute: '/',
      routes: {
        RoutePath.welcome: (context) => const WelcomePage(),
        RoutePath.product: (context) => const ProductPage(),
      },
    );
  }
}
