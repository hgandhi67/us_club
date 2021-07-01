import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/di/export_di.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/providers/providers.dart';
import 'package:us_club/ui/widgets/item_product.dart';
import 'package:us_club/widgets/grey_divider.dart';
import 'package:us_club/widgets/widgets.dart';
import 'package:velocity_x/velocity_x.dart';

import '../screens.dart';

class SearchScreen extends StatefulWidget {
  final String subCatId;
  final String query;
  final bool isSearch;
  final bool showSearch;
  final bool isViewMore;

  const SearchScreen({
    @required this.isSearch,
    this.subCatId,
    this.query,
    this.showSearch = true,
    this.isViewMore = false,
  });

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product> _searchList;
  List<Product> _tempList;

  final queryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getSearchProducts(query: !widget.isViewMore ? widget.query : widget.subCatId);
  }

  void getSearchProducts({String query}) async {
    print("isViewMore =====>>> ${widget.isViewMore}");
    print("query =====>>> ${widget.query}");

    _searchList = await context.read<SearchProvider>().getSearchedProducts(query, widget.isViewMore);
    _tempList = _searchList;

    showLog("_searchList =======>>> ${_searchList.length}");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: context.theme.iconTheme.color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: !widget.showSearch
            ? Texts(widget.query, color: Palette.black)
            : TextFormField(
                controller: queryController,
                onChanged: (value) {
                  getSearchProducts(query: value);
                },
                decoration: InputDecoration(
                  hintText: "Search For Products",
                ),
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Icon(Icons.search),
              color: context.theme.iconTheme.color,
              onPressed: () {
                if (!widget.showSearch) {
                  navigator.navigateTo(
                    Routes.searchScreen,
                    arguments: SearchScreenArguments(query: "", isSearch: true),
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Column(
              children: [
                const GreyDivider(height: 5),
                Visibility(
                  visible: widget.query.isNotBlank,
                  child: Container(
                    height: kToolbarHeight,
                    color: context.theme.backgroundColor,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Texts(
                      "Showing results for \"${widget.query}\"",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const GreyDivider(height: 5),
                Expanded(
                  child: _searchList.isNull
                      ? const NativeLoader()
                      : _searchList.isEmpty
                          ? const NoDataFound(msg: "No products found.")
                          : (widget.isSearch || queryController.text.isNotEmpty)
                              ? ListView.builder(
                                  // shrinkWrap: true,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _searchList.length,
                                  itemBuilder: (contextItem, index) {
                                    return singleItem(_searchList[index], index);
                                  },
                                )
                              : GridView.count(
                                  crossAxisCount: 2,
                                  shrinkWrap: true,
                                  childAspectRatio: 1 / 1.4,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  children: _searchList.mapIndexed((e, i) => _itemGrid(e, i)).toList(),
                                ),
                ),
                FilterBar(
                  cid: widget.subCatId,
                  onChanged: (sortBy) {
                    List<Product> list = _tempList.toList();

                    switch (sortBy) {
                      case SortBy.popularity:
                        break;
                      case SortBy.high_to_low:
                        list.sort((a, b) {
                          return b.proPrice.toDouble().compareTo(a.proPrice.toDouble());
                        });
                        break;
                      case SortBy.low_to_high:
                        list.sort((a, b) {
                          return a.proPrice.toDouble().compareTo(b.proPrice.toDouble());
                        });
                        break;
                    }

                    _searchList = list;

                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemGrid(Product product, int index) {
    List<StoreDetail> storeDetail = Provider.of<HomeProvider>(context).storeDetails;
    StoreDetail discount = storeDetail.firstWhere((element) => element.type == 'discount');
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

  Widget singleItem(Product product, int index) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        navigator.navigateTo(Routes.productDetails, arguments: ProductDetailsArguments(product: product));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 21.0,
              color: Colors.black,
            ),
            const SizedBox(width: 5.0),
            Texts(product.proName, fontFamily: semiBold, fontSize: 16.0),
          ],
        ),
      ),
    );
  }
}
