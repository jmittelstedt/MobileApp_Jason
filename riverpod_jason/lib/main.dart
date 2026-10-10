import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todo.dart';

final fetchTodosProvider = FutureProvider<List<Todo>>((ref) async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/todos');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Todo.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load todos');
  }
});

void main() {
  runApp(
    // Always wrap the root of your app in a ProviderScope
    ProviderScope(child: MyApp()),
  );
}

/// Home screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    final double rowHeight = (screen.height - 20) / 6;
    final double colWidth = screen.width / 2;

    return Scaffold(
      appBar: AppBar(title: const Text('Home'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: rowHeight + 10,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'Riverpod Async Data Fetching by Jason',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 8.0,
                  ), // Optional: adds space between the lines
                  Text(
                    'Click the button below to navigate to the second page and fetch TODO items from JSONPlaceholder.',
                    style: TextStyle(fontSize: 14.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            ElevatedButton(
              onPressed: () => context.go('/todo'),
              child: const Text('View Todo List'),
            ),
          ],
        ),
      ),
    );
  }
}

/// About screen
class TodoScreen extends ConsumerWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(fetchTodosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod Manual Async Todos')),
      // Handle the data lifecycle using .when
      body: todosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (todos) {
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${todo.id}')),
                title: Text(todo.title),
                trailing: Checkbox(
                  value: todo.completed,
                  onChanged: null, // UI is read-only for this async fetch
                ),
              );
            },
          );
        },
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
        path: '/todo',
        name: 'todo',
        builder: (context, state) => const TodoScreen(),
      ),
    ],
    errorBuilder: (context, state) =>
        ErrorScreen(message: state.error.toString()),
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'RiverPod Example',
      routerConfig: _router,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
