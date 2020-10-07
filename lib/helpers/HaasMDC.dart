import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:async/async.dart';

extension StringExtensions on String {
  String removeWhitespace() {
    return this.replaceAll(' ', '');
  }
}

class HaasMDC {

  bool connected = false;
  Socket sock;
  String host;
  int port;

  Stream<String> tests;
  StreamQueue<String> events;

  HaasMDC(String host, int port){
  this.host = host;
  this.port = port;
  }

  parseQ(String data) {

  }

  bool isConnected(){
    return connected;
  }

  Future<bool> connect() async {
  try {
    sock = await Socket.connect(host, port, timeout: Duration(seconds: 5));
  } catch (e) {
    print('HaasMDC Socket error: $e');
    return false;
  }
    if(sock != null) {
      tests = Utf8Decoder().bind(sock).transform(LineSplitter());
      events = StreamQueue<String>(tests);
      connected = true;
      return true; //<------ on connect return true to connect()
    }
    else {
      print('HaasMDC Socket is null!');
      return false;
    }
  }



  Future<String>sendRecv(String cmd) async {
    sock.writeln(cmd);
    return await events.next;
  }

  Future<String>getSerialNumber() async {
    sock.writeln('?Q100');
    return await events.next;
  }


  double parseToolOffset(String res){

    return double.parse(res.removeWhitespace().split(',')[1]);
  }

  Future<List<ToolOffset>> getToolOffsets(int maxTools) async {
    List<ToolOffset> offsets = [];
    for(int i = 0; i < maxTools; i++) {
      ToolOffset tool = new ToolOffset();
      tool.toolNumber = i + 1;
      sock.writeln('?Q600');
      tool.x = parseToolOffset(await events.next);
      sock.writeln('?Q600');
      tool.y = parseToolOffset(await events.next);
      sock.writeln('?Q600');
      tool.z = parseToolOffset(await events.next);
      sock.writeln('?Q600');
      tool.a = parseToolOffset(await events.next);
      sock.writeln('?Q600');
      tool.b = parseToolOffset(await events.next);
      sock.writeln('?Q600');
      tool.c = parseToolOffset(await events.next);
      sock.writeln('?Q600');
      tool.p = parseToolOffset(await events.next);
      offsets.add(tool);
    }
    return offsets;
  }

  printToolOffsets(List<ToolOffset> offsets) {
    for (var tool in offsets) {
      print('Tool: ${tool.toolNumber} X: ${tool.x} Y: ${tool.y} Z: ${tool.z} A: ${tool.a} B: ${tool.b} C: ${tool.c} P: ${tool.p}');
    }
  }


  //Add streamable widget builders



}

class ToolOffset {
  int toolNumber;
  double x,y,z,a,b,c,p;
}

