import 'package:flutter/material.dart';

class Owner extends StatefulWidget {
  final String walletAddress;
  const Owner({Key? key, required this.walletAddress}) : super(key: key);

  @override
  State<Owner> createState() => _OwnerState();
}

class _OwnerState extends State<Owner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.walletAddress),
      ),
    );
  }
}
