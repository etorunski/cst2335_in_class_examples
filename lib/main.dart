import 'package:cst2335_in_class_examples/database/app_database.dart';
import 'package:cst2335_in_class_examples/database/todo.dart';
import 'package:cst2335_in_class_examples/database/todo_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'AppLocalizations.dart';

void main() {
  runApp(const MyApp());
}
//means never changes
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) async {

    //this retrieves the state
    MyAppState? state = context.findAncestorStateOfType<MyAppState>();
    state?.changeLanguage(newLocale);
  }

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  //app starts off with this language:
  var _locale = Locale("en", "ca");//english from canada

  void changeLanguage(Locale locale){
    setState(() {
      _locale = locale;  //this updates your language to the new one
    });
  }



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [   //list all the languages your app supports:
        Locale("de"),
        Locale("en", "CA")
      ],
      localizationsDelegates: const [   //copy and paste this, don't change it
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: _locale, //starting language
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
  List<Todo> list1 = [];
  Todo? selectedItem = null;//nothing is selected

  late TodoDao itemDAO;

  var isChecked = false;
  var myFontSize = 0.0;
  late TextEditingController _controller; //late means promise to initialize it later

  //can't be async, because it overrides from parent
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(); //doing your promise to initialize

    //want to load any existing data into the arraylist
    //to open the database:

    $FloorAppDatabase.databaseBuilder('ItemFile.db').build()
        .then( (database){
      itemDAO = database.todoDao;

      //query all data:
      itemDAO.findAllTodos().then( (listOfItems ) {
        setState(() { //redraw the GUI
          list1.addAll(listOfItems); //put the items in the list:
        });
      });
    }  );
  }

  //you are being removed
  @override
  void dispose() {
    super.dispose();
    //free memory:
    _controller.dispose();
  }



  @override
  Widget build(BuildContext context) {




    return Scaffold(

      appBar: AppBar(
        actions: [
          FilledButton(onPressed: (){MyApp.setLocale(context, Locale("en", "CA")); },
              child: Text("English")),
          FilledButton(onPressed: (){MyApp.setLocale(context, Locale("de")); },
              child: Text("German")),
          FilledButton(onPressed: (){MyApp.setLocale(context, Locale("ar")); },
              child: Text("Arabic")),
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: reactiveLayout(), //decides how to lay out

    );
  }

  Widget reactiveLayout(){

    var size = MediaQuery.of(context).size; ///how big is the screen?
    var height = size.height;
    var width = size.width;



    if( (width>height) && (width > 720)) {
      //tablet
      return Row( children:[
        Expanded(child: ListPage(),    flex:2), //Left side 40%
        Expanded(child: DetailsPage(), flex:3) //Right side, 60%
      ]);
    }
    else{ //Portrait mode / Phone
      if( selectedItem== null)
        return ListPage(); //show the list
      else
        return DetailsPage(); //show the details
    }
  }

  Widget DetailsPage() {
    if(selectedItem != null){
      return Center(child:Column( children: [
        Text("Name: ${selectedItem!.name}", style: TextStyle(fontSize: 40.0),),
        Text("Quantity: ${selectedItem!.quantity}", style: TextStyle(fontSize: 40.0)),
        Spacer(),//balloon that expands to fill the space
        OutlinedButton(onPressed: (){
          setState(() { selectedItem = null; });
        }, child: Text("Delete")),


        OutlinedButton(onPressed: (){
          setState(() { selectedItem = null; });
        }, child: Text("Close"))

      ], mainAxisAlignment: MainAxisAlignment.center,)
      ); //show what's been selected
    }
    else{
      return Text(AppLocalizations.of(context)!.translate('TextSelect')!,style: TextStyle(fontSize: 30.0));
    }
  }

  Widget ListPage()
  {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row( mainAxisAlignment: MainAxisAlignment.spaceBetween, children:[
            Flexible(
                flex:1,
                child: ElevatedButton( child:Text(AppLocalizations.of(context)!.translate('Add')!), onPressed:() {
                  setState(() {
                    //Unique IDs
                    Todo newItem = Todo( name:_controller.value.text, quantity: "qty");

                    itemDAO.insertTodo(newItem);//insert to database
                    list1.add(newItem);
                    _controller.text = "";
                  });
                } )

            ),

            Flexible( flex:4, child:TextField(controller: _controller ))
          ]),

          Expanded(child:
          ListView.builder(
              itemCount: list1.length,
              itemBuilder:(context, rowNum) =>
                  GestureDetector(child:Text("Row $rowNum, Name: ${list1[rowNum].name} Quantity: ${list1[rowNum].quantity }") ,

                      onTap: () {
                        setState(() {  selectedItem = list1[rowNum]; });
                      },


                      onLongPress: () {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Delete this?'),
                              content: const Text('are you sure?'),
                              actions: <Widget>[
                                FilledButton(child:Text("Yes"), onPressed:() {
                                  setState(() {
                                    list1.removeAt(rowNum);
                                  });

                                  Navigator.pop(context);
                                }),
                                FilledButton(child:Text("Cancel"), onPressed:() {
                                  Navigator.pop(context);

                                }),
                              ],
                            )
                        );

                      })
          )
          )
        ]);
  }
}