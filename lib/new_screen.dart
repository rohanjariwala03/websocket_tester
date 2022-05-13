import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WebSocket? ws;
  final String url = 'wss://demo.piesocket.com/v3/channel_1?api_key=VCXCEuvhGcBDP7XhiJJUDvR1e1D3eiVjgZ9VRiaV&notify_self';
  int wsDelaySeconds = 4;
  bool stateConnectionLost=false;
  List lst = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async{
      await _wsListen();
    });
  }

  _wsListen() async {
    ws = await WebSocket.connect(url);
    ws!.listen(
            (data){
          print("data: $data");
          lst.add(data);
          setState(() {});
        },
        cancelOnError: true,
        onDone: () {
          print("connection done");
          setState(() { stateConnectionLost = true; });
          ws = null;
          print('waiting for $wsDelaySeconds seconds');
          Timer.periodic(Duration(seconds:wsDelaySeconds), (Timer timer) async {
            try {
              print("retry");
              await _wsListen();
            } catch (e) {
              print("error: $e");
            }
            if (ws != null) timer.cancel();
          });
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: size.height,
          child: lst.isEmpty
              ? Center(child: const Text("NOTHING HERE"))
              : ListView.builder(
            itemCount: lst.length,
            itemBuilder: (context,index) {
              return Row(
                children: [
                  SizedBox(
                    width: size.width*0.1,
                    child: Text(index.toString()),
                  ),
                  SizedBox(
                    width: size.width*0.8,
                    child: Text(lst[index].toString()),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}