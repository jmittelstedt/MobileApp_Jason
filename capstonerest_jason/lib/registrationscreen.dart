import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateRegistrationScreen extends StatefulWidget {
  const CreateRegistrationScreen({super.key});

  @override
  State<CreateRegistrationScreen> createState() =>
      _CreateRegistrationScreenState();
}

class _CreateRegistrationScreenState extends State<CreateRegistrationScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8E6F2),

      // App Bar
      appBar: AppBar(
        title: const Text('Event Registration'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D2B52),
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

      // Registration Form
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons.notifications_active,
                color: Colors.indigo,
                size: 100,
              ),
            ),
            // Full Name
            const Text(
              'Full Name',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D2B52),
              ),
            ),

            const SizedBox(height: 10),

            _buildTextField(
              controller: nameController,
              hint: 'Enter your full name',
            ),

            const SizedBox(height: 30),

            // Email Address
            const Text(
              'Email Address',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D2B52),
              ),
            ),

            const SizedBox(height: 10),

            _buildTextField(
              controller: emailController,
              hint: 'Enter your email address',
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 30),

            // Password
            const Text(
              'Password',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D2B52),
              ),
            ),

            const SizedBox(height: 10),

            _buildTextField(
              controller: passwordController,
              hint: 'Enter your password',
              obscureText: true,
            ),

            const SizedBox(height: 30),

            // Number of Tickets
            const Text(
              'Confirm Password',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D2B52),
              ),
            ),

            const SizedBox(height: 10),

            _buildTextField(
              controller: confirmPasswordController,
              hint: 'Confirm your password',
              obscureText: true,
            ),

            const SizedBox(height: 50),

            // Register Button
            Center(
              child: SizedBox(
                width: 180,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Registration functionality goes here.
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D2B52),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Reusable Text Field
  Widget _buildTextField({
    TextEditingController? controller,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
