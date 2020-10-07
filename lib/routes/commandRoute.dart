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

  List<StatelessWidget> wlist = new List();


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
    if(mdc == null) {
      this.mdc = new HaasMDC(md.connectionName, md.port);
    }

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
          return Column(
              children: [
                Text(snapshot.data),
                RaisedButton(
                  child: Text('Get Tool Offsets'),
                  onPressed: () {
                    print('getting tool offsets');
                    mdc.getToolOffsets(2).then((value) {
                      wlist.add(
                        ListView.builder(
                          itemCount: value == null ? 0 : value.length,
                          itemBuilder: (context, int i) =>
                         ListTile(
                           title: Text('test $value[i]'),
                         )
                        )
                      );
                    });
                    wlist.add(Text('test'));
                    setState(() {

                    });
                  },
                )
              ]+wlist,
          );
        }else if (snapshot.hasError){

         return Text('ERROR has occored',textScaleFactor: 1.5,);
        }else{
          return Center(

            child:SizedBox(
              width: 100,
              height: 100,
              child: Column(

                children: [
                CircularProgressIndicator(),
                Text('Connecting')],
            ),
            ),
          );}
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
    if(!mdc.isConnected()) {
      await mdc.connect();
    }
    return await mdc.getSerialNumber();


    //return 'its done';
  }


  Future<String> getOff() async {
    return await mdc.getToolOffsets(2).toString();
  }
}



