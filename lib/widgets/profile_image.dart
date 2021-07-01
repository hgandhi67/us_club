import 'dart:io';

import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/generated/assets.dart';
import 'package:us_club/widgets/widgets.dart';

class ProfileImage extends StatelessWidget {
  final onTap;
  final imageFile;
  final imageUrl;
  final width;
  final height;
  final isRound;
  final bool useCachedImage;
  final BoxFit fit;

  const ProfileImage({
    Key key,
    this.onTap,
    this.imageFile,
    this.width,
    this.height,
    this.imageUrl,
    this.isRound: true,
    this.useCachedImage = true,
    this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String url = imageUrl;

    // if (imageFile == null) {
    //   url = imageUrl;
    //   final end1 = url.toString().substring(url.lastIndexOf('/') + 1);
    //   final end2 = sharedPref.getString(Constants.NAME)?.removeSpaces()?.trim()?.toLowerCase();
    //
    //   showLog("end1 =======>>> $end1");
    //   showLog("end2 =======>>> $end2");
    //
    //   if (!end2.isEmptyORNull) {
    //     if (end1.removeSpaces().isEmptyORNull || end1 == "$end2.jpg") {
    //       url = noImageAvailable;
    //     }
    //   }
    //   showLog("url =======>>> $url");
    // }
    return SizedBox(
      width: width.toDouble(),
      height: height.toDouble(),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            imageUrl != null && imageUrl != "" && (imageFile == null || imageFile == "")
                ? useCachedImage
                    ? CachedImage(
                        url,
                        radius: width.toDouble() ?? 100,
                        width: width,
                        height: height,
                        isRound: isRound,
                        fit: fit,
                      )
                    : ClipOval(
                        child: Container(
                          width: width,
                          height: height,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(Assets.imagesDefault),
                            ),
                          ),
                          child: Image.network(
                            url,
                            width: width,
                            height: height,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                : imageFile == null
                    ? Image.asset(
                        Assets.imagesDefault,
                        width: width.toDouble() ?? 100,
                        height: height.toDouble() ?? 100,
                        fit: BoxFit.cover,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(width.toDouble()),
                        child: Image.file(
                          File(imageFile),
                          width: width.toDouble() ?? 100,
                          height: height.toDouble() ?? 100,
                          fit: BoxFit.cover,
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
