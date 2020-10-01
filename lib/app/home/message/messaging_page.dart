import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lol_friend_flutter/app/home/models/message.dart';
import 'package:lol_friend_flutter/app/home/models/userProfile.dart';
import 'package:lol_friend_flutter/app/repositories/MessagingRepository.dart';
import 'package:lol_friend_flutter/app/repositories/matchesRepository.dart';
import 'package:lol_friend_flutter/common_widgets/constants.dart';

class MessagingPage extends StatefulWidget {
  const MessagingPage({Key key, this.currentUser, this.selectedUser})
      : super(key: key);
  final UserProfile currentUser, selectedUser;

  static Future<void> show(
    BuildContext context, {
    UserProfile currentUser,
    selectedUser,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MessagingPage(
          currentUser: currentUser,
          selectedUser: selectedUser,
        ),
      ),
    );
  }

  @override
  _MessagingPageState createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  TextEditingController _messageTextController = TextEditingController();
  final MatchesRepository _matchesRepository = MatchesRepository();
  final MessagingRepository _messagingRepository = MessagingRepository();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print('photoUrl: ${widget.selectedUser.photoUrl}');

    return Scaffold(
      appBar: AppBar(
        leadingWidth: size.width * 0.33,
        leading: Builder(
          builder: (BuildContext context) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  width: size.width * 0.05,
                ),
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: size.height * 0.025,
                    backgroundImage: NetworkImage(widget.selectedUser.photoUrl),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ],
            );
          },
        ),
        titleSpacing: size.width * 0.01,
        title: Text(widget.selectedUser.name),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: size.width * 0.05),
            //color: Colors.blueAccent,
            icon: const Icon(FontAwesomeIcons.userTimes),
            iconSize: size.height * 0.025,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${widget.selectedUser.name} 님과 매치되었습니다',
                      style: TextStyle(fontSize: size.width * 0.06)),
                  Text('0일 전', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: size.height * 0.03),
                  CircleAvatar(
                    radius: size.height * 0.15,
                    backgroundImage: NetworkImage(widget.selectedUser.photoUrl),
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.white70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _messageTextController,
                    textInputAction: TextInputAction.send,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: kTextFieldDecoration.copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(FontAwesomeIcons.paperPlane),
                        onPressed: () {
                          sendMessage(
                            message: Message(
                              text: _messageTextController.text,
                              senderId: widget.currentUser.uid,
                              selectedUserId: widget.selectedUser.uid,
                              senderName: widget.currentUser.name,
                            ),
                          );
                          openFirstChat(
                              widget.currentUser.uid, widget.selectedUser.uid);
                          _messageTextController.clear();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void openFirstChat(currentUserId, selectedUserId) async {
    await _matchesRepository.openChat(
        currentUserId: currentUserId, selectedUserId: selectedUserId);
  }

  void sendMessage({Message message}) async {
    await _messagingRepository.sendMessage(
        message: Message(
            text: message.text,
            senderId: message.senderId,
            selectedUserId: message.selectedUserId,
            senderName: message.senderName));
  }
}
