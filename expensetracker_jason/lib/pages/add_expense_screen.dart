import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/expense_model.dart';
import '../data_providers/expense_provider.dart';
import '../widgets/add_category_dialog.dart';
import '../widgets/add_subcategory_dialog.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? initialExpense;

  const AddExpenseScreen({super.key, this.initialExpense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  late TextEditingController _payeeController;
  String? _selectedCategoryId;
  String? _selectedSubcategoryId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.initialExpense?.amount.toString() ?? '',
    );
    _noteController = TextEditingController(
      text: widget.initialExpense?.notes ?? '',
    );
    _payeeController = TextEditingController(
      text: widget.initialExpense?.payee ?? '',
    );
    _selectedDate = widget.initialExpense?.date ?? DateTime.now();
    _selectedCategoryId = widget.initialExpense?.categoryId;
    _selectedSubcategoryId = widget.initialExpense?.subcategoryId;
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialExpense == null ? 'Add Expense' : 'Edit Expense',
        ),
        backgroundColor: Colors.deepPurple[400],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: buildCategoryDropdown(expenseProvider),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: buildSubcategoryDropdown(expenseProvider),
            ),
            buildDateField(_selectedDate),
            buildTextField(
              _amountController,
              'Amount',
              TextInputType.numberWithOptions(decimal: true),
            ),
            buildTextField(
              _payeeController,
              'Business/Person',
              TextInputType.text,
            ),
            buildTextField(_noteController, 'Note', TextInputType.text),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50),
          ),
          onPressed: _saveExpense,
          child: Text('Save Expense'),
        ),
      ),
    );
  }

  void _saveExpense() {
    if (_amountController.text.isEmpty || _payeeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields!')),
      );
      return;
    }
    if (_selectedCategoryId == null || _selectedSubcategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category and a subcategory!')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount < 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a valid amount!')));
      return;
    }

    final expense = Expense(
      id:
          widget.initialExpense?.id ??
          Provider.of<ExpenseProvider>(
            context,
            listen: false,
          ).generateExpenseId().toString(),
      amount: amount,
      categoryId: _selectedCategoryId!,
      subcategoryId: _selectedSubcategoryId!,
      notes: _noteController.text,
      payee: _payeeController.text,
      date: _selectedDate,
    );

    Provider.of<ExpenseProvider>(
      context,
      listen: false,
    ).addOrUpdateExpense(expense);
    Navigator.pop(context);
  }

  Widget buildTextField(
    TextEditingController controller,
    String label,
    TextInputType type,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: type,
      ),
    );
  }

  Widget buildDateField(DateTime selectedDate) {
    return ListTile(
      title: Text("Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
      trailing: Icon(Icons.calendar_today),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null && picked != selectedDate) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
    );
  }

  Widget buildCategoryDropdown(ExpenseProvider provider) {
    return DropdownButtonFormField<String>(
      initialValue: _selectedCategoryId,
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context,
            builder: (context) => AddCategoryDialog(
              onAdd: (newCategory) {
                provider.addCategory(newCategory);
                setState(() => _selectedCategoryId = newCategory.id);
              },
            ),
          );
        } else {
          setState(() => _selectedCategoryId = newValue);
        }
      },
      items:
          provider.categories.map<DropdownMenuItem<String>>((category) {
            return DropdownMenuItem<String>(
              value: category.id,
              child: Text(category.name),
            );
          }).toList()..add(
            DropdownMenuItem(value: "New", child: Text("Add New Category")),
          ),
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget buildSubcategoryDropdown(ExpenseProvider provider) {
    return DropdownButtonFormField<String>(
      initialValue: _selectedSubcategoryId,
      onChanged: (newValue) {
        if (newValue == 'New') {
          showDialog(
            context: context,
            builder: (context) => AddSubcategoryDialog(
              onAdd: (newSubcategory) {
                provider.addSubcategory(newSubcategory);
                setState(() => _selectedSubcategoryId = newSubcategory.id);
              },
            ),
          );
        } else {
          setState(() => _selectedSubcategoryId = newValue);
        }
      },
      items:
          provider.subcategories.map<DropdownMenuItem<String>>((subcategory) {
            return DropdownMenuItem<String>(
              value: subcategory.id,
              child: Text(subcategory.name),
            );
          }).toList()..add(
            DropdownMenuItem(value: "New", child: Text("Add New Subcategory")),
          ),
      decoration: InputDecoration(
        labelText: 'Subcategory',
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _payeeController.dispose();
    super.dispose();
  }
}
