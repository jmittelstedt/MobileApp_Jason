import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: const Center(
        child: Text('Create Event Screen', style: TextStyle(fontSize: 24)),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_active,
                    color: Colors.white,
                    size: 60,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "NextGen Reminder",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => context.go('/'),
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text("Create Event"),
              onTap: () => context.go('/events'),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text("Calendar"),
              onTap: () => context.go('/calendar'),
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text("Map"),
              onTap: () => context.go('/map'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text("Photos"),
              onTap: () => context.go('/photos'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text("Login"),
              onTap: () => context.go('/login'),
            ),
          ],
        ),
      ),
    );
  }
}
