import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerContainer extends StatefulWidget {
  final Widget child;
  final Function(BuildContext context, File image) onPick;

  const ImagePickerContainer({
    Key key,
    this.child,
    this.onPick,
  }) : super(key: key);

  @override
  _ImagePickerContainerState createState() => _ImagePickerContainerState();
}

class _ImagePickerContainerState extends State<ImagePickerContainer> {
  Future getImage(context, ImageSource imageSource) async {
    File image;
    image = await ImagePicker.pickImage(source: imageSource);
    if (Platform.isAndroid) {
      final LostDataResponse response = await ImagePicker.retrieveLostData();
      if (response.isEmpty) {
        widget.onPick(context, image);
        return;
      }
      if (response.file != null) {
        image = response.file;
      } else {
        var error = response.exception.code;
        print(error);
      }
      widget.onPick(context, image);
    } else {
      widget.onPick(context, image);
    }
  }

  void showChoiceDialog(context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: Text('Pick image from?', textAlign: TextAlign.center),
          children: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                getImage(context, ImageSource.camera);
              },
              child: Text(
                'CAMERA',
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                getImage(context, ImageSource.gallery);
              },
              child: Text(
                'GALLERY',
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'CLOSE',
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => showChoiceDialog(context),
      child: widget.child,
    );
  }
}
