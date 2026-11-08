import 'package:flutter/material.dart';

import 'screens.dart';

import 'package:go_router/go_router.dart';

import 'product_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await ProductDatabase.open();
  runApp(MyApp(database: database));
}

class Routes {
  static const String home = '/';
  static const String add = '/add';
  static const String list = '/list';
}

/// Main App with GoRouter
class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.database});

  final ProductDatabase database;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: Routes.home,

      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: Routes.add,
          builder: (context, state) => AddScreen(database: database),
        ),
        GoRoute(
          path: Routes.list,
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

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.deepPurpleAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Text(
              'Products',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              context.go(Routes.home);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add product'),
            onTap: () {
              context.go(Routes.add);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Product list'),
            onTap: () {
              context.go(Routes.list);
            },
          ),
        ],
      ),
    );
  }
}
