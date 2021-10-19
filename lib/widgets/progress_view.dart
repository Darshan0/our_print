import 'package:flutter/material.dart';

class ProgressView extends StatelessWidget {
  final int index;
  final int position;
  final int length;

  ProgressView({
    Key key,
    @required this.index,
    this.position,
    this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(2),
          decoration: index > position
              ? null
              : BoxDecoration(
                  border: Border.all(color: Colors.green),
                  shape: BoxShape.circle,
                ),
          child: CircleAvatar(
            radius: 4,
            backgroundColor:
                index > position ? Colors.grey.withOpacity(0.7) : Colors.green,
          ),
        ),
        index + 1 == length
            ? Container()
            : Column(
                children: List.generate(
                  7,
                  (int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Container(
                        height: 7,
                        width: 1,
                        color: Colors.grey.withOpacity(0.7),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
