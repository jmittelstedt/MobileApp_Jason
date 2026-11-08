import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sqlite_jason/product.dart';
import 'package:go_router/go_router.dart';

import 'product_database.dart';
import 'main.dart';

/// Home screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Jason Mittelstedt'),
        centerTitle: true,
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildNavigationButton(
                context: context,
                label: 'Add Product',
                onPressed: () {
                  context.go(Routes.add);
                },
              ),
              const SizedBox(height: 32),
              _buildNavigationButton(
                context: context,
                label: 'View Product List',
                onPressed: () {
                  context.go(Routes.list);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Colors.deepPurple, Colors.deepPurpleAccent],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Add screen
class AddScreen extends StatelessWidget {
  const AddScreen({super.key, required this.database});

  final ProductDatabase database;

  @override
  Widget build(BuildContext context) {
    final form = GlobalKey<FormState>();
    final saving = ValueNotifier<bool>(false);
    var name = '';
    var price = '';
    var quantity = '';

    void save() {
      final formState = form.currentState!;
      if (!formState.validate()) return;
      formState.save();

      saving.value = true;
      final messenger = ScaffoldMessenger.of(context);
      final router = GoRouter.of(context);

      database
          .add(
            name: name.trim(),
            price: double.parse(price),
            quantity: int.parse(quantity),
          )
          .then((product) {
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  'Added ${product.name} (Id: ${product.id}) '
                  ' Price: ${product.price} Quantity: ${product.quantity} ',
                ),
              ),
            );
            router.go(Routes.home);
          })
          .whenComplete(() => saving.value = false);
    }

    String? requiredNumber(String? value, String message) =>
        (value == null || value.trim().isEmpty) ? message : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Add product'), centerTitle: true),
      drawer: const AppDrawer(),
      body: Form(
        key: form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              autofocus: true,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Enter a name'
                  : null,
              onSaved: (value) => name = value ?? '',
              onFieldSubmitted: (_) => save(),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              validator: (value) => requiredNumber(value, 'Enter a price'),
              onSaved: (value) => price = value ?? '',
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) => requiredNumber(value, 'Enter a quantity'),
              onSaved: (value) => quantity = value ?? '',
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder<bool>(
              valueListenable: saving,
              builder: (context, isSaving, _) => FilledButton(
                onPressed: isSaving ? null : save,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () => context.go(Routes.home),
        child: const Text('Back'),
      ),
    );
  }
}

/// List screen
class ListScreen extends StatelessWidget {
  final ProductDatabase database;
  const ListScreen({super.key, required this.database});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product List'), centerTitle: true),
      drawer: const AppDrawer(),
      body: FutureBuilder<List<Product>>(
        future: database.all(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Could not load products: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final products = snapshot.data!;
          if (products.isEmpty) {
            return const Center(child: Text('No products yet'));
          }
          return ListView.separated(
            itemCount: products.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) => ListTile(
              leading: CircleAvatar(child: Text('${products[i].id}')),
              title: Text(products[i].name),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Price: ${products[i].price}'),
                  Text('Quantity: ${products[i].quantity}'),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () => context.go(Routes.home),
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
