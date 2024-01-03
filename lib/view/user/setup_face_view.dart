import 'package:flutter/material.dart';

class SetupFaceView extends StatelessWidget {
  const SetupFaceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: ElevatedButton(onPressed: (){

      }, child: Text("add")),
      ),
    );
  }
}
