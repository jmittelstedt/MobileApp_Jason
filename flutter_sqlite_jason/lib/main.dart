import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sqlite_jason/product.dart';
import 'package:go_router/go_router.dart';

import 'product_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await ProductDatabase.open();
  runApp(MyApp(database: database));
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
class AddScreen extends StatefulWidget {
  const AddScreen({super.key, required this.database});

  final ProductDatabase database;

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _form = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _quantity = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _id.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final product = await widget.database.add(
        id: _id.text.isEmpty ? null : int.parse(_id.text),
        name: _name.text.trim(),
        price: 0.0,
        quantity: 0,
      );
      messenger.showSnackBar(
        SnackBar(content: Text('Added ${product.name} (id ${product.id})')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add product')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _id,
              decoration: const InputDecoration(
                labelText: 'Id',
                helperText: 'Leave blank to use the next id',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              autofocus: true,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Enter a name'
                  : null,
              onFieldSubmitted: (_) => _save(),
            ),
            TextFormField(
              controller: _price,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quantity,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving
                  ? null
                  : () {
                      _save();
                      context.go('/');
                    },
              child: const Text('Save'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

/// List screen
class ListScreen extends StatefulWidget {
  final ProductDatabase database;
  const ListScreen({super.key, required this.database});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late final Future<List<Product>> _products = widget.database.all();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product List')),
      body: FutureBuilder<List<Product>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text('Could not load products: ${snapshot.error}'),
            );
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final products = snapshot.data!;
          if (products.isEmpty)
            return const Center(child: Text('No products yet'));
          return ListView.separated(
            itemCount: products.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) => ListTile(
              leading: CircleAvatar(child: Text('${products[i].id}')),
              title: Text(products[i].name),
            ),
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () => context.go('/'),
        child: const Text('Back'),
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
}

// Example of returning data

class Address {
  final String street;
  final String city;

  const Address({required this.street, required this.city});
}
