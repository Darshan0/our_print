import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:ourprint/data/local/shared_prefs.dart';
import 'package:ourprint/data/static/cities.dart';
import 'package:ourprint/model/address_model.dart';
import 'package:ourprint/model/order_model.dart';
import 'package:ourprint/repository/address_repo.dart';
import 'package:ourprint/screens/address_pages/address.dart';
import 'package:ourprint/widgets/dialog_boxes.dart';
import 'package:ourprint/widgets/error_snackbar.dart';
import 'package:ourprint/widgets/error_widget.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:toast/toast.dart';

class AddAddress extends StatefulWidget {
  static Map addressNames = {
    'home': 'Home',
    'work': 'Work',
    'others': 'Others',
  };

  AddAddress({
    Key key,
    this.addressModel,
  }) : super(key: key);

  static openReplacement(context,
      {OrderModel oModel, AddressModel addressModel}) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AddAddress(
          addressModel: addressModel,
        ),
      ),
    );
  }

  final AddressModel addressModel;

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final addressLineCtrl1 = TextEditingController();
  final addressLineCtrl2 = TextEditingController();
  final landmarkCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final pinCodeCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final alternateMobCtrl = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  String addressName;

  // List pinCodes = [];

  Future<List> getDetails() async {
    // pinCodes = await AddressRepo.getPinCodes();
    return AddressRepo.getStates();
  }

  @override
  void initState() {
    super.initState();
    fillFields();
    future = getDetails();
  }

  final scrollCtrl = ScrollController();

  fillFields() {
    addressLineCtrl1.text = widget.addressModel?.addressLine1;
    addressLineCtrl2.text = widget.addressModel?.addressLine2;
    landmarkCtrl.text = widget.addressModel?.landmark;
    cityCtrl.text = widget.addressModel?.city;
    addressName = widget.addressModel?.addressName ?? 'others';
    stateCtrl.text = widget.addressModel?.state;
    pinCodeCtrl.text = widget.addressModel?.pinCode;
    alternateMobCtrl.text = widget.addressModel?.alternateMob;
  }

  Future<List> future;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return FutureBuilder<List>(
        future: future,
        builder: (context, snap) {
          if (snap.hasError)
            return Material(
              child: CustomErrorWidget(error: snap.error),
            );
          if (!snap.hasData)
            return Material(
              child: LoadingWidget(),
            );
          List states = snap.data.map((data) => data['state']).toList();

          return Scaffold(
            appBar: AppBar(),
            floatingActionButton: RaisedButton(
              onPressed: () async {
                if (!formKey.currentState.validate()) return;

                if (!states.contains(stateCtrl.text))
                  return Toast.show('Please select a valid state', context,
                      duration: 3);

                // if (!pinCodes.contains(pinCodeCtrl.text))
                //   return Toast.show('Please select a valid pincode', context,
                //       duration: 3);

                if (cityCtrl.text.length < 3)
                  return Toast.show('Please enter a valid city', context,
                      duration: 3);

                final model = AddressModel(
                    id: widget.addressModel?.id,
                    addressName: addressName,
                    addressLine1: addressLineCtrl1.text,
                    addressLine2: addressLineCtrl2.text,
                    state: stateCtrl.text,
                    pinCode: pinCodeCtrl.text,
                    city: cityCtrl.text,
                    alternateMob: alternateMobCtrl.text,
                    user: await Prefs.getUserId(),
                    landmark: landmarkCtrl.text);
                print(model.toMap());
                try {
                  LoadingWidget.showLoadingDialog(context);
                  widget.addressModel != null
                      ? await AddressRepo.editAddress(model)
                      : await AddressRepo.addAddress(model);
                  Navigator.pop(context);
                  Address.openReplacement(context);
                } catch (e) {
                  print(e);
                  Navigator.pop(context);
                  DialogBox.parseAndShowErrorDialog(context, e);
                }
              },
              child: Text('SAVE'),
            ),
            body: Form(
              key: formKey,
              child: ListView(
                controller: scrollCtrl,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Add Address',
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(color: Color(0xFF173A50)),
                    ),
                  ),
                  Divider(height: 32),
                  SizedBox(height: 12),
                  ListTile(
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'Address Line 1', style: textTheme.caption),
                          TextSpan(
                              text: '*', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                    subtitle: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      validator: (value) => value.trim().length > 0
                          ? null
                          : 'This field cannot be empty',
                      controller: addressLineCtrl1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: 'Tap to edit',
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  ListTile(
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'Address Line 2', style: textTheme.caption),
                          TextSpan(
                              text: '*', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                    subtitle: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      validator: (value) => value.trim().length > 0
                          ? null
                          : 'This field cannot be empty',
                      controller: addressLineCtrl2,
                      decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: 'Tap to edit'),
                    ),
                  ),
                  SizedBox(height: 12),
                  ListTile(
                    title: Text('Landmark', style: textTheme.caption),
                    subtitle: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: landmarkCtrl,
                      decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: 'Tap to edit'),
                    ),
                  ),
                  SizedBox(height: 12),
                  ListTile(
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'City', style: textTheme.caption),
                          TextSpan(
                              text: '*', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                    subtitle: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        textCapitalization: TextCapitalization.words,
                        controller: cityCtrl,
                        decoration: InputDecoration(
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: 'Tap to edit'),
                      ),
                      suggestionsCallback: (pattern) async {
                        return cities.where((data) => data.contains(pattern));
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(leading: Text(suggestion));
                      },
                      onSuggestionSelected: (suggestion) {
                        cityCtrl.text = suggestion;
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  ListTile(
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'Pincode', style: textTheme.caption),
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    subtitle: TextFormField(
                      validator: (val) => val.trim().length == 6
                          ? null
                          : 'Please enter a valid pin-code',
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      controller: pinCodeCtrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: 'Tap to edit',
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  ListTile(
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'State', style: textTheme.caption),
                          TextSpan(
                              text: '*', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                    subtitle: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        textCapitalization: TextCapitalization.words,
                        controller: stateCtrl,
                        decoration: InputDecoration(
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: 'Tap to edit'),
                      ),
                      suggestionsCallback: (pattern) async {
                        return states.where((data) => data.contains(pattern));
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(leading: Text(suggestion));
                      },
                      onSuggestionSelected: (suggestion) {
                        stateCtrl.text = suggestion;
                      },
                    ),
                  ),
                  SizedBox(height: 12),
                  ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Padding(
                        padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Address name',
                                  style: textTheme.caption),
                              TextSpan(
                                  text: '*',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Wrap(
                          spacing: 12,
                          children: List.generate(3, (int i) {
                            final key =
                                AddAddress.addressNames.keys.toList()[i];
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Radio(
                                  value: key,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  groupValue: addressName,
                                  onChanged: (value) =>
                                      setState(() => addressName = value),
                                ),
                                Text(
                                  AddAddress.addressNames[key],
                                  style: textTheme.subhead.copyWith(
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      )),
                  SizedBox(height: 12),
                  ListTile(
                    title: Text('Alternate Number', style: textTheme.caption),
                    subtitle: TextFormField(
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      controller: alternateMobCtrl,
                      decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: 'Tap to edit'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
