import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ViewModels
import 'core/constants/app_routes.dart';
import 'features/auth/viewmodels/sign_up_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignUpViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sallony',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: AppRoutes.splash, // écran initial
      routes: AppRoutes.routes,       // toutes les routes
    );
  }
}
