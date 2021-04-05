import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String picURL;
  String uid = FirebaseAuth.instance.currentUser.uid;
  DatabaseReference _dataRef;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataRef = FirebaseDatabase.instance.reference().child('User_Information').child(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: _profileBody(context),
    );
  }





  pickImageFromGallery(ImageSource source) {
      ImagePicker.pickImage(source: source).then((value){
          Navigator.pop(context);
          print('File Path : ${value.path}');
          showUploadingDialog(context);
          uploadFile(value.path).then((value) {
            setState(() {
              print('DOWN URL : $picURL');
              Navigator.pop(context);
            });
          });
      });

  }

  Future<void> uploadFile(String filePath) async {
    File file = File(filePath);

    try {
      await FirebaseStorage.instance.ref("profile_pics").child("/$uid.jpg")
          .putFile(file).then((value) {
              return value.ref.getDownloadURL().then((value){
                picURL = value;
                saveImageLinkToDB(picURL);
        });
      });
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
    }
  }

  showUploadingDialog(BuildContext context){
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return AlertDialog(
          content: new Row(
            children: [
              CircularProgressIndicator(),
              Container(margin: EdgeInsets.only(left: 7),child:Text("Uploading..." )),
            ],),
        );
      },
    );
  }

  Widget _appBar(BuildContext context){
    return AppBar(title: Text('Profile'),);
  }

  Widget _profileBody(BuildContext context){
    return Container(
      child: Center(
        child:
          GestureDetector(
            child: CircleAvatar(
              backgroundImage: (picURL==null)?NetworkImage('https://alchinlong.com/wp-content/uploads/2015/09/sample-profile.png'):
                                NetworkImage(picURL),
              radius: 100,),
            onTap: (){
                showOptionDialog(context);
            },
          )
      ),
    );
  }

  showOptionDialog(BuildContext context){
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return AlertDialog(
          content: new Wrap(
            children: [
              ListTile(leading: Icon(Icons.remove_red_eye),title: Text('View Profile Picture'),onTap: (){Navigator.pop(context);},),
              ListTile(leading: Icon(Icons.photo),title: Text('Select from Gallery'),onTap: (){pickImageFromGallery(ImageSource.gallery);},),
            ],),
        );
      },
    );
  }

  Future<void> saveImageLinkToDB(String imgLink) async{
    await _dataRef.update({'Image':imgLink});
  }
}
