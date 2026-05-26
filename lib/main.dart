import 'package:flutter/material.dart';

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

  @override
  void initState(){
    super.initState();

    _controller = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FilledButton(onPressed: (){}, child:Text("Save")),
          FilledButton(onPressed: (){}, child:Text("Open")),
          FilledButton(onPressed: (){}, child:Text("Reset"))
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Title"),
      ),
      drawer:      Column(mainAxisAlignment: .end,
        children: [
        FilledButton(onPressed: (){}, child: Text("Go back")),],),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (whichButton){
            if(whichButton == 0) ///camera
            { }
            else if(whichButton == 1){
              //user clicked phone
            }
          }, //index of array item clicked
          items: [
              BottomNavigationBarItem(icon: Icon(Icons.camera_alt_outlined), label: "Camera"),
              BottomNavigationBarItem(icon: Icon(Icons.call_end_outlined), label:"Phone"  ),
              BottomNavigationBarItem(icon: Icon(Icons.money_off_csred_outlined), label:"Cash"),

      ]),
      body: Center(
        child:
        Row(children: [
          Spacer(flex:1),
Expanded(flex:5,
    child:
          Column(
            crossAxisAlignment: .start,
           mainAxisAlignment: .spaceEvenly,
          children: [
            Expanded(flex:1, child: Text(""),),

            Text("One-pan skillet cookie", style: TextStyle(color:Colors.orange, fontSize: 40.0),),
            Text("Ingredient list"),


            Expanded(flex:1, child: Text(""),),


            Row(mainAxisAlignment: .start,  children: [
              Icon(Icons.star),
              Text("1 stick of unsalted butter",  style: TextStyle(color:Colors.orange))
            ],),
            Row(mainAxisAlignment: .start, children: [
              Icon(Icons.star),
              Text("1/2 C granulated sugar")
            ],),
            Row(mainAxisAlignment: .start, children: [
              Icon(Icons.star),
              Text("1/2 C light brown sugar")
            ],),


            Expanded(flex:5, child: Text(""),),

          ], //empty column
        )),

          Spacer(flex:1),
        ]
      )
      )

    );
  }

  void buttonPressed(){
     var inpt = _controller.value.text;

    _controller.text = "You typed " + inpt;
  }
}
