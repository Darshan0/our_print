import 'package:flutter/material.dart';
import 'package:ourprint/bloc/subs_purchase_bloc.dart';
import 'package:ourprint/model/configuration_model.dart';
import 'package:ourprint/model/dependent_config_price.dart';
import 'package:ourprint/model/subscription_model.dart';
import 'package:ourprint/repository/configuration_repo.dart';
import 'package:ourprint/repository/subscription_repo.dart';
import 'package:ourprint/widgets/error_widget.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class SubscriptionPlans extends StatefulWidget {
  final bool isExtending;

  const SubscriptionPlans({Key key, this.isExtending = false})
      : super(key: key);

  static open(context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SubscriptionPlans()),
      );

  @override
  _SubscriptionPlansState createState() => _SubscriptionPlansState();
}

class _SubscriptionPlansState extends State<SubscriptionPlans> {
  final int len = 2;
  Future future;
  List<ConfigurationModel> configs = [];
  DependentConfigPrice dependentConfigPrice;

  Future<List<SubscriptionModel>> getDetails() async {
    final res = await SubscriptionRepo.getSubscriptions();
    dependentConfigPrice = await ConfigurationsRepo.getDependentConfigPrice();
    configs = await ConfigurationsRepo.getConfigs();
    return res;
  }

  @override
  void initState() {
    super.initState();
    future = getDetails();
    final subsPurchaseBloc =
        Provider.of<SubsPurchaseBloc>(context, listen: false);
    Future.delayed(Duration.zero).then((value) {
      subsPurchaseBloc.init(context, isExtending: widget.isExtending);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final purchaseBloc = Provider.of<SubsPurchaseBloc>(context);
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<SubscriptionModel>>(
          future: future,
          builder: (context, snap) {
            if (snap.hasError) return CustomErrorWidget(error: snap.error);
            if (!snap.hasData) return LoadingWidget();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Choose a plan',
                    style: textTheme.title.copyWith(color: Color(0xFF173A50)),
                  ),
                ),
                SizedBox(height: 24),
                Flexible(
                  child: ListView.separated(
                      separatorBuilder: (_, i) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Divider(
                              endIndent: 8,
                              height: 32,
                            )),
                            Text('OR', style: textTheme.caption),
                            Expanded(child: Divider(indent: 8)),
                          ],
                        );
                      },
                      itemCount: snap.data.length,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      itemBuilder: (context, index) {
                        final plan = snap.data[index];
                        return Card(
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(vertical: 12),
                          child: InkWell(
                            onTap: () {
                              purchaseBloc.createSubscriptionPlan(plan);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Text(
                                      '${plan.name}',
                                      style: textTheme.bodyText2.copyWith(
                                        color: theme.accentColor,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('B/w Double side',
                                            style: textTheme.bodyText1),
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text:
                                                    '${plan.blackWhiteDoubleSide} PC ',
                                                style: textTheme.bodyText1
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w900)),
                                            TextSpan(
                                              text:
                                                  '(${dependentConfigPrice.blackWhiteDoubleSide}/-paise)',
                                              style: textTheme.bodyText1,
                                            )
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('B/w Single side',
                                            style: textTheme.bodyText1),
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text:
                                                    '${plan.blackWhiteSingleSide} PC ',
                                                style: textTheme.bodyText1
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w900)),
                                            TextSpan(
                                              text:
                                                  '(${dependentConfigPrice.blackWhiteSingleSide}/-paise)',
                                              style: textTheme.bodyText1,
                                            )
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Color Double side',
                                            style: textTheme.bodyText1),
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text:
                                                    '${plan.colorDoubleSide} PC ',
                                                style: textTheme.bodyText1
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w900)),
                                            TextSpan(
                                              text:
                                                  '(${dependentConfigPrice.colorDoubleSide}/-paise)',
                                              style: textTheme.bodyText1,
                                            )
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Color Single side',
                                            style: textTheme.bodyText1),
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text:
                                                    '${plan.colorSingleSide} PC ',
                                                style: textTheme.bodyText1
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w900)),
                                            TextSpan(
                                              text:
                                                  '(${dependentConfigPrice.colorSingleSide}/-paise)',
                                              style: textTheme.bodyText1,
                                            )
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Bond Paper',
                                            style: textTheme.bodyText1),
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text:
                                                    '${plan.bondColorSingleSide} PC ',
                                                style: textTheme.bodyText1
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w900)),
                                            TextSpan(
                                              text:
                                                  '(${configs.firstWhere((element) => element.title.contains('Bond Paper')).price}/-paise)',
                                              style: textTheme.bodyText1,
                                            )
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Container(
                                    width: double.infinity,
                                    color: theme.accentColor,
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Center(
                                      child: Text(
                                        '₹ ${plan.price}',
                                        style: textTheme.subtitle1.copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            );
          }),
    );
  }
}
