import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/constant/agora_contants.dart';
import 'package:permission_handler/permission_handler.dart';

final videoControllerProvider = Provider.autoDispose((ref) {
  return VideoCallController(ref);
});

class VideoCallController {
  final ProviderRef ref;

  VideoCallController(this.ref);

  var joined = StateProvider.autoDispose<bool>((ref) {
    return false;
  });

  var remoteUid = StateProvider.autoDispose<int>((ref) {
    return 0;
  });

  RtcEngineContext contextEng = RtcEngineContext(APP_ID);

  leaveChannel(context) async {
    var engine = await RtcEngine.createWithContext(contextEng);

    await engine.leaveChannel();
    Navigator.of(context).pop();
  }

  Future<void> initPlatformState() async {
    await [Permission.camera, Permission.microphone].request();

    //Create RTC

    var engine = await RtcEngine.createWithContext(contextEng);

    //Define event handling logic
    engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        print('joinChannelSuccess $channel - $uid');
        ref.read(joined.state).state = true;
      },
      userJoined: (int uid, int elapsed) {
        ref.read(remoteUid.state).state = uid;
        print('userJoined $uid');
      },
      userOffline: (int uid, UserOfflineReason reason) {
        ref.read(remoteUid.state).state = 0;
        print('userOffline $uid');
      },
    ));

    await engine.enableVideo();

    await engine.joinChannel(TOKEN, 'Ohio Chat App', null, 0);
  }
}
