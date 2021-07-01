import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/di/export_di.dart';
import 'package:us_club/model/home/home_model.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/providers/explore_provider.dart';
import 'package:us_club/providers/home_provider.dart';
import 'package:us_club/ui/widgets/item_product.dart';
import 'package:us_club/widgets/widgets.dart';
import 'package:velocity_x/velocity_x.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen();

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  bool isLoadingVertical = false;

  AutoScrollController controller;

  AnimationController _hideFabAnimation;

  ExploreProvider _provider;

  @override
  void initState() {
    super.initState();

    controller = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical,
    );

    _hideFabAnimation = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      reverseDuration: const Duration(milliseconds: 100),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = Provider.of<HomeProvider>(context);
    _provider = Provider.of<ExploreProvider>(context);
    return Scaffold(
      body: _provider.exploreProductsList.isEmpty
          ? const NoDataFound(msg: Strings.somethingWrong2)
          : NotificationListener<ScrollNotification>(
              onNotification: _handleScrollNotification,
              child: LazyLoadScrollView(
                // key: PageStorageKey("home-screen"),
                onEndOfPage: _loadMore,
                child: ScrollConfiguration(
                  behavior: const NoGlowingBehavior(),
                  child: SingleChildScrollView(
                    controller: controller,
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        AutoScrollTag(
                          key: ValueKey(0),
                          controller: controller,
                          index: 0,
                          child: topSliderSingleItemWidget(list: provider.sliders),
                        ),
                        exploreProductsGridView(exploreProducts: _provider.exploreProductsList),
                        Visibility(
                          visible: isLoadingVertical,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: const NativeLoader(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: ScaleTransition(
        scale: _hideFabAnimation,
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          heroTag: null,
          onPressed: () async {
            _hideFabAnimation.value = 0.0;
            await controller.scrollToIndex(0, preferPosition: AutoScrollPosition.begin);
          },
          child: Icon(Icons.keyboard_arrow_up),
          backgroundColor: context.theme.primaryColor,
        ),
      ),
    );
  }

  /// Widget function which gives the list of the top slider images in the explore screen.
  /// These images are the list of the images fetch as [Offer] from the home-product apis.
  Widget topSliderSingleItemWidget({List<Sliders> list}) {
    return Visibility(
      visible: !list.isNullOrEmpty,
      child: SizedBox(
        key: const PageStorageKey("images-list"),
        height: context.mq.size.width / 1.8,
        child: ScrollConfiguration(
          behavior: const NoGlowingBehavior(),
          child: PageView.builder(
            itemCount: list.length,
            itemBuilder: (_, index) {
              return ItemExplore(list[index]);
            },
          ),
        ),
      ),
    );
  }

  // /// Widget function which gives the list of the top slider images in the explore screen.
  // /// These images are the list of the images fetch as [Offer] from the home-product apis.
  // Widget topSliderSingleItemWidget({List<Offer> list}) {
  //   return SizedBox(
  //     key: const PageStorageKey("images-list"),
  //     height: context.mq.size.width / 1.8,
  //     child: ScrollConfiguration(
  //       behavior: NoGlowingBehavior(),
  //       child: PageView.builder(
  //         itemCount: list.length,
  //         itemBuilder: (_, index) {
  //           return ItemExplore(list[index]);
  //         },
  //       ),
  //     ),
  //   );
  // }

  /// Widget function gives the [GridView] UI for the explore products.
  Widget exploreProductsGridView({List<Product> exploreProducts}) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Palette.white),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: 1 / 1.5,
        key: const PageStorageKey("explore-list"),
        physics: const NeverScrollableScrollPhysics(),
        children: exploreProducts.mapIndexed((e, i) => _itemGrid(e, i)).toList(),
      ),
    );
  }

  /// Widget function which provides the UI for the single item of the Grid of the explore products.
  Widget _itemGrid(Product product, int index) {
    return ItemProduct(
      index: index,
      id: product.proId,
      name: product.proName,
      image: product.imgLink,
      price: "${product.proPrice}",
      onTap: () {
        navigator.navigateTo(Routes.productDetails, arguments: ProductDetailsArguments(product: product));
      },
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    // showLog("notification =======>>> ${notification.metrics.pixels}");

    if (notification.metrics.pixels == 0.0) {
      _hideFabAnimation.reverse();
      return false;
    }

    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent != userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.forward();
            }
            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent != userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.reverse();
            }
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  _loadMore() async {
    final list = _provider.exploreProductsList?.size;

    showLog("end of list size =====>>> $list");
    // if (list <= 100) {
    setState(() {
      isLoadingVertical = true;
    });
    await _provider.getMoreExploreProducts("10");
    setState(() {
      isLoadingVertical = false;
    });
    // } else {
    //   showLog("all of the products are loaded");
    // }
  }

  @override
  void dispose() {
    controller.dispose();
    _hideFabAnimation.dispose();
    super.dispose();
  }
}

class ItemExplore extends StatelessWidget {
  final model;

  const ItemExplore(this.model);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.all(6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          // if (model.redirect.type == 'ssubcategory') {
          //   List<String> temp = model.redirect.id.split('-');
          //   navigator.navigateTo(
          //     Routes.searchScreen,
          //     arguments: SearchScreenArguments(query: temp[temp.length - 1]),
          //   );
          // } else {
          //   navigator.navigateTo(Routes.subCategoriesScreen,
          //       arguments: SubCategoriesScreenArguments(
          //         menuBar: null,
          //         cid: model.redirect.type == 'category' ? model.redirect.id.split('-')[0] : '',
          //         isCid: model.redirect.type == 'category',
          //         isScid: model.redirect.type == 'subcategory',
          //         scid: model.redirect.type == 'subcategory' ? model.redirect.id.split('-')[0] : '',
          //       ));
          // }
        },
        child: CachedImage(
          model.sliderImg,
          width: context.mq.size.width / 3,
          height: context.mq.size.width / 1.8,
          isRound: false,
          radius: 5,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
