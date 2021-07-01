import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/widgets/widgets.dart';

enum SortBy { popularity, high_to_low, low_to_high }

class SortModel {
  String title;
  SortBy value;
  bool isSelected;

  SortModel({this.title, this.value, this.isSelected = false});
}

class SortByBottomSheet extends StatefulWidget {
  final Function(SortBy) sortBy;
  final SortBy selected;

  const SortByBottomSheet({
    Key key,
    @required this.sortBy,
    this.selected = SortBy.popularity,
  }) : super(key: key);

  @override
  _SortByBottomSheetState createState() => _SortByBottomSheetState();
}

class _SortByBottomSheetState extends State<SortByBottomSheet> {
  List<SortModel> sortList = [
    SortModel(title: "By Popularity", value: SortBy.popularity),
    SortModel(title: "Price High To Low", value: SortBy.high_to_low),
    SortModel(title: "Price Low To High", value: SortBy.low_to_high),
  ];

  @override
  void initState() {
    super.initState();

    if (widget.selected != null) {
      switch (widget.selected) {
        case SortBy.popularity:
          sortList[0].isSelected = true;
          break;
        case SortBy.high_to_low:
          sortList[1].isSelected = true;
          break;
        case SortBy.low_to_high:
          sortList[2].isSelected = true;
          break;
      }
    } else {
      sortList[0].isSelected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Palette.accentColor,
              ),
              onPressed: () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
            ),
          ),
          Column(
            children: sortList
                .map(
                  (e) => ListTile(
                    onTap: () {
                      setState(() {
                        sortList.forEach((element) {
                          element.isSelected = element.title == e.title;
                        });
                      });
                      widget.sortBy?.call(e.value);
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.done,
                          color: e.isSelected ? Palette.black : Colors.transparent,
                          size: 20,
                        ),
                        const SizedBox(width: 15),
                        Texts(
                          e.title.toUpperCase(),
                          fontFamily: bold,
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
