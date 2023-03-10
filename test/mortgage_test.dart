// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';

import 'package:flutter_mort/mortgage.dart';
import 'package:test/test.dart';

void main() {
  test('Example calcs to test formulae in the Mortgage model', () {
    // Instantiate a Mortgage with example properties.
    Mortgage mortgage = Mortgage('farts', 225400, 2.125, 180);
    expect((mortgage.calcMonthlyPayment() * pow(10, 2)).round() / pow(10, 2),
        1463.48);
  });
}
