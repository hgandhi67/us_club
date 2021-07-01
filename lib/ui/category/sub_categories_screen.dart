import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/di/export_di.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/providers/providers.dart';
import 'package:us_club/ui/screens.dart';
import 'package:us_club/ui/widgets/item_product.dart';
import 'package:us_club/widgets/widgets.dart';
import 'package:velocity_x/velocity_x.dart';

class SubCategoriesScreen extends StatefulWidget {
  final Menubar menuBar;

  final String cid;
  final bool isCid;
  final String scid;
  final bool isScid;

  const SubCategoriesScreen({
    @required this.menuBar,
    @required this.cid,
    @required this.isCid,
    @required this.scid,
    @required this.isScid,
  });

  @override
  _SubCategoriesScreenState createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  CategoriesProvider _provider;

  AutoScrollController controller;

  AnimationController _hideFabAnimation;

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
    // showLog("SubCategoriesScreen build.");

    _provider = Provider.of<CategoriesProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      body: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Column(
          children: [
            CustomAppbar(
              routeName: Routes.subCategoriesScreen,
              onLogo: () {
                if (widget.isCid) {
                  Navigator.of(context).pop();
                } else {
                  int count = 0;
                  Navigator.popUntil(context, (route) {
                    return count++ == 2;
                  });
                }
              },
            ),
            Expanded(
              child: Scaffold(
                body: SingleChildScrollView(
                  controller: controller,
                  child: AutoScrollTag(
                    key: ValueKey(0),
                    controller: controller,
                    index: 0,
                    child: _SubCategoriesList(
                      menuBar: widget.menuBar,
                      cid: widget.cid,
                      scid: widget.scid,
                      isCid: widget.isCid,
                      isScid: widget.isScid,
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
              ),
            ),
            FilterBar(
              menuBar: widget.menuBar,
              cid: widget.cid,
              scid: widget.scid,
              isCid: widget.isCid,
              isScid: widget.isScid,
            ),
          ],
        ),
        // child: CustomScrollView(
        //   physics: const ClampingScrollPhysics(),
        //   slivers: [
        //     SliverFillRemaining(
        //       hasScrollBody: true,
        //       child: SingleChildScrollView(
        //         controller: controller,
        //         child: Column(
        //           children: [
        //             const CustomAppbar(routeName: Routes.subCategoriesScreen),
        //             Flexible(
        //               fit: FlexFit.loose,
        //               child: Scaffold(
        //                 body: AutoScrollTag(
        //                   key: ValueKey(0),
        //                   controller: controller,
        //                   index: 0,
        //                   child: _SubCategoriesList(
        //                     menuBar: widget.menuBar,
        //                     cid: widget.cid,
        //                     scid: widget.scid,
        //                     isCid: widget.isCid,
        //                     isScid: widget.isScid,
        //                   ),
        //                 ),
        //                 floatingActionButton: ScaleTransition(
        //                   scale: _hideFabAnimation,
        //                   alignment: Alignment.bottomCenter,
        //                   child: FloatingActionButton(
        //                     heroTag: null,
        //                     onPressed: () async {
        //                       _hideFabAnimation.value = 0.0;
        //                       await controller.scrollToIndex(0, preferPosition: AutoScrollPosition.begin);
        //                     },
        //                     child: Icon(Icons.keyboard_arrow_up),
        //                     backgroundColor: context.theme.primaryColor,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //             FilterBar(
        //               menuBar: widget.menuBar,
        //               cid: widget.cid,
        //               scid: widget.scid,
        //               isCid: widget.isCid,
        //               isScid: widget.isScid,
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      )
      /*body: Column(
        children: [
          const CustomAppbar(routeName: Routes.subCategoriesScreen),
          Expanded(
            child: _SubCategoriesList(
              menuBar: widget.menuBar,
              cid: widget.cid,
              scid: widget.scid,
              isCid: widget.isCid,
              isScid: widget.isScid,
            ),
          ),
          FilterBar(
            menuBar: widget.menuBar,
            cid: widget.cid,
            scid: widget.scid,
            isCid: widget.isCid,
            isScid: widget.isScid,
          ),
        ],
      ),*/
      ,
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

  @override
  void dispose() {
    super.dispose();

    if (widget.isCid) {
      _provider.clearAllValues();
    } else {
      _provider.clearSubCatValues();
    }
  }
}

class _SubCategoriesList extends StatefulWidget {
  final Menubar menuBar;
  final String cid;
  final bool isCid;
  final String scid;
  final bool isScid;

  const _SubCategoriesList({this.cid, this.isCid, this.scid, this.isScid, this.menuBar});

  @override
  _SubCategoriesListState createState() => _SubCategoriesListState();
}

class _SubCategoriesListState extends State<_SubCategoriesList> with AutomaticKeepAliveClientMixin {
  CData cData;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      callAPIS();
    });
  }

  callAPIS() async {
    var response;

    if (widget.isCid) {
      // response = await context.read<CategoriesProvider>().getAllSubCategories(widget.cid);
      response = await context.read<CategoriesProvider>().getAllSubCategories(widget.cid);
    } else {
      // response = await context.read<CategoriesProvider>().getAllSubSubCategories(widget.scid);
      response = await context.read<CategoriesProvider>().getAllSubSubCategories(widget.scid);
    }

    if (response != null) {
      cData = response.data[0];
    }

    // showLog("response 2 =======>>> ${cData?.subcat?.length}");

    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // showLog("_SubCategoriesList build.");

    List<dynamic> list;

    if (widget.isCid) {
      list = cData?.subcat;
    } else {
      list = cData?.subcatType;
    }

    return cData.isNull
        ? const NativeLoader()
        : list?.isNotEmpty == true
            ? Column(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Palette.greyLight,
                    ),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      childAspectRatio: 4 / 2.3,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      children: list
                          .mapIndexed(
                            (product, index) => _itemCategory(context, product),
                          )
                          .toList(),
                    ),
                  ),
                  ProductsView(
                    menuBar: widget.menuBar,
                    cid: widget.cid,
                    scid: widget.scid,
                    isCid: widget.isCid,
                    isScid: widget.isScid,
                  ),
                ],
              )
            : const NoDataFound();
  }

  Widget _itemCategory(BuildContext context, SubCategory model) {
    return InkWell(
      // behavior: HitTestBehavior.opaque,
      onTap: () {
        // showLog("isCid =======>>> ${widget.isCid}");
        // showLog("isScid =======>>> ${widget.isScid}");
        showLog("cid =======>>> ${widget.cid}");
        showLog("scid =======>>> ${widget.scid}");
        showLog("subcatId =======>>> ${model.subcatId}");

        /// if user is coming from home screen
        if (widget.isCid) {
          navigator.navigateTo(
            Routes.subCategoriesScreen,
            arguments: SubCategoriesScreenArguments(
              menuBar: widget.menuBar,
              cid: "",
              isCid: false,
              scid: model.subcatId ?? model.sctId,
              isScid: true,
            ),
          );
          return;
        }

        /// if user is coming from sub category screen and user taps on sub category
        /// then we have to goto search screen
        if (widget.isScid) {
          var query = model.subcatName ?? model.sctName;

          navigator.navigateTo(
            Routes.searchScreen,
            arguments: SearchScreenArguments(
              query: query,
              isSearch: false,
              isViewMore: true,
              subCatId: widget.scid,
            ),
          );
          return;
        }
      },
      child: Card(
        elevation: 1.5,
        child: Container(
          decoration: BoxDecoration(
            color: context.theme.backgroundColor,
            border: Border.all(color: Palette.accentColor, width: 0.3),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          child: Texts(
            model.subcatName ?? model.sctName,
            color: Palette.grey,
            textAlign: TextAlign.center,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }
}

class ProductsView extends StatefulWidget {
  final Menubar menuBar;
  final String cid;
  final bool isCid;
  final String scid;
  final bool isScid;

  const ProductsView({this.cid, this.isCid, this.scid, this.isScid, this.menuBar});

  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  List<Product> productsList;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      callAPIS();
    });
  }

  callAPIS() async {
    var response;

    if (widget.isCid) {
      // response = await context.read<CategoriesProvider>().getAllCategoryProduct(widget.cid);
      context.read<CategoriesProvider>().getAllCategoryProduct(widget.cid);
    } else {
      // response = await context.read<CategoriesProvider>().getAllSubCategoriesProducts(widget.scid);
      context.read<CategoriesProvider>().getAllSubCategoriesProducts(widget.scid);
    }

    // if (response != null) {
    //   productsList = response.data;
    // } else {
    //   productsList = [];
    // }

    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoriesProvider>();
    final isLoad = widget.isCid ? provider.allProducts.isNull : provider.scAllProducts.isNull;
    final isEmpty = widget.isCid ? provider.allProducts?.isEmpty : provider.scAllProducts?.isEmpty;
    final list = widget.isCid ? provider.allProducts : provider.scAllProducts;

    // showLog("ProductsView build.");

    return isLoad
        ? const SizedBox()
        : isEmpty
            ? NoDataFound(msg: "No products found.")
            : Builder(
                builder: (context) {
                  return ScrollConfiguration(
                    behavior: const NoGlowingBehavior(),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      childAspectRatio: 0.5 / 0.7,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      children: list.mapIndexed((product, index) {
                        return ItemProduct(
                          index: index,
                          id: product.proId,
                          price: product.proPrice,
                          image: product.imgLink,
                          onTap: () {
                            navigator.navigateTo(
                              Routes.productDetails,
                              arguments: ProductDetailsArguments(product: product),
                            );
                          },
                          name: product.proName,
                        );
                      }).toList(),
                    ),
                  );
                },
              );
  }
}

class FilterBar extends StatefulWidget {
  final Menubar menuBar;
  final String cid;
  final bool isCid;
  final String scid;
  final bool isScid;
  final Function(SortBy) onChanged;

  const FilterBar({
    this.menuBar,
    this.cid,
    this.isCid,
    this.scid,
    this.isScid,
    this.onChanged,
  });

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  var sortedBy = SortBy.popularity;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      child: Row(
        children: [
          Expanded(
            child: FlatButton(
              height: kToolbarHeight,
              color: context.theme.primaryColor,
              onPressed: filterProducts,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Texts(
                    "Filter",
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FlatButton(
              height: kToolbarHeight,
              color: context.theme.primaryColor,
              onPressed: sortProducts,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Texts(
                    "Sort",
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void filterProducts() async {
    String idToPass = widget.cid;

    if (widget.isScid == true) {
      idToPass = widget.scid;
    }

    final result = await navigator.navigateToView(FilterScreen(
      catId: idToPass,
      type: widget.isScid == false ? 'cat' : 'subcat',
    )) as Map;

    showLog("result =======>>> ${result.toString()}");

    if (result != null) {
      showLoader();
      await context.read<CategoriesProvider>().getFilteredProducts(
            idToPass,
            result['lower_bound'].toString(),
            result['upper_bound'].toString(),
            result['size'].toString(),
            result['color'].toString(),
            widget.isCid,
          );
      hideLoader();
    }
  }

  void sortProducts() async {
    final sortBy = await showMaterialModalBottomSheet(
        context: context,
        builder: (_) {
          return SortByBottomSheet(
            sortBy: (selected) => Navigator.of(context).pop(selected),
            selected: sortedBy,
          );
        });

    if (sortBy != null) {
      if (sortedBy != sortBy) {
        if (widget.onChanged == null) {
          context.read<CategoriesProvider>().sortProducts(sortBy, widget.isCid);
        }
      }

      setState(() {
        sortedBy = sortBy;
      });
      widget.onChanged?.call(sortedBy);
    }
    showLog("sortBy =======>>> $sortedBy");
  }
}
