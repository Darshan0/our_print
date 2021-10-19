import 'package:flutter/material.dart';
import 'package:ourprint/bloc/pdf_bloc.dart';
import 'package:ourprint/bloc/subs_purchase_bloc.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'bloc/subscription_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var chatBloc = PDFBloc();
  var subscriptionBloc = SubscriptionBloc();
  var purchaseBloc = SubsPurchaseBloc();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider<PDFBloc>.value(value: chatBloc),
      ChangeNotifierProvider<SubscriptionBloc>.value(value: subscriptionBloc),
      ChangeNotifierProvider<SubsPurchaseBloc>.value(value: purchaseBloc),
    ], child: MyApp()),
  );
}
