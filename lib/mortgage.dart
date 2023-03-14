import 'dart:math';
import 'package:flutter/material.dart';

class Mortgage {
  final String name;
  final double balance;
  final double rate; // as a percent, ie 100x the actual rate
  final double term; // in months
  late final double payment;
  late final List<Period> _amortization = <Period>[];
  late final double _lifetimeInterest;

  /*
    Sets all the basic parameters and populates an amortization. 
  */
  Mortgage(
    this.name,
    this.balance,
    this.rate,
    this.term,
  ) {
    payment =
        _calcMonthlyPayment(); // assumes no balloon payment at end of term
    _amortization.add(Period(balance, getMonthlyRate(), payment));
    for (var i = 1; i < term; i++) {
      _amortization.add(
          Period(_amortization[i - 1].endBalance, getMonthlyRate(), payment));
    }
    _lifetimeInterest = _calcLifetimeInterest();
  }

// does this return a separate copy? GOOD
// is it a new copy each time the getter is called? BAD
  get amortization => [..._amortization];

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
  double _calcMonthlyPayment() {
    final double monthlyRate = rate / 100 / 12;
    return balance *
        (monthlyRate * pow(1 + monthlyRate, term)) /
        (pow(1 + monthlyRate, term) - 1);
  }

  get lifetimeInterest => num.parse(_lifetimeInterest.toStringAsFixed(2));
  double _calcLifetimeInterest() {
    double lifeTimeInterest = 0;
    for (Period period in _amortization) {
      lifeTimeInterest += period._interest;
    }
    return lifeTimeInterest;
  }

/* 
  periods is probably in months; to get the first 1 year of interest, pass in 12
*/
  double getPartialInterest(int periods) {
    double interest = 0;
    for (Period period in _amortization.sublist(0, periods)) {
      interest += period._interest;
      debugPrint('interest = ${period.interest}    sum = $interest');
    }
    return interest;
  }
}

class Period {
  final double _balance;
  final double _rate;
  final double _payment;
  late final double _newBalance;
  late final double _interest;

  Period(this._balance, this._rate, this._payment) {
    _interest = (_balance * _rate);
    _newBalance = _balance + _interest - _payment;
  }

  get startBalance => num.parse(_balance.toStringAsFixed(2));
  get endBalance => num.parse(_newBalance.toStringAsFixed(2));
  get interest => num.parse(_interest.toStringAsFixed(2));
  get principle => num.parse((_payment - _interest).toStringAsFixed(2));
}
