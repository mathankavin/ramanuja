import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:cometchat_sdk/cometchat_sdk.dart';
import 'package:vitatraq_chart/UserDetail.dart';
import 'package:permission_handler/permission_handler.dart';
class ChatScreenNew extends StatefulWidget {
  final String receiverUid;
  final String userName;
  final  String userProfilePhotoUrl;
  const ChatScreenNew({super.key, required this.receiverUid, required this.userName, required this.userProfilePhotoUrl});

  @override
  ChatScreenNewState createState() => ChatScreenNewState();
}

class ChatScreenNewState extends State<ChatScreenNew>
    implements MessageListener {
      final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Key _key = UniqueKey(); // Key to trigger rebuild
List<BaseMessage> _messages = [];
late User user;
  @override
  void initState() {
    super.initState();
    requestPermissions();
    CometChat.addMessageListener("listenerId", this);
    user = User(
      name: widget.userName,
      uid: widget.receiverUid,
    );
  }
void requestPermissions() async {
  var status = await Permission.microphone.request();
  if (status.isGranted) {
    print("Microphone permission granted");
  } else {
    print("Microphone permission denied");
  }

  var storageStatus = await Permission.storage.request();
  if (storageStatus.isGranted) {
    print("Storage permission granted");
  } else {
    print("Storage permission denied");
  }
}

  void sendMessage(TextMessage message) {
    CometChat.sendMessage(
      message,
      onSuccess: (TextMessage sentMessage) {
        print("Message sent successfully: ${sentMessage.text}");
        refreshMessageList(); // Call the refresh method after sending a message
      
      },
      onError: (CometChatException excep) {
        print("Message sending failed with error: $excep");
      },
    ).catchError((error) {
      print("Message sending failed with error: $error");
    });
  }
  @override
  void dispose() {
    CometChat.removeMessageListener("listenerId");
    super.dispose();
  }

  void refreshMessageList() {
    setState(() {
      //_key = UniqueKey();
      user = User(
      name: widget.userName,
      uid: widget.receiverUid,
    ); 
    });
  }

 
PreferredSizeWidget customMessageHeader(User? user, Group? group, BuildContext context) {
  print('widget.userProfilePhotoUrl${widget.userProfilePhotoUrl}');
  return AppBar(
    title: Text(user != null ? user.name : group?.name ?? 'Chat'),
    automaticallyImplyLeading: false, // Hides the back button
    leading: GestureDetector( onTap: () { Navigator.push( context, MaterialPageRoute( builder: (context) => UserDetails(user: user!), ), ); },
    child: user != null || user?.avatar != null 
        ? CircleAvatar(
          radius: 12.5,
            backgroundImage: NetworkImage(widget.userProfilePhotoUrl), // Load the profile photo
            backgroundColor: Colors.transparent, // If you want to change the background color
          )
        : CircleAvatar( radius: 12.5, child: Icon(Icons.person),), // Default icon if there's no avatar ),// Default icon if there's no avatar
    ),
  );
}


  Widget customMessageListView(User? user, Group? group, BuildContext context) {
    return ListView.builder(
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return ListTile(
          title: Text(message.sender?.name ?? ""),
         // subtitle: Text(message),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      body: CometChatMessages(
       // hideMessageComposer: false,
       // hideDetails: false,
      key: _key, // Assign the unique key here
      messageListConfiguration: MessageListConfiguration( 

       ), // Pass the custom message list here ),
        user: user,
          messageHeaderView: customMessageHeader,
       // messageListView: customMessageListView, 
            messageComposerConfiguration: MessageComposerConfiguration(
          onSendButtonTap: (BuildContext context, BaseMessage message,
              PreviewMessageMode? mode) {
            if (message is TextMessage) {
              print('Message sent: ${message.text}');
              sendMessage(TextMessage(
                receiverUid: widget.receiverUid,
                text: message.text,
                receiverType: 'user',
                type: 'text',
              ));
            } else {
              print(
                  'Message sent: ${message.id}'); // Handle other message types here
            }
          },
        ),
      ),
    );
  }

  @override
  void onTextMessageReceived(TextMessage textMessage) {
    refreshMessageList();
    //  setState(() {
    //   _messages.add(textMessage); // Update the message list directly
    // });
    user = User(
      name: widget.userName,
      uid: widget.receiverUid,
    );
  }

  @override
  void onMediaMessageReceived(MediaMessage mediaMessage) {
    refreshMessageList();
    //  setState(() {
    //   _messages.add(mediaMessage); // Update the message list directly
    // });
    user = User(
      name: widget.userName,
      uid: widget.receiverUid,
    );
  }

  @override
  void onCustomMessageReceived(CustomMessage customMessage) {
    // TODO: implement onCustomMessageReceived
  }

  @override
  void onInteractionGoalCompleted(InteractionReceipt receipt) {
    // TODO: implement onInteractionGoalCompleted
  }

  @override
  void onInteractiveMessageReceived(InteractiveMessage message) {
    // TODO: implement onInteractiveMessageReceived
  }

  @override
  void onMessageDeleted(BaseMessage message) {
    // TODO: implement onMessageDeleted
  }

  @override
  void onMessageEdited(BaseMessage message) {
    // TODO: implement onMessageEdited
  }

  @override
  void onMessageReactionAdded(ReactionEvent reactionEvent) {
    // TODO: implement onMessageReactionAdded
  }

  @override
  void onMessageReactionRemoved(ReactionEvent reactionEvent) {
    // TODO: implement onMessageReactionRemoved
  }

  @override
  void onMessagesDelivered(MessageReceipt messageReceipt) {
    // TODO: implement onMessagesDelivered
  }

  @override
  void onMessagesDeliveredToAll(MessageReceipt messageReceipt) {
    // TODO: implement onMessagesDeliveredToAll
  }

  @override
  void onMessagesRead(MessageReceipt messageReceipt) {
    // TODO: implement onMessagesRead
  }

  @override
  void onMessagesReadByAll(MessageReceipt messageReceipt) {
    // TODO: implement onMessagesReadByAll
  }

  @override
  void onTransientMessageReceived(TransientMessage message) {
    // TODO: implement onTransientMessageReceived
  }

  @override
  void onTypingEnded(TypingIndicator typingIndicator) {
    // TODO: implement onTypingEnded
  }

  @override
  void onTypingStarted(TypingIndicator typingIndicator) {
    // TODO: implement onTypingStarted
  }
}
  