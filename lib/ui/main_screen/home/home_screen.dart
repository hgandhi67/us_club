import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/base/strings.dart';
import 'package:us_club/di/export_di.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/providers/home_provider.dart';
import 'package:us_club/providers/providers.dart';
import 'package:us_club/ui/widgets/item_product.dart';
import 'package:us_club/widgets/widgets.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  bool isLoadingVertical = false;

  AutoScrollController controller;

  AnimationController _hideFabAnimation;
  AnimationController _controller;
  Animation<Offset> _animation;

  HomeProvider _provider;

  bool _isVisible = true;

  @override
  void initState() {
    super.initState();

    controller = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical,
    )..addListener(() {
        if (controller.position.userScrollDirection == ScrollDirection.reverse) {
          if (_isVisible)
            setState(() {
              _isVisible = false;
            });
        }
        if (controller.position.userScrollDirection == ScrollDirection.forward) {
          if (!_isVisible)
            setState(() {
              _isVisible = true;
            });
        }
      });

    _hideFabAnimation = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      reverseDuration: const Duration(milliseconds: 100),
    );

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
    _animation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: const Offset(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    ));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _provider = Provider.of<HomeProvider>(context);

    // showLog("HomeScreen build =====>>>> ${provider.randomProducts}");

    return Scaffold(
      body: _provider.isBusy
          ? const NativeLoader()
          : LayoutBuilder(
              builder: (context, constraints) {
                return _provider.randomProducts == null
                    ? const NoDataFound(msg: Strings.somethingWrong2)
                    : Column(
                        children: [
                          AnimatedContainer(
                            width: double.infinity,
                            duration: Duration(milliseconds: 500),
                            height: _isVisible ? 100.0 : 0.0,
                            curve: Curves.easeInQuad,
                            child: AutoScrollTag(
                              key: ValueKey(0),
                              controller: controller,
                              index: 0,
                              child: const _CategoriesListView(),
                            ),
                          ),
                          Expanded(
                            child: NotificationListener<ScrollNotification>(
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
                                        const _ImagesListView(),
                                        const _MainListView(),
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
                          ),
                        ],
                      );
              },
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
    final list = _provider.randomProducts?.size;

    // showLog("end of list size =====>>> $list");
    if (list <= 50) {
      setState(() {
        isLoadingVertical = true;
      });
      await _provider.getRandomProducts("10");
      setState(() {
        isLoadingVertical = false;
      });
    } else {
      showLog("all of the products are loaded");
    }
  }

  @override
  void dispose() {
    controller.dispose();
    _hideFabAnimation.dispose();
    super.dispose();
  }
}

class _CategoriesListView extends StatelessWidget {
  const _CategoriesListView();

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<HomeProvider>(context).categories;

    // showLog("_CategoriesListView build ");

    return Container(
      key: PageStorageKey("categories"),
      decoration: BoxDecoration(
        color: Palette.white,
      ),
      // margin: EdgeInsets.only(top: 10),
      child: !categories.isNullOrEmpty
          ? ScrollConfiguration(
              behavior: const NoGlowingBehavior(),
              child: ListView.separated(
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 5),
                separatorBuilder: (_, index) {
                  return const Spacers(width: 8);
                },
                itemBuilder: (_, index) {
                  final item = categories[index];

                  return _ItemCategories(model: item);
                },
              ),
            )
          : categories.isNull
              ? NoDataFound(msg: "No categories found")
              : const NativeLoader(),
    );
  }
}

class _ItemCategories extends StatelessWidget {
  final Menubar model;

  const _ItemCategories({this.model});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constrains) {
        // showLog("constrains =======>>> ${constrains.maxHeight}");
        return GestureDetector(
          onTap: () => navigator.navigateTo(
            Routes.subCategoriesScreen,
            arguments: SubCategoriesScreenArguments(
              menuBar: model,
              cid: model.catId,
              isCid: true,
              isScid: false,
              scid: "",
            ),
          ),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: 65,
                  height: constrains.maxHeight * 0.70,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(model.imgLink),
                      // fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Texts(
                model.catName,
                color: context.theme.accentColor,
                fontFamily: bold,
                fontSize: constrains.maxHeight * 0.13,
              ),
              SizedBox(height: constrains.maxHeight * 0.05),
            ],
          ),
        );
      },
    );
  }
}

class _ImagesListView extends StatelessWidget {
  const _ImagesListView();

  @override
  Widget build(BuildContext context) {
    final offers = Provider.of<HomeProvider>(context).offers;

    // showLog("_ImagesListView build ");

    return SizedBox(
      key: PageStorageKey("images-list"),
      height: context.mq.size.width / 1.8,
      child: !offers.isNullOrEmpty
          ? ScrollConfiguration(
              behavior: NoGlowingBehavior(),
              child: ListView.separated(
                itemCount: offers.length,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 5, top: 8, bottom: 8),
                separatorBuilder: (_, index) {
                  return const Spacers(width: 8);
                },
                itemBuilder: (_, index) {
                  final item = offers[index];

                  return GestureDetector(
                    onTap: () {
                      showLog("item =======>>> ${item.toJson()}");

                      if (item.redirect.type == 'ssubcategory') {
                        List<String> temp = item.redirect.id.split('-');
                        navigator.navigateTo(
                          Routes.searchScreen,
                          arguments: SearchScreenArguments(query: temp[temp.length - 1], isSearch: false),
                        );
                      } else {
                        navigator.navigateTo(
                          Routes.subCategoriesScreen,
                          arguments: SubCategoriesScreenArguments(
                            menuBar: null,
                            cid: item.redirect.type == 'category' ? item.redirect.id.split('-')[0] : '',
                            isCid: item.redirect.type == 'category',
                            isScid: item.redirect.type == 'subcategory',
                            scid: item.redirect.type == 'subcategory' ? item.redirect.id.split('-')[0] : '',
                          ),
                        );
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Card(
                      elevation: 5.0,
                      color: Palette.white,
                      margin: const EdgeInsets.all(0),
                      child: CachedImage(
                        item.bannerImg,
                        width: context.mq.size.width / 3,
                        isRound: false,
                        radius: 0,
                      ),
                    ),
                  );
                },
              ),
            )
          : offers.isNull
              ? NoDataFound(msg: "No data found")
              : const NativeLoader(),
    );
  }
}

class _MainListView extends StatelessWidget {
  const _MainListView();

  @override
  Widget build(BuildContext context) {
    final randoms = Provider.of<HomeProvider>(context).randomProducts;

    // showLog("_MainListView build ");

    return !randoms.isNullOrEmpty
        ? Column(
            children: randoms
                .mapIndexed(
                  (currentValue, index) => _ItemMain(model: currentValue),
                )
                .toList(),
          )
        : randoms.isNull
            ? NoDataFound(msg: "No data found.")
            : const NativeLoader();
    // return ListView.builder(
    //   itemCount: 5,
    //   shrinkWrap: true,
    //   physics: NeverScrollableScrollPhysics(),
    //   itemBuilder: (_, index) {
    //     return _ItemMain(
    //       model: dummyList[index],
    //     );
    //   },
    // );
  }
}

class _ItemMain extends StatelessWidget {
  final Random model;

  const _ItemMain({this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: kToolbarHeight,
          color: context.theme.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Texts(
                  model?.header?.sctName,
                  color: Palette.white,
                  fontFamily: bold,
                ),
              ),
              FlatButton(
                height: kToolbarHeight,
                onPressed: () {
                  navigator.navigateTo(
                    Routes.searchScreen,
                    arguments: SearchScreenArguments(
                        subCatId: model.header.subcatId,
                        query: model.header.sctName,
                        isSearch: false,
                        showSearch: false,
                        isViewMore: true),
                  );
                },
                child: Texts(
                  "View More",
                  color: Palette.white,
                  fontFamily: bold,
                ),
              ),
            ],
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(color: Palette.white),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 1 / 1.4,
            physics: const NeverScrollableScrollPhysics(),
            children: model.product.mapIndexed((e, i) => _itemGrid(e, i, context)).toList(),
          ),
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }

  Widget _itemGrid(Product product, int index, BuildContext context) {
    List<StoreDetail> storeDetail = Provider.of<HomeProvider>(context).storeDetails;
    StoreDetail discount = storeDetail.firstWhere((element) => element.type == 'discount');
    return ItemProduct(
      id: product.proId,
      index: index,
      name: product.proName,
      image: product.imgLink,
      price: "${product.proPrice}",
      onTap: () {
        navigator.navigateTo(Routes.productDetails, arguments: ProductDetailsArguments(product: product));
      },
    );
  }
}
