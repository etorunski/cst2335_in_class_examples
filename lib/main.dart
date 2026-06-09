import 'package:flutter/material.dart';
import 'OtherPage.dart';
import 'DataRepository.dart';
import 'package:url_launcher/url_launcher.dart';


void main() {
  runApp(const MyApp());
}

//page with no variables, never changes, no setState()
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        //key (string)   --  value  Widget function(BuildContext )
        '/'           :   ( BuildContext bc)  =>   MyHomePage(title:"My app"),
        '/otherPage'  :   (bc) => OtherPage()

      },
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //for namedRoutes, use initialRoute:
      initialRoute: '/', //don't need home: parameter
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
  late TextEditingController _controller;
  static const String _keyName = 'user_name';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }


  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(

              onPressed: (){
                var words = _controller.text;

                DataRepository.setWords( words ); //store the words to pass along
                Navigator.pushNamed(context , '/otherPage' ); },

              child: const Text('Go to next page'),
            ),

            Row(children:[
          Expanded(child:    TextField(controller: _controller,
                decoration: InputDecoration(
                    label:Text("Enter words:"),
                    border: OutlineInputBorder() )),),
              IconButton(
                icon:Icon(Icons.phone), onPressed: () {  launch("tel:"); },),
              IconButton(
                icon:Icon(Icons.sms), onPressed: () {  launch("sms:"); },),

            ])

          ],
        ),
      ),
    );
  }

}
