import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/widgets/widgets.dart';

class TextFormFieldWidget extends StatefulWidget {
  final TextInputType textInputType;
  final String hintText;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final String defaultText;
  final String errorText;
  final FocusNode focusNode;
  final bool obscureText;
  final TextEditingController controller;
  final Function functionValidate;
  final String parametersValidate;
  final TextInputAction actionKeyboard;
  final Function onSubmitField;
  final Function onFieldTap;
  final Function onTextChanged;
  final String label;
  final String richS1;
  final String richS2;
  final bool hasDecoration;
  final int minLines;
  final int maxLines;
  final bool readOnly;
  final bool enabled;
  final bool autoFocus;
  final InputDecoration customInputDecoration;
  final TextStyle customTextStyle;
  final TextStyle hintStyle;

  const TextFormFieldWidget({
    this.hintText,
    this.focusNode,
    this.textInputType,
    this.defaultText,
    this.errorText,
    this.obscureText = false,
    this.controller,
    this.functionValidate,
    this.parametersValidate,
    this.actionKeyboard = TextInputAction.next,
    this.onSubmitField,
    this.onFieldTap,
    this.onTextChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.label,
    this.richS1,
    this.richS2,
    this.hasDecoration: true,
    this.minLines = 1,
    this.maxLines = 1,
    this.readOnly = false,
    this.enabled = true,
    this.autoFocus = false,
    this.customInputDecoration,
    this.customTextStyle,
    this.hintStyle,
  });

  @override
  _TextFormFieldWidgetState createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  double bottomPaddingToError = 12;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Visibility(
          visible: widget.label == null,
          child: RichLabel(s1: widget.richS1, s2: widget.richS2),
        ),
        Visibility(
          visible: widget.label != null,
          child: Label(widget.label),
        ),
        Theme(
          data: Theme.of(context).copyWith(splashColor: Colors.transparent),
          child: TextFormField(
            cursorColor: Colors.black,
            obscureText: widget.obscureText,
            keyboardType: widget.textInputType,
            textInputAction: widget.actionKeyboard,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            focusNode: widget.focusNode,
            readOnly: widget.readOnly,
            enabled: widget.enabled,
            autofocus: widget.autoFocus,
            style: widget.customTextStyle != null
                ? widget.customTextStyle
                : Styles.customTextStyle(
                    color: Palette.black,
                    fontSize: 15.0,
                    fontFamily: bold,
                  ),
            initialValue: widget.defaultText,
            onChanged: widget.onTextChanged,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            decoration: widget.customInputDecoration != null
                ? widget.customInputDecoration
                : InputDecoration(
                    prefixIcon: widget.prefixIcon,
                    suffixIcon: widget.suffixIcon,
                    hintText: widget.hintText,
                    focusedBorder: widget.hasDecoration
                        ? UnderlineInputBorder(borderSide: BorderSide(color: Palette.accentColor))
                        : InputBorder.none,
                    hintStyle: widget.hintStyle != null
                        ? widget.hintStyle
                        : TextStyle(
                            color: Colors.grey,
                            fontSize: 15.0,
                            letterSpacing: 1,
                            fontFamily: light,
                          ),
                    contentPadding: EdgeInsets.only(
                      top: widget.hasDecoration ? 12 : 0.0,
                      bottom: bottomPaddingToError,
                      left: 8.0,
                      right: 8.0,
                    ),
                    isDense: true,
                    errorText: widget.errorText,
                    errorStyle: Styles.customTextStyle(
                      color: Palette.red,
                      fontSize: 12.0,
                      letterSpacing: 1.2,
                    ),
                    suffix: widget.suffixIcon,
                    border: widget.hasDecoration
                        ? UnderlineInputBorder(borderSide: BorderSide(color: Palette.grey))
                        : InputBorder.none,
                    errorBorder: widget.hasDecoration
                        ? UnderlineInputBorder(borderSide: BorderSide(color: Palette.red))
                        : InputBorder.none,
                    focusedErrorBorder: widget.hasDecoration
                        ? UnderlineInputBorder(borderSide: BorderSide(color: Palette.red))
                        : InputBorder.none,
                  ),
            controller: widget.controller,
            validator: widget.functionValidate,
            onFieldSubmitted: (value) {
              if (widget.onSubmitField != null) widget.onSubmitField();
            },
            onTap: () {
              if (widget.onFieldTap != null) widget.onFieldTap();
            },
          ),
        ),
      ],
    );
  }
}

class RichLabel extends StatelessWidget {
  final String s1;
  final String s2;

  final Color color;
  final double fontSize;
  final String fontFamily;

  const RichLabel({Key key, this.s1, this.s2, this.color, this.fontSize, this.fontFamily}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: s1,
            style: Styles.customTextStyle(
              color: Palette.grey,
              fontSize: fontSize,
            ),
          ),
          TextSpan(
            text: s2,
            style: Styles.customTextStyle(
              color: Palette.red,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}

class Label extends StatelessWidget {
  final String label;
  final Color color;
  final double fontSize;
  final String fontFamily;

  const Label(this.label, {Key key, this.color, this.fontSize, this.fontFamily}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Texts(
      label,
      color: color ?? Palette.grey,
      fontSize: fontSize,
      fontFamily: fontFamily,
    );
  }
}

void changeFocus(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
