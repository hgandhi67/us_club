// import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';

import 'upload_doc_dialog.dart';

class ChatTextField extends StatefulWidget {
  final Function onChanged;
  final Function onPick;
  final VoidCallback onSend;
  final String hintText;
  final TextEditingController controller;
  final isWriting;

  const ChatTextField({
    Key key,
    this.onChanged,
    this.onPick,
    this.hintText,
    this.onSend,
    this.controller,
    this.isWriting,
  }) : super(key: key);

  @override
  _ChatTextFieldState createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  String _path, _fileName;

  // FileType _pickingType = FileType.custom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Container(
                color: Palette.accentLight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(width: 8.0),
                    Visibility(
                      visible: false,
                      child: Container(
                        margin: EdgeInsets.only(top: 10.0, bottom: 12.0),
                        child: Icon(
                          Icons.insert_emoticon,
                          size: 25.0,
                          color: Color(0xffaeb5bb),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Scrollbar(
                        child: TextField(
                          controller: widget.controller,
                          cursorColor: Palette.black,
                          onChanged: widget.onChanged,
                          minLines: 1,
                          maxLines: 6,
                          style: Styles.customTextStyle(
                            color: Palette.black,
                          ),
                          decoration: InputDecoration(
                            hintText: widget.hintText,
                            hintStyle: Styles.customTextStyle(
                              color: Palette.black,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showBottomSheet();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        margin: EdgeInsets.only(top: 10.0, bottom: 12.0),
                        child: Transform.rotate(
                          angle: -180.0,
                          child: Icon(
                            Icons.attach_file,
                            size: 25.0,
                            color: Palette.accentColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.isWriting,
            child: Row(
              children: [
                SizedBox(width: 8.0),
                GestureDetector(
                  onTap: widget.onSend,
                  behavior: HitTestBehavior.opaque,
                  child: CircleAvatar(
                    backgroundColor: Palette.accentColor,
                    radius: 25.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 23.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> pickImage() async {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (_) {
        return ImageDialog(
          onPick: (fileName, imagePath) {
            if (imagePath != null && imagePath.isNotEmpty) {
              showLog("image name ==>> $fileName");
              showLog("image path ==>> $imagePath");
              widget.onPick("image", fileName, imagePath);
            }
          },
        );
      },
    );
  }

  showBottomSheet() {
    showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Palette.black,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: <Widget>[
                  FlatButton(
                    child: Icon(
                      Icons.close,
                    ),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Attach document",
                        style: TextStyle(
                          color: Palette.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  ModalTile(
                    title: "Media",
                    subtitle: "Share Photos (.jpg, .png or .jpeg etc)",
                    icon: Icons.image,
                    onTap: () => pickImage(),
                  ),
                  ModalTile(
                    title: "File",
                    subtitle: "Share Documents (pdf)",
                    icon: Icons.tab,
                    onTap: () => _openFileExplorer(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _openFileExplorer() async {
    // try {
    //   Navigator.of(context).pop();
    //   _path = await FilePicker.getFilePath(
    //     type: _pickingType,
    //     allowedExtensions: ['pdf'],
    //   );
    //   if (!mounted) return;
    //   setState(() {
    //     _fileName = _path != null ? _path.split('/').last : "...";
    //   });
    //
    //   showLog("_openFileExplorer name ====>> $_fileName");
    //   showLog("_openFileExplorer path ====>> $_path");
    //   widget.onPick("document", _fileName, _path);
    // } on PlatformException catch (e) {
    //   print("Unsupported operation" + e.toString());
    // }
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;

  const ModalTile({
    @required this.title,
    @required this.subtitle,
    @required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Palette.black,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: Palette.grey,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Palette.grey,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Palette.black,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
