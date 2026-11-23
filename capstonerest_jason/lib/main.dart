import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const ReminderApp());
}

/// ROUTER
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/events',
      builder: (context, state) => const CreateEventScreen(),
    ),
    GoRoute(
      path: '/calendar',
      builder: (context, state) => const CreateCalendarScreen(),
    ),
    GoRoute(path: '/map', builder: (context, state) => const CreateMapScreen()),
    GoRoute(
      path: '/photos',
      builder: (context, state) => const CreatePhotoScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const PlaceholderScreen(title: 'Login'),
    ),
  ],
);

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

class CreateCalendarScreen extends StatelessWidget {
  const CreateCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: const Center(
        child: Text('Create Calendar Screen', style: TextStyle(fontSize: 24)),
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

class CreateMapScreen extends StatelessWidget {
  const CreateMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: const Center(
        child: Text('Create Map Screen', style: TextStyle(fontSize: 24)),
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
              title: const Text("Events"),
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

class CreatePhotoScreen extends StatelessWidget {
  const CreatePhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photos')),
      body: const Center(
        child: Text('Create Photo Screen', style: TextStyle(fontSize: 24)),
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
              title: const Text(" Create Event"),
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

class ReminderApp extends StatelessWidget {
  const ReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NextGen Reminder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      routerConfig: _router,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String username = "testmyapp";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("NextGen Reminder"), centerTitle: true),
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Icon(
              Icons.notifications_active,
              color: Colors.indigo,
              size: 100,
            ),

            const SizedBox(height: 20),

            const Text(
              "NextGen Reminder App",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "Welcome, $username",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                children: [
                  _buildMenuCard(
                    context,
                    Icons.event,
                    "Events",
                    Colors.blue,
                    '/events',
                  ),
                  _buildMenuCard(
                    context,
                    Icons.calendar_month,
                    "Calendar",
                    Colors.green,
                    '/calendar',
                  ),
                  _buildMenuCard(
                    context,
                    Icons.map,
                    "Map",
                    Colors.orange,
                    '/map',
                  ),
                  _buildMenuCard(
                    context,
                    Icons.photo_camera,
                    "Photos",
                    Colors.purple,
                    '/photos',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    String route,
  ) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () => context.go(route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple placeholder screen
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('$title Screen', style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}
