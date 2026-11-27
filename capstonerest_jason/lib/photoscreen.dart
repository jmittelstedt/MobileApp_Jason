import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class CreatePhotoScreen extends StatefulWidget {
  const CreatePhotoScreen({super.key});

  @override
  State<CreatePhotoScreen> createState() => _CreatePhotoScreenState();
}

class _CreatePhotoScreenState extends State<CreatePhotoScreen> {
  final ImagePicker _picker = ImagePicker();

  XFile? _photo;

  // Open camera and capture a picture
  Future<void> _takePhoto() async {
    final XFile? captured = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (captured != null && mounted) {
      setState(() {
        _photo = captured;
      });
    }
  }

  Widget displayPickedImage(XFile pickedFile) {
    if (kIsWeb) {
      // On web, pickedFile.path is a blob URL
      return Image.network(pickedFile.path);
    } else {
      // On mobile/desktop, use Image.file
      return Image.file(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photos')),

      // Navigation drawer
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
              leading: const Icon(Icons.event),
              title: const Text("List Events"),
              onTap: () => context.go('/list-events'),
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

      // Display captured picture
      body: Center(
        child: _photo == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_camera, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No image captured yet.',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text('Tap the camera button to take a picture.'),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: displayPickedImage(_photo!),
              ),
      ),

      // Camera button
      floatingActionButton: FloatingActionButton(
        onPressed: _takePhoto,
        tooltip: 'Take a Picture',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
