import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:artgen/components/syslog_count_chart.dart';

import '../../constants.dart';
import 'components/header.dart';

class HostDetailView extends StatefulWidget {
  HostDetailView({Key key, this.host}) : super(key: key);
  final host;

  @override
  State<HostDetailView> createState() => _HostDetailViewState();
}

class _HostDetailViewState extends State<HostDetailView> {
  // Host host = new Host(hostname: "No Host Selected", countSyslogs: 0);

  // setSelectedHost(host) {
  //   setState(() {
  //     this.host = host;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // return Iframe(host);
    return Scaffold(
      body: Container(
        color: Colors.white,
        //color: Colors.blueGrey, //Playing around with colours? Let's get functionality done first :p
        // color: Color(0x010429), //Why is this not working??
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
                      // Card(
                      //   elevation: 4,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(32),
                      //   ),
                      //   color: const Color(0xff020227),
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(top: 16),
                      //     child: SyslogCountChart(),
                      //   ),
                      // ),
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
                                        '${widget.host.hostname}',
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
                                      "Syslogs: ${widget.host.countSyslogs}",
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
              ),
              // Expanded(
              //     child: Column(children: [
              //   Text("Total Syslogs Per Minute"),
              //   Expanded(child: SyslogCountChart()),
              //   Text("Session Logs Per Minute"),
              //   Expanded(child: SyslogCountChart()),
              //   Text("ntd_app Syslogs Per Minute"),
              //   Expanded(child: SyslogCountChart())
              // ])),
              Text(
                  "Total Syslogs Per Minute\n"), //TODO: Fix not to need newline.. add column or something.. tidy above
              Expanded(child: SyslogCountChart()),
              Text("Session Logs Per Minute\n"),
              Expanded(child: SyslogCountChart()),
              Text("ntd_app Syslogs Per Minute\n"),
              Expanded(child: SyslogCountChart()),
            ],
          ),
        ),
      ),
    );
  }
}
