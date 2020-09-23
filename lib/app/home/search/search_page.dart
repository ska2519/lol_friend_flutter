import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol_friend_flutter/app/home/models/userProfile.dart';
import 'package:lol_friend_flutter/app/services/auth.dart';
import 'package:lol_friend_flutter/app/services/database.dart';
import 'package:lol_friend_flutter/app/ui/widgets/profile.dart';
import 'package:provider/provider.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({Key key, this.database}) : super(key: key);
  final DataBase database;
  


  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  UserProfile userProfile, user;
  bool _isLoading = false;
  
  //which executes a function only one time after the layout is completed
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => getUserProfile());
  }

  void getUserProfile() async {
    final database = Provider.of<DataBase>(context, listen: false);
    final user = Provider.of<User>(context, listen: false);
    
    userProfile = await database.getUserProfile(user.uid);
    setState(() {
      _isLoading = true;
    });
  }
  @override
  Widget build(BuildContext context)  {
    //final userProfile = Provider.of<UserProfile>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    int difference;    
    print('userProfile = $userProfile');

        return 
        _isLoading ?
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

                profileWidget(
                padding: 3.3,
                photoHeight: size.height * 0.77,
                photo: userProfile.photo != null ? userProfile.photo : 'https://images.unsplash.com/photo-1559637621-d766677659e8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
                clipRadius: size.height * 0.02,
                containerHeight: size.height * 0.3,
                containerWidth: size.width * 0.9,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children:[
                          Expanded(
                            child: Text(
                              userProfile.name != null ? userProfile.name :
                               '오미드 아르민',
                                style: GoogleFonts.jua(
                                  textStyle:TextStyle(
                                    color: Colors.white,
                                    fontSize: 30
                                  ),
                                ),
                            ),
                          ),
                        ]      
                      ),  
                      
                      Row(
                        children:[
                          Icon(
                            FontAwesomeIcons.mapMarkerAlt,
                            color: Colors.white,
                          ),
                          Text(
                            difference != null
                                ? (difference / 1000).floor().toString() + 'km 거리에 있음'
                                : '27km 거리에 있음',
                            style: GoogleFonts.jua(
                                  textStyle:TextStyle(
                                    color: Colors.white,
                                    fontSize: 17
                                    ),
                                ),
                          )
                        ],
                      ),
                      SizedBox(height: size.height * 0.01), 
                    ],
                  ),
                ),
            ),
            //Card(child: Placeholder(fallbackHeight: size.height * 0.17)),
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
                    onPressed: (){
                      selectUser();
                    },
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
        )
        :
        Container();
        
}

  void selectUser() {}
}