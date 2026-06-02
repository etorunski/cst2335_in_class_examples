import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  int _selectedIndex = 0;
  late TextEditingController _controller;

  var isChecked = false;

  //runs before the page is visible:
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    loadData();


  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // there's await in here, so this must be async
  void loadData() async {

    //timer that ends when the data is loaded
    //await means wait until the timer ends
    final prefs = await SharedPreferences.getInstance(); //returns a Future<>

  //here the timer has finished, choose from get()), getInt(), getBool(), getString()
    final str = prefs.getString( "USERNAME" ); //key or variable name

    //this will run the function after the duration has expired:

    if(str != null) {
      Future.delayed(Duration.zero, () {
        //this creates it:
        var snackBar = SnackBar(
          content: Text('Welcome back ' + str),
          action: SnackBarAction(label: "Ok great", onPressed: () {}
          ),);

        //this shows it:
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            FilledButton(onPressed: () {}, child: Text("Save")),
            FilledButton(onPressed: () {}, child: Text("Open")),
            FilledButton(onPressed: () {}, child: Text("Reset"))
          ],
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          title: Text("Favorite Recipes"),
        ),
        body: Center(
            child:
            Column(mainAxisAlignment: .center,
                children: [
                  TextField(controller:_controller,
                    decoration: InputDecoration(label:Text("Name")),),
              OutlinedButton(child:Text("Save data"), onPressed: () {

                SharedPreferences.getInstance().then( ( sharedPrefs) {

                  //this part is async, or runs after the timer ends
                  sharedPrefs.setString("USERNAME", _controller.text);//
                } );


                /*
                //show a dialog
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    //the title:
                    title: const Text('AlertDialog Title'),

                    //the body
                    content: const Text('AlertDialog description'),

                    //buttons:
                    actions: <Widget>[
                    FilledButton(child:Text("Ok"), onPressed: (){
                      Navigator.pop(context); //hide the dialog
                    },),
                       FilledButton(child:Text("Cancel"), onPressed: (){
                         Navigator.pop(context); //hide the dialog
                       },),
                    ],
                  ),
                );*/

              },)
            ]
            )
        )

    );
  }

  void buttonPressed() {
    var inpt = _controller.value.text;

    _controller.text = "You typed " + inpt;
  }
}
