# websocket_tester

A small Flutter app I wrote to try out WebSockets: connect to a socket, keep listening, show every incoming message in a list, and reconnect on its own when the connection drops.

## What it does

- The first screen has a single button that opens the listener screen.
- The listener screen (`lib/new_screen.dart`) connects with `dart:io`'s `WebSocket` and appends each message it receives to a `ListView`, numbered in arrival order. It shows "NOTHING HERE" until the first message arrives.
- When the socket closes, it retries every 4 seconds until it gets a connection back.

The socket URL is hardcoded and points at a PieSocket demo channel. Change the `url` field in `lib/new_screen.dart` to use your own server.

There is also some code that isn't wired into the UI:

- `lib/main.dart` has a `connectWebSocket()` method using `web_socket_channel` with a 3 second reconnect timer. It is never called.
- `lib/websocket_class.dart` has a singleton `NotificationController` that rebroadcasts socket messages through a `StreamController`. Nothing uses it yet.

The app only listens. Sending messages from the UI is not implemented.

## Stack

- Flutter (beta channel, Dart SDK `>=2.17.0-69.2.beta`), May 2022
- `web_socket_channel` ^2.1.0
- Android and iOS targets only. It uses `dart:io`, so it won't run on Flutter web.

## Running it

```
flutter pub get
flutter run
```

It was built against a 2022 Flutter beta and hasn't been updated since, so a current SDK may need some changes.

## Notes

`test/widget_test.dart` is still the default counter test from `flutter create` and will fail against this app. `dbcrypt` is listed in `pubspec.yaml` but not used.
