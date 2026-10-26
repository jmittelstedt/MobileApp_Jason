import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_expense_screen.dart';

import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../data_providers/expense_provider.dart';
import '../models/expense_model.dart';
import '../models/category_model.dart';
import '../models/subcategory_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _allEntryTabLabel = "All Expenses";
  final _groupByCategoryTabLabel = "Grouped by Categories";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Tracker"),
        backgroundColor: Colors.deepPurple[800],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: _allEntryTabLabel),
            Tab(text: _groupByCategoryTabLabel),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.category, color: Colors.deepPurple),
              title: Text('Manage Categories'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/manage_categories');
              },
            ),
            ListTile(
              leading: Icon(Icons.tag, color: Colors.deepPurple),
              title: Text('Manage Subcategories'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/manage_subcategories');
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildExpenseByDate(context),
          buildExpensesByCategory(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddExpenseScreen()),
        ),
        tooltip: 'Add Expense',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget buildExpenseByDate(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        if (provider.expenses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 50, color: Colors.deepPurple),
                Text(
                  'No expenses yet!',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 55, 55, 55),
                    fontSize: 24,
                  ),
                ),
                Text(
                  "Click the + button to record an expense.",
                  style: TextStyle(color: Colors.grey[600], fontSize: 18),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: provider.expenses.length,
          itemBuilder: (context, index) {
            final expense = provider.expenses[index];
            String formattedDate = DateFormat(
              'MMM dd, yyyy',
            ).format(expense.date);
            return Dismissible(
              key: Key(expense.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                provider.deleteExpense(expense.id);
              },
              background: Container(
                color: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: Card(
                color: Colors.purple[50],
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: ListTile(
                  isThreeLine: true,
                  title: Text(
                    "${getCategoryNameById(context, expense.categoryId)} - ${getSubcategoryNameById(context, expense.subcategoryId)}",
                  ),
                  subtitle: Text(
                    " Amount: \$${expense.amount.toStringAsFixed(2)}"
                    " Date: $formattedDate"
                    " Business/Person: ${expense.payee}"
                    " Notes: ${expense.notes.isNotEmpty ? expense.notes : 'None'}",
                  ),
                  trailing: Icon(Icons.delete, color: Colors.black),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddExpenseScreen(initialExpense: expense),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildExpensesByCategory(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context, provider, child) {
        if (provider.expenses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 50, color: Colors.deepPurple),
                Text(
                  'No expenses yet!',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 55, 55, 55),
                    fontSize: 24,
                  ),
                ),
                Text(
                  "Tap the + button to add your first expense.",
                  style: TextStyle(color: Colors.grey[600], fontSize: 18),
                ),
              ],
            ),
          );
        }

        var grouped = groupBy(provider.expenses, (Expense e) => e.categoryId);
        return ListView(
          children: grouped.entries.map((entry) {
            String categoryName = getCategoryNameById(context, entry.key);
            double total = entry.value.fold(
              0.0,
              (double prev, Expense element) => prev + element.amount,
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "$categoryName - \$${total.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: entry.value.length,
                  itemBuilder: (context, index) {
                    Expense expense = entry.value[index];
                    return ListTile(
                      leading: Text("-"),
                      title: Text(
                        "${getSubcategoryNameById(context, expense.subcategoryId)}"
                        ": \$${expense.amount.toStringAsFixed(2)}"
                        " (${DateFormat('MMM dd, yyyy').format(expense.date)})",
                      ),
                    );
                  },
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  String getCategoryNameById(BuildContext context, String categoryId) {
    var category = Provider.of<ExpenseProvider>(context, listen: false)
        .categories
        .firstWhere(
          (Category c) => c.id == categoryId,
          orElse: () => Category(id: '', name: 'Unknown'),
        );
    return category.name;
  }

  String getSubcategoryNameById(BuildContext context, String subcategoryId) {
    var subcategory = Provider.of<ExpenseProvider>(context, listen: false)
        .subcategories
        .firstWhere(
          (s) => s.id == subcategoryId,
          orElse: () => Subcategory(id: '', name: 'Unknown'),
        );
    return subcategory.name;
  }
}
