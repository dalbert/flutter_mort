import 'package:flutter/material.dart';
import 'package:flutter_mort/mortgage.dart';
import "package:intl/intl.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mortgage Calculator',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Your Mortgage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final balanceController = TextEditingController();
  final rateController = TextEditingController();
  final termController = TextEditingController();
  final currencyFormat = NumberFormat.currency(locale: "en_US", symbol: '\$');
  late Mortgage mortgage;
  List<Mortgage> mortgages = [];

  @override
  void dispose() {
    balanceController.dispose();
    rateController.dispose();
    termController.dispose();
    super.dispose();
  }

  void _saveMortgage() {
    setState(() {
      double balance = double.tryParse(balanceController.text.trim()) as double;
      double rate = double.tryParse(rateController.text.trim()) as double;
      double term = double.tryParse(termController.text.trim()) as double;
      mortgage = Mortgage("farts", balance, rate, term);
      mortgages.add(mortgage);
    });
  }

  // This method is rerun every time setState is called
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        children: [
          Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  balanceField(),
                  rateField(),
                  termField(),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveMortgage();
                        debugPrint("balance: ${mortgage.balance}");
                        debugPrint("rate: ${mortgage.rate}");
                        debugPrint("term: ${mortgage.term}");
                        debugPrint(mortgage.name);
                        debugPrint(mortgage.payment.toString());
                        debugPrint(
                            'Lifetime Interest: ${mortgage.lifetimeInterest}');
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              )),
          if (mortgage != null)
            ...getAmortizationWidgets()
          else
            amortPlaceholder(),
        ],
      )),
    );
  }

  Widget balanceField() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Balance: "),
        ),
        Flexible(
          //This container is required when placing a TextFormField inside a Row <shrug> - https://stackoverflow.com/questions/45986093/textfield-inside-of-row-causes-layout-exception-unable-to-calculate-size
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: balanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: 'Enter the principle balance of your mortgage',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 10,
                    ),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 169, 209, 229)),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a number';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget rateField() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Interest Rate: "),
        ),
        Flexible(
          //This container is required when placing a TextFormField inside a Row <shrug> - https://stackoverflow.com/questions/45986093/textfield-inside-of-row-causes-layout-exception-unable-to-calculate-size
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: 'Enter the interest rate of your mortgage',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.yellow,
                      width: 10,
                    ),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 169, 209, 229)),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a number btwn 0.0 - 100.0';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget termField() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Term (months): "),
        ),
        Flexible(
          //This container is required when placing a TextFormField inside a Row <shrug> - https://stackoverflow.com/questions/45986093/textfield-inside-of-row-causes-layout-exception-unable-to-calculate-size
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: termController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: 'Enter the length of your mortgage (months)',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.yellow,
                      width: 10,
                    ),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 169, 209, 229)),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a number btwn 0.0 - 100.0';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget amortizationHeader() {
    return Row(
      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('start'),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('end'),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('interest'),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('principle'),
        ),
      ],
    );
  }

  Widget amortization() {
    return Flexible(
      child: ListView(
          children: mortgage.amortization
              .map((e) => Card(
                    child: Row(
                      children: [
                        // TODO: add $ to each value
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(currencyFormat.format(e.startBalance)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(currencyFormat.format(e.endBalance)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(currencyFormat.format(e.interest)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(currencyFormat.format(e.principle)),
                        ),
                      ],
                    ),
                  ))
              .toList()),
    );
  }

  Widget amortizationTopMetrics() {
    return Row(
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          color: Colors.amber,
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text('Lifetime Interest'),
                Text(
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    currencyFormat.format(mortgage.lifetimeInterest)),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text('Monthly Payment'),
                Text(currencyFormat.format(mortgage.payment)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> getAmortizationWidgets() {
    return [amortizationTopMetrics(), amortizationHeader(), amortization()];
  }

  Widget amortPlaceholder() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('enter params above to get the thing'),
      ),
    );
  }
}
