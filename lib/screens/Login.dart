import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/screens/Registration.dart';
import 'package:flutter_app_test/screens/SecondScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:g_captcha/g_captcha.dart';
import 'firstScreen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseAuth auth = FirebaseAuth.instance;
  DatabaseReference _dataRef;
  TextEditingController eC = TextEditingController();
  TextEditingController pC = TextEditingController();
  static const String CAPTCHA_SITE_KEY = "6LcKqfQUAAAAAC1I5Bjg0WI9RMc6wK9gjwG29Nr3";
  @override
  void initState() {
    // TODO: implement initState

  }

  _openReCaptcha() async {
    String tokenResult = await GCaptcha.reCaptcha(CAPTCHA_SITE_KEY);
    print('tokenResult: $tokenResult');
    Fluttertoast.showToast(msg: tokenResult, timeInSecForIosWeb: 4);
    // setState
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                  controller: eC,
                  decoration: InputDecoration(hintText: 'Email'),),
                TextField(
                    controller: pC,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Password')),
                RaisedButton(onPressed: _openReCaptcha, child: Text('reCaptcha')),
                RaisedButton(
                  child: Text('Login',style: TextStyle(color: Colors.white),),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Colors.purple,
                  onPressed: (){
                    print('Email : ${eC.text}');
                    print('Password : ${pC.text}');
                    loginUser(eC.text, pC.text);
                    showLoaderDialog(context);
                  },
                ),
                RaisedButton(
                  child: Text('New User',style: TextStyle(color: Colors.white),),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: Colors.purple,
                  onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context){
                          return Registration();
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



  void loginUser(String email,String password) async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      ).then((value) {
        return Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context){
              return SecondScreen();
            }));
      });
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

}
