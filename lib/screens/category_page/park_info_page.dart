import 'package:flutter/material.dart';

class ParkInfoPage extends StatefulWidget {
  final String parkId;

  ParkInfoPage({@required this.parkId});

  @override
  _ParkInfoPageState createState() => _ParkInfoPageState();
}

class _ParkInfoPageState extends State<ParkInfoPage> {
  String _parkId;

  @override
  void initState() {
    _parkId = widget.parkId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text(_parkId)
        )
      ),
    );
  }

}