import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portfolio/provider/AuthProvider.dart' as auth;
import 'package:flutter_portfolio/routing/app_router.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<auth.AuthProvider>(
          create: (_) => auth.AuthProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter().router,
      title: 'Flutter Portfolio',
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
