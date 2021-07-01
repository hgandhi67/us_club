import 'package:flutter/material.dart';

class ConditionalWidget extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final bool If;

  // ignore: non_constant_identifier_names
  final Widget True;

  // ignore: non_constant_identifier_names
  final Widget False;

  const ConditionalWidget({
    Key key,
    // ignore: non_constant_identifier_names
    @required this.If,
    // ignore: non_constant_identifier_names
    @required this.True,
    // ignore: non_constant_identifier_names
    @required this.False,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (If) {
      return True ?? SizedBox();
    } else {
      return False ?? SizedBox();
    }
  }
}
