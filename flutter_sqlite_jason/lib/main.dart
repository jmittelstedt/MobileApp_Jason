import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

/// Home screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jason Mittelstedt')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/add'),
              child: const Text('Add Product'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/list'),
              child: const Text('List products'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Add screen
class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/'),
          child: const Text('Back'),
        ),
      ),
    );
  }
}

/// List screen
class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/'),
          child: const Text('Back'),
        ),
      ),
    );
  }
}

/// Error screen
class ErrorScreen extends StatelessWidget {
  final String message;
  const ErrorScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text(message)),
    );
  }
}

/// Main App with GoRouter
class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Define routes
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/add',
        name: 'add',
        builder: (context, state) => const AddScreen(),
      ),
      GoRoute(
        path: '/list',
        name: 'list',
        builder: (context, state) => const ListScreen(),
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
}

// Example of returning data

class Address {
  final String street;
  final String city;

  const Address({required this.street, required this.city});
}
