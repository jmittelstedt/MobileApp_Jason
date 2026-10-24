import 'dart:convert';

import 'package:flutter/foundation.dart' hide Category;
import 'package:localstorage/localstorage.dart';

import '../models/category_model.dart';
import '../models/expense_model.dart';
import '../models/subcategory_model.dart';

class ExpenseProvider with ChangeNotifier {
  final LocalStorage storage;

  List<Expense> _expenses = [];
  List<Subcategory> _subcategories = [];
  List<Category> _categories = [];

  List<Expense> get expenses => _expenses;
  List<Category> get categories => _categories;
  List<Subcategory> get subcategories => _subcategories;

  ExpenseProvider(this.storage) {
    _loadCategoriesFromStorage();
    _loadSubcategoriesFromStorage();
    _loadExpensesFromStorage();
  }

  void _loadExpensesFromStorage() {
    final storedExpenses = storage.getItem('expenses');

    if (storedExpenses != null) {
      final List<dynamic> decoded = jsonDecode(storedExpenses);

      _expenses = decoded
          .map((item) => Expense.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      notifyListeners();
    } else {
      _saveExpensesToStorage();
    }
  }

  void _loadCategoriesFromStorage() {
    final storedCategories = storage.getItem('categories');

    if (storedCategories != null) {
      final List<dynamic> decoded = jsonDecode(storedCategories);

      _categories = decoded
          .map((item) => Category.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      notifyListeners();
    } else {
      _saveCategoriesToStorage();
    }
  }

  void _loadSubcategoriesFromStorage() {
    final storedSubcategories = storage.getItem('subcategories');

    if (storedSubcategories != null) {
      final List<dynamic> decoded = jsonDecode(storedSubcategories);

      _subcategories = decoded
          .map((item) => Subcategory.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      notifyListeners();
    } else {
      _saveSubcategoriesToStorage();
    }
  }

  void addExpense(Expense expense) {
    _expenses.add(expense);
    _saveExpensesToStorage();
    notifyListeners();
  }

  void addOrUpdateExpense(Expense expense) {
    final index = _expenses.indexWhere((e) => e.id == expense.id);

    if (index != -1) {
      _expenses[index] = expense;
    } else {
      _expenses.add(expense);
    }

    _saveExpensesToStorage();
    notifyListeners();
  }

  void deleteExpense(String id) {
    _expenses.removeWhere((expense) => expense.id == id);

    _saveExpensesToStorage();
    notifyListeners();
  }

  void _saveExpensesToStorage() {
    storage.setItem(
      'expenses',
      jsonEncode(_expenses.map((e) => e.toJson()).toList()),
    );
  }

  void addCategory(Category category) {
    if (!_categories.any((c) => c.name == category.name)) {
      _categories.add(category);
      _saveCategoriesToStorage();
      notifyListeners();
    }
  }

  void deleteCategory(String id) {
    _categories.removeWhere((category) => category.id == id);

    _saveCategoriesToStorage();
    notifyListeners();
  }

  void _saveCategoriesToStorage() {
    storage.setItem(
      'categories',
      jsonEncode(_categories.map((c) => c.toJson()).toList()),
    );
  }

  void addSubcategory(Subcategory subcategory) {
    if (!_subcategories.any((s) => s.name == subcategory.name)) {
      _subcategories.add(subcategory);
      _saveSubcategoriesToStorage();
      notifyListeners();
    }
  }

  void deleteSubcategory(String id) {
    _subcategories.removeWhere((subcategory) => subcategory.id == id);

    _saveSubcategoriesToStorage();
    notifyListeners();
  }

  void _saveSubcategoriesToStorage() {
    storage.setItem(
      'subcategories',
      jsonEncode(_subcategories.map((s) => s.toJson()).toList()),
    );
  }

  int generateCategoryId() {
    return _nextId(_categories.map((category) => category.id));
  }

  int generateSubcategoryId() {
    return _nextId(_subcategories.map((subcategory) => subcategory.id));
  }

  int generateExpenseId() {
    return _nextId(_expenses.map((expense) => expense.id));
  }

  int _nextId(Iterable<String> ids) {
    final numbers = ids.map(int.tryParse).whereType<int>();

    if (numbers.isEmpty) {
      return 1;
    }

    return numbers.reduce((a, b) => a > b ? a : b) + 1;
  }
}
