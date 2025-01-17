import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:vitatraq_chart/call_listener.dart';
import 'package:vitatraq_chart/chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<BaseMessage> _messages = [];
  String currentUserName = '';
  final String currentUserId = "cometchat-uid-6"; // Replace with sender's ID
  final String receiverUid = "cometchat-uid-1"; // Replace with receiver's ID
    String authKey = "f0fb32ecb41defeed65843fa3ba8092f9bd0d7d1";

  String userProfilePhotoUrl = '';
  bool isCompleted = false;
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    initializeCometChat();
    CometChat.addCallListener(
    'ChatScreenNew_CallListener',
    CustomCallListener(context),
  );


  CometChat.getUser(receiverUid, onSuccess: (User user){
    debugPrint("User Fetched Successfully : $user");
  }, onError: (CometChatException e){
    debugPrint("User Fetch Failed: ${e.message}");
  });

  }

  

  @override
  void dispose() {
    // CometChat.removeMessageListener("listenerId");
     CometChat.removeCallListener('ChatScreenNew_CallListener');
    super.dispose();
  }

  void initializeCometChat() {
    String region = "in";
    String appId = "2690788d14860d90";

    AppSettings appSettings = (AppSettingsBuilder()
          ..subscriptionType = CometChatSubscriptionType.allUsers
          ..region = region
          ..autoEstablishSocketConnection = true)
        .build();

    CometChat.init(appId, appSettings, onSuccess: (String successMessage) {
      print("Initialization completed successfully: $successMessage");

      loginUser();
       //createUser();
      //fetchUser();
    }, onError: (CometChatException excep) {
      print("Initialization failed with exception: ${excep.message}");
    });
  }

    void createUser() {
    User user = User(uid: currentUserId, name: "Arush");

    CometChat.createUser(user, authKey, onSuccess: (User user) {
      debugPrint("Create User successful: ${user}");
      loginUser();
    }, onError: (CometChatException e) {
      debugPrint("Create User Failed with exception: ${e.message}");
    });
  }

  void fetchUser() {
    CometChat.getUser(receiverUid, onSuccess: (User user) {
      debugPrint("User Fetched Successfully: $user");
    }, onError: (CometChatException e) {
      debugPrint("User Fetch Failed: ${e.message}");
    });
  }


  void loginUser() {
  
    CometChat.login(currentUserId, authKey, onSuccess: (User user) {
      print('user.avatar ?? ""${user.avatar ?? ""}');
      print("Login Successful: $user");
     
      currentUserName = user.name;
      userProfilePhotoUrl = user.avatar ?? "";

       isCompleted = true;
      //CometChat.addMessageListener("listenerId", this);
    }, onError: (CometChatException excep) {
      print("Login failed with exception: ${excep.message}");
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:   (isCompleted == true)  ? 
      ChatScreenNew(
              receiverUid: receiverUid, userName: currentUserName, userProfilePhotoUrl: userProfilePhotoUrl
      )
                          : Container()
      
      // body: Column(
      //   children: [
      //     TextField(
      //       controller: _controller,
      //       decoration: InputDecoration(hintText: "Enter your UID"),
      //     ),
      //     ElevatedButton(
      //       onPressed: () {
      //         if (isCompleted == true) {
      //           Navigator.pushReplacement(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (context) => ChatScreenNew(
      //                       receiverUid: receiverUid, userName: currentUserName,
      //                     )),
      //           );
      //         }
      //       },
      //       child: Text("Login"),
      //     ),
      //   ],
      // ),

    );
  }
}
