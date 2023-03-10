import 'dart:math';

import 'package:flutter/material.dart';

class Mortgage {
  final String name;
  final double balance;
  final double rate; // as a percent, ie 100x the actual rate
  final double term; // in months
  late final double payment;
  late final List<Period> amortization = <Period>[];

  Mortgage(
    this.name,
    this.balance,
    this.rate,
    this.term,
  ) {
    payment = calcMonthlyPayment(); // assumes no balloon payment at end of term
    amortization.add(Period(balance, getMonthlyRate(), payment));
    for (var i = 0; i < term; i++) {
      amortization
          .add(Period(amortization[i]._newBalance, getMonthlyRate(), payment));
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

  double calcLifetimeInterest() {
    final double payment = calcMonthlyPayment();
    double interest = 0;
    double lifeTimeInterest = 0;
    double balance = this.balance;
    for (var i = 0; i < term; i++) {
      interest = (balance * getMonthlyRate());
      balance = balance + interest - payment;
      lifeTimeInterest += interest;
//      debugPrint('balance: $balance  interest: $interest  prinPay: ${payment - interest}');
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

  get startBalance => num.parse(_balance.toStringAsFixed(2));
  get endBalance => num.parse(_newBalance.toStringAsFixed(2));
}
