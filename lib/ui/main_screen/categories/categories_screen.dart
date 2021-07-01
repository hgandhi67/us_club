import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/di/export_di.dart';
import 'package:us_club/model/home/home_model.dart';
import 'package:us_club/providers/providers.dart';
import 'package:us_club/widgets/widgets.dart';
import 'package:velocity_x/velocity_x.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen();

  @override
  Widget build(BuildContext context) {
    return const _CategoriesListView();
  }
}

class _CategoriesListView extends StatelessWidget {
  const _CategoriesListView();

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<HomeProvider>(context).categories;

    if (categories.isNullOrEmpty) {
      return const NoDataFound(msg: Strings.somethingWrong2);
    }

    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      padding: const EdgeInsets.all(8),
      children: categories.mapIndexed((e, i) => _ItemGrid(model: e, index: i)).toList(),
    );
  }
}

class _ItemGrid extends StatelessWidget {
  final Menubar model;
  final int index;

  const _ItemGrid({this.model, this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        border: Border.all(color: context.theme.primaryColor),
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image: CachedNetworkImageProvider(model.imgLink),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        height: 25,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[600].withOpacity(0.8),
          borderRadius:
              BorderRadius.only(bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
        ),
        child: FittedBox(
          child: Texts(
            model.catName,
            color: Palette.white,
            fontFamily: semiBold,
            fontSize: 13.0,
          ),
        ),
      ),
    ).onTap(() {
      navigator.navigateTo(
        Routes.subCategoriesScreen,
        arguments: SubCategoriesScreenArguments(
          menuBar: model,
          cid: model.catId,
          isCid: true,
          isScid: false,
          scid: "",
        ),
      );
    }, hitTestBehavior: HitTestBehavior.opaque);
  }
}
