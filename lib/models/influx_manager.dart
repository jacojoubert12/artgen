import 'package:influxdb_client/api.dart';
import 'package:artgen/auth_gate.dart';
import 'package:artgen/models/mood.dart';

class InfluxManager {
  InfluxManager();

  void updateMoodValue(Mood mood, {DateTime? backDate = null}) async {
    var client = InfluxDBClient(
        url: 'http://68.183.44.212:8087',
        token:
            '1qJX4g1r0LJehTx-TMnI0hFHyfow5KcewN1YGAyj6OLoUINTS9cPrqVTEE2Tifcl7miAnrUhSAkZYYOqGyKY_A==',
        org: 'Enginosoft',
        bucket: 'artgen');

    if (backDate != null) backDate = DateTime.now().toUtc();

    var writeApi = WriteService(client);

    var point = Point('moodtracker')
        .addTag('userID', user!.uid)
        .addTag('moodID', mood.moodID.toString())
        .addField("moodValue", mood.moodValue)
        .time(backDate);

    await writeApi.write(point).then((value) {
      print('Write completed 1');
    }).catchError((exception) {
      // error block
      print("Handle write error here!");
      print(exception);
    });
  }

  // Future getHostData() async {
  //   var count = 0;
  //   var client = getClient();

  //   var queryService = client.getQueryService();
  //   var recordStream = await queryService.query('''
  //     from(bucket: "telegraf")
  //         |> range(start: -10m, stop: 0m)
  //         |> filter(fn: (r) => r["_measurement"] == "syslog")
  //         |> group(columns: ["hostname"])
  //         |> count()
  //         |> group()
  //     ''');

  //   await recordStream.forEach((record) {
  //     developer.log(
  //         'record: ${count++} : ${record['hostname']} ${record['_value']}');
  //     // hostNames.add(record['hostname']);
  //     hostsFactory.add(
  //         Host(hostname: record['hostname'], countSyslogs: record['_value']));
  //   });
  //   client.close();
  //   developer.log('Host factory lenght,${hostsFactory.length}');
  //   return hostsFactory;
  // }

}
