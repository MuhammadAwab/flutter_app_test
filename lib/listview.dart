import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ListViewDemo extends StatefulWidget {
  @override
  _ListViewDemoState createState() => _ListViewDemoState();
}

class _ListViewDemoState extends State<ListViewDemo> {
  double appBarHeight,listItemHeight;
  @override
  Widget build(BuildContext context) {
    AppBar myBar = AppBar(
        title: Text('WhatsApp'),
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.camera_alt),),
            Tab(child: Text('Chats'),),
            Tab(child: Text('Status'),),
            Tab(child: Text('Calls'),),
          ],));
    appBarHeight = myBar.preferredSize.height;
    listItemHeight = (MediaQuery.of(context).size.height - appBarHeight)/3;
    return DefaultTabController(
        length: 4,
        initialIndex: 1,
        child:Scaffold(
          body: tabView(context,listItemHeight),
          appBar: myBar
      ),
      );
  }
}

Widget tabView(BuildContext context,double listItemHeight){
  return TabBarView(
      children: [
        cameraView(context,listItemHeight),
        chatsView(context,listItemHeight),
        statusView(context,listItemHeight),
        callsView(context,listItemHeight),
      ]);
}

Widget cameraView(BuildContext context,double listItemHeight){

  return ListView(
      scrollDirection: Axis.horizontal,
      children:[
        Container(
          width: MediaQuery.of(context).size.width,
          height: listItemHeight,
          color: Colors.red,),
        Container(
          width: MediaQuery.of(context).size.width,
          height: listItemHeight,
          color: Colors.deepOrange,),
        Container(
          width: MediaQuery.of(context).size.width,
          height: listItemHeight,
          color: Colors.redAccent,),
      ]
  );
}

Widget chatsView(BuildContext context,double listItemHeight){
  return ListView(
      children:[
        Container(
          width: MediaQuery.of(context).size.width,
          height: listItemHeight,
          color: Colors.deepPurple,),
        Container(
          width: MediaQuery.of(context).size.width,
          height: listItemHeight,
          color: Colors.deepPurpleAccent,),
        Container(
          width: MediaQuery.of(context).size.width,
          height: listItemHeight,
          color: Colors.purple,),
      ]
  );
}

Widget statusView(BuildContext context,double listItemHeight){
  return ListView(
      children:[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/3,
          color: Colors.green,),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/3,
          color: Colors.greenAccent,),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/3,
          color: Colors.lightGreen,),
      ]
  );
}

Widget callsView(BuildContext context,double listItemHeight){
  return ListView(
      children:[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/3,
          color: Colors.green,),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/3,
          color: Colors.greenAccent,),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/3,
          color: Colors.lightGreen,),
      ]
  );
}