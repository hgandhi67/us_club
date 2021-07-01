import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/widgets/widgets.dart';

class ItemProduct extends StatelessWidget {
  final String id;
  final int index;
  final String image;
  final String name;
  final String price;
  final VoidCallback onTap;

  const ItemProduct({
    @required this.id,
    @required this.image,
    @required this.name,
    @required this.price,
    @required this.onTap,
    @required this.index,
  })  : assert(name != null),
        assert(price != null),
        assert(onTap != null);

  @override
  Widget build(BuildContext context) {
    final discountPrice = (price.toInt() - ((price.toInt() * discount) / 100)).toStringAsFixed(2);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Material(
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                right: index.isEven ? BorderSide(color: Colors.grey) : BorderSide.none,
                // left: index.isOdd ? BorderSide(color: Colors.red) : BorderSide.none,
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CachedImage(
                      image,
                      isRound: false,
                      radius: 0.0,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Texts(
                        name,
                        color: Palette.black,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        fontFamily: bold,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: Strings.r + discountPrice.toString() + "\n",
                              style: Styles.customTextStyle(
                                color: Palette.black,
                                fontFamily: bold,
                                fontSize: 14.0,
                              ),
                            ),
                            TextSpan(
                              text: "${Strings.r}${price.toDouble().toStringAsFixed(2)}",
                              style: Styles.customTextStyle(
                                color: Palette.black.withOpacity(0.5),
                                fontFamily: bold,
                                textDecoration: TextDecoration.lineThrough,
                                fontSize: 14.0,
                              ),
                            ),
                            TextSpan(
                              text: " " + "${discount.toInt()}" + "% Off",
                              style: Styles.customTextStyle(
                                color: Palette.red,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
