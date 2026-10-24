import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../data_providers/expense_provider.dart';

class AddCategoryDialog extends StatefulWidget {
  final Function(Category) onAdd;

  const AddCategoryDialog({super.key, required this.onAdd});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Category'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(labelText: 'Category Name'),
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
            var newCategory = Category(
              id: Provider.of<ExpenseProvider>(
                context,
                listen: false,
              ).generateCategoryId().toString(),
              name: name,
            );
            widget.onAdd(newCategory);
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
