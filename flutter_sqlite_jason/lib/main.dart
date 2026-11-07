import 'package:flutter/material.dart';

import 'screens.dart';

import 'package:go_router/go_router.dart';

import 'product_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await ProductDatabase.open();
  runApp(MyApp(database: database));
}

/// Main App with GoRouter
/* class MyApp extends StatelessWidget {
  MyApp({super.key, required this.database});

  final ProductDatabase database;

  // Define routes
  late final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/add',
        name: 'add',
        builder: (context, state) => AddScreen(database: database),
      ),
      GoRoute(
        path: '/list',
        name: 'list',
        builder: (context, state) => ListScreen(database: database),
      ),
    ],
    errorBuilder: (context, state) =>
        ErrorScreen(message: state.error.toString()),
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'GoRouter Example',
      routerConfig: _router,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}*/

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.database});

  final ProductDatabase database;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',

      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/add',
          builder: (context, state) => AddScreen(database: database),
        ),
        GoRoute(
          path: '/list',
          builder: (context, state) => ListScreen(database: database),
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Product Management',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: router,
    );
  }
}

// Example of returning data

//class Address {
//  final String street;
//  final String city;

//  const Address({required this.street, required this.city});
//}
