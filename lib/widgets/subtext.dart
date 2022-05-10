import 'package:flutter/material.dart';

class SubText extends StatelessWidget {
  const SubText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
                      child: Card(
                        color: Color.fromARGB(0, 217, 217, 217),
                        elevation: 0.0,
                        child: Text('Powered by Newgen',
                            style: TextStyle(fontSize: 12,fontFamily: 'Benne'),),
                      ),
                    );
  }
}