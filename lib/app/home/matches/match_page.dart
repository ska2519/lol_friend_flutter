import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lol_friend_flutter/app/home/message/messaging_page.dart';
import 'package:lol_friend_flutter/app/home/models/userProfile.dart';
import 'package:lol_friend_flutter/app/repositories/matchesRepository.dart';
import 'package:lol_friend_flutter/app/services/auth.dart';
import 'package:lol_friend_flutter/app/ui/widgets/profile.dart';

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
    final double itemHeight = (size.height) / 2;
    final double itemWidth = size.width / 2;
    UserProfile matchedUser, currentUser;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            title: Text(
              '매칭 유저',
              style: TextStyle(color: Colors.black, fontSize: 18.0),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: matchesRepository.getMatchedList(user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                      child: Container(
                    color: Colors.black,
                  ));
                }
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                      child: Container(color: Colors.black));
                }
                if (snapshot.data.docs != null) {
                  print(user.uid);
                  final matchedList = snapshot.data.docs;
                  //print('matchedList[0].id: ${matchedList[0].id}');

                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {
                            print('index: $index');
                            matchedUser = await matchesRepository
                                .getUserDetails(matchedList[index].id);
                            print('selectedUser: $matchedUser');
                            currentUser = await matchesRepository
                                .getUserDetails(user.uid);
                            print('currentUser: $currentUser');

                            MessagingPage.show(context,
                                currentUser: currentUser,
                                selectedUser: matchedUser);
                          },
                          child: Column(
                            children: [
                              profileWidget(
                                  photoUrl: matchedList[index].get('photoUrl'),
                                  padding: size.height * 0.01,
                                  photoWidth: size.width * 0.5,
                                  photoHeight: size.height * 0.2,
                                  containerHeight: size.height * 0.04,
                                  containerWidth: size.width * 0.5,
                                  clipRadius: size.height * 0.01),
                              Text(matchedList[index].get('name'))
                            ],
                          ),
                        );
                      },
                      childCount: matchedList.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: (itemWidth / itemHeight)),
                  );
                } else {
                  return SliverToBoxAdapter(
                    child: Container(height: 50, width: 50, color: Colors.red),
                  );
                }
              }),
          SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            title: Text(
              "메시지",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
