
import 'package:cometchat_sdk/handlers/call_listener.dart';
import 'package:cometchat_sdk/models/call.dart';
import 'package:flutter/material.dart';
import 'package:vitatraq_chart/incoming_call.dart';

class CustomCallListener implements CallListener {
  final BuildContext context;

  CustomCallListener(this.context);

  @override
  void onIncomingCallReceived(Call call) {
    print('incoming call recived');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IncomingCallScreen(call: call),
      ),
    );
  }

  @override
  void onOutgoingCallAccepted(Call call) {
    // Handle outgoing call accepted
  }

  @override
  void onOutgoingCallRejected(Call call) {
    // Handle outgoing call rejected
  }

  @override
  void onIncomingCallCancelled(Call call) {
    // Handle incoming call cancelled
  }
  
  @override
  void onCallEndedMessageReceived(Call call) {
    // TODO: implement onCallEndedMessageReceived
  }
}
