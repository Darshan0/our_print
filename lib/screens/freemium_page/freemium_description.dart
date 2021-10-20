import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourprint/data/local/shared_prefs.dart';
import 'package:ourprint/model/order_model.dart';
import 'package:ourprint/repository/user_repo.dart';
import 'package:ourprint/screens/freemium_page/freemium_page.dart';
import 'package:ourprint/screens/orders_page/order_tracking.dart';
import 'package:ourprint/widgets/error_widget.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:ourprint/widgets/progress_view.dart';
import 'package:toast/toast.dart';

class FreemiumDescription extends StatefulWidget {
  static open(context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FreemiumDescription()),
      );

  @override
  _FreemiumDescriptionState createState() => _FreemiumDescriptionState();
}

class _FreemiumDescriptionState extends State<FreemiumDescription> {
  Future<List<OrderModel>> future;
  DateTime userCreatedAt;

  Future<List<OrderModel>> getDetails() async {
    userCreatedAt = DateTime.tryParse(
        await Prefs.getUserCreatedAt() ?? DateTime.now().toString());
    return UserRepo.getFreemiumUsage("True");
  }

  @override
  void initState() {
    super.initState();
    future = getDetails();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return FutureBuilder<List<OrderModel>>(
        future: future,
        builder: (context, snap) {
          if (snap.hasError)
            return Material(child: CustomErrorWidget(error: snap.error));
          if (!snap.hasData) return Material(child: LoadingWidget());
          var monthsLen = (DateTime.now().month - userCreatedAt.month) + 1;

          return Scaffold(
            appBar: AppBar(),
            body: ListView(
              padding: EdgeInsets.all(20),
              children: <Widget>[
                Text(
                  'What is a Freemium print by\nOurPrint?',
                  style: textTheme.title.copyWith(color: Color(0xFF173A50)),
                ),
                SizedBox(height: 24),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit,'
                  ' sed do eiusmod tempor  incididunt ut  labore et dolore '
                  'magna aliqua. Sapien  nec  sagittis  aliquam malesuada '
                  'bibendum arcu vitae elementum curabitur. Mauris pelle '
                  'ntesque pulvinar pellentesque habitant morbi. ',
                  style: textTheme.caption.copyWith(
                    fontWeight: FontWeight.w100,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Details',
                  style: textTheme.title.copyWith(color: Color(0xFF173A50)),
                ),
                SizedBox(height: 20),
                Text(
                  '* Free upto 100 Pages',
                  style: textTheme.caption.copyWith(
                    fontWeight: FontWeight.w100,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '* Maximum 150 pages',
                  style: textTheme.caption.copyWith(
                    fontWeight: FontWeight.w100,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '* Delivery charge applicable',
                  style: textTheme.caption.copyWith(
                    fontWeight: FontWeight.w100,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '* Contains Ads',
                  style: textTheme.caption.copyWith(
                    fontWeight: FontWeight.w100,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Freemium Usage',
                  style: textTheme.title.copyWith(color: Color(0xFF173A50)),
                ),
                SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                    monthsLen,
                    (int index) {
                      var position = 0;
                      var freemiumDate = DateTime.parse(
                          '${userCreatedAt.year}-${(userCreatedAt.month + index).toString().padLeft(2, '0')}-${userCreatedAt.day}');

                      var orderDate = snap.data
                          .firstWhere((data) {
                            return data.createdAt.month == freemiumDate.month &&
                                data.createdAt.year == freemiumDate.year;
                          }, orElse: () => null)
                          ?.createdAt
                          ?.toLocal();
                      if (orderDate != null) position = index;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ProgressView(
                                index: index,
                                position: position,
                                length: monthsLen,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        DateFormat('MMMM').format(freemiumDate),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        orderDate == null
                                            ? 'Not Ordered'
                                            : 'Ordered on ${DateFormat('dd MMM, yyyy').format(orderDate)}',
                                        style: textTheme.caption.copyWith(
                                            fontWeight: FontWeight.w100,
                                            color:
                                                Colors.black.withOpacity(0.7)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          orderDate == null &&
                                  freemiumDate.month == DateTime.now().month
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: RaisedButton(
                                    onPressed: () {
                                      Toast.show('COMING SOON', context);
//                                      return FreemiumPage.openReplacement(context);
                                    },
                                    child: Text('ORDER NOW'),
                                  ),
                                )
                              : Container()
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          );
        });
  }
}
