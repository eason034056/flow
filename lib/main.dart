import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'views/home_page.dart';
import 'controllers/auth_controller.dart';
import 'controllers/drink_record_controller.dart';
import 'views/rewards_page.dart';
import 'views/settings_page.dart';
import 'controllers/quick_add_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  final authController = AuthController();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authController),
        ChangeNotifierProvider(create: (_) => DrinkRecordController()),
        ChangeNotifierProvider(
          create: (_) => QuickAddController(authController),
        ),
      ],
      child: MaterialApp(
        title: '智能水壺',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            primary: Colors.blue,
            secondary: Colors.lightBlue,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        home: const HomePage(),
        routes: {
          '/rewards': (context) => const RewardsPage(),
          '/settings': (context) => const SettingsPage(),
        },
      ),
    ),
  );
}
