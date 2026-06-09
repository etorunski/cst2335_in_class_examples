import 'DataRepository.dart';
import 'package:flutter/material.dart'; //page will look like android
import 'package:url_launcher/url_launcher.dart';


class OtherPage extends StatefulWidget
{
  @override                     // returns
  OtherPageState createState() => OtherPageState() ; //doesn't exist yet
}

//holds only variables
class OtherPageState extends State<OtherPage>
{
  //declare variables:  inherits setState() to redraw

  @override   // returns how this object state will be represented
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Other Page"),
      ),
      body: createLayout()
    ); //basics of a page
  }

  Widget createLayout()
  {
    //get the string from MainPage
    var theWords = DataRepository.getWords();

    return Center(child:
      Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text("Welcome ${theWords}"),              //everything allocated here in context is freed
          FilledButton(onPressed: () {  Navigator.pop(context); },
              child: Text("Go back")),

          OutlinedButton(child:Text("open website"), onPressed: () async {

            //can throw exception if malformed URL
            var url = Uri.parse("tel:613-727-4723");

            if(await canLaunchUrl( url) ) {
              launchUrl(url);
            }
            else
              {
                //warn that this can't make phone calls
              }

          },)
      ],)
    );
  }

}