import 'package:flutter/material.dart';
import 'package:flutter_mort/mortgage.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Your Mortgage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final balanceController = TextEditingController();
  final rateController = TextEditingController();
  final termController = TextEditingController();

  @override
  void dispose() {
    balanceController.dispose();
    rateController.dispose();
    termController.dispose();
    super.dispose();
  }

  void _saveMortgage() {
    setState(() {});
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
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Form(
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
                        //Process form data
                        debugPrint("balance: ${balanceController.text}");
                        debugPrint("rate: ${rateController.text}");
                        debugPrint("term: ${termController.text}");
                      }
                    },
                    child: const Text('Submit'),
                  )
                ],
              ))),
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
}
