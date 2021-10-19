import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ourprint/resources/images.dart';

class ProfileImageFromNet extends StatelessWidget {
  final String imageUrl;
  final String placeholder;
  final double radius;
  final double borderRadius;
  final double errorRadius;

  const ProfileImageFromNet({
    Key key,
    @required this.imageUrl,
    this.placeholder,
    this.radius,
    this.borderRadius,
    this.errorRadius,
  }) : super(key: key);

  const ProfileImageFromNet.square(
      {Key key,
      @required this.imageUrl,
      @required double size,
      this.placeholder,
      this.radius,
      this.borderRadius,
      this.errorRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || !imageUrl.contains('http')) {
      return CircleAvatar(
        backgroundImage: AssetImage(Images.noProfile),
        radius: 60,
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) {
        return Container(
          width: radius ?? 40,
          height: radius,
          margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 24,
                spreadRadius: 8,
              )
            ],
            borderRadius: BorderRadius.circular(borderRadius ?? 15),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        );
      },
      placeholder: (context, url) {
        return Container(
          width: radius ?? 40,
          height: radius,
        );
      },
      errorWidget: (context, url, error) {
        return CircleAvatar(
          backgroundImage: AssetImage(Images.noProfile),
          radius: errorRadius ?? 40,
        );
      },
    );
  }
}
