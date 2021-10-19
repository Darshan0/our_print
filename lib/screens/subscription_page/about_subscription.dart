import 'package:flutter/material.dart';
import 'package:ourprint/bloc/subs_purchase_bloc.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/model/dependent_config_price.dart';
import 'package:ourprint/model/subscription_model.dart';
import 'package:ourprint/repository/configuration_repo.dart';
import 'package:ourprint/widgets/error_widget.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class AboutSubscription extends StatefulWidget {
  final SubscriptionModel subscription;

  const AboutSubscription({Key key, this.subscription}) : super(key: key);

  static open(context, SubscriptionModel val) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AboutSubscription(subscription: val),
        ),
      );

  @override
  _AboutSubscriptionState createState() => _AboutSubscriptionState();
}

class _AboutSubscriptionState extends State<AboutSubscription> {
  int index = 0;
  Future future;
  List<ConfigurationModel> configs = [];

  Future<DependentConfigPrice> getDetails() async {
    final res = await ConfigurationsRepo.getDependentConfigPrice();
    configs = await ConfigurationsRepo.getConfigs();
    return res;
  }

  @override
  void initState() {
    super.initState();
    future = getDetails();
    final purchaseBloc = Provider.of<SubsPurchaseBloc>(context, listen: false);
    Future.delayed(Duration.zero).then((value) {
      purchaseBloc.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final purchaseBloc = Provider.of<SubsPurchaseBloc>(context);
    return FutureBuilder<DependentConfigPrice>(
      future: future,
      builder: (_, snap) {
        if (snap.hasError)
          return Material(child: CustomErrorWidget(error: snap.error));
        if (!snap.hasData) return Material(child: LoadingWidget());
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FractionallySizedBox(
            widthFactor: 0.9,
            child: RaisedButton(
              onPressed: () {
                purchaseBloc.createSubscriptionPlan(widget.subscription);
              },
              child: Text('BUY SUBSCRIPTION'),
            ),
          ),
          appBar: AppBar(),
          body: ListView(
            padding: EdgeInsets.all(20),
            children: [
              Text(
                '${widget.subscription.validForInMonths} Month plan',
                style: textTheme.title.copyWith(color: Color(0xFF173A50)),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: PlanDetails(
                  plan: widget.subscription,
                  dependentConfigPrice: snap.data,
                  configs: configs,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class PlanDetails extends StatelessWidget {
  final SubscriptionModel plan;
  final DependentConfigPrice dependentConfigPrice;
  final List<ConfigurationModel> configs;

  const PlanDetails(
      {Key key, this.plan, this.dependentConfigPrice, this.configs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'With this ${(plan.price).toInt()}/-plan you can be able '
          'to print ${plan.pageCounter} PC',
          style: textTheme.bodyText1.copyWith(
            color: theme.accentColor,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 20),
        Text('What is PC (Page Counter) ?', style: textTheme.caption),
        SizedBox(height: 8),
        Text(
          'PC is calculated with respect to the Print type and page '
          'type configurations.',
          style: textTheme.bodyText1,
        ),
        SizedBox(height: 12),
        Text(
          'You can print any number of print type i.e,Color or '
          'Black & White or Bond prints within the PC limit.',
          style: textTheme.bodyText1,
        ),
        SizedBox(height: 20),
        Text('Benefits', style: textTheme.caption),
        SizedBox(height: 8),
        Text('1. No Delivery Fee'),
        SizedBox(height: 8),
        Text('2. Unlimited spiral binding'),
        SizedBox(height: 20),
        Text('Note', style: textTheme.caption),
        SizedBox(height: 8),
        Text('1. Min. order limit is 20 pages'),
        SizedBox(height: 8),
        Text('2. ${plan.validForInMonths} Months validity'),
        SizedBox(height: 20),
        Text('Details', style: textTheme.caption),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('B/w Double side', style: textTheme.bodyText1),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: '${plan.blackWhiteDoubleSide} PC ',
                    style: textTheme.bodyText1
                        .copyWith(fontWeight: FontWeight.w900)),
                TextSpan(
                  text: '(${dependentConfigPrice.blackWhiteDoubleSide}/-paise)',
                  style: textTheme.bodyText1,
                )
              ]),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('B/w Single side', style: textTheme.bodyText1),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: '${plan.blackWhiteSingleSide} PC ',
                    style: textTheme.bodyText1
                        .copyWith(fontWeight: FontWeight.w900)),
                TextSpan(
                  text: '(${dependentConfigPrice.blackWhiteSingleSide}/-paise)',
                  style: textTheme.bodyText1,
                )
              ]),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Color Double side', style: textTheme.bodyText1),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: '${plan.colorDoubleSide} PC ',
                    style: textTheme.bodyText1
                        .copyWith(fontWeight: FontWeight.w900)),
                TextSpan(
                  text: '(${dependentConfigPrice.colorDoubleSide}/-paise)',
                  style: textTheme.bodyText1,
                )
              ]),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Color Single side', style: textTheme.bodyText1),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: '${plan.colorSingleSide} PC ',
                    style: textTheme.bodyText1
                        .copyWith(fontWeight: FontWeight.w900)),
                TextSpan(
                  text: '(${dependentConfigPrice.colorSingleSide}/-paise)',
                  style: textTheme.bodyText1,
                )
              ]),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Bond Paper', style: textTheme.bodyText1),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: '${plan.bondColorSingleSide} PC ',
                    style: textTheme.bodyText1
                        .copyWith(fontWeight: FontWeight.w900)),
                TextSpan(
                  text: '(5/-paise)',
                  style: textTheme.bodyText1,
                )
              ]),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: theme.accentColor),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Subscription Price', style: textTheme.caption),
                SizedBox(height: 8),
                Text(
                  '₹ ${plan.price}',
                  style: textTheme.title.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: theme.accentColor,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        Text('Subscription mode', style: textTheme.caption),
        SizedBox(height: 8),
        Text('CA Officials', style: textTheme.bodyText1),
        SizedBox(height: 8),
        Text('Schools', style: textTheme.bodyText1),
        SizedBox(height: 8),
        Text('Universities', style: textTheme.bodyText1),
        SizedBox(height: 50)
      ],
    );
  }
}

class TwelveMonthPlan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
            'eiusmod tempor incididunt ut labore et dolore magna aliqua. Sapien '
            'nec sagittis aliquam malesuada bibendum arcu vitae elementum '
            'curabitur. Mauris pelle ntesque pulvinar pellentesque habitant '
            'morbi.',
            style: textTheme.caption,
          ),
          SizedBox(height: 20),
          Text('B/W', style: textTheme.caption),
          SizedBox(height: 8),
          Text('Double sided - 3200 pages', style: textTheme.bodyText1),
          SizedBox(height: 8),
          Text('Single sided - 3000 pages', style: textTheme.bodyText1),
          SizedBox(height: 20),
          Text('Color', style: textTheme.caption),
          SizedBox(height: 8),
          Text('Double sided - 500 pages', style: textTheme.bodyText1),
          SizedBox(height: 8),
          Text('Single sided - 400 pages', style: textTheme.bodyText1),
          SizedBox(height: 20),
          Text('Executive Bond', style: textTheme.caption),
          SizedBox(height: 8),
          Text('500 pages - Single or Double-sided',
              style: textTheme.bodyText1),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: theme.accentColor),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Subscription Price', style: textTheme.caption),
                  SizedBox(height: 8),
                  Text(
                    '₹ 1999',
                    style: textTheme.title.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: theme.accentColor,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Text('Subscription mode', style: textTheme.caption),
          SizedBox(height: 8),
          Text('CA Officials', style: textTheme.bodyText1),
          SizedBox(height: 8),
          Text('Schools', style: textTheme.bodyText1),
          SizedBox(height: 8),
          Text('Universities', style: textTheme.bodyText1),
        ],
      ),
    );
  }
}
