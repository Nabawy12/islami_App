import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islami_app/Screens/Quran/Surah/Surah.dart';
import 'package:islami_app/Screens/Splash/splash.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:islami_app/Screens/Tasbeeh/tasbeeh.dart';
import 'Screens/Home/home.dart';
import 'Screens/Qbla/abla.dart';
import 'Screens/Quran/Quran.dart';
import 'core/LastReadService/lastread.dart';

void main ()async{
  WidgetsFlutterBinding.ensureInitialized();
  await LastReadService.init();
  runApp(QuranApp());
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en'),
      supportedLocales: const [Locale('en')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner:  false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        QuranScreen.routeName: (context) => QuranScreen(),
        SurahScreen.routeName: (context) => SurahScreen(),
        QiblaScreen.routeName: (context) => QiblaScreen(),
        TasbeehScreen.routeName: (context) => TasbeehScreen(),
      },
    );
  }
}


