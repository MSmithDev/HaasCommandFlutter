





import 'dart:io';

import 'package:validators/validators.dart';

class HaasMDC {

  Socket sock;

  HaasMDC(Socket socket){
    this.sock = socket;
  }

  parseQ(String data) {

  }


  Future<String> queryQ(String qCmd, [String arg]) {
    int didSucceed = 0;
    //Make sure socket is open
    if(sock != null) {
      // Write cmd to socket
      sock.writeln(qCmd);
    String ress;
      //wait for res
      sock.listen((data) {
        String res = new String.fromCharCodes(data).trim();
        if (res != null) {
          print("Socket got: " + res);
          if (isNumeric(res)) {
            didSucceed = 1;
          }
          else {
            didSucceed = 2;
          }
        }
        while (didSucceed == 0) {
          Future.delayed(Duration(milliseconds: 100));
        }

      });
    return null;
    }
    else return null;

  }



}
