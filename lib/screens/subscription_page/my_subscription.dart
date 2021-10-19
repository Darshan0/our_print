import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ourprint/model/user_subscription_model.dart';
import 'package:ourprint/repository/subscription_repo.dart';
import 'package:ourprint/screens/subscription_page/subscriptions.dart';
import 'package:ourprint/widgets/error_widget.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:pie_chart/pie_chart.dart';

class MySubscription extends StatefulWidget {
  static open(context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MySubscription()),
      );

  @override
  _MySubscriptionState createState() => _MySubscriptionState();
}

class _MySubscriptionState extends State<MySubscription> {
  Future<UserSubscriptionModel> future;
  final dateFormat = DateFormat('dd MMM, yyyy');
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    future = SubscriptionRepo.checkIfSubscribed();
    future.then((value) {
      if (value.haveSubscription == false) {
        Subscriptions.open(context);
      } else {
        isLoaded = true;
        if (mounted) setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<UserSubscriptionModel>(
          future: future,
          builder: (context, snap) {
            if (snap.hasError) return CustomErrorWidget(error: snap.error);
            if (!snap.hasData || (!isLoaded)) return LoadingWidget();
            final used = 100 -
                (snap.data.pageLeft / snap.data.subscription.pageCounter * 100)
                    .toInt();
            print(used / 10);
            return ListView(
              padding: EdgeInsets.all(20),
              children: [
                Text(
                  'My Subscription',
                  style: textTheme.title.copyWith(color: Color(0xFF173A50)),
                ),
                SizedBox(height: 20),
                Center(
                  child: PieChart(
                    dataMap: {'used': (used / 10), 'unused': 10 - (used / 10)},
                    colorList: [theme.accentColor, theme.primaryColor],
                    chartRadius: 200,
                    chartValuesOptions:
                        ChartValuesOptions(showChartValues: false),
                    legendOptions: LegendOptions(
                        showLegends: false, legendPosition: LegendPosition.top),
                  ),
                ),
                Center(
                  child: Text(
                    '${snap.data.pageLeft} Page counter used',
                    style: textTheme.bodyText1.copyWith(fontSize: 15),
                  ),
                ),
                SizedBox(height: 4),
                Center(
                  child: Text(
                    '$used% used',
                    style: textTheme.caption,
                  ),
                ),
                SizedBox(height: 44),
                ListTile(
                  contentPadding: EdgeInsets.only(top: 20),
                  title: Text(
                    'Plan',
                    style: textTheme.caption,
                  ),
                  subtitle: Text(
                    '${snap.data.subscription.price} /- plan',
                    style: textTheme.bodyText1,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(top: 0),
                  title: Text(
                    'Subscribed date',
                    style: textTheme.caption,
                  ),
                  subtitle: Text(
                    '${dateFormat.format(snap.data.createdAt)}',
                    style: textTheme.bodyText1,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(top: 0),
                  title: Text(
                    'Expiry date',
                    style: textTheme.caption,
                  ),
                  subtitle: Text(
                    '${dateFormat.format(snap.data.expireOn)}',
                    style: textTheme.bodyText1,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(top: 0),
                  title: Text(
                    'Subscription Validity',
                    style: textTheme.caption,
                  ),
                  subtitle: Text(
                    '${snap.data.subscription.validForInMonths} Months',
                    style: textTheme.bodyText1,
                  ),
                ),
              ],
            );
          }),
    );
  }
}
