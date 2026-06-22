import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';


import 'package:shared_preferences/shared_preferences.dart';

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Udaya Wedding',
      debugShowCheckedModeBanner: false,
      scrollBehavior: NoScrollbarBehavior(),
      initialRoute: AppRoutes.HOME,
      getPages: AppPages.pages,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD83076)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFCF9F6),
        textTheme: GoogleFonts.loraTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}
