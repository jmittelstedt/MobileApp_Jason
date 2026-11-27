import 'package:capstonerest_jason/listeventsscreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'event_repository.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key, this.event});

  final Event? event;

  @override
  State<CreateEventScreen> createState() => CreateEventScreenState();
}

class CreateEventScreenState extends State<CreateEventScreen> {
  String? selectedType;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  final TextEditingController titleController = TextEditingController();

  final List<String> eventTypes = [
    'Meeting',
    'Appointment',
    'Reminder',
    'Deadline',
    'Work',
    'Personal',
    'Health',
    'Learning',
    'Social',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.event != null) {
      titleController.text = widget.event!.title;
      selectedType = widget.event!.type;
      selectedDate = widget.event!.date;
      selectedTime = widget.event!.time;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  String formatDate(DateTime date) {
    return "${date.month.toString().padLeft(2, '0')}/"
        "${date.day.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  void createEvent() {
    if (selectedType == null || titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an event title and select a type.'),
        ),
      );
      return;
    }

    // Create a new event
    final newEvent = Event(
      id: DateTime.now().millisecondsSinceEpoch,
      title: titleController.text.trim(),
      type: selectedType!,
      date: selectedDate,
      time: selectedTime,
    );

    // Add event to the shared list
    events.add(newEvent);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${newEvent.title} created successfully!')),
    );

    // Navigate to List Events
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateListEventScreen()),
    );
  }

  void updateEvent() {
    final updatedEvent = Event(
      id: widget.event!.id,
      title: titleController.text,
      type: selectedType!,
      date: selectedDate!,
      time: selectedTime!,
    );

    final index = events.indexWhere((e) => e.id == updatedEvent.id);

    if (index != -1) {
      events[index] = updatedEvent;
    }
    context.go('/list-events');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEAF0F3),

      appBar: AppBar(
        title: const Text('Create Event'),
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

      // Event Creation Form
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "NEW EVENT",
              style: TextStyle(
                color: Colors.redAccent,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Create an event",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            const Text(
              "Schedule a meeting, appointment, or deadline.",
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),

            const SizedBox(height: 30),

            const Text(
              "EVENT TYPE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
              hint: const Text("Select a type..."),
              items: eventTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() => selectedType = value);
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "EVENT TITLE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "e.g. Q3 Planning Review",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Date and Time
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "DATE",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 8),

                      InkWell(
                        onTap: pickDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(formatDate(selectedDate)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "TIME",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 8),

                      InkWell(
                        onTap: pickTime,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.access_time),
                          ),
                          child: Text(selectedTime.format(context)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Location and Photo Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.location_on_outlined),
                    label: const Text("Add Location"),
                    onPressed: () {
                      context.go('/map');
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.photo_outlined),
                    label: const Text("Add Photos"),
                    onPressed: () {
                      context.go('/photos');
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Create Event Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (widget.event == null) {
                    if (selectedType == null ||
                        titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter an event title and select a type.',
                          ),
                        ),
                      );
                      return;
                    }

                    final newEvent = Event(
                      id: DateTime.now().millisecondsSinceEpoch,
                      title: titleController.text.trim(),
                      type: selectedType!,
                      date: selectedDate,
                      time: selectedTime,
                    );

                    events.add(newEvent);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${newEvent.title} created successfully!',
                        ),
                      ),
                    );

                    context.go('/list-events');
                  } else {
                    updateEvent();
                  }
                },
                child: const Text('Create Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
