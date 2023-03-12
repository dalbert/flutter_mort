import 'dart:math';
import 'package:flutter/material.dart';

class Mortgage {
  final String name;
  final double balance;
  final double rate; // as a percent, ie 100x the actual rate
  final double term; // in months
  late final double payment;
  late final List<Period> amortization = <Period>[];

  /*
    Sets all the basic parameters and populates an amortization. 
    TODO: make the amortization private. 
  */
  Mortgage(
    this.name,
    this.balance,
    this.rate,
    this.term,
  ) {
    payment = calcMonthlyPayment(); // assumes no balloon payment at end of term
    amortization.add(Period(balance, getMonthlyRate(), payment));
    for (var i = 1; i < term; i++) {
      amortization.add(
          Period(amortization[i - 1].endBalance, getMonthlyRate(), payment));
      debugPrint(amortization[i]._newBalance.toString());
    }
  }

  double getMonthlyRate() {
    return rate / 100 / 12;
  }

  /* 
  M = P [ i(1 + i)^n ] / [ (1 + i)^n – 1]. 
    M = Total monthly payment
    P = The total amount of your loan
    I = Your interest rate, as a monthly percentage
    N = The total amount of months in your timeline for paying off your mortgage
  */
  double calcMonthlyPayment() {
    final double monthlyRate = rate / 100 / 12;
    return balance *
        (monthlyRate * pow(1 + monthlyRate, term)) /
        (pow(1 + monthlyRate, term) - 1);
  }

  //TODO: refactor this to use class-level payment and amortization
  //(ie sum up the pre-calc'd interest payments)
  double calcLifetimeInterest() {
    double lifeTimeInterest = 0;
    for (Period period in amortization) {
      lifeTimeInterest += period._interestPaid;
    }
    return lifeTimeInterest;
  }
}

class Period {
  final double _balance;
  final double _rate;
  final double _payment;
  late final double _newBalance;
  late final double _interestPaid;

  Period(this._balance, this._rate, this._payment) {
    _interestPaid = (_balance * _rate);
    _newBalance = _balance + _interestPaid - _payment;
  }

  // TODO: store without the decimal truncation, move that formatting up into display code
  // - preserves precision for calculations, handle truncation at display time
  get startBalance => num.parse(_balance.toStringAsFixed(2));
  get endBalance => num.parse(_newBalance.toStringAsFixed(2));
  get interest => num.parse(_interestPaid.toStringAsFixed(2));
  get principle => num.parse((_payment - _interestPaid).toStringAsFixed(2));
}
