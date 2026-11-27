import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateLoginScreen extends StatelessWidget {
  const CreateLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCE5F2),

      // App Bar
      appBar: AppBar(
        title: const Text('Login'),
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
              title: const Text('Create Event'),
              onTap: () => context.go('/events'),
            ),

            ListTile(
              leading: const Icon(Icons.event),
              title: const Text("List Events"),
              onTap: () => context.go('/list-events'),
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

      // Login Form
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              const Center(
                child: Icon(
                  Icons.notifications_active,
                  color: Colors.indigo,
                  size: 100,
                ),
              ),

              // Email or Username
              const Text(
                'Email or Username',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Password
              const Text(
                'Password',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 100),

              // Login Button
              Center(
                child: SizedBox(
                  width: 140,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add login functionality here.
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Forgot Password
              Center(
                child: TextButton(
                  onPressed: () {
                    // Add forgot password functionality here.
                  },
                  child: const Text(
                    'Forget Password',
                    style: TextStyle(fontSize: 18, color: Color(0xFF2F5BA8)),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Register Section
              const Center(
                child: Text(
                  "Don't have an account",
                  style: TextStyle(fontSize: 20),
                ),
              ),

              const SizedBox(height: 20),

              // Register Button
              Center(
                child: SizedBox(
                  width: 140,
                  height: 45,
                  child: OutlinedButton(
                    onPressed: () {
                      context.go('/register');
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF2F5BA8)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: Color(0xFF2F5BA8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
