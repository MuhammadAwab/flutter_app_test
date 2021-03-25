import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

import 'Login.dart';
import 'SecondScreen.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference _dataRef;
  TextEditingController eC = TextEditingController();
  TextEditingController pC = TextEditingController();
  TextEditingController nC = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataRef = FirebaseDatabase.instance.reference().child('User_Information');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: containerBody(context)
    );
  }

  Widget containerBody(BuildContext context){
    return Container(
        color: Colors.deepPurple,
        padding: EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(),
          elevation: 5,
          child : Padding(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width*0.25,
                0,MediaQuery.of(context).size.width*0.25,
                0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/binglogo.jpg'),
                TextField(
                  controller: nC,
                  decoration: InputDecoration(hintText: 'Name'),),
                TextField(
                  controller: eC,
                  decoration: InputDecoration(hintText: 'Email'),),
                TextField(
                    controller: pC,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Password')),
                RaisedButton(
                  child: Text('Register',style: TextStyle(color: Colors.white),),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Colors.purple,
                  onPressed: (){
                    print('Email : ${eC.text}');
                    print('Password : ${pC.text}');
                    registerUser(eC.text, pC.text);
                    showLoaderDialog(context);
                  },
                ),
                RaisedButton(
                  child: Text('Existing User',style: TextStyle(color: Colors.white),),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Colors.purple,
                  onPressed: (){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context){
                          return Login();
                        }));
                  },
                ),
              ],
            ), ),
        ));
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

  void registerUser(String email,String password) async{
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      ).then((value) {
        String uid = FirebaseAuth.instance.currentUser.uid;
        return _setData(uid, nC.text,email).then((value) {
          return Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context){
                return SecondScreen();
              }));
        });
      });

      print('SOMETHING');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      Navigator.pop(context);
      Fluttertoast.showToast(msg: e.code);
    } catch (e) {
      print(e);
    }
  }


  Future<void> _setData(String uid,String name,String email) async{
    await _dataRef.child(uid).set({'Name':name,'Email':email});
  }

}
