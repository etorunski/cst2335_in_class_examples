
import 'package:flutter/material.dart'; //page will look like android

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
    return Scaffold(); //basics of a page
  }

}