import 'dart:io';

import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:validators/sanitizers.dart';
import '../helpers/database_helpers.dart';
import '../main.dart';
import 'dart:math';

class AddNewMachinePage extends StatefulWidget {
  @override
  _AddNewMachinePageState createState() => _AddNewMachinePageState();
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

class _AddNewMachinePageState extends State<AddNewMachinePage> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    //print('didPush');
  }

  @override
  void didPopNext() {
    //print('didPopNext');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Machine"),
      ),
      body: SecondRoute(),
    );
  }
}

class SecondRoute extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<SecondRoute> {
  final _formKey = GlobalKey<FormState>();

  final nicknameController = TextEditingController();
  final hostController = TextEditingController();
  final portController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Nickname'),
            controller: nicknameController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a nickname';
              } else if (!isAlpha(value)) {
                return "Cannot contain numbers or spaces";
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Machine IP/Hostname'),
            controller: hostController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter Hostname or IP';
              } else if (!isIP(value)) {
                return "Invalid IP Address";
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Machine Data Collect Port'),
            controller: portController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter MDC port number';
              } else if (!isNumeric(value)) {
                return 'The port must be numeric';
              }
              return null;
            },
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      // Remove current snackbar if it exists.
                      Scaffold.of(context).removeCurrentSnackBar();
                      // Open snackbar with loading animation
                      Scaffold.of(context).showSnackBar(SnackBar(

                          duration: Duration(seconds: 5),
                          content: Row(

                            children: [Text(
                                'Testing: ${hostController.text} on ${int.parse(portController.text)}'),
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(



                                ),
                              ),
                              ),
                          ]),

                      ));
                      print('trying....');
                      // Socket socket = await Socket.connect('192.168.1.99', 1024, timeout: Duration(seconds: 5));

                      await Socket.connect("${hostController.text}", int.parse(portController.text),
                              timeout: Duration(seconds: 5))
                          .then((sock) {
                        Duration(seconds: 5);
                        sock.writeln('?Q100');
                        int didSucceed = 0;
                        //Establish the onData, and onDone callbacks
                        sock.listen((data) {
                          String res = new String.fromCharCodes(data).trim();
                          if(res != null){
                            print("Socket got: " + res);
                            if(isNumeric(res)) {
                              didSucceed = 1;
                            }
                            else{
                              didSucceed = 2;
                            }
                          }
                          while(didSucceed == 0){
                            Future.delayed(Duration(seconds: 1));
                          }
                          sock.destroy();
                          if(didSucceed == 1) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                                duration: Duration(seconds: 10),
                                backgroundColor: Colors.lightGreen,
                                content: Text(
                                    'Test successful: ${hostController
                                        .text} on ${int.parse(
                                        portController.text)}')));
                          }
                          else {
                            Scaffold.of(context).showSnackBar(SnackBar(
                                duration: Duration(seconds: 10),
                                backgroundColor: Colors.redAccent,
                                content: Text(
                                    'Got invalid response: ${hostController.text} on ${int.parse(portController.text)}')));
                          }
                        }, onDone: () {
                          print("Done");
                          sock.destroy();
                        });
                      }).catchError((err) {
                        print('ERROR: ' + err.toString());
                          // Show error snackbar
                          Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 10),
                              backgroundColor: Colors.redAccent,
                              content: Text(
                                  'Failed to connect to: ${hostController.text} on ${int.parse(portController.text)}')));
                      });
                    }
                  },
                  child: Text('Test Connection'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')));

                      ////////

                      _save() async {
                        MachineData md = MachineData();
                        md.sn = Random().nextInt(1000);
                        md.nickname = nicknameController.text;
                        md.connectionName = hostController.text;
                        md.port = int.parse(portController.text);
                        md.model = "VF03";
                        md.softwareVersion = "SoftVer";
                        DatabaseHelper helper = DatabaseHelper.instance;
                        int id = await helper.insertMachineData(md);
                        print('inserted row: $id');
                      }

                      _save().then((value) => {Navigator.pop(context, true)});

                      ////////
                    }
                  },
                  child: Text('Add'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    //Todo Change route to home
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MyHomePage(title: 'Haas Command Machines'),
                    //   ),
                    // );
                    Navigator.pop(context, true);
                    //Navigator.of(context).pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
                  },
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
