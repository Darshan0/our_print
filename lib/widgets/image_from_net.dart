import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageFromNet extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final String placeholder;

  const ImageFromNet({
    Key key,
    @required this.imageUrl,
    this.height,
    this.width,
    this.placeholder,
  }) : super(key: key);

  const ImageFromNet.square({
    Key key,
    @required this.imageUrl,
    @required double size,
    this.placeholder,
  })  : height = size,
        width = size,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || !imageUrl.contains('http')) {
      return Container(
        color: Theme.of(context).primaryColor,
        width: width,
        height: height,
        child: Center(
          child: Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) {
        return Image(
          image: imageProvider,
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      },
      placeholder: (context, url) {
        return Container(
          color: Theme.of(context).primaryColor,
          width: width,
          height: height,
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          color: Theme.of(context).primaryColor,
          width: width,
          height: height,
          child: Center(
            child: Icon(Icons.broken_image, color: Colors.grey),
          ),
        );
      },
    );
  }
}
