import 'dart:io';

import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:validators/sanitizers.dart';
import '../helpers/database_helpers.dart';
import '../main.dart';
import 'dart:math';
import '../helpers/HaasMDC.dart';


class CommandPage extends StatefulWidget {
  @override
  _CommandPageState createState() => _CommandPageState();
// Widget build(BuildContext context) {
//   final appTitle = 'Add new machine';
//
//   return Scaffold(
//       appBar: AppBar(
//         title: Text(appTitle),
//       ),
//       body: SecondRoute(),
//   );
// }
}

class _CommandPageState extends State<CommandPage> with RouteAware {
  MachineData md;
  HaasMDC mdc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    print('Command dispose ${md.nickname} ${md.connectionName}');
    //todo disconnect on dispose

    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    print('Command didPush');

    //todo connect to passed machine
  }

  @override
  void didPop(){
    print('Command didPop');
  }

  @override
  void didPopNext() {
    print('Command didPopNext');
  }

  @override
  Widget build(BuildContext context) {
    this.md = ModalRoute.of(context).settings.arguments;
    this.mdc = new HaasMDC(md.connectionName, md.port);

    return Scaffold(
    appBar: AppBar(
      title: Text('Command'),
    )
    ,
    body:
      FutureBuilder<String>(
      future: stuff(),
      builder: (context, AsyncSnapshot<String> snapshot) {
        if(snapshot.hasData) {
          return Text(snapshot.data);
        } else {
          return CircularProgressIndicator();
        }
      },
    ),
    );
    Scaffold(

      appBar: AppBar(

        title: Text("Haas Command"),
      ),

    );
  }
  
  Future<String> stuff() async {
    await Future.delayed(Duration(seconds: 5), () {

    });
    return 'its done';
    //return 'its done';
  }
}



