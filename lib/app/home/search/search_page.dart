import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lol_friend_flutter/app/home/models/user.dart';
import 'package:lol_friend_flutter/app/ui/widgets/profile.dart';
import 'package:lol_friend_flutter/app/ui/widgets/userGender.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  User _user, _currentUser;
  int difference;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      
      children: [
        profileWidget(
            padding: size.height * 0.005,
            photoHeight: size.height * 0.59,
            photoWidth: size.width * 0.99,
            photo: _user != null ? _user.photo : 'https://cdn.pixabay.com/photo/2015/01/15/12/44/model-600222_960_720.jpg',
            clipRadius: size.height * 0.02,
            containerHeight: size.height * 0.3,
            containerWidth: size.width * 0.9,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
        SizedBox(
          height: size.height * 0.06,
        ),
        Row(
          children: <Widget>[
            userGender(_user != null ?_user.gender : 'Female'),
            Expanded(
              child: Text(
                " " +
                    '_user.name' +
                    ", ",
                    
                style: TextStyle(
                    color: Colors.white,
                    fontSize: size.height * 0.05),
              ),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Icon(
              Icons.location_on,
              color: Colors.white,
            ),
            Text(
              difference != null
                  ? (difference / 1000).floor().toString() +
                      "km away"
                  : "away",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        SizedBox(
          height: size.height * 0.05,
        ),
        
                ],
              ),
            ),
        ),
        Card(
          child:
          Column(
            children: [
              Placeholder(fallbackHeight: size.height * 0.17)
            ],
          ),
        ),
        Container(
          height: size.height * 0.11,
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Ink(
              height: size.height * 0.085,
              child: RawMaterialButton(
                onPressed: (){},
              elevation: 2.0,
              fillColor: Colors.white,
              shape: CircleBorder(),
              child: Icon(
                FontAwesomeIcons.times,
                color: Color(0xFFFE3C72),
                size: size.height * 0.05,
                ),
              ),
            ),
            Ink(
              height: 50,
              child: RawMaterialButton(
                onPressed: (){},
              elevation: 2.0,
              fillColor: Colors.white,
              shape: CircleBorder(),
              child: Icon(
                FontAwesomeIcons.solidStar,
                color: Color(0xFF0091EA),
                size: size.height * 0.035,
                ),
              ),
            ),
            Ink(
              height: size.height * 0.085,
              child: RawMaterialButton(
                onPressed: (){},
              elevation: 2.0,
              fillColor: Colors.white,
              shape: CircleBorder(),
              child: Icon(
                FontAwesomeIcons.solidHeart,
                color: Color(0xFF84F0D5),
                size: size.height * 0.045,
                ),
              ),
            ),

          ],
            ),
        ),
      ],
    );
  }
}