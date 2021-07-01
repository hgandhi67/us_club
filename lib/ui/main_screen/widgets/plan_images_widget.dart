import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/widgets/widgets.dart';
import 'package:velocity_x/velocity_x.dart';

class PlainImagesListView extends StatelessWidget {

  final List<dynamic> list;

  const PlainImagesListView({this.list});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: PageStorageKey("images-list"),
      height: context.mq.size.width / 1.8,
      child: ScrollConfiguration(
        behavior: NoGlowingBehavior(),
        child: ListView.separated(
          itemCount: list.length,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          separatorBuilder: (_, index) {
            return const Spacers(width: 0);
          },
          itemBuilder: (_, index) {
            return Card(
              elevation: 5.0,
              color: Palette.white,
              margin: const EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: CachedImage(
                  dummyList[index].image,
                  width: context.mq.size.width / 3,
                  fit: BoxFit.cover,
                  isRound: false,
                  radius: 0,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
