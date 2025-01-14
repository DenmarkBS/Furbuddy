import 'package:flutter/material.dart';
import 'package:tinder_new/data/db/entity/app_user.dart';
import 'package:tinder_new/data/db/entity/chat.dart';
import 'package:tinder_new/data/db/entity/message.dart';
import 'package:tinder_new/data/db/remote/firebase_database_source.dart';
import 'package:tinder_new/ui/widgets/chat_top_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tinder_new/ui/widgets/message_bubble.dart';
import 'package:tinder_new/util/constants.dart';

class ChatScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();
  final messageTextController = TextEditingController();

  static const String id = 'chat_screen';

  final String chatId;
  final String myUserId;
  final String otherUserId;

  ChatScreen({super.key, required this.chatId, required this.myUserId, required this.otherUserId});

  void checkAndUpdateLastMessageSeen(Message lastMessage, String messageId, String myUserId) {
    if (lastMessage.seen == false && lastMessage.senderId != myUserId) {
      lastMessage.seen = true;
      Chat updatedChat = Chat(chatId, lastMessage);

      _databaseSource.updateChat(updatedChat);
      _databaseSource.updateMessage(chatId, messageId, lastMessage);
    }
  }

  bool shouldShowTime(Message currMessage, Message? messageBefore) {
    int halfHourInMilli = 1800000;

    if (messageBefore != null) {
      if ((messageBefore.epochTimeMs - currMessage.epochTimeMs).abs() > halfHourInMilli) {
        return true;
      }
    }
    return messageBefore == null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: StreamBuilder<DocumentSnapshot>(
                stream: _databaseSource.observeUser(otherUserId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return ChatTopBar(user: AppUser.fromSnapshot(snapshot.data!));
                })),
        body: Column(children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: _databaseSource.observeMessages(chatId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    List<Message> messages = [];
                    for (var element in snapshot.data!.docs) {
                      messages.add(Message.fromSnapshot(element));
                    }
                    if (snapshot.data!.docs.isNotEmpty) {
                      checkAndUpdateLastMessageSeen(messages.first, snapshot.data!.docs[0].id, myUserId);
                    }
                    if (_scrollController.hasClients) {
                      _scrollController.jumpTo(0.0);
                    }

                    // List<bool> showTimeList = [];
                    // for (int i = messages.length - 1; i >= 0; i--) {
                    //   bool shouldShow = i == (messages.length - 1)
                    //       ? true
                    //       : shouldShowTime(messages[i], messages[i + 1]);
                    //   showTimeList[i] = shouldShow;
                    List<bool> showTimeList = List<bool>.generate(messages.length, (i) => i == (messages.length - 1)  || shouldShowTime(messages[i], messages[i + 1]));

                    return ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final item = messages[index];
                        return ListTile(
                          title: MessageBubble(
                              epochTimeMs: item.epochTimeMs,
                              text: item.text,
                              isSenderMyUser: messages[index].senderId == myUserId,
                              includeTime: showTimeList[index]),
                        );
                      },
                    );
                  })),
          getBottomContainer(context, myUserId)
        ]));
  }

  void sendMessage(String myUserId) {
    if (messageTextController.text.isEmpty) return;

    Message message = Message(DateTime.now().millisecondsSinceEpoch, false, myUserId, messageTextController.text);
    Chat updatedChat = Chat(chatId, message);
    _databaseSource.addMessage(chatId, message);
    _databaseSource.updateChat(updatedChat);
    messageTextController.clear();
  }
  Widget getBottomContainer(BuildContext context, String myUserId) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjust vertical padding
      child: Material( // Use Material to apply elevation and rounded corners
        elevation: 4, // Add elevation for a modern look
        borderRadius: BorderRadius.circular(16), // Apply rounded corners
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: kSecondaryColor.withOpacity(0.5)), // Add border
            borderRadius: BorderRadius.circular(16), // Match the borderRadius of Material
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0), // Adjust horizontal padding
            child: Row(
              children: [
                Expanded(
                  child: Container( // Wrap TextField in Container for height adjustment
                    height: 48, // Increase the height of the TextField
                    child: TextField(
                      controller: messageTextController,
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(color: kSecondaryColor),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: kSecondaryColor.withOpacity(0.5)), // Add hint text style
                        border: InputBorder.none, // Remove border
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8), // Adjust content padding
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8), // Add spacing between TextField and Button
                Material(
                  borderRadius: BorderRadius.circular(8), // Apply rounded corners to the button
                  color: Colors.orange, // Use orange color for button background
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8), // Match the borderRadius of Material
                    onTap: () {
                      sendMessage(myUserId);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0), // Adjust button padding
                      child: Icon(
                        Icons.send,
                        color: Colors.white, // Use white color for icon
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



}
