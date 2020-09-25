import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:haas_command/MyRouteObserver.dart';
import 'package:haas_command/routes/editMachineRoute.dart';
import 'routes/addNewMahcineRoute.dart';
import 'helpers/database_helpers.dart';
import "RouteAwareWidget.dart";
import 'helpers/NavigatorMiddleware.dart';


import 'dart:developer';
// Register the RouteObserver as a navigation observer.
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
NavigatorMiddleware<PageRoute> middleware = NavigatorMiddleware<PageRoute>(
  onPush: (route, previousRoute) {
    log('we have push event');
    ///if route is Y we should have some API call
    ///
    log('DO SOMETHING HERE');
  },
  onPop: (route, previousRoute) {
    print("Current Route is: " + route.toString());
  },
);




void main() {

  runApp(MyApp());
}



class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver, middleware],
      routes: {
        'addNewMachineRoute': (context) => AddNewMachinePage(),
        'editMachine': (context) => EditMachine(),

      },
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
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Haas Command Machines'),
    );
  }
}

class MyHomePage extends StatefulWidget  {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with RouteAware{
  List<MachineData> mdl;

  @override
  initState() {
    super.initState();
    _read().then((result) {
    print("result: $result");
    setState(() {
      mdl = result;
    });
    });
  }

  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _test() {
    _read().then((result) {
      print("result: $result");
      setState(() {
        mdl = result;
      });
    });
    // setState(() {
    //   machineList.clear();
    //   //updateMachines();
    //
    // });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: mdl == null ? 0 : mdl.length,
        itemBuilder: (context, int i) =>

            Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Container(
                color: Colors.white,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigoAccent,
                    child: Text('${mdl[i].sn}'),
                    foregroundColor: Colors.white,
                  ),
                  title: Text('${mdl[i].nickname}'),
                  subtitle: Text('${mdl[i].connectionName}'),
                ),
              ),
              actions: <Widget>[
                IconSlideAction(
                  caption: 'Edit',
                  color: Colors.black45,
                  icon: Icons.edit,
                  onTap: () => Navigator.pushNamed(context,'editMachine', arguments: mdl[i]).then((value) {
                    _test();
                    //_test();
                  }),
                ),
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    print('attempt to delete ${mdl[i]}');

                    DatabaseHelper.instance.removeMachine(mdl[i]);
                    _test();
                  },
                ),
              ],

            ),



            // Column(
            //   children: [
            //     new ListTile(
            //       leading: new CircleAvatar(
            //           child: Text(mdl[i].sn.toString())),
            //       title: new Text(mdl[i].nickname),
            //       subtitle: new Text(mdl[i].connectionName),
            //       onTap: () {},
            //       onLongPress: () {
            //         print(
            //           Text("Long Pressed"),
            //         );
            //       },
            //     ),
            //   ],
            // ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context,'addNewMachineRoute').then((value) {
          _test();
          //_test();
        }),

        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
Future<List> _read() async {
  DatabaseHelper helper = DatabaseHelper.instance;
  int rowId = 111;
  machineList.clear();
  final md = await helper.queryAllMachines();
  if (md != null) {
    md.forEach((data) {
      print('row ${data.sn}: ${data.nickname}');
      machineList.add(data);
    });
  }
  return machineList;
}

 updateMachines() async {
  print("Updating machine list");
  final res = await _read();
  print("Done!");

}

var machineList = List<MachineData>();

class DisplayListView extends StatefulWidget {
  @override
  _DisplayListViewState createState() => _DisplayListViewState();
}

class _DisplayListViewState extends State {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: machineList.length,
      itemBuilder: (context, int i) =>
          Column(
            children: [
              new ListTile(
                leading: new CircleAvatar(
                    child: Text(machineList[i].sn.toString())),
                title: new Text(machineList[i].nickname),
                subtitle: new Text(machineList[i].port.toString()),
                onTap: () {},
                onLongPress: () {
                  print(
                    Text("Long Pressed"),
                  );
                },
              ),
            ],
          ),
    );
  }
}