class CartCalculator {
  double subtotal = 0.0;

  void addItem(double price, {int quantity = 1}) {
    if (price < 0 || quantity <= 0) {
      throw ArgumentError('Price and quantity must be positive.');
    }
    subtotal += price * quantity;
  }

  double calculateTotal({double taxRate = 0.08, double discount = 0.0}) {
    if (discount < 0 || discount > subtotal) {
      throw ArgumentError('Invalid discount value.');
    }
    final taxedAmount = (subtotal - discount) * (1 + taxRate);
    return double.parse(taxedAmount.toStringAsFixed(2));
  }

  void clearCart() {
    subtotal = 0.0;
  }
}
