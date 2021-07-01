import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';

enum LoaderPlatform { android, ios }

class NativeLoader extends StatelessWidget {
  final Color valueColor;
  final LoaderPlatform platform;

  const NativeLoader({
    Key key,
    this.valueColor: Palette.accentColor,
    this.platform,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isAndroid;

    /// null = PlatformSpecific meaning native loader will be shown
    if (platform != null) {
      if (platform == LoaderPlatform.android) {
        isAndroid = true;
      } else {
        isAndroid = false;
      }
    } else {
      isAndroid = Platform.isAndroid;
    }

    return Center(
      child: isAndroid
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Palette.accentColor),
            )
          : const CupertinoActivityIndicator(),
    );
  }
}

class APILoader extends StatelessWidget {
  const APILoader();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
        scale: .28,
        // child: Lottie.asset(ImagesLink.api_loader),
      ),
    );
  }
}
