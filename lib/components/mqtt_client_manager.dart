/*
 * Package : mqtt_client
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 31/05/2017
 * Copyright :  S.Hamblett
 */

import 'dart:async';
import 'dart:io';
import 'package:artgen/views/main/main_view.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';

class MQTTClientManager {
  MqttBrowserClient client = MqttBrowserClient.withPort(
      'ws://68.183.44.212:1883', 'mobile_client', 1883);

  Future<int> connect() async {
    client.logging(on: true);
    client.keepAlivePeriod = 3600;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;

    final connMessage =
        MqttConnectMessage().startClean().withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;

    while (true) {
      try {
        await client.connect();
        break; // break out of the loop if connection is successful
      } on NoConnectionException catch (e) {
        print('MQTTClient::Client exception - $e');
        client.disconnect();
      } on SocketException catch (e) {
        print('MQTTClient::Socket exception - $e');
        client.disconnect();
      }

      await Future.delayed(
          Duration(seconds: 1)); // wait for 1 second before retrying
    }

    return 0;
  }

  void disconnect() {
    client.disconnect();
  }

  void subscribe(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);
  }

  void onConnected() {
    print('MQTTClient::Connected');
  }

  void onDisconnected() {
    print('MQTTClient::Disconnected');
  }

  void onSubscribed(String topic) {
    print('MQTTClient::Subscribed to topic: $topic');
  }

  void pong() {
    print('MQTTClient::Ping response received');
  }

  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>>? getMessagesStream() {
    return client.updates;
  }
}
