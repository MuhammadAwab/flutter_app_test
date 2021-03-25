import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app_test/screens/firstScreen.dart';
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
  String _text='Movies';
  List<String> cats = ['Action','Animated','Adventure','Biography','Comedy','Drama','Fiction','Horror','Thriller','Sci-Fiction'];
  DatabaseReference _dataRef;
  String uid = FirebaseAuth.instance.currentUser.uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataRef = FirebaseDatabase.instance.reference().child('User_Information').child(uid);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_text),
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
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/binglogo.jpg'),
                      radius: 50,
                    ),
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
          Text(_text,style: TextStyle(fontSize: 25,color: Colors.indigo),),
        ],
      )
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

  void signOut()async{
    await FirebaseAuth.instance.signOut().then((value) {
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
}
