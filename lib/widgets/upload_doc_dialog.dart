import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';
import 'package:us_club/utils/export_utils.dart';
import 'package:us_club/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ImageDialog extends StatefulWidget {
  final String title;
  final Function onPick;

  const ImageDialog({Key key, this.title, @required this.onPick}) : super(key: key);

  @override
  _ImageDialogState createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Image'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      content: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () {
                pick(ImageSource.camera);
              },
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Palette.accentLight,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Texts(
                    "Camera",
                    color: Palette.accentColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          const Spacers(width: 20),
          Expanded(
            child: InkWell(
              onTap: () async {
                pick(ImageSource.gallery);
              },
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Palette.accentLight,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Texts(
                    "Gallery",
                    color: Palette.accentColor,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: const Texts('CANCEL'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void pick(ImageSource source) async {
    try {
      Navigator.pop(context);
      // final pickedFile = await _picker.getImage(source: source);
      final pickedFile = await Utils.pickImage(source: source);

      if (pickedFile != null) {
        var fileName;

        if (source == ImageSource.camera) {
          var now = DateTime.now();
          fileName = "Image_${now.year}_${now.month}_${now.day}_${now.millisecondsSinceEpoch}.jpg";
        } else {
          fileName = pickedFile.path.substring(pickedFile.path.lastIndexOf("/"));
          fileName = fileName.toString().substring(1).replaceAll("image_picker", "Image_");
        }
        widget.onPick(fileName, pickedFile.path);
      }
    } catch (e) {
      showLog("exception in pick image ==>>> ${e.toString()}");
    }
  }
}
