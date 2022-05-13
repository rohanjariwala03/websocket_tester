import 'dart:async';
import 'dart:io';

class NotificationController {

  static final NotificationController _singleton = NotificationController._internal();

  StreamController<String> streamController = StreamController.broadcast(sync: true);

  String wsUrl = 'wss://demo.piesocket.com/v3/channel_1?api_key=VCXCEuvhGcBDP7XhiJJUDvR1e1D3eiVjgZ9VRiaV&notify_self';

  late WebSocket channel;

  factory NotificationController() {
    return _singleton;
  }

  NotificationController._internal() {
    initWebSocketConnection();
  }

  initWebSocketConnection() async {
    print("connecting...");
    channel = await connectWs();
    print("socket connection initialized");
    channel.done.then((dynamic _) => _onDisconnected());
    broadcastNotifications();
  }

  broadcastNotifications() {
    channel.listen((streamData) {
      print("listening  " + streamData.toString());
      streamController.add(streamData);
    }, onDone: () {
      print("connecting aborted");
      initWebSocketConnection();
    }, onError: (e) {
      print('Server error: $e');
      initWebSocketConnection();
    });
  }

  connectWs() async{
    try {
      print("connect to web socket");
      return await WebSocket.connect(wsUrl);
    } catch  (e) {
      print("Error! can not connect WS connectWs " + e.toString());
      await Future.delayed(const Duration(milliseconds: 10000));
      return await connectWs();
    }

  }

  void _onDisconnected() {
    print("disconnected");
    initWebSocketConnection();
  }
}