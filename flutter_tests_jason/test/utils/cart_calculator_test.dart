import 'package:flutter_tests_jason/utils/cart_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CartCalculator', () {
    test('adding items increases the subtotal accurately', () {
      final cart = CartCalculator();

      cart.addItem(10.0, quantity: 2);
      cart.addItem(5.0);

      expect(cart.subtotal, 25.0);
    });

    test('calculateTotal applies discount and tax correctly', () {
      final cart = CartCalculator();
      cart.addItem(100.0);

      final total = cart.calculateTotal(taxRate: 0.08, discount: 10.0);

      expect(total, 97.20);
    });

    test('clearCart resets the subtotal to zero', () {
      final cart = CartCalculator();
      cart.addItem(25.0);

      cart.clearCart();

      expect(cart.subtotal, 0.0);
    });

    test('negative item price throws an ArgumentError', () {
      final cart = CartCalculator();

      expect(() => cart.addItem(-5.0), throwsA(isA<ArgumentError>()));
    });
  });
}
