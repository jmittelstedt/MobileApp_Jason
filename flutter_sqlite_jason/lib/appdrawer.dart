import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.deepPurple, Colors.deepPurpleAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Text(
              'Product Management',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // close the drawer
              context.go('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add product'),
            onTap: () {
              Navigator.pop(context);
              context.go('/add');
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Product list'),
            onTap: () {
              Navigator.pop(context);
              context.go('/list');
            },
          ),
        ],
      ),
    );
  }
}
