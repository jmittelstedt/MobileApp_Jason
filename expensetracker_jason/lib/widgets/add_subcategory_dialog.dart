import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/subcategory_model.dart';
import '../data_providers/expense_provider.dart';

class AddSubcategoryDialog extends StatefulWidget {
  final Function(Subcategory) onAdd;

  const AddSubcategoryDialog({super.key, required this.onAdd});

  @override
  State<AddSubcategoryDialog> createState() => _AddSubcategoryDialogState();
}

class _AddSubcategoryDialogState extends State<AddSubcategoryDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Subcategory'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(labelText: 'Subcategory Name'),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Add'),
          onPressed: () {
            final name = _controller.text.trim();
            if (name.isEmpty) {
              return;
            }
            var newSubcategory = Subcategory(
              id: Provider.of<ExpenseProvider>(
                context,
                listen: false,
              ).generateSubcategoryId().toString(),
              name: name,
            );
            widget.onAdd(newSubcategory);
            _controller.clear();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
