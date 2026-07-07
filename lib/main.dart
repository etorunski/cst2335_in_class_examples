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
                              _deleteTodo(todo);
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
      ),
      body: todoDao == null
          ? const Center(child: CircularProgressIndicator())
          : listPage(context),
    );
  }
}
