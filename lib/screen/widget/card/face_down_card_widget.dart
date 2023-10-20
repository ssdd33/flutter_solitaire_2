import 'package:flutter/material.dart';

class FaceDownCardWidget extends StatelessWidget {
  const FaceDownCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 80,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 0.7,
              blurRadius: 0.5,
              offset: Offset(-1, 1))
        ],
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(3),
        color: Colors.indigo,
      ),
      child: Padding(
          padding: EdgeInsets.all(3),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 0.5),
                borderRadius: BorderRadius.circular(2)),
          )),
    );
  }
}
