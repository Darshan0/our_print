import 'package:flutter/material.dart';
import 'package:ourprint/repository/user_repo.dart';
import 'package:ourprint/widgets/dialog_boxes.dart';
import 'package:ourprint/widgets/error_snackbar.dart';
import 'package:ourprint/widgets/loading_widget.dart';

class ProfileDropDown extends StatefulWidget {
  final String title;
  final String keY;
  final List<String> items;
  final Function(String val, BuildContext context, {bool textField}) onChanged;
  final String value;

  ProfileDropDown(
      {Key key, this.title, this.items, this.onChanged, this.value, this.keY})
      : super(key: key);

  @override
  _ProfileDropDownState createState() => _ProfileDropDownState();
}

class _ProfileDropDownState extends State<ProfileDropDown> {
  final focusNode = FocusNode();
  String otherTextField = '';

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      print('liaten');
      if (!focusNode.hasFocus) {
        print('submit');
        widget.onChanged(otherTextField, context, textField: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputStyle = Theme.of(context)
        .textTheme
        .title
        .copyWith(color: Colors.black, fontWeight: FontWeight.w900);
    return Builder(
      builder: (context) => Column(
        children: <Widget>[
          ListTile(
            title: Text(widget.title),
            subtitle: DropdownButtonFormField(
              icon: Icon(Icons.keyboard_arrow_down),
              decoration: InputDecoration(
                  enabledBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none)),
              value: widget.items.contains(widget.value)
                  ? widget.value
                  : widget.items[widget.items.length - 1],
              items: widget.items
                  .map(
                    (value) => DropdownMenuItem(
                      child: Text(
                        value,
                        style: value == 'NA'
                            ? Theme.of(context).textTheme.caption.copyWith(
                                fontSize: 20, fontWeight: FontWeight.bold)
                            : inputStyle,
                      ),
                      value: value,
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val == 'NA') return;
                widget.onChanged(val, context);
              },
            ),
          ),
          widget.value.toLowerCase() == 'others' ||
                  (!widget.items.contains(widget.value))
              ? ListTile(
                  contentPadding:
                      EdgeInsets.only(left: 16, bottom: 8, right: 16),
                  title: Text('Enter ${widget.title}'),
                  subtitle: TextFormField(
//                    controller: controller,
                    initialValue: widget.value,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(hintText: 'Tap to edit'),
                    focusNode: focusNode,
                    onChanged: (val){
                      otherTextField=val;
                    },
                    onFieldSubmitted: (val) {
//                    updateProfile(context, {widget.keY: val});
                    },
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  updateProfile(context, Map body) async {
    try {
      LoadingWidget.showLoadingDialog(context);
      await UserRepo.editProfile(body);
      Navigator.pop(context);
    } catch (e) {
      print(e);
      Navigator.pop(context);
      DialogBox.parseAndShowErrorDialog(context, e);
    }
  }
}
