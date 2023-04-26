import 'dart:async';
import 'dart:convert';

import 'package:artgen/views/main/main_view.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef WebSocketCallback = void Function(String message);

class MyWebsockets {
  WebSocketCallback? onMessageReceived;
  WebSocketChannel? webSocketChannel;
  bool _explicitClose = false;
  bool _reconnecting = false;
  String _topic = '';
  bool _didDisconnect = false;
  String lastSub = '';

  MyWebsockets._internal({this.onMessageReceived}) {
    _setupWSClient();
  }

  factory MyWebsockets({WebSocketCallback? onMessageReceived, String? topic}) {
    MyWebsockets instance =
        MyWebsockets._internal(onMessageReceived: onMessageReceived);
    if (topic != null) {
      print("subscribing to ${topic}");
      instance._subscribeToTopic(topic);
      instance._topic = topic;
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
        print("WS Response:");
        if (onMessageReceived != null) {
          onMessageReceived!(event);
        }
      },
      onError: (error) {
        print('Websocket Error: $error');
        _reconnectWS();
      },
      onDone: () {
        print('WebSocket disconnected.');
        _reconnectWS();
      },
    );

    if (_topic.isNotEmpty) {
      _subscribeToTopic("img-gen-url-res-${user.selectedModel}");
      _didDisconnect = false;
    }

    Timer.periodic(Duration(seconds: 5), (timer) {
      if (webSocketChannel == null || webSocketChannel!.closeCode != null) {
        _didDisconnect = true;
        print("Websocket Disconnected - Cancel Timer");
        _reconnectWS();
        // timer.cancel();
      } else {
        print("Websocket Send Ping");
        if (_didDisconnect || lastSub != user.selectedModel) {
          _subscribeToTopic("img-gen-url-res-${user.selectedModel}");
        }
        lastSub = user.selectedModel; //Todo Rather make listener
        webSocketChannel?.sink.add(jsonEncode({'type': 'ping'}));
      }
    });
  }

  void _reconnectWS() {
    if (!_explicitClose && !_reconnecting) {
      _reconnecting = true;
      Future.delayed(Duration(seconds: 5), () {
        print("Websocket reconecting...");
        _wsConnect().then((_) {
          _reconnecting = false;
          if (_didDisconnect) {
            _subscribeToTopic(_topic);
          }
        });
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

  bool get isOpen =>
      webSocketChannel != null && webSocketChannel!.closeCode == null;

  void close() {
    _explicitClose = true;
    webSocketChannel?.sink.close();
  }
}
