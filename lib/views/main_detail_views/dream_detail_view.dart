import 'dart:developer' as developer;
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/header.dart';

class DreamsDetailView extends StatefulWidget {
  DreamsDetailView({Key key}) : super(key: key);
  // final dream;

  @override
  State<DreamsDetailView> createState() => _DreamsDetailViewState();
}

class _DreamsDetailViewState extends State<DreamsDetailView> {
  @override
  Widget build(BuildContext context) {
    // return Iframe(dream);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Header(),
              Divider(thickness: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(kDefaultPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        maxRadius: 24,
                        backgroundColor: Colors.transparent,
                        // backgroundImage: AssetImage(emails[1].image),
                      ),
                      SizedBox(width: kDefaultPadding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'bleh',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: kDefaultPadding / 2),
                                Text(
                                  DateTime.now().toString(),
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ],
                            ),
                            SizedBox(height: kDefaultPadding),
                            LayoutBuilder(
                              builder: (context, constraints) => SizedBox(
                                width: constraints.maxWidth > 850
                                    ? 800
                                    : constraints.maxWidth,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      // "Syslogs: ${widget.dream.countSyslogs}",
                                      "Todo: Replace this text",
                                      style: TextStyle(
                                        height: 1.5,
                                        color: Color(0xFF4D5875),
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    SizedBox(height: kDefaultPadding),
                                    Divider(thickness: 1),
                                    SizedBox(height: kDefaultPadding / 2),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
