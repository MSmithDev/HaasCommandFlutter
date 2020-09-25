
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:validators/sanitizers.dart';
import '../helpers/database_helpers.dart';
import '../main.dart';
import 'dart:math';

class EditMachine extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();








  @override
  Widget build(BuildContext context) {
    final MachineData md = ModalRoute.of(context).settings.arguments;
    final nicknameController = TextEditingController(text: md.nickname);
    final hostController = TextEditingController(text: md.connectionName);
    final portController = TextEditingController(text: md.port.toString());
    print('MD ARGS : ${md.sn}');
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
        title: Text("Editing: ${md.nickname}"),
    ),
    body: Form(
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
              } else if (!isAlphanumeric(value)) {
                return "Cannot contain spaces";
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
              } else if (!isAlphanumeric(value)) {
                if (!isIP(value)) {
                  return "Invalid IP Address";
                }
                return "Hostname must be Alpha Numeric";
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
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')));
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
                      _save().then((value) => {
                        Navigator.pop(context, true)
                      });

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
                    Navigator.pop(context,true);
                    //Navigator.of(context).pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));

                  },
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );

  }
}