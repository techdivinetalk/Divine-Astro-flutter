import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';

class AudioPlayerScreen extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerScreen({required this.audioUrl});

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      await _audioPlayer.setUrl(widget.audioUrl);
    } catch (e) {
      print('Error initializing audio player: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<PlayerState>(
              stream: _audioPlayer.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                return IconButton(
                  icon: Icon(
                    playerState?.playing ?? false
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  iconSize: 64.0,
                  onPressed: () {
                    if (playerState?.playing ?? false) {
                      _audioPlayer.pause();
                    } else {
                      _audioPlayer.play();
                    }
                  },
                );
              },
            ),
            StreamBuilder(
              stream: _audioPlayer.durationStream,
              builder: (context, snapshot) {
                final duration = snapshot.data ?? Duration.zero;
                return StreamBuilder<Duration>(
                  stream: _audioPlayer.positionStream,
                  builder: (context, snapshot) {
                    var position = snapshot.data ?? Duration.zero;
                    if (position > duration) {
                      position = duration;
                    }
                    return Slider(
                      value: position.inSeconds.toDouble(),
                      min: 0.0,
                      max: duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        _audioPlayer.seek(Duration(seconds: value.toInt()));
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}