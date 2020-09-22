import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lol_friend_flutter/app/home/models/userProfile.dart';
import 'package:lol_friend_flutter/app/services/auth.dart';
import 'package:lol_friend_flutter/app/services/database.dart';
import 'package:lol_friend_flutter/app/ui/widgets/gender.dart';
import 'package:provider/provider.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key, this.database}) : super(key: key);
  final DataBase database;



  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  
  final TextEditingController _nameController = TextEditingController();
  PlatformFile photo;
  File myFile;
  DateTime age;
  String gender, interestedIn;
  GeoPoint location;
  

  bool isLoading;
  bool submitted;

  _getLocation() async {
    Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    location = GeoPoint(position.latitude, position.longitude);
  }   

  Future<void> _submit() async {
  final database = Provider.of<DataBase>(context,listen: false);
  final user = Provider.of<User>(context, listen: false);
    _getLocation();
    return database.setUserProfile(UserProfile(
      name: _nameController.text,
      age: age,
      gender: gender,
      interestedIn: interestedIn,
      location: location,
      photo: myFile,
      uid: user.uid,
      ),
    );
  }


  


    
  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      //scrollDirection: Axis.vertical,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: CircleAvatar(
                radius: size.width * 0.5,
                backgroundColor: Colors.transparent,
                child: 
                  photo == null ? GestureDetector(
                    onTap: () async {
                      FilePickerResult pickerResult = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );
                      if (pickerResult != null) {
                        setState(() {
                          photo = pickerResult.files.first;
                            print(photo.path);
                        });
                      }
                    },
                  child: Image.asset('assets/profilephoto.png'),
                  )
                  : GestureDetector(
                    onTap: () async {
                      FilePickerResult pickerResult = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );
                    if (pickerResult != null) {
                      setState(() {
                        photo = pickerResult.files.first;
                      });
                    }
                  },
                  child: CircleAvatar(
                    radius: size.width * 0.3,
                    backgroundImage: FileImage(myFile = File(photo.path)),
                  )
                ),
              )
            ),
            textFieldWidget(_nameController, "Name", size),
            GestureDetector(
              onTap: () {
                DatePicker.showDatePicker(
                  context,
                  showTitleActions: true,
                  minTime: DateTime(1900, 1, 1),
                  maxTime: DateTime(DateTime.now().year - 19, 1, 1),
                  onConfirm: (date) {
                    setState(() {
                      age = date;
                    });
                    print(age);
                  },
                );
              },
              child: Text(
                "Enter Birthday",
                style: TextStyle(
                    color: Colors.white, fontSize: size.width * 0.09),
              ),
            ),
            SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.height * 0.02),
                  child: Text(
                    "You Are",
                    style: TextStyle(
                        color: Colors.white, fontSize: size.width * 0.09),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    genderWidget(
                        FontAwesomeIcons.venus, "Female", size, gender,
                        () {
                      setState(() {
                        gender = "Female";
                      });
                    }),
                    genderWidget(
                        FontAwesomeIcons.mars, "Male", size, gender, () {
                      setState(() {
                        gender = "Male";
                      });
                    }),
                    genderWidget(
                      FontAwesomeIcons.transgender,
                      "Transgender",
                      size,
                      gender,
                      () {
                        setState(
                          () {
                            gender = "Transgender";
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.height * 0.02),
                  child: Text(
                    "Looking For",
                    style: TextStyle(
                        color: Colors.white, fontSize: size.width * 0.09),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    genderWidget(FontAwesomeIcons.venus, "Female", size,
                        interestedIn, () {
                      setState(() {
                        interestedIn = "Female";
                      });
                    }),
                    genderWidget(
                        FontAwesomeIcons.mars, "Male", size, interestedIn,
                        () {
                      setState(() {
                        interestedIn = "Male";
                      });
                    }),
                    genderWidget(
                      FontAwesomeIcons.transgender,
                      "Transgender",
                      size,
                      interestedIn,
                      () {
                        setState(
                          () {
                            interestedIn = "Transgender";
                          },
                        );
                      },
                    ),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                    child: GestureDetector(
                      onTap: _submit,
                      child: Container(
                        width: size.width * 0.8,
                        height: size.height * 0.06,
                        decoration: BoxDecoration(
                          color:  Colors.white,
                          borderRadius:
                              BorderRadius.circular(size.height * 0.05),
                        ),
                        child: Center(
                            child: Text(
                              "Save",
                              style: TextStyle(
                                fontSize: size.height * 0.025,
                                color: Colors.blue),
                          )
                        ),
                      ),
                    ),
                  )
              ],
            )
          ],
        ),
      ),  
    );
  }
}

Widget textFieldWidget(controller, text, size) {
  return Padding(
    padding: EdgeInsets.all(size.height * 0.02),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
        labelStyle:
            TextStyle(color: Colors.white, fontSize: size.height * 0.03),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
        ),
      ),
    ),
  );
}