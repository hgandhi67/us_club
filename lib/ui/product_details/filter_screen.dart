import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/base/palette.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/widgets/widgets.dart';

class SizeClass {
  String size;
  String color;
  bool isSelected;

  SizeClass({this.size, this.color, this.isSelected});
}

class FilterScreen extends StatefulWidget {
  final String catId;
  final String type;

  const FilterScreen({this.catId, this.type = 'cat'});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  FilterData data;

  bool isBusy = false;

  int _currentIndex = 0;

  double _lowerValue = 50;
  double _upperValue = 200;

  String size, color;

  List<SizeClass> sizeList = [];
  List<SizeClass> colorList = [];

  void setBusy(bool value) {
    if (!mounted) return;
    setState(() {
      isBusy = value;
    });
  }

  @override
  void initState() {
    super.initState();

    getFilterTypes();
  }

  getFilterTypes() async {
    showLoader();
    final response = await api.getFilterType(widget.catId, widget.type);

    hideLoader();

    if (response != null) {
      data = response.data;

      if (data is String) {
        /// no data found
        return;
      }

      _lowerValue = data.price[0].toDouble();
      _upperValue = data.price[1].toDouble();

      if (!data.size.isNullOrEmpty) {
        data.size.forEach((element) {
          sizeList.add(SizeClass(size: element, isSelected: false));
        });
      }

      if (!data.color.isNullOrEmpty) {
        data.color.forEach((element) {
          colorList.add(SizeClass(color: element, isSelected: false));
        });
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      centerTitle: false,
      elevation: 0.0,
      child: isBusy
          ? const NativeLoader()
          : SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: kToolbarHeight,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Palette.darkGrey,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Texts(
                          "Filters",
                          color: Palette.black,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Visibility(
                          visible: data != null && data is! String,
                          child: Expanded(
                            flex: 1,
                            child: Container(
                              color: Palette.grey.withOpacity(0.1),
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: data != null && !data.size.isNullOrEmpty,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            setState(() {
                                              _currentIndex = 0;
                                            });
                                          },
                                          title: Texts("Size"),
                                          dense: true,
                                        ),
                                        Divider(indent: 8, height: 1),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: data != null && !data.price.isNullOrEmpty,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            setState(() {
                                              _currentIndex = 1;
                                            });
                                          },
                                          title: Texts("Price"),
                                          dense: true,
                                        ),
                                        Divider(indent: 8, height: 1),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: data != null && !data.color.isNullOrEmpty,
                                    child: ListTile(
                                      onTap: () {
                                        setState(() {
                                          _currentIndex = 2;
                                        });
                                      },
                                      title: Texts("Color"),
                                      dense: true,
                                    ),
                                  ),
                                  Divider(indent: 8, height: 1),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: IndexedStack(
                            index: _currentIndex,
                            children: [
                              list1(),
                              list2(),
                              list3(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: kToolbarHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              if (data != null) {
                                _lowerValue = data.price[0].toDouble();
                                _upperValue = data.price[1].toDouble();
                              }
                            });
                          },
                          child: Texts("Clear Filters"),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: FlatButton(
                            color: Palette.accentColor,
                            onPressed: () {
                              String size = '', color = '';

                              sizeList.forEach((element) {
                                if (element.isSelected) {
                                  size += "size=" + element.size + "&";
                                }
                              });

                              colorList?.forEach((element) {
                                if (element.isSelected) {
                                  color += "color=" + element.color + "&";
                                }
                              });

                              showLog("size =======>>> $size");
                              showLog("color =======>>> $color");

                              final map = {
                                "size": !size.isEmptyORNull ? size.substring(0, size.length - 1) : null,
                                "lower_bound": _lowerValue,
                                "upper_bound": _upperValue,
                                "color": !color.isEmptyORNull ? color.substring(0, color.length - 1) : null,
                              };

                              Navigator.of(context).pop(map);
                            },
                            child: Texts(
                              "Done",
                              color: Palette.white,
                              fontFamily: semiBold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget list1() {
    return sizeList != null && sizeList.isNotEmpty
        ? ListView.separated(
            itemCount: sizeList.length,
            separatorBuilder: (_, index) {
              return Divider(height: 1);
            },
            itemBuilder: (_, index) {
              final item = sizeList[index];
              return ListTile(
                onTap: () {
                  setState(() {
                    for (var i = 0; i < sizeList.length; ++i) {
                      var o = sizeList[i];

                      if (o.size.removeSpaces() == item.size.removeSpaces()) {
                        o.isSelected = !o.isSelected;
                        size = o.size;
                        break;
                      } else {
                        o.isSelected = o.size.toLowerCase() == item.size.toLowerCase();
                        size = o.size;
                      }
                    }

                    showLog("item =======>>> ${item.isSelected}");
                  });
                },
                dense: true,
                title: Texts(item.size),
                trailing: Icon(
                  Icons.done,
                  color: !item.isSelected ? Colors.transparent : Palette.accentColor,
                ),
              );
            },
          )
        : const NoDataFound(msg: "No filters yet.");
  }

  Widget list2() {
    return data?.price != null && data?.price?.isNotEmpty == true
        ? Column(
            children: [
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: FlutterSlider(
                  values: [_lowerValue, _upperValue],
                  rangeSlider: true,
                  tooltip: FlutterSliderTooltip(
                    alwaysShowTooltip: true,
                    positionOffset: FlutterSliderTooltipPositionOffset(top: -30.0, left: 5),
                  ),
                  min: data.price[0].toDouble(),
                  max: data.price[1].toDouble(),
                  onDragging: (handlerIndex, lowerValue, upperValue) {
                    _lowerValue = lowerValue;
                    _upperValue = upperValue;
                    setState(() {});
                  },
                  trackBar: FlutterSliderTrackBar(
                    activeTrackBar: BoxDecoration(
                      color: Palette.accentColor,
                    ),
                  ),
                  handlerHeight: 18,
                  rightHandler: FlutterSliderHandler(
                    decoration: BoxDecoration(
                      color: Palette.white,
                      border: Border.all(color: Palette.accentColor),
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox(),
                  ),
                  handler: FlutterSliderHandler(
                    decoration: BoxDecoration(
                      color: Palette.white,
                      border: Border.all(color: Palette.accentColor),
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox(),
                  ),
                ),
              ),
            ],
          )
        : const NoDataFound(msg: "No filters yet.");
  }

  Widget list3() {
    return colorList != null && colorList.isNotEmpty
        ? ListView.separated(
            itemCount: colorList.length,
            separatorBuilder: (_, index) {
              return Divider(height: 1);
            },
            itemBuilder: (_, index) {
              final item = colorList[index];
              return ListTile(
                onTap: () {
                  setState(() {
                    for (var i = 0; i < colorList.length; ++i) {
                      var o = colorList[i];

                      if (o.color.removeSpaces() == item.color.removeSpaces()) {
                        o.isSelected = !o.isSelected;
                        color = o.color;
                        break;
                      } else {
                        o.isSelected =
                            o.color.removeSpaces().toLowerCase() == item.color.removeSpaces().toLowerCase();
                        color = o.color;
                      }
                    }

                    showLog("item =======>>> ${item.isSelected}");
                  });
                },
                dense: true,
                title: Texts(item.color.sCap()),
                trailing: Icon(
                  Icons.done,
                  color: !item.isSelected ? Colors.transparent : Palette.accentColor,
                ),
              );
            },
          )
        : const NoDataFound(msg: "No colors yet.");
  }
}
