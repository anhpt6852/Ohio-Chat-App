import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoveView;
import 'package:flutter/material.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({Key? key}) : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  bool _switch = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: _switch ? _renderRemoteVideo() : _renderLocalPreview(),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: 100,
            height: 100,
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
    );
  }

  Widget _renderRemoteVideo() {
    return RtcRemoveView.SurfaceView(uid: 1, channelId: 'Ohio Chat App');
  }

  Widget _renderLocalPreview() {
    return RtcLocalView.SurfaceView();
  }
}
