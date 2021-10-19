import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ourprint/bloc/subs_purchase_bloc.dart';
import 'package:ourprint/model/subscription_model.dart';
import 'package:ourprint/repository/subscription_repo.dart';
import 'package:ourprint/screens/subscription_page/about_subscription.dart';
import 'package:ourprint/widgets/error_widget.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class Subscriptions extends StatefulWidget {
  static open(context) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Subscriptions()),
      );

  @override
  _SubscriptionsState createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    final purchaseBloc = Provider.of<SubsPurchaseBloc>(context, listen: false);
    Future.delayed(Duration.zero).then((value) {
      purchaseBloc.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final purchaseBloc = Provider.of<SubsPurchaseBloc>(context);
    return FutureBuilder<List<SubscriptionModel>>(
        future: SubscriptionRepo.getSubscriptions(),
        builder: (context, snap) {
          if (snap.hasError)
            return Material(child: CustomErrorWidget(error: snap.error));
          if (!snap.hasData) return Material(child: LoadingWidget());
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subscriptions',
                    style: textTheme.title.copyWith(color: Color(0xFF173A50)),
                  ),
                  SizedBox(height: 8),
                  Flexible(
                    child: ListView.builder(
                      itemCount: snap.data.length,
                      itemBuilder: (_, index) {
                        final plan = snap.data[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              AboutSubscription.open(context, plan);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '₹ ${plan.price}',
                                    style: textTheme.subtitle1.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: theme.accentColor,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${plan.validForInMonths} Month plan',
                                    style: textTheme.bodyText1.copyWith(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
