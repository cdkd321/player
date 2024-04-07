import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'player.dart';

enum PlayFit {
  contain,
  cover,
  fitWidth,
  fitHeight,
  ar4_3,
  ar16_9
}

class VideoView extends StatefulWidget {
  var player = Player();
  final String playUrl;
  final bool showRecover;
  var fit;
  var showPlayInfo;

  VideoView({required this.playUrl, required this.showRecover, this.showPlayInfo = false, this.fit = PlayFit.contain});

  @override
  State<StatefulWidget> createState() {
    return VideoViewState();
  }
}

class VideoViewState extends State<VideoView> {
  int showTime = 0;

  @override
  void dispose() {
    widget.player.stop();
    widget.player.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var finalUrl = widget.playUrl;
    if (widget.playUrl.startsWith('assets')) {
      finalUrl = "asset:///${widget.playUrl}";
    }
    widget.player.setDataSource(finalUrl, autoPlay: true, showCover: widget.showRecover);
    widget.player.setLoop(0);
    var realFit = getRealFit(widget.fit);
    return Scaffold(
        body: GestureDetector(
      onTap: onTap,
      child: Stack(children: [
        AbsorbPointer(absorbing: true, child: FijkView(player: widget.player, fit: realFit,)),
            if (widget.player.state == FijkState.paused)
              const Align(
              alignment: Alignment.center,
              child: Icon(Icons.play_arrow_outlined, size: 50, color: Colors.white)),
        if (widget.showPlayInfo)
          Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              children:[
              Icon(Icons.play_arrow_outlined, size: 15, color: Colors.white),
              Text('223', style: TextStyle(color: Colors.white, fontSize: 13),)
            ]),
        ),
      ]),
    ));
  }

  void onTap() {
    if (widget.player.state == FijkState.started) {
      widget.player.pause();
    } else {
      widget.player.start();
    }
    setState(() {showTime = 0;});
  }

  FijkFit getRealFit(fit) {
    switch(fit) {
      case PlayFit.contain:
        return FijkFit.contain;
      case PlayFit.cover:
        return FijkFit.cover;
      case PlayFit.fitWidth:
        return FijkFit.fitWidth;
      case PlayFit.fitHeight:
        return FijkFit.fitHeight;
      case PlayFit.ar4_3:
        return FijkFit.ar4_3;
      case PlayFit.ar16_9:
        return FijkFit.ar16_9;
      default:
        return FijkFit.contain;
        break;
    }

  }
}
