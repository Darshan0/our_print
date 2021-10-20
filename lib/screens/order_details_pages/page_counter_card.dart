import 'package:flutter/material.dart';
import 'package:ourprint/bloc/subscription_bloc.dart';
import 'package:provider/provider.dart';

class PageCounterCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    final subsBloc = Provider.of<SubscriptionBloc>(context, listen: false);
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Colors.white,
        child: FractionallySizedBox(
          widthFactor: 0.7,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Page Counter deduction',
                      style: textTheme.caption,
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, size: 16),
                    )
                  ],
                ),
                Divider(height: 16),
                SizedBox(height: 12),
                ...List.generate(
                  subsBloc.getPageCounter.length,
                  (i) {
                    final name = subsBloc.getPageCounter.keys.toList()[i];
                    final count = subsBloc.getPageCounter.values.toList()[i];
                    return Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$name',
                            style: textTheme.bodyText1,
                          ),
                          Text(
                            '$count PC',
                            style: textTheme.bodyText1.copyWith(
                              fontWeight: FontWeight.w800,
                              color: theme.accentColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
