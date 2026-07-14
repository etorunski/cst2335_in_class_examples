import 'package:flutter/material.dart';
import 'database/app_database.dart';
import 'database/todo.dart';
import 'database/todo_dao.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Todo Floor Database'),
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
  TodoDao? todoDao;
  List<Todo> todos = [];
  late TextEditingController _nameController;
  late TextEditingController _quantityController;

  Todo? selectedItem  = null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _quantityController = TextEditingController();
    _initDatabase();
  }

  Future<void> _initDatabase()  async {
    Future.delayed(Duration.zero, () async{

    //create the database on disk:
    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    //get the DAO of the database
    todoDao = database.todoDao;

    //query all objects:
    _refreshTodos();
      //code to run later

    }  );

  }

  Future<void> _refreshTodos() async {
    if (todoDao != null) {
      //querying all from database:
      final result = await todoDao!.findAllTodos();
      setState(() {
        //setting our list for the listView:
        todos = result;
      });
    }
  }

  Future<void> _addTodo() async {
    //make sure fields have something in them:
    if (_nameController.text.isNotEmpty && _quantityController.text.isNotEmpty) {
    //create an Entity object:
      final todo = Todo(
        name: _nameController.text,
        quantity: _quantityController.text,
      );

      //insert into database:
      await todoDao?.insertTodo(todo);

      //clear the textfields:
      _nameController.clear();
      _quantityController.clear();

      //reload the data:
      _refreshTodos();
    }
  }

  Future<void> _deleteTodo(Todo todo) async {
    //delete from database:
    await todoDao?.deleteTodo(todo);

    //requery data:
    _refreshTodos();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Widget reactiveLayout(BuildContext bc)
  {
    var size = MediaQuery.of(context).size; //get the size of the screen
    var height = size.height;
    var width = size.width;

    if((width > height) && (width > 720))//landscape / desktop mode
        {
        return Row(children: [
         Expanded(child: listPage(bc), flex: 1), //1 / 4
         Expanded(child:detailsPage(bc), flex:3) //1 / 4
        ],);
    }
    else //it's portrait mode
    {
      if(selectedItem == null){
        //nothing is selected:
        return listPage(bc);
      }
      else{
        return detailsPage(bc);
      }
    }
  }

  Widget detailsPage(BuildContext context){

    if(selectedItem != null)
      {
        //there is a selected Item:
        return Center(child:Column(
            mainAxisAlignment: .center,
            children:[
          Text("Item name is: ${selectedItem!.name}"),
          Text("Quantity is: ${selectedItem!.quantity}"),
              OutlinedButton(child:Text("clear"), onPressed: (){
                setState(() {
                  selectedItem = null; // need to go back to the listview
                });

              },),
              OutlinedButton(child:Text("Delete"), onPressed:(){
                setState(() {

                  todos.remove(selectedItem);//we don't have the index
                  selectedItem = null;

                });
              })
        ]));
      }
    else{
      //nothing is selected
      return Center(child:Column(children:[
        Text("Select an item from the list to see the details")
      ]));
    }
  }

  Widget listPage(BuildContext context) {
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
                      decoration: const InputDecoration(hintText: "Enter name"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _quantityController,
                      decoration: const InputDecoration(hintText: "Enter quantity"),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addTodo,
                  child: const Text("add"),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                title: Text("${todo.name} (${todo.quantity})"),
                onTap: () {
                  //The user has selected this item:
                  setState(() {
                    //redraw the GUI:

                    selectedItem = todo; //store what was selected
                    });
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
      ),
      body: reactiveLayout(context),
    );
  }
}
