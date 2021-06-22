import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app_test/screens/firstScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import '../listview.dart';
import 'Login.dart';
import 'Profile.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}
enum menuItems { nG, nB, wW, sM ,sT}
class _SecondScreenState extends State<SecondScreen> {
  String _text;
  List<String> cats = ['Action','Animated','Adventure','Biography','Comedy','Drama','Fiction','Horror','Thriller','Sci-Fiction'];
  DatabaseReference _dataRef;
  String uid = FirebaseAuth.instance.currentUser.uid;
  String id;
  final List<String> imgList = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
    'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  ];
  bool switchVal = false;
  double height = AppBar().preferredSize.height;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _text="Movies";
    _dataRef = FirebaseDatabase.instance.reference().child('User_Information').child(uid);
    //_testData();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Text(_text),
        ),
        actions: [
          PopupMenuButton(
          onSelected: (menuItems result) { setState(()
          {
            if(result==menuItems.nB){
              Navigator.push(context, MaterialPageRoute(builder:(context){
                return TabbedView();
              })) ;
            }
            if(result==menuItems.nG){
              Navigator.push(context, MaterialPageRoute(builder:(context){
                return ListViewDemo();
              })) ;
            }

          }); },
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<menuItems>>[
            PopupMenuItem(
              value: menuItems.nG,
              child: Text('New Group'),
            ),
            PopupMenuItem(
              value: menuItems.nB,
              child: Text('New Broadcast'),
            ),
            PopupMenuItem(
              value: menuItems.wW,
              child: Text('WhatsApp Web'),
            ),
            PopupMenuItem(
              value: menuItems.sM,
              child: Text('Starred messages'),
            ),
              PopupMenuItem(
                value: menuItems.sT,
                child: Text('Settings'),
              ),

          ];
          },
        )
      ],),
      drawer: Drawer(
        child: ListView(
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                        future: _getImage(),
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          if(snapshot.connectionState==ConnectionState.waiting){
                            return CircleAvatar(
                              radius: 50,
                            );
                          }
                          else if(snapshot.hasData){
                            return CircleAvatar(
                              backgroundImage: NetworkImage(snapshot.data),
                              radius: 50,
                            );
                          }
                          else{
                            return CircleAvatar(
                              radius: 50,
                            );
                          }
                        }),
                    FutureBuilder(
                        future: _getName(),
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          if(snapshot.connectionState==ConnectionState.waiting){
                            return Text('Waiting...');
                          }
                          else if(snapshot.hasData){
                            return Text(snapshot.data, style: TextStyle(
                                color: Colors.white, fontSize: 15),);
                          }
                          else{
                            return Text('Error');
                          }
                    }),
                    FutureBuilder(
                        future: _getEmail(),
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          if(snapshot.connectionState==ConnectionState.waiting){
                            return Text('Waiting...');
                          }
                          else if(snapshot.hasData){
                            return Text(snapshot.data, style: TextStyle(
                                color: Colors.white, fontSize: 15),);
                          }
                          else{
                            return Text('Error');
                          }
                        }),
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.lightBlue
                ),
              ),
              GestureDetector(
                child: ListTile(leading: Icon(Icons.person),title: Text('Profile'),),
                onTap: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                          return Profile();
                      })
                  );
                  /*setState(() {
                    _text = 'Profile';
                    Navigator.pop(context);
                  });*/
                }),
              ListTile(leading: Icon(Icons.settings),title: Text('Settings'),),
              ListTile(leading: Icon(Icons.info),title: Text('About Us'),),
              GestureDetector(
                  child: ListTile(leading: Icon(Icons.logout),title: Text('Sign out'),),
                  onTap: (){
                    signOut();
                    showLoaderDialog(context);
                    /*setState(() {
                    _text = 'Profile';
                    Navigator.pop(context);
                  });*/
                  }),
            ],
          ),
      ),
      body: Column(
        children: [
          _catList(),
          _imageSliderExample(context),
          _tButton(context)
        ],
      )
    );
  }

  Widget _drawer(BuildContext context){
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                    future: _getImage(),
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return CircleAvatar(
                          radius: 50,
                        );
                      }
                      else if(snapshot.hasData){
                        return CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data),
                          radius: 50,
                        );
                      }
                      else{
                        return CircleAvatar(
                          radius: 50,
                        );
                      }
                    }),
                FutureBuilder(
                    future: _getName(),
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return Text('Waiting...');
                      }
                      else if(snapshot.hasData){
                        return Text(snapshot.data, style: TextStyle(
                            color: Colors.white, fontSize: 15),);
                      }
                      else{
                        return Text('Error');
                      }
                    }),
                FutureBuilder(
                    future: _getEmail(),
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return Text('Waiting...');
                      }
                      else if(snapshot.hasData){
                        return Text(snapshot.data, style: TextStyle(
                            color: Colors.white, fontSize: 15),);
                      }
                      else{
                        return Text('Error');
                      }
                    }),
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.lightBlue
            ),
          ),
          GestureDetector(
              child: ListTile(leading: Icon(Icons.person),title: Text('Profile'),),
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return Profile();
                    })
                );
                /*setState(() {
                    _text = 'Profile';
                    Navigator.pop(context);
                  });*/
              }),
          ListTile(leading: Icon(Icons.settings),title: Text('Settings'),),
          ListTile(leading: Icon(Icons.info),title: Text('About Us'),),
          GestureDetector(
              child: ListTile(leading: Icon(Icons.logout),title: Text('Sign out'),),
              onTap: (){
                signOut();
                showLoaderDialog(context);
                /*setState(() {
                    _text = 'Profile';
                    Navigator.pop(context);
                  });*/
              }),
        ],
      ),
    );

  }

  Widget _customBar(BuildContext context){
    return PreferredSize(
      preferredSize: Size(
          MediaQuery.of(context).size.width,
          height
      ),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
          ListTile(
            leading: IconButton(icon: Icon(Icons.menu), onPressed: () {
              print('Clicked');
              Scaffold.of(context).openDrawer();
              },),
            title: Text('Movies'),
            trailing:  IconButton(icon: Icon(Icons.more_vert), onPressed: () {  },),
          )
        ],),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.red,Colors.blue]
          )
        ),
      ),
      
    );
  }

  Widget _tButton(BuildContext context){
    return Switch(value: switchVal, onChanged: (value){
      setState(() {
        switchVal = value;
      });
    },);
  }
  
  Widget _imageSliderExample(BuildContext context){
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        enlargeStrategy: CenterPageEnlargeStrategy.height,
      ),
      items: List.generate(imgList.length, (index) {
        return _eachItem(context, index);
      }),
    );
  }

  Widget _eachItem(BuildContext context,int index){
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(imgList[index],fit: BoxFit.cover),
    );
  }

  Future<String> _getName() async{
    return await _dataRef.child('Name').once().then((DataSnapshot mapValue) {
      return mapValue.value;
    });
  }

  Future<String> _getEmail() async{
    return await _dataRef.child('Email').once().then((DataSnapshot snapshot) {
      return snapshot.value;
    });
  }

  Future<String> _getImage() async{
    return await _dataRef.child('Image').once().then((DataSnapshot snapshot) {
      return snapshot.value;
    });
  }

  void signOut()async{
    await FirebaseAuth.instance.signOut().then((value) {
      GoogleSignIn().disconnect();
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context){
        return Login();
      }));
    });
  }

  showLoaderDialog(BuildContext context){
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return AlertDialog(
          content: new Row(
            children: [
              CircularProgressIndicator(),
              Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
            ],),
        );
      },
    );
  }

  Widget _catList(){
    return SizedBox(
        height: 40,
        child: ListView.builder(
        itemCount: cats.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context,index){
          return _itemUI(index);
        }
    ));
  }

  Widget _itemUI(int index){
    return Container(
              height: 10,
              child: Card(
                elevation: 5,
                shadowColor: Colors.lightBlue,
                color: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Center(
                      child:Text(cats[index],
                        style: TextStyle(color: Colors.white,),
                        textAlign: TextAlign.center,
                      )),
                ),
                )
          );
  }

  void _testData() async{
    DatabaseReference _testRef = FirebaseDatabase.instance.reference().child('testing').child(uid);
    await _testRef.limitToLast(1).once().then((DataSnapshot snapshot) {
      if(snapshot.value!=null) {
        //var body = jsonEncode(snapshot.value);
        Map<dynamic, dynamic> data = snapshot.value;
        print('TESTING : ${data.keys.first}');
        int numId = int.parse(data.keys.first) + 1;
        if (numId < 10) {
          id = ('0$numId').toString(); //id="02"
        }
        else {
          id = (numId).toString();
        }
        print(id);
      }
      else{
        id = "01";
      }
    }).then((value){
        _testRef.child(id).set({'a':1,'b':1,'c':1}).then((value){
          _testData();
        });
    });
  }



}
