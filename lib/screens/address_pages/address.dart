import 'package:flutter/material.dart';
import 'package:ourprint/model/address_model.dart';
import 'package:ourprint/model/order_model.dart';
import 'package:ourprint/repository/address_repo.dart';
import 'package:ourprint/screens/address_pages/add_address.dart';
import 'package:ourprint/screens/order_details_pages/order_review.dart';
import 'package:ourprint/utils/error_handling.dart';
import 'package:ourprint/widgets/dialog_boxes.dart';
import 'package:ourprint/widgets/error_snackbar.dart';
import 'package:ourprint/widgets/error_widget.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:toast/toast.dart';

class Address extends StatefulWidget {
  static final Map<String, String> statuses = {
    'home': 'Home',
    'work': 'Work',
    'others': 'Others',
  };

  const Address({Key key}) : super(key: key);

  static open(context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Address()),
      );

  static openReplacement(context) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Address()),
      );

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  int addressId;

  @override
  void initState() {
    super.initState();
    future = AddressRepo.getAddress();
    future.then((value) {
      if (value.isEmpty) return;
      addressId = value.first.id;
      setState(() {});
    });
  }

  Future<List<AddressModel>> future;

  @override
  Widget build(BuildContext context) {
    final texTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    return FutureBuilder<List<AddressModel>>(
        future: future,
        builder: (context, snap) {
          if (snap.hasError)
            return Material(child: CustomErrorWidget(error: snap.error));
          if (!snap.hasData) return Material(child: LoadingWidget());
          final models = snap.data;
          return Scaffold(
            appBar: AppBar(),
            floatingActionButton: models.isEmpty
                ? Container()
                : FractionallySizedBox(
                    widthFactor: 0.9,
                    child: RaisedButton(
                      onPressed: () {
                        final result = OrderModel().add(
                          model: OrderModel(),
                          address: addressId,
                        );
                        print(result.toMap());
                        OrderReview.open(
                          context,
                          result,
                          address: addressId,
                        );
                      },
                      child: Text('DELIVER TO THIS ADDRESS'),
                    ),
                  ),
            body: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Addresses',
                          style:
                              texTheme.title.copyWith(color: Color(0xFF173A50)),
                        ),
                        InkWell(
                          onTap: () {
                            AddAddress.openReplacement(context);
                          },
                          child: Text(
                            'ADD NEW',
                            style: texTheme.subtitle2.copyWith(
                                color: theme.accentColor,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  models.length == 0
                      ? Flexible(
                          child: Center(
                            child: Text(
                              'No Addresses Found!',
                              style: texTheme.headline,
                            ),
                          ),
                        )
                      : Flexible(
                          child: ListView.builder(
                            itemCount: models.length,
                            itemBuilder: (context, int index) {
                              AddressModel model = models[index];
                              return Container(
                                color: addressId == model.id
                                    ? theme.primaryColor
                                    : null,
                                child: ListTile(
                                  onTap: () {
                                    addressId = model.id;
                                    setState(() {});
                                  },
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 8,
                                  ),
                                  title: Text(
                                    '${model.addressName?.length == 0 ? 'NA' : AddAddress.addressNames[model.addressName] ?? model.addressName}',
                                    style: texTheme.title.copyWith(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      '${model.addressLine1}, ${model.addressLine2}.'
                                      ' ${model.landmark.length == 0 ? '' : 'Near ${model.landmark}'}\n'
                                      '${model.city ?? ''}, ${model.state} - ${model.pinCode}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w100,
                                          color: Color(0xFF3E3E3E)),
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16.0),
                                        child: InkWell(
                                          child: Icon(
                                            Icons.edit,
                                            size: 20,
                                            color:
                                                Theme.of(context).accentColor,
                                          ),
                                          onTap: () =>
                                              AddAddress.openReplacement(
                                                  context,
                                                  addressModel: models[index]),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16.0),
                                        child: InkWell(
                                            child: Icon(
                                              Icons.delete,
                                              size: 20,
                                              color: Colors.redAccent
                                                  .withOpacity(0.8),
                                            ),
                                            onTap: () => _showDeleteConfirmBox(
                                                model.id)),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          );
        });
  }

  _showDeleteConfirmBox(int addressId) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Are your sure you want to delete this address?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => _deleteAddress(context, addressId),
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'No',
                  style: TextStyle(color: Theme.of(context).accentColor),
                ),
              )
            ],
          ));

  _deleteAddress(context, int addressId) async {
    LoadingWidget.showLoadingDialog(context);
    try {
      await AddressRepo.deleteAddress(addressId);
      future = AddressRepo.getAddress();
      future.then((value) {
        setState(() {});
      });
      Navigator.pop(context);
    } catch (e) {
      print(e);
      DialogBox.parseAndShowErrorDialog(context, e);
    }
    Navigator.pop(context);
  }
}
