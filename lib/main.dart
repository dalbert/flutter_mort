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
          colorScheme: const ColorScheme.highContrastDark(
              primary: Colors.green,
              secondary: Colors.blue,
              tertiary: Colors.yellow)),
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
  var selectedIndex = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final balanceController = TextEditingController();
  final rateController = TextEditingController();
  final termController = TextEditingController();
  final currencyFormat = NumberFormat.currency(locale: "en_US", symbol: '\$');
  Mortgage? mortgage;
  MortgageList mortgages = MortgageList();

  @override
  void dispose() {
    balanceController.dispose();
    rateController.dispose();
    termController.dispose();
    super.dispose();
  }

  // TODO: prevent duplicates in the mortgages List @low
  void _saveMortgage() {
    setState(() {
      double balance = double.tryParse(balanceController.text.trim()) as double;
      double rate = double.tryParse(rateController.text.trim()) as double;
      double term = double.tryParse(termController.text.trim()) as double;
      mortgage = Mortgage("farts", balance, rate, term);
      mortgages.add(mortgage!);
    });
  }

  // This method is rerun every time setState is called
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page = const Center(
      child: Text('butt'),
    );
    switch (selectedIndex) {
      case 0:
        page = const MortgagesPage();
        break;
      case 1:
        //page = AmortizationPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 100),
        child: page,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth < 450) {
            return Column(
              children: [
                // need to move most of the Widget tree into separate func per page which will be rendered here inside mainArea
                // this will also move the navbar to the bottom; right now all the page content is below this navbar, while mainArea is above it
                Expanded(child: mainArea),
                SafeArea(
                    child: BottomNavigationBar(
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite),
                      label: 'Favorites',
                    ),
                  ],
                  currentIndex: selectedIndex,
                  onTap: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                )),
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
                              debugPrint('NARROW');
                            }
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    )),
                mortgageHistory(),
                if (mortgage != null)
                  ...getAmortizationWidgets()
                else
                  amortPlaceholder(),
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                    child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: const [
                    NavigationRailDestination(
                        icon: Icon(Icons.home), label: Text('Home')),
                    NavigationRailDestination(
                        icon: Icon(Icons.favorite), label: Text('Favorites')),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                )),
                Expanded(
                  // move the contents of this Expanded into another func and render it in the mainArea var
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
                                    debugPrint("WIDELOAD");
                                  }
                                },
                                child: const Text('Submit'),
                              ),
                            ],
                          )),
                      mortgageHistory(),
                      if (mortgage != null)
                        ...getAmortizationWidgets()
                      else
                        amortPlaceholder(),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget balanceField() {
    return Row(
      children: [
        const SizedBox(
          width: 125,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Balance: "),
          ),
        ),
        Flexible(
          //This container is required when placing a TextFormField inside a Row <shrug> - https://stackoverflow.com/questions/45986093/textfield-inside-of-row-causes-layout-exception-unable-to-calculate-size
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              style: const TextStyle(fontSize: 20),
              controller: balanceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Enter the principle balance of your mortgage',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondary),
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
        const SizedBox(
          width: 125,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Interest Rate: "),
          ),
        ),
        Flexible(
          //This container is required when placing a TextFormField inside a Row <shrug> - https://stackoverflow.com/questions/45986093/textfield-inside-of-row-causes-layout-exception-unable-to-calculate-size
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              style: const TextStyle(fontSize: 20),
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Enter the interest rate of your mortgage',
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.yellow,
                      width: 10,
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondary),
              validator: (String? value) {
                if (value == null ||
                    value.isEmpty ||
                    num.parse(value) < 0 ||
                    num.parse(value) > 100) {
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
        const SizedBox(
          width: 125,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Term (months): "),
          ),
        ),
        Flexible(
          //This container is required when placing a TextFormField inside a Row <shrug> - https://stackoverflow.com/questions/45986093/textfield-inside-of-row-causes-layout-exception-unable-to-calculate-size
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              style: const TextStyle(fontSize: 20),
              controller: termController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Enter the length of your mortgage (months)',
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.yellow,
                      width: 10,
                    ),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondary),
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
          children: mortgage!.amortization
              .map((e) => Card(
                    child: Row(
                      children: [
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

  Widget mortgageHistory([int sortBy = 0]) {
    MortgageList displayMortgages;
    switch (sortBy) {
      case 1: // sort by lifetime interest
        displayMortgages = mortgages.sortedByLifetimeInterest;
        break;
      case 2: // sort by 5y interest
        displayMortgages = mortgages.sortedBy5yInterest;
        break;
      case 3: // sort by monthly payment
        displayMortgages = mortgages.sortedByPayment;
        break;
      default: // don't sort, just go with whatever order they are in currently
        displayMortgages = mortgages;
        break;
    }
    return Flexible(
      child: ListView(
          children: displayMortgages.all
              .map((mortgage) => MortgageRow(
                  currencyFormat: currencyFormat, mortgage: mortgage))
              .toList()),
    );
  }

  List<Widget> getAmortizationWidgets() {
    return [amortizationHeader(), amortization()];
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

class MortgagesPage extends StatelessWidget {
  const MortgagesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Text("farts");
  }
}

class MortgageRow extends StatelessWidget {
  const MortgageRow({
    super.key,
    required this.currencyFormat,
    required this.mortgage,
  });

  final NumberFormat currencyFormat;
  final Mortgage? mortgage;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var labelStyle = theme.textTheme.labelLarge!
        .copyWith(color: theme.colorScheme.onPrimary);
    var dollarStyle =
        theme.textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold);

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
                Text('Lifetime Interest', style: labelStyle),
                Text(
                    style: dollarStyle,
                    currencyFormat.format(mortgage!.lifetimeInterest)),
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
                Text(currencyFormat.format(mortgage!.payment)),
              ],
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text('5 Year Interest'),
                Text(currencyFormat.format(mortgage!.getPartialInterest(60))),
              ],
            ),
          ),
        )
      ],
    );
  }
}
