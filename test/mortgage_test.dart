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
  test('MOrtgage.calcMonthlyPayment do duh good math', () {
    // Instantiate a Mortgage with example properties.
    Mortgage mortgage = Mortgage('farts', 225400, 2.125, 180);
    expect((mortgage.payment * pow(10, 2)).round() / pow(10, 2), 1463.48);
  });

  test('Spot check the Periods inside the amortization List', () {
    Mortgage mortgage = Mortgage('farts', 225400, 2.125, 180);
    expect(mortgage.amortization[0].startBalance, 225400);
    expect(mortgage.amortization[1].startBalance, 224335.67);
    expect(mortgage.amortization[179].endBalance, 0);
  });

  test('Mortgage.calcLifetimeInterest() does math good', () {
    Mortgage mortgage = Mortgage('farts', 225400, 2.125, 180);
    expect((mortgage.lifetimeInterest * pow(10, 2)).round() / pow(10, 2),
        38026.14);
  });
}
