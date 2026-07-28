import 'package:cst2335_in_class_examples/AppLocalizations.dart';
import 'package:flutter/material.dart';

//need this line:
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale)
  { //find the state object of your app
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLanguage(newLocale);
  }

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp>{

  var _locale = Locale("en");

  void changeLanguage(Locale newLocale){
    setState(() {
      _locale = newLocale;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [
        Locale("en"),
        Locale("de"),
        Locale("ar")
      ], //must list locales that you support
      locale: _locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;

  List<String> words = ["One", "Two"];
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  var otherWords = <String>[];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Widget ListPage(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(hintText: AppLocalizations.of(context)!.translate("enter_name")),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _quantityController,
                      decoration: InputDecoration(hintText: AppLocalizations.of(context)!.translate("enter_quantity")),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_nameController.text.isNotEmpty &&
                          _quantityController.text.isNotEmpty) {
                        words.add(
                            "${_nameController.text} (${_quantityController.text})");
                        _nameController.clear();
                        _quantityController.clear();
                      }
                    });
                  },
                  child: Text(AppLocalizations.of(context)!.translate("add")!),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: words.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(words[index]),
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm"),
                        content: const Text("Do you really want to delete this item?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                words.removeAt(index);
                              });
                              Navigator.pop(context);
                            },
                            child: const Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            OutlinedButton(child:Text("English"),
              onPressed: (){
                MyApp.setLocale(context, Locale("en")); }),
            OutlinedButton(child:Text("Deutsch"),
                onPressed:(){
              MyApp.setLocale(context, Locale("de"));}),
            OutlinedButton(child:Text("Arabic"),
                onPressed:(){
                  MyApp.setLocale(context, Locale("ar"));}),
         ],
        ),
        body: ListPage(context)
    );
  }

}
