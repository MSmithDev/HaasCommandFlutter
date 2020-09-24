import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:validators/sanitizers.dart';

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Form Validation Demo';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: SecondRoute(),
      ),
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
