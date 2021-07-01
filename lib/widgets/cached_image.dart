import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:us_club/generated/assets.dart';
import 'package:us_club/widgets/native_loader.dart';

final String noImageAvailable = "https://usclub.in/images/users/default.png";

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final bool isRound;
  final double radius;
  final double height;
  final double width;

  final BoxFit fit;
  final String placeholder;
  final bool showLoader;
  final Widget placeholderWidget;
  final Widget errorWidget;
  final EdgeInsets padding;

  const CachedImage(
    this.imageUrl, {
    this.isRound = true,
    this.radius = 50.0,
    this.height = 50.0,
    this.width = 50.0,
    this.fit = BoxFit.cover,
    this.placeholder = Assets.imagesImgPlaceholder,
    this.placeholderWidget,
    this.errorWidget,
    this.showLoader = false,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    try {
      return SizedBox(
        height: isRound ? radius : height,
        width: isRound ? radius : width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isRound ? radius : 0),
          child: Padding(
            padding: padding,
            child: CachedNetworkImage(
              imageUrl: imageUrl ?? "",
              fit: fit,
              placeholder: (context, url) => placeholderWidget ?? showLoader
                  ? const Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: const NativeLoader(),
                    )
                  : Container(
                      height: isRound ? radius : height,
                      width: isRound ? radius : width,
                      decoration: BoxDecoration(
                        shape: isRound ? BoxShape.circle : BoxShape.rectangle,
                        image: DecorationImage(
                          image: AssetImage(placeholder),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              errorWidget: (context, url, error) =>
                  errorWidget ??
                  Container(
                    height: isRound ? radius : height,
                    width: isRound ? radius : width,
                    decoration: BoxDecoration(
                      shape: isRound ? BoxShape.circle : BoxShape.rectangle,
                      image: DecorationImage(
                        image: AssetImage(placeholder),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            ),
          ),
        ),
      );
    } on NetworkImageLoadException catch (e) {
      return ClipOval(
        child: Image.network(
          noImageAvailable,
          height: isRound ? radius : height,
          width: isRound ? radius : width,
          fit: BoxFit.cover,
        ),
      );
    }
  }
}
