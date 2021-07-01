import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/model/models.dart';
import 'package:us_club/widgets/text_widget.dart';

class CustomDropdownWidget extends StatefulWidget {
  final List<dynamic> valuesList;
  final Function selectedValue;
  final dynamic initialValue;
  final double bottomLeft;
  final double bottomRight;
  final double topLeft;
  final double topRight;
  final Color themeColor;
  final Color borderColor;
  final Color canvasColor;
  final Color themeTextColor;
  final double padding;
  final String errorText;
  final Widget arrowWidget;
  final bool validateGender;
  final double textSize;
  final bool isImagePresent;
  final String hint;

  const CustomDropdownWidget({
    Key key,
    this.valuesList,
    this.selectedValue,
    this.initialValue,
    this.arrowWidget,
    this.validateGender,
    this.canvasColor,
    this.bottomLeft: 0.0,
    this.bottomRight: 0.0,
    this.topLeft: 0.0,
    this.topRight: 0.0,
    this.themeColor: Palette.greyLight,
    this.themeTextColor: Colors.black,
    this.padding: 0.0,
    this.errorText,
    this.textSize: 18.0,
    this.isImagePresent: false,
    this.borderColor,
    this.hint,
  }) : super(key: key);

  @override
  _CustomDropdownWidgetState createState() => _CustomDropdownWidgetState();
}

class _CustomDropdownWidgetState extends State<CustomDropdownWidget> {
  dynamic dropdownValue = '';

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(CustomDropdownWidget oldWidget) {
    dropdownValue = widget.initialValue;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: widget.canvasColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buttonThemeWidget(),
          _errorWidget(),
        ],
      ),
    );
  }

  Widget _errorWidget() {
    return Visibility(
      visible: (widget.errorText == null || widget.errorText == '') ? false : true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              widget.errorText != null ? widget.errorText : '',
              style: Styles.customTextStyle(
                fontSize: 12.0,
                color: Palette.red,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buttonThemeWidget() {
    return ButtonTheme(
      alignedDropdown: true,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: widget.padding),
        width: MediaQuery.of(context).size.width,
        decoration: ShapeDecoration(
          color: widget.themeColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.0,
              style: BorderStyle.solid,
              color: widget.borderColor ?? widget.themeColor,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(widget.bottomLeft),
              bottomRight: Radius.circular(widget.bottomRight),
              topLeft: Radius.circular(widget.topLeft),
              topRight: Radius.circular(widget.topRight),
            ),
          ),
        ),
        child: widget.valuesList != null && widget.valuesList.isNotEmpty
            ? DropdownButtonHideUnderline(
                child: Listener(
                  onPointerDown: (_) => FocusScope.of(context).unfocus(),
                  child: DropdownButton(
                      value: dropdownValue,
                      isExpanded: true,
                      iconSize: 30,
                      hint: Texts(
                        widget.hint,
                        fontWeight: FontWeight.normal,
                        color: widget.themeTextColor,
                        fontSize: widget.textSize,
                        fontFamily: regular,
                      ),
                      icon: widget.arrowWidget,
                      iconDisabledColor: widget.themeTextColor,
                      iconEnabledColor: widget.themeTextColor,
                      style: TextStyle(color: widget.themeTextColor, fontSize: widget.textSize),
                      onChanged: (dynamic data) {
                        setState(() {
                          dropdownValue = data;
                          widget.selectedValue(dropdownValue);
                        });
                      },
                      items: widget.valuesList.map<DropdownMenuItem<dynamic>>((dynamic value) {
                        String text = '';
                        switch (value.runtimeType) {
                          case Country:
                            text = (value as Country).name;
                            break;
                          case States:
                            text = (value as States).name;
                            break;
                          case City:
                            text = (value as City).name;
                            break;
                          case String:
                            text = value;
                            break;
                        }
                        return DropdownMenuItem<dynamic>(
                          value: value,
                          child: Text(
                            text,
                            style: Styles.customTextStyle(
                              fontWeight: FontWeight.normal,
                              color: widget.themeTextColor,
                              fontSize: widget.textSize,
                            ),
                          ),
                        );
                      }).toList()),
                ),
              )
            : SizedBox(),
      ),
    );
  }
}
