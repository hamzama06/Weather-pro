import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/ic_logo.png"),
                    fit: BoxFit.fill,
                    
                  )),
          ),
        SizedBox(height: 30,),
        CircularProgressIndicator()
      ],
    );
  }
}