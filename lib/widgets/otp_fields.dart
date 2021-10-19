import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpFields extends StatefulWidget {
  final length;
  final List<TextEditingController> controllers;
  final GlobalKey formKey;

  const OtpFields({
    Key key,
    @required this.length,
    this.controllers,
    this.formKey,
  }) : super(key: key);

  @override
  _OtpFieldsState createState() => _OtpFieldsState();
}

class _OtpFieldsState extends State<OtpFields> {
  List<FocusNode> focusNodes = List<FocusNode>();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.length; i++) {
      focusNodes.add(FocusNode());
      widget.controllers.add(TextEditingController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Row(
        children: List.generate(
          widget.length,
          (int index) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextFormField(
                  maxLength: 1,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                  validator: (text) => text.length == 1 ? null : '',
                  controller: widget.controllers[index],
                  focusNode: focusNodes[index],
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'X',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w900,
                    ),
                    counterText: "",
                  ),
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    if (value == '')
                      focusNodes[index].previousFocus();
                    else {
                      if (index == widget.length - 1)
                        focusNodes[index].unfocus();
                      else
                        focusNodes[index + 1].nextFocus();
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
