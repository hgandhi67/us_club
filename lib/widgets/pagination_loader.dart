import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadMoreLoader extends StatelessWidget {
  final current;
  final total;

  const LoadMoreLoader({this.current, this.total});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: current < total,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
