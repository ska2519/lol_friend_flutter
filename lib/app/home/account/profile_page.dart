import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lol_friend_flutter/app/home/models/userProfile.dart';
import 'package:lol_friend_flutter/app/landing_page.dart';
import 'package:lol_friend_flutter/app/services/auth.dart';
import 'package:lol_friend_flutter/app/services/database.dart';
import 'package:lol_friend_flutter/app/ui/widgets/profile.dart';
import 'package:lol_friend_flutter/common_widgets/form_submit_button.dart';
import 'package:lol_friend_flutter/common_widgets/platform_exception_alert_dialog.dart';
import 'package:chips_choice/chips_choice.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key, this.database, this.userProfile, this.user})
      : super(key: key);
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
  final _formkey = GlobalKey<FormState>();
  PlatformFile photo;
  DateTime age;
  String gender, interestedIn;
  GeoPoint location;
  String labelName = '이름';
  bool isLoading;
  bool submitted;
  String name;
  File myFile;

  @override
  void initState() {
    super.initState();
    if (widget.userProfile != null) {
      name = widget.userProfile.name;
    }
    _getLocation();
  }

  _getLocation() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    location = GeoPoint(position.latitude, position.longitude);
    print(location);
  }

  bool _validateAndSaveForm() {
    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      print('form: $form');
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    //final user = Provider.of<User>(context, listen: false);
    if (_validateAndSaveForm()) {
      try {
        await widget.database.setUserProfile(
            myFile, widget.user.uid, name, gender, interestedIn, age, location);
        await Navigator.push(
            context, MaterialPageRoute(builder: (context) => LandingPage()));
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Form(
      key: _formkey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.userProfile == null ? '프로필 작성' : '프로필 보기'),
          actions: widget.userProfile == null
              ? [
                  IconButton(
                      icon: Icon(FontAwesomeIcons.save), onPressed: _submit)
                ]
              : null,
        ),
        backgroundColor: Colors.grey[50],
        body: SingleChildScrollView(
          //scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: widget.userProfile == null
                    ? GestureDetector(
                        onTap: () async {
                          FilePickerResult pickerResult =
                              await FilePicker.platform.pickFiles(
                            type: FileType.image,
                          );
                          if (pickerResult != null) {
                            setState(() {
                              photo = pickerResult.files.first;
                              myFile = File(photo.path);
                            });
                          }
                        },
                        child: photo != null
                            ? Container(
                                padding: const EdgeInsets.all(3.3),
                                // height: size.height * 0.57,
                                width: size.height * 0.77,
                                child: Image.file(myFile),
                              )
                            : profileWidget(
                                padding: 3.3,
                                photoHeight: size.height * 0.57,
                                photoWidth: size.height * 0.77,
                                clipRadius: size.height * 0.02,
                                containerHeight: size.height * 0.3,
                                containerWidth: size.width * 0.9,
                                photoUrl:
                                    'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png'),
                      )
                    : GestureDetector(
                        onTap: () async {
                          FilePickerResult pickerResult =
                              await FilePicker.platform.pickFiles(
                            type: FileType.image,
                          );
                          if (pickerResult != null) {
                            setState(() {
                              photo = pickerResult.files.first;
                              myFile = File(photo.path);
                              print(photo.path);
                            });
                          }
                        },
                        child: photo != null
                            ? Container(
                                padding: const EdgeInsets.all(3.3),
                                // height: size.height * 0.57,
                                width: size.height * 0.77,
                                child: Image.file(myFile),
                              )
                            : Container(
                                padding: const EdgeInsets.all(3.3),
                                width: size.height * 0.77,
                                child: FadeInImage.assetNetwork(
                                    //fit:BoxFit.fill ,
                                    width: size.height * 0.77,
                                    placeholder: 'assets/ball-1s-200px.gif',
                                    image: widget.userProfile.photo),
                              ),
                      ),
              ),
              Padding(
                padding: EdgeInsets.all(size.height * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textFieldWidget(
                        widget.userProfile != null
                            ? widget.userProfile.name
                            : 'null',
                        size),
                    SizedBox(height: size.height * 0.01),
                    FormSubmitButton(
                      text: widget.userProfile == null
                          ? "생일을 입력해주세요"
                          : '생일 : ${widget.userProfile.age.toString()}',
                      //disabledColor: Colors.grey,

                      onPressed: widget.userProfile == null
                          ? () {
                              DatePicker.showDatePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime(1900, 1, 1),
                                maxTime:
                                    DateTime(DateTime.now().year - 19, 1, 1),
                                onConfirm: (date) {
                                  setState(() {
                                    age = date;
                                  });
                                  print(age);
                                },
                              );
                            }
                          : null,
                    ),
                    Divider(
                        height: 30,
                        thickness: 1,
                        color: Theme.of(context).accentColor),
                    Text(
                      "내 성별",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: size.width * 0.07),
                    ),
                    ChipsChoice<String>.single(
                        padding: EdgeInsets.all(0),
                        value: widget.userProfile != null
                            ? widget.userProfile.gender
                            : gender,
                        itemConfig: ChipsChoiceItemConfig(
                          labelStyle: TextStyle(fontSize: 20),
                          selectedBrightness: Brightness.dark,
                        ),
                        options: <ChipsChoiceOption<String>>[
                          ChipsChoiceOption<String>(value: 'Male', label: '남성'),
                          ChipsChoiceOption<String>(
                              value: 'Female', label: '여성'),
                          ChipsChoiceOption<String>(
                              value: "Transgender", label: '모든사람'),
                        ],
                        onChanged: (val) => setState(() => gender = val)),
                    Divider(
                        height: 30,
                        thickness: 1,
                        color: Theme.of(context).accentColor),
                    Text(
                      "상대의 성별",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: size.width * 0.07),
                    ),
                    ChipsChoice<String>.single(
                      padding: EdgeInsets.all(0),
                      value: widget.userProfile != null
                          ? widget.userProfile.interestedIn
                          : interestedIn,
                      itemConfig: ChipsChoiceItemConfig(
                        labelStyle: TextStyle(fontSize: 20),
                        selectedBrightness: Brightness.dark,
                      ),
                      options: <ChipsChoiceOption<String>>[
                        ChipsChoiceOption<String>(value: 'Male', label: '남성'),
                        ChipsChoiceOption<String>(value: 'Female', label: '여성'),
                        ChipsChoiceOption<String>(
                            value: "Transgender", label: '모든사람'),
                      ],
                      isWrapped: true,
                      onChanged: (val) => setState(() => interestedIn = val),
                    ),
                  ],
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: FormSubmitButton(text: '저장', onPressed: _submit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textFieldWidget(name, size) {
    return TextFormField(
      validator: (value) {
        print('validator value: $value');
        if (value.isEmpty) {
          return 'Enter some text';
        } else
          return null;
      },
      initialValue: name,
      onSaved: (value) => name = value,
      decoration: InputDecoration(
        labelText: labelName,
        labelStyle:
            TextStyle(color: Colors.black, fontSize: size.height * 0.03),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
      ),
    );
  }
}
