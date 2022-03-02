import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class HomePageNavigationContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MaterialButton(
          child: Icon(Ionicons.person_add_outline,
              color: Color(0xff999999), size: 22),
          onPressed: () {
            Navigator.pushNamed(context, '/useradd');
          },
        ),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: []),
    ));
  }
}
