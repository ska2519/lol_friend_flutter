import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lol_friend_flutter/app/home/account/profile_page.dart';
import 'package:lol_friend_flutter/app/home/models/userProfile.dart';
import 'package:lol_friend_flutter/app/services/auth.dart';
import 'package:lol_friend_flutter/app/services/database.dart';
import 'package:lol_friend_flutter/app/ui/widgets/profile.dart';
import 'package:provider/provider.dart';
import 'package:lol_friend_flutter/app/repositories/searchRepository.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key, this.database}) : super(key: key);
  final DataBase database;

  @override
  _SearchPageState createState() => _SearchPageState();
}

// Persistent Tab bars by AutomaticKeepAliveClientMixin
class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  bool keepAlive = false;
  final SearchRepository _searchRepository = SearchRepository();
  UserProfile userProfile, randomProfile, user;
  int difference;

  void initState() {
    super.initState();
    //which executes a function only one time after the layout is completed
    WidgetsBinding.instance.addPostFrameCallback((_) => getUserProfile());
  }

  @override
  bool get wantKeepAlive => true;

  Future getUserProfile() async {
    final user = Provider.of<User>(context, listen: false);
    final database = Provider.of<DataBase>(context, listen: false);
    bool isNotFirstTime = await database.isNotFirstTime(user.uid);

    if (!isNotFirstTime) {
      ProfilePage.show(context, user: user, database: database);
    }
    if (isNotFirstTime) {
      print('user.uid1 : ${user.uid}');
      randomProfile = await _searchRepository.getUserProfile(user.uid);
      print('userProfile0 : $randomProfile');
      if (randomProfile == null) {
        print('userProfile Null : $randomProfile');
        return null;
      } else {
        print('userProfile1 = $randomProfile');
        setState(() {
          userProfile = randomProfile;
        });
      }
    }
  }

  Future<int> getDifference(GeoPoint userLocation) async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // ignore: await_only_futures
    double location = await distanceBetween(userLocation.latitude,
        userLocation.longitude, position.latitude, position.longitude);
    if (location < 1) {
      difference = 1;
      print('difference : $difference');
      return difference;
    } else {
      difference = location.toInt();
    }
    print('difference : $difference');
    return difference;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = Provider.of<User>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    int difference;
    print('userProfile2 = $userProfile');
    print('int difference = $difference');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        userProfile == null
            ? Container(
                padding: EdgeInsets.all(3.3),
                height: size.height * 0.75,
                child: Image.asset('assets/loading_cat.gif'),
              )
            : profileWidget(
                padding: 3.3,
                photoHeight: size.height * 0.75,
                photoUrl: userProfile.photoUrl == null
                    ? 'https://images.unsplash.com/photo-1559637621-d766677659e8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80'
                    : userProfile.photoUrl,
                clipRadius: size.height * 0.02,
                containerHeight: size.height * 0.3,
                containerWidth: size.width * 0.9,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Text(
                            userProfile.name == null
                                ? '오미드 아르민'
                                : userProfile.name,
                            style: GoogleFonts.jua(
                              textStyle:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                          ),
                        ),
                      ]),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.mapMarkerAlt,
                            color: Colors.white,
                          ),
                          Text(
                            difference != null
                                ? difference.toString() + 'km 거리에 있음'
                                : '27km 거리에 있음',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),

        //Card(child: Placeholder(fallbackHeight: size.height * 0.17)),
        SizedBox(height: size.height * 0.01),
        Container(
          height: size.height * 0.11,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Ink(
                height: size.height * 0.085,
                child: RawMaterialButton(
                  onPressed: () async => await passUser(user),
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
                  onPressed: () {},
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
                  onPressed: () => chooseUser(user),
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

  chooseUser(User user) async {
    final database = Provider.of<DataBase>(context, listen: false);
    print('database: $database');
    UserProfile currentUser = await database.getUserProfile(uid: user.uid);
    print('currentUser.photo: $currentUser');
    UserProfile nextUserProfile = await _searchRepository.chooseUser(
        user.uid,
        currentUser.name,
        currentUser.photoUrl,
        userProfile.uid,
        userProfile.name,
        userProfile.photoUrl);
    setState(() {
      userProfile = nextUserProfile;
    });
  }

  passUser(User user) async {
    UserProfile passUserProfile =
        await _searchRepository.passUser(user.uid, userProfile.uid);
    setState(() {
      userProfile = passUserProfile;
    });
  }
}
