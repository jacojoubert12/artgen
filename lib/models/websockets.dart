import 'dart:convert';

import 'package:artgen/views/main/main_view.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef WebSocketCallback = void Function(String message);

class MyWebsockets {
  WebSocketCallback? onMessageReceived;
  WebSocketChannel? webSocketChannel;
  bool _explicitClose = false; // Add this flag

  MyWebsockets._internal({this.onMessageReceived}) {
    _setupWSClient();
  }

  factory MyWebsockets({WebSocketCallback? onMessageReceived, String? topic}) {
    MyWebsockets instance =
        MyWebsockets._internal(onMessageReceived: onMessageReceived);
    if (topic != null) {
      print("subscribing to ${topic}");
      instance._subscribeToTopic(topic);
    }
    return instance;
  }

  Future<void> _wsConnect() async {
    print("Connecting to WebSocket");

    webSocketChannel = WebSocketChannel.connect(
      Uri.parse('wss://ws.artgen.fun:8765'),
    );
    webSocketChannel!.stream.listen(
      (event) {
        // print("WS Response:");
        if (onMessageReceived != null) {
          onMessageReceived!(event);
        }
      },
      onError: (error) {
        print('Error: $error');
        _reconnectWS();
      },
      onDone: () {
        print('WebSocket disconnected.');
        _reconnectWS();
      },
    );
  }

  void _reconnectWS() {
    if (!_explicitClose) {
      // Check if the close was explicit before reconnecting
      Future.delayed(Duration(seconds: 2), () {
        _wsConnect();
      });
    }
  }

  void _subscribeToTopic(String topic) {
    webSocketChannel?.sink
        .add(json.encode({'uid': user.user!.uid, 'subscribe': topic}));
  }

  void sendMessage(var query) {
    webSocketChannel?.sink.add(jsonEncode(query));
  }

  Future<void> _setupWSClient() async {
    await _wsConnect();
  }

  void close() {
    _explicitClose = true;
    webSocketChannel?.sink.close();
  }
}
