import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/screens/Login.dart';
import 'package:flutter_app_test/screens/SecondScreen.dart';
import 'package:flutter_app_test/screens/firstScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: (FirebaseAuth.instance.currentUser==null)
            ?Login()
            :SecondScreen() ///HomePage()//RegistrationPage()//TabbedView()//
            //_home(context)
    );
    
  }
  
  Widget _home(BuildContext context){
    if(FirebaseAuth.instance.currentUser==null){
      return Login();
    }
    else{
      return SecondScreen();
    }
  }
}








