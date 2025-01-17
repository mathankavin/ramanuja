import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

class UserDetails extends StatelessWidget {
  final User user;  // Define your user variable

  UserDetails({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CometChatDetails(
          user: user,
        ),
      ),
    );
  }
}
