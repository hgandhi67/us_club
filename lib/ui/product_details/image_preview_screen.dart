import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/widgets/widgets.dart';
import 'package:velocity_x/velocity_x.dart';

class ImagePreviewScreen extends StatefulWidget {
  final List<Media> imagesList;
  final int index;
  final String tag;

  const ImagePreviewScreen({this.imagesList, this.index, this.tag});

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  var controller = PageController();

  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.index.toInt() + 1;
    controller = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: controller,
              physics: const BouncingScrollPhysics(),
              children: widget.imagesList
                  .map(
                    (e) => PhotoView(
                      imageProvider: CachedNetworkImageProvider(e.url),
                      initialScale: PhotoViewComputedScale.contained * 0.8,
                      minScale: PhotoViewComputedScale.contained * 0.8,
                      heroAttributes: PhotoViewHeroAttributes(tag: e.url),
                      backgroundDecoration: BoxDecoration(color: Colors.white),
                      gestureDetectorBehavior: HitTestBehavior.opaque,
                    ),
                  )
                  .toList(),
              onPageChanged: (newPage) {
                setState(() {
                  _currentIndex = ++newPage;
                });
              },
            ),
            Positioned(
              bottom: 10,
              right: 20,
              child: Texts(
                "$_currentIndex/${widget.imagesList.length}",
                color: context.theme.textSelectionColor,
                fontSize: 16,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: context.theme.accentColor,
                  size: 35,
                ),
                onPressed: () => Navigator.of(context).pop(),
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: kToolbarHeight,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: widget.imagesList
              .mapIndexed(
                (e, index) => GestureDetector(
                  onTap: () {
                    controller.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: CachedImage(
                    e.url,
                    isRound: false,
                    width: (screenWidth / 8),
                    height: kToolbarHeight,
                    radius: 0.0,
                    fit: BoxFit.contain,
                    // padding: const EdgeInsets.all(1),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
