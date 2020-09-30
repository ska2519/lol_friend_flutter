import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lol_friend_flutter/app/home/message/messaging.dart';
import 'package:lol_friend_flutter/app/home/models/userProfile.dart';
import 'package:lol_friend_flutter/app/repositories/matchesRepository.dart';
import 'package:lol_friend_flutter/app/services/auth.dart';
import 'package:lol_friend_flutter/app/ui/widgets/iconWidget.dart';
import 'package:lol_friend_flutter/app/ui/widgets/pageTurn.dart';
import 'package:lol_friend_flutter/app/ui/widgets/profile.dart';
import 'package:lol_friend_flutter/app/ui/widgets/userGender.dart';
import 'package:provider/provider.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({Key key, this.uid}) : super(key: key);
  final String uid;

  
    @override
    _MatchPageState createState() => _MatchPageState();
}



class _MatchPageState extends State<MatchPage> {
  MatchesRepository matchesRepository = MatchesRepository();
  int difference;
  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final user = Provider.of<User>(context, listen: false);
    UserProfile matchedUser,currentUser;
    
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.white,
          title: Text('Matched User',
            style: TextStyle(color: Colors.black, fontSize: 30.0),),
        ),
        
        StreamBuilder<QuerySnapshot>(
          stream: matchesRepository.getMatchedList(user.uid),
          builder: (context, snapshot) {
            if(snapshot.hasError){
              return SliverToBoxAdapter(child: Container(color: Colors.black,));
            }
            if(!snapshot.hasData){
              return  SliverToBoxAdapter(
                child: Container(color: Colors.black));
            }
            if (snapshot.data.docs != null) {
              print(user.uid);
              final matchedList = snapshot.data.docs;
              //print('matchedList[0].id: ${matchedList[0].id}');

              return SliverGrid(
                
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index){
                    return GestureDetector(
                    onTap: () async {
                      
                      print('index: $index');
                      matchedUser = 
                        await matchesRepository.getUserDetails(matchedList[index].id);
                        print('selectedUser: $matchedUser');
                      currentUser =
                        await matchesRepository.getUserDetails(user.uid);
                        print('currentUser: $currentUser');
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                          backgroundColor: Colors.black,
                          child: profileWidget(
                            photoUrl: matchedUser.photo,
                            padding: size.height * 0.01,
                            photoHeight: size.height ,
                            photoWidth: size.width,
                            containerHeight: size.height* 0.02,
                            containerWidth: size.width ,
                            clipRadius: size.height * 0.01,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.height * 0.02),
                              child: ListView(
                                children: [
                                  SizedBox(height: size.height * 0.02),
                                  Row(
                                    children: [
                                      userGender(matchedUser.gender),
                                      Expanded(
                                        child: Text(
                                          " " +
                                              matchedUser.name +
                                              ", " +
                                              (DateTime.now().year - matchedUser.age.toDate().year).toString(),
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: size.height * 0.1),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        difference != null
                                            ? (difference / 1000).floor().toString() +
                                                " km away"
                                            : "away",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(size.height * 0.02),
                                        child: iconWidget(Icons.message, () {
                                          pageTurn(
                                            Messaging(
                                                currentUser: currentUser,
                                                selectedUser: matchedUser),
                                            context);
                                        }, size.height * 0.04, Colors.white),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: profileWidget(
                          padding: size.height * 0.01,
                          photoUrl: matchedList[index].get('photoUrl'), 
                          photoWidth: size.width * 0.5,
                          photoHeight: size.height * 0.3,
                          clipRadius: size.height * 0.01,
                          containerHeight: size.height * 0.03,
                          containerWidth: size.width * 0.5,
                          // child: Text(
                          //   "  " + matchedList[index].get('name'),
                          //   style: TextStyle(color: Colors.white),
                          // ),
                        ),
                      );
                    },
                    childCount: matchedList.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              );
            } else{
              return SliverToBoxAdapter(
                      child: Container(color: Colors.red),
              );
            }
          }
        ),
        SliverAppBar(
          backgroundColor: Colors.white,
          pinned: true,
          title: Text(
            "Someone Likes You",
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
        ),
      ],
    );
  }
}