import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CreateMapScreen extends StatelessWidget {
  const CreateMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar
      appBar: AppBar(
        title: const Text('Map'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      // Navigation Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
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
                    'NextGen Reminder',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => context.go('/'),
            ),

            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Events'),
              onTap: () => context.go('/events'),
            ),

            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Calendar'),
              onTap: () => context.go('/calendar'),
            ),

            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Map'),
              onTap: () => context.go('/map'),
            ),

            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Photos'),
              onTap: () => context.go('/photos'),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () => context.go('/login'),
            ),

            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Register'),
              onTap: () => context.go('/register'),
            ),
          ],
        ),
      ),

      // OpenStreetMap
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(33.9243, -84.3785),
          initialZoom: 13.0,
        ),

        children: [
          // OpenStreetMap Tile Layer
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.your_app_name',
          ),

          // Location Marker
          MarkerLayer(
            markers: [
              Marker(
                point: const LatLng(33.9243, -84.3785),
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),

          // OpenStreetMap Attribution
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution('OpenStreetMap contributors', onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
