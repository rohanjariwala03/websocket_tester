import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:websocket_tester/new_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

WebSocketChannel channel = WebSocketChannel.connect(
  Uri.parse("wss://demo.piesocket.com/v3/channel_1?api_key=VCXCEuvhGcBDP7XhiJJUDvR1e1D3eiVjgZ9VRiaV&notify_self"),
);

class _MyHomePageState extends State<MyHomePage> {
  late StreamSubscription subscription;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    //connectWebSocket();
  }

  bool initialize=false;
  bool timerRunning=false;
  bool runMethod=true;

  void connectWebSocket(){

    //channel.sink.close();

    try {
      channel = WebSocketChannel.connect(
        Uri.parse("wss://demo.piesocket.com/v3/channel_1?api_key=VCXCEuvhGcBDP7XhiJJUDvR1e1D3eiVjgZ9VRiaV&notify_self"),
      );

      // if (timerRunning) {
      //   timer.cancel();
      // }

      if (initialize) {
        //print("subscription.toString(); " + subscription.toString());
      }
      subscription = channel.stream.listen((event) {
        var decodedJson = json.decode(event);
       // print("decoded DATA " + decodedJson.toString());
      },

          onDone: () {

            ///ON DONE
            print("Inside Done Method");

            if (!initialize) {
              //print("timer");
              timer = Timer.periodic(const Duration(seconds: 3), (timer) {
                initialize = true;
                connectWebSocket();
              });
            }
          },

          onError: (err) {
            ///ON ERROR
            print("inside Error method " + err.toString());
            //timerRunning = true;
          }
      );
    }catch(e){
      print("exception e " + e.toString());
    }
    print("subscription.toString(); " + subscription.toString());
    print("subscription.toString(); " + subscription.isPaused.toString());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("WEB SOCKET"),
      ),
      body: SizedBox(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: (){
                  print("PRESSED");
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomePage())
                  );
                },
                child: Text("Press Me")
            )
          ],
        ),
      ),
    );
  }
}

