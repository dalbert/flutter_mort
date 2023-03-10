import 'dart:math';

class Mortgage {
  String name;
  double balance;
  double rate; // as a percent, ie 100x the actual rate
  double term; // in months

  Mortgage(
    this.name,
    this.balance,
    this.rate,
    this.term,
  );

  /* 
  M = P [ i(1 + i)^n ] / [ (1 + i)^n – 1]. 
    M = Total monthly payment
    P = The total amount of your loan
    I = Your interest rate, as a monthly percentage
    N = The total amount of months in your timeline for paying off your mortgage
*/
  double calcMonthlyPayment() {
    double monthlyRate = rate / 100 / 12;
    return balance *
        (monthlyRate * pow(1 + monthlyRate, term)) /
        (pow(1 + monthlyRate, term) - 1);
  }
}
