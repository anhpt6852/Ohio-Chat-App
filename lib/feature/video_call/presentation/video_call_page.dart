import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoveView;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_chat_app/core/constant/colors.dart';
import 'package:ohio_chat_app/feature/video_call/presentation/controller/video_call_controller.dart';

class VideoCallPage extends ConsumerStatefulWidget {
  const VideoCallPage({Key? key}) : super(key: key);

  @override
  ConsumerState<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends ConsumerState<VideoCallPage> {
  bool _switch = false;
  bool _hideCallEnd = false;

  @override
  Widget build(BuildContext context) {
    var controller = ref.watch(videoControllerProvider);

    Widget _renderRemoteVideo() {
      if (ref.watch(controller.remoteUid) != 0) {
        return RtcRemoveView.SurfaceView(
            uid: ref.watch(controller.remoteUid), channelId: 'Ohio Chat App');
      } else {
        return const Text(
          'Please wait remote user join',
          textAlign: TextAlign.center,
        );
      }
    }

    Widget _renderLocalPreview() {
      if (ref.watch(controller.joined)) {
        return const RtcLocalView.SurfaceView();
      } else {
        return const Text(
          'Please join channel first',
          textAlign: TextAlign.center,
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.ink[0],
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _hideCallEnd = !_hideCallEnd;
              });
            },
            child: Center(
              child: _switch ? _renderRemoteVideo() : _renderLocalPreview(),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) =>
                FadeTransition(child: child, opacity: animation),
            child: _hideCallEnd
                ? const SizedBox.shrink()
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: (() {
                        controller.leaveChannel(context);
                      }),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.call_end,
                              size: 32,
                              color: AppColors.ink[0],
                            )),
                      ),
                    )),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: MediaQuery.of(context).size.width / 2 - 16,
              height: MediaQuery.of(context).size.height / 3,
              color: Colors.blue,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _switch = !_switch;
                  });
                },
                child: Center(
                  child: _switch ? _renderRemoteVideo() : _renderLocalPreview(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
