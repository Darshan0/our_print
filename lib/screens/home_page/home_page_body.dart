import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/hidden_drawer_controller.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import 'package:intl/intl.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/bloc/subscription_bloc.dart';
import 'package:ourprint/configuration_items.dart';
import 'package:ourprint/model/user_subscription_model.dart';
import 'package:ourprint/repository/subscription_repo.dart';
import 'package:ourprint/resources/images.dart';
import 'package:ourprint/screens/file_config_page/file_config.dart';
import 'package:ourprint/screens/home_page/widgets/home_card_new.dart';
import 'package:ourprint/screens/subscription_page/subscription_config.dart';
import 'package:ourprint/screens/subscription_page/subscription_plans.dart';
import 'package:ourprint/screens/user_profile/user_profile.dart';
import 'package:ourprint/widgets/error_widget.dart';
import 'package:ourprint/widgets/loading_widget.dart';
import 'package:ourprint/widgets/profile_image_from_net.dart';
import 'package:provider/provider.dart';

import 'widgets/freemium_card.dart';

class HomePageBody extends StatefulWidget {
  final SimpleHiddenDrawerBloc controller;
  final userImage;
  final AsyncSnapshot snap;
  final MenuState menuState;

  const HomePageBody(
      {Key key, this.controller, this.userImage, this.snap, this.menuState})
      : super(key: key);

  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  Future future;
  final dateFormat = DateFormat('dd MMM');

  Future<UserSubscriptionModel> getDetails() async {
    var response = await SubscriptionRepo.checkIfSubscribed();
    final subsBloc = Provider.of<SubscriptionBloc>(context, listen: false);
    subsBloc.setUserSubscription = response;
    return response;
  }

  @override
  void initState() {
    super.initState();
    future = getDetails();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    MenuState menuState = widget.menuState;
    final pdfBloc = Provider.of<PDFBloc>(context);
    final subsBloc = Provider.of<SubscriptionBloc>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Image.asset(Images.menuIcon),
          color: Theme.of(context).accentColor,
          onPressed: () {
            widget.controller.toggle();
          },
        ),
        actions: <Widget>[
          widget.userImage == null
              ? Container()
              : InkWell(
                  onTap: () => UserProfile.open(context),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0, top: 4),
                    child: ProfileImageFromNet(
                      errorRadius: 16,
                      imageUrl: widget.userImage,
                    ),
                  ),
                )
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20),
          FutureBuilder<UserSubscriptionModel>(
              future: future,
              builder: (context, snap) {
                if (snap.hasError) return CustomErrorWidget(error: snap.error);
                if (!snap.hasData) return LoadingWidget();
                if (subsBloc.userSubscription.haveSubscription == false)
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Material(
                      color: Theme.of(context).accentColor,
                      child: InkWell(
                        splashColor: Colors.black12,
                        highlightColor: Colors.black12,
                        onTap: () {
                          SubscriptionPlans.open(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Subscription',
                                style: textTheme.title.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Choose an plan and get extra benefits',
                                style: textTheme.caption.copyWith(
                                    fontWeight: FontWeight.w100,
                                    color: Colors.white.withOpacity(0.7)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 24, bottom: 8, left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Subscribed',
                          style: textTheme.title.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Subscribed on ${dateFormat.format(subsBloc.userSubscription.createdAt)}',
                          style:
                              textTheme.caption.copyWith(color: Colors.white54),
                        ),
                        Text(
                          'Valid till ${dateFormat.format(subsBloc.userSubscription.expireOn)}',
                          style:
                              textTheme.caption.copyWith(color: Colors.white54),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${subsBloc.userSubscription.pageLeft} Page counters left',
                          style:
                              textTheme.caption.copyWith(color: Colors.white54),
                        ),
                        SizedBox(height: 8),
                        Center(
                          child: SizedBox(
                            height: 40,
                            child: FractionallySizedBox(
                              child: OutlineButton(
                                onPressed: () {
                                  if (subsBloc.userSubscription.pageLeft <= 0)
                                    return;
                                  pdfBloc.setOrderType = OrderType.SUBSCRIPTION;
                                  SubscriptionConfig.open(
                                      context, subsBloc.userSubscription);
                                },
                                borderSide: BorderSide(color: Colors.white),
                                padding: EdgeInsets.zero,
                                child: Text(
                                  'UPLOAD FILES',
                                  style: textTheme.caption.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
          SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'What do you want to print today?',
                    style: textTheme.title.copyWith(color: Color(0xFF173A50)),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          SizedBox(height: 20),
          widget.snap.data['is_freemium_available'] == false
              ? Container()
              : FreemiumCard(),
          SizedBox(height: 12),
          HomeCard(
            title: 'Standard',
            subTitle: 'Unlimited Pages Colour, B&W, '
                'Multi Colour. Binding Configuration.',
            expansionTexts: [
              'Select Page, Print and Binding Configuration',
              'Review your order and pay',
              'Get it delivered in 2-3 business days',
              'Available in'
            ],
            button: OutlineButton(
              padding: EdgeInsets.all(12),
              onPressed: () async {
                pdfBloc.setOrderType = OrderType.STANDARD;
                FileConfig.open(context);
              },
              child: Text('Upload Files'),
            ),
            images: [
              ConfigurationItems.a4,
              ConfigurationItems.oneSided,
              ConfigurationItems.twoSided,
              ConfigurationItems.color,
              ConfigurationItems.bAndW,
              ConfigurationItems.spiralBind,
              ConfigurationItems.stapledCopy,
              ConfigurationItems.loosePapers,
            ],
          ),
          SizedBox(height: 12),
          HomeCard(
            title: 'Offical Documents',
            subTitle: 'Customisation of Covers. B&W and Colour.'
                ' Printing Instructions. ',
            expansionTexts: [
              'Use for Professional documentations',
              'Agreement copies',
              'B.Tech & M.Tech project books'
            ],
            button: OutlineButton(
              padding: EdgeInsets.all(12),
              onPressed: () async {
                print(menuState);
                if (menuState == MenuState.open) {
                  return widget.controller.toggle();
                }
                pdfBloc.setOrderType = OrderType.OFFICIAL_DOCUMENTS;
                FileConfig.open(context);
              },
              child: Text('Upload Files'),
            ),
            images: [],
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }
}
