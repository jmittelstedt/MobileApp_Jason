import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'event_repository.dart';

// String jsonString = await rootBundle.loadString('assets/testdata.json');
// pass the jsonString into the jsonDecode function to parse it into a List of dynamic objects

// Event Model
class Event {
  final int id;
  final String title;
  final String type;
  final DateTime date;
  final TimeOfDay time;

  Event({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.time,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    final date = DateTime.parse(json['date'].toString());
    final timeParts = json['time'].toString().split(':');

    return Event(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      date: date,
      time: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
    );
  }

  String get day => date.day.toString();

  String get month {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[date.month - 1];
  }
}

// List Events Screen
class CreateListEventScreen extends StatefulWidget {
  const CreateListEventScreen({super.key});

  @override
  State<CreateListEventScreen> createState() => _CreateListEventScreenState();
}

class _CreateListEventScreenState extends State<CreateListEventScreen> {
  // Events collection
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
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
              leading: const Icon(Icons.event_note),
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

      // Events List
      body: events.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return EventCard(
                  event: event,
                  onTap: () => _showEventDetails(
                    context,
                    event,
                    onEdit: () => editEvent(context, event),
                    onDelete: () => deleteEvent(context, event),
                  ),
                );
              },
            ),

      // Create Event Button
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/events'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Empty Events State
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.event_note_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),

          const Text(
            'No Events Yet',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            'Tap "New Event" to create your first event',
            style: TextStyle(color: Colors.grey.shade600),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: () => context.go('/events'),
            icon: const Icon(Icons.add),
            label: const Text('New Event'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Display Event Details
  void _showEventDetails(
    BuildContext context,
    Event event, {
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(event.title),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type: ${event.type}'),
                const SizedBox(height: 8),
                Text(
                  'Date: ${event.date.month}/${event.date.day}/${event.date.year}',
                ),
                const SizedBox(height: 8),
                Text('Time: ${event.time.format(dialogContext)}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(dialogContext);
                onDelete();
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                onEdit();
                showEditEventDialog(
                  context,
                  event,
                  onSave: (updatedEvent) {
                    setState(() {
                      // Replace the old event in your list with updatedEvent
                    });
                  },
                );
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void editEvent(BuildContext context, Event event) {
    context.go('/events', extra: event);
  }

  void deleteEvent(BuildContext context, Event event) {
    setState(() {
      events.removeWhere((item) => item.id == event.id);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('"${event.title}" deleted')));
  }
}

void showEditEventDialog(
  BuildContext context,
  Event event, {
  required ValueChanged<Event> onSave,
}) {
  final titleController = TextEditingController(text: event.title);
  final typeController = TextEditingController(text: event.type);
  DateTime selectedDate = event.date;
  TimeOfDay selectedTime = event.time;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Edit Event'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: typeController,
                    decoration: const InputDecoration(labelText: 'Type'),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Date: ${selectedDate.month}/${selectedDate.day}/${selectedDate.year}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setDialogState(() => selectedDate = picked);
                      }
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Time: ${selectedTime.format(context)}'),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                      );
                      if (picked != null) {
                        setDialogState(() => selectedTime = picked);
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.trim().isEmpty) return;

                  final updatedEvent = Event(
                    id: event.id,
                    title: titleController.text.trim(),
                    type: typeController.text.trim(),
                    date: selectedDate,
                    time: selectedTime,
                  );

                  Navigator.pop(dialogContext);
                  onSave(updatedEvent);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}

// Event Card
class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,

        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              event.day,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(event.month.toUpperCase()),
          ],
        ),

        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Text('${event.type} • ${event.time.format(context)}'),

        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
