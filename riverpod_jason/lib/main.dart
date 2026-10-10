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
      backgroundColor: const Color(0xFFFaF6F7),
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(fetchTodosProvider),
          ),
        ],
      ),
      body: todosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (todos) => ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];

            return Card(
              color: const Color(0xFFF5EFF2),
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                // 1. Icon configuration
                leading: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: todo.completed
                        ? const Color(0xFFCBEBCE)
                        : const Color(0xFFFFE8CC),
                  ),
                  child: Icon(
                    todo.completed ? Icons.check : Icons.hourglass_bottom,
                    color: todo.completed ? Colors.green : Colors.orange,
                  ),
                ),
                // 2. Title layout with custom formatting
                title: Text(
                  todo.title,
                  style: TextStyle(
                    color: todo.completed ? Colors.black38 : Colors.black87,
                    decoration: todo.completed
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                // 3. Subtitle dynamic meta-text
                subtitle: Text('ID: ${todo.id} | User ID: ${todo.userId}'),
                // 4. Trailing inline Checkbox
                trailing: Transform.scale(
                  scale: 0.8, // Lowers the scale factor (1.0 is default size)
                  child: Checkbox(
                    value: todo.completed,
                    activeColor: Colors.grey,
                    onChanged: (val) {},
                  ),
                ),
              ),
            );
          },
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
