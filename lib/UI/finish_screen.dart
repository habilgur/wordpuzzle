import 'package:flutter/material.dart';
import 'package:wordpuzzle/game_initialize.dart';

class FinishScreen extends StatelessWidget {
  const FinishScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (context)=>const GameInit()));
            },
            child: const Text("reload"),
          ),
        ],
      ),
    );

  }
}
