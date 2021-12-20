import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DialogWithPlayers extends StatefulWidget {
  final String vimeoId;
  const DialogWithPlayers({required this.vimeoId, Key? key}) : super(key: key);

  @override
  _DialogWithPlayersState createState() => _DialogWithPlayersState();
}

class _DialogWithPlayersState extends State<DialogWithPlayers> {
  // final YoutubePlayerController _controller = YoutubePlayerController(
  //   initialVideoId: 'iLnmTe5Q2Qw',
  //   flags: const YoutubePlayerFlags(
  //     mute: true,
  //     autoPlay: false,
  //   ),
  // );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Column(
        children: const [
          Text('Vimeo'),
          // SizedBox(
          //   width: 350,
          //   height: 200,
          //   child:
          //    VimeoPlayer(
          //     id: '577635596',
          //     //allowFullScreen: true,
          //   ),
          // ),
          // const Text('Youtube'),
          // SizedBox(
          //   height: 200,
          //   width: 350,
          //   child: YoutubePlayerBuilder(
          //     builder: (context, player) {
          //       return player;
          //     },
          //     player: YoutubePlayer(
          //       controller: _controller,
          //       //width: MediaQuery.of(context).size.width,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
