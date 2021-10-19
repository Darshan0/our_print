import 'package:flutter/material.dart';

class ContainerShadow extends StatelessWidget {
  final Widget child;
  final double blurRadius;
  final double yAxis;

  const ContainerShadow({Key key, this.child, this.blurRadius, this.yAxis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, yAxis ?? -5),
          ),
        ],
      ),
      child: child,
    );
  }
}
