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

import 'package:lol_friend_flutter/common_widgets/form_submit_button.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key, this.database, this.userProfile, this.user}) : super(key: key);
  final DataBase database;
  final UserProfile userProfile;
  final User user;

  static Future<void> show(
    BuildContext context, {
    User user,
    DataBase database,
    UserProfile userProfile,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ProfilePage(
          user: user,
          database: database,
          userProfile: userProfile,
        ),
      ),
    );
  }
    
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
  
  @override
  void initState() { 
    super.initState();
    _getLocation();
  }
  _getLocation() async {
    
    Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    location = GeoPoint(position.latitude, position.longitude);
    print(location);
  }   

  Future<void> _submit() async {
    final user = widget.user;
    await widget.database.setUserProfile(UserProfile(
      name: _nameController.text,
      age: age,
      gender: gender,
      interestedIn: interestedIn,
      location: location,
      photo: photo.path,
      uid: user.uid,
      ),
    );
    Navigator.pop(context);
  }
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.grey[500],
      body: SingleChildScrollView(
        //scrollDirection: Axis.vertical,
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
            FormSubmitButton(text: "생일을 입력해주세요",
              onPressed: (){
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
            ),
              
          
            SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  children: [
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
                SizedBox(height: size.height * 0.02),
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
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
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
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: FormSubmitButton(
                     text: '저장',onPressed: _submit,),
                    ),
                ),
                
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