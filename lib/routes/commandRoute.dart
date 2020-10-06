import 'dart:io';

import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:validators/sanitizers.dart';
import '../helpers/database_helpers.dart';
import '../main.dart';
import 'dart:math';

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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    print('Command dispose');
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
    return Scaffold(

      appBar: AppBar(

        title: Text("Haas Command"),
      ),

    );
  }
}



